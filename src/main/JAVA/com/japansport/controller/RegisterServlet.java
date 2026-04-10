package com.japansport.controller;

import com.japansport.dao.UserDao;
import com.japansport.model.User;
import com.japansport.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static String ensureCsrf(HttpSession session) {
        Object cur = session.getAttribute("CSRF_TOKEN");
        if (cur != null)
            return String.valueOf(cur);

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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        ensureCsrf(req.getSession());

        if (!validCsrf(req)) {
            req.setAttribute("errorMessage", "CSRF token không hợp lệ. Vui lòng tải lại trang và thử lại.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (name == null || name.isBlank() ||
                email == null || email.isBlank() ||
                password == null || password.isBlank() ||
                confirmPassword == null || confirmPassword.isBlank()) {
            req.setAttribute("errorMessage", "Vui lòng nhập đủ thông tin.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // Chuẩn hóa email trước khi xử lý
        email = email.trim().toLowerCase();

        // Kiểm tra xác nhận mật khẩu
        if (!password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // Mật khẩu tối thiểu 8 ký tự
        if (password.length() < 8) {
            req.setAttribute("errorMessage", "Mật khẩu tối thiểu 8 ký tự.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        try {
            UserDao dao = new UserDao();
            if (dao.existsByEmail(email)) {
                req.setAttribute("errorMessage", "Email này đã được sử dụng, vui lòng dùng email khác.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            User u = new User();
            u.setName(name.trim());
            u.setEmail(email); // đã được chuẩn hóa ở trên
            u.setPassword(PasswordUtil.hash(password));
            u.setActive(1);

            int affected = dao.insert(u);
            if (affected > 0) {
                // flash message (để login.jsp đọc)
                HttpSession session = req.getSession();
                session.setAttribute("FLASH_MSG", "Đăng ký thành công. Vui lòng đăng nhập.");
                session.setAttribute("FLASH_TYPE", "success");
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
            } else {
                req.setAttribute("errorMessage", "Đăng ký thất bại, thử lại!");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Có lỗi hệ thống. Vui lòng thử lại.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
