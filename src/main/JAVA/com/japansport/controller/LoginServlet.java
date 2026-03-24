package com.japansport.controller;

import com.japansport.dao.UserDao;
import com.japansport.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static String ensureCsrf(HttpSession session) {
        String csrf = (String) session.getAttribute("CSRF_TOKEN");
        if (csrf == null || csrf.isBlank()) {
            byte[] buf = new byte[32];
            new SecureRandom().nextBytes(buf);
            csrf = Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
            session.setAttribute("CSRF_TOKEN", csrf);
        }
        return csrf;
    }

    private static boolean validCsrf(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        String s = (String) session.getAttribute("CSRF_TOKEN");
        String r = req.getParameter("csrf");
        return r != null && r.equals(s);
    }

    private static boolean isSafeBack(String back) {
        // chỉ cho phép path nội bộ kiểu "/cart.jsp" hoặc "/payment.jsp"
        if (back == null || back.isBlank()) return false;
        if (!back.startsWith("/")) return false;
        if (back.startsWith("//")) return false;
        return !back.contains("\r") && !back.contains("\n");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        ensureCsrf(session);

        // Nếu đang login mà đã login rồi -> điều hướng hợp lý
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            String ctx = request.getContextPath();
            if (currentUser.isAdmin()) {
                response.sendRedirect(ctx + "/admin/dashboard");
            } else {
                response.sendRedirect(ctx + "/account");
            }
            return;
        }
        request.setAttribute("csrf", ensureCsrf(session));
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        ensureCsrf(request.getSession());

        if (!validCsrf(request)) {
            request.setAttribute("errorMessage", "CSRF token không hợp lệ. Vui lòng tải lại trang và thử lại.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String back = request.getParameter("back");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("errorMessage", "Vui lòng nhập email và mật khẩu.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        UserDao userDao = new UserDao();
        try {
            User user = userDao.login(email.trim().toLowerCase(), password);

            if (user != null) {
                // chống session fixation
                request.changeSessionId();

                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);

                String ctx = request.getContextPath();

                // Nếu có redirectAfterLogin (được set bởi AdminAuthFilter) thì ưu tiên redirect về đó
                String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
                if (redirectAfterLogin != null && !redirectAfterLogin.isBlank()) {
                    session.removeAttribute("redirectAfterLogin");
                    // redirectAfterLogin lưu dạng "/admin/..." nên nối thẳng với contextPath
                    response.sendRedirect(ctx + redirectAfterLogin);
                    return;
                }

                // ✅ Admin login: mặc định vào trang Admin Dashboard
                if (user.isAdmin()) {
                    response.sendRedirect(ctx + "/admin/dashboard");
                    return;
                }

                // User thường: ưu tiên back hợp lệ, không thì về account
                if (isSafeBack(back)) {
                    response.sendRedirect(ctx + back);
                } else {
                    response.sendRedirect(ctx + "/account");
                }
            } else {
                request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Có lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
