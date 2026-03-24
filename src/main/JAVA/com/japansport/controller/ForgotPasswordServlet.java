package com.japansport.controller;

import com.japansport.dao.PasswordResetDao;
import com.japansport.dao.UserDao;
import com.japansport.model.User;
import com.japansport.util.AppConfig;
import com.japansport.util.MailUtil;
import com.japansport.util.TokenUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

@WebServlet("/forgot")
public class ForgotPasswordServlet extends HttpServlet {

    private static String clientIp(HttpServletRequest req) {
        String xff = req.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) return xff.split(",")[0].trim();
        return req.getRemoteAddr();
    }

    private static boolean isLocal(HttpServletRequest req) {
        String host = req.getServerName();
        String ip = req.getRemoteAddr();
        return "localhost".equalsIgnoreCase(host)
                || "127.0.0.1".equals(host)
                || "127.0.0.1".equals(ip)
                || "0:0:0:0:0:0:0:1".equals(ip)
                || "::1".equals(ip);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        String email = req.getParameter("email");
        if (email == null) email = "";
        email = email.trim().toLowerCase();

        if (email.isBlank()) {
            session.setAttribute("FLASH_MSG", "Vui lòng nhập email.");
            session.setAttribute("FLASH_TYPE", "error");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Generic message (production-safe)
        String genericMsg = "Nếu email tồn tại trong hệ thống, chúng tôi đã gửi hướng dẫn đặt lại mật khẩu.";

        // Local dev: luôn show lỗi + link để test cho khỏi nản
        boolean local = isLocal(req);

        try {
            UserDao userDao = new UserDao();
            User u = userDao.findActiveByEmail(email);

            // Nếu không tìm thấy user hoặc active=0 => production vẫn generic
            if (u != null) {
                String token = TokenUtil.generateToken();
                String tokenHash = TokenUtil.sha256Hex(token);
                Timestamp expiresAt = Timestamp.from(Instant.now().plus(30, ChronoUnit.MINUTES));

                PasswordResetDao prDao = new PasswordResetDao();
                prDao.create(u.getId(), tokenHash, expiresAt, clientIp(req));

                // baseUrl
                String baseUrl = AppConfig.get("APP_BASE_URL", "");
                if (baseUrl.isBlank()) {
                    baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
                }

                String resetLink = baseUrl + "/reset-password?token=" + URLEncoder.encode(token, "UTF-8");

                // Nếu SMTP chưa cấu hình
                if (!MailUtil.isSmtpConfigured()) {
                    if (local) {
                        session.setAttribute("FLASH_MSG",
                                "SMTP chưa cấu hình nên KHÔNG gửi được email. " +
                                        "Bạn test lại bằng /mail-test để thấy lỗi. " +
                                        "Link reset (demo): " + resetLink);
                        session.setAttribute("FLASH_TYPE", "error");
                        resp.sendRedirect(req.getContextPath() + "/login.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
                        return;
                    }
                } else {
                    // SMTP đã cấu hình -> cố gửi
                    try {
                        MailUtil.sendResetPasswordEmail(u.getEmail(), resetLink);
                    } catch (Exception mailEx) {
                        getServletContext().log("Send reset email failed", mailEx);

                        if (local) {
                            session.setAttribute("FLASH_MSG",
                                    "Gửi email THẤT BẠI: " + mailEx.getMessage() +
                                            ". Vào /mail-test để xem ROOT CAUSE. " +
                                            "Link reset (demo): " + resetLink);
                            session.setAttribute("FLASH_TYPE", "error");
                            resp.sendRedirect(req.getContextPath() + "/login.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
                            return;
                        }
                    }
                }
            }

            // Production (hoặc user null) luôn generic
            session.setAttribute("FLASH_MSG", genericMsg);
            session.setAttribute("FLASH_TYPE", "success");
            resp.sendRedirect(req.getContextPath() + "/login.jsp?email=" + URLEncoder.encode(email, "UTF-8"));

        } catch (Exception e) {
            getServletContext().log("Forgot password error", e);
            session.setAttribute("FLASH_MSG", "Có lỗi hệ thống. Vui lòng thử lại.");
            session.setAttribute("FLASH_TYPE", "error");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}
