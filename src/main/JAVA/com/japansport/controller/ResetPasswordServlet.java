package com.japansport.controller;

import com.japansport.dao.PasswordResetDao;
import com.japansport.dao.UserDao;
import com.japansport.model.PasswordResetToken;
import com.japansport.util.PasswordUtil;
import com.japansport.util.TokenUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private static String ensureCsrf(HttpSession session) {
        Object cur = session.getAttribute("CSRF_TOKEN");
        if (cur != null) return String.valueOf(cur);

        byte[] buf = new byte[32];
        new SecureRandom().nextBytes(buf);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
        session.setAttribute("CSRF_TOKEN", token);
        return token;
    }

    private static boolean validCsrf(HttpServletRequest req) {
        HttpSession session = req.getSession();
        String s = String.valueOf(session.getAttribute("CSRF_TOKEN"));
        String r = req.getParameter("csrf");
        return r != null && r.equals(s);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ensureCsrf(req.getSession());

        String token = req.getParameter("token");
        if (token == null || token.isBlank()) {
            req.setAttribute("errorMessage", "Liên kết đặt lại mật khẩu không hợp lệ.");
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
            return;
        }

        String tokenHash = TokenUtil.sha256Hex(token);
        PasswordResetDao prDao = new PasswordResetDao();
        PasswordResetToken prt = prDao.findValidByHash(tokenHash);

        if (prt == null) {
            req.setAttribute("errorMessage", "Link đã hết hạn hoặc không hợp lệ. Vui lòng thử lại.");
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("token", token);
        req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        ensureCsrf(req.getSession());

        String token = req.getParameter("token");
        String newPass = req.getParameter("new_password");
        String confirm = req.getParameter("confirm_password");

        if (!validCsrf(req)) {
            req.setAttribute("errorMessage", "CSRF token không hợp lệ. Vui lòng tải lại trang và thử lại.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
            return;
        }

        if (token == null || token.isBlank()) {
            req.setAttribute("errorMessage", "Thiếu token đặt lại mật khẩu.");
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
            return;
        }
        if (newPass == null || newPass.isBlank() || confirm == null || confirm.isBlank()) {
            req.setAttribute("errorMessage", "Vui lòng nhập đầy đủ mật khẩu mới và xác nhận.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
            return;
        }
        if (newPass.length() < 8) {
            req.setAttribute("errorMessage", "Mật khẩu mới tối thiểu 8 ký tự.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
            return;
        }
        if (!newPass.equals(confirm)) {
            req.setAttribute("errorMessage", "Xác nhận mật khẩu không khớp.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
            return;
        }

        String tokenHash = TokenUtil.sha256Hex(token);
        PasswordResetDao prDao = new PasswordResetDao();
        PasswordResetToken prt = prDao.findValidByHash(tokenHash);

        if (prt == null) {
            req.setAttribute("errorMessage", "Link đã hết hạn hoặc không hợp lệ. Vui lòng thử lại.");
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
            return;
        }

        try {
            UserDao userDao = new UserDao();
            String newHash = PasswordUtil.hash(newPass);
            boolean ok = userDao.updatePassword(prt.getUserId(), newHash);

            if (!ok) {
                req.setAttribute("errorMessage", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                req.setAttribute("token", token);
                req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
                return;
            }

            prDao.markUsed(prt.getId());

            HttpSession session = req.getSession();
            session.setAttribute("FLASH_MSG", "Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.");
            session.setAttribute("FLASH_TYPE", "success");

            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Có lỗi hệ thống. Vui lòng thử lại.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
        }
    }
}
