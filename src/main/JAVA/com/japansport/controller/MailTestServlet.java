package com.japansport.controller;

import com.japansport.util.AppConfig;
import com.japansport.util.MailUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/mail-test")
public class MailTestServlet extends HttpServlet {

    private static boolean isLocal(HttpServletRequest req) {
        String host = req.getServerName();
        String ip = req.getRemoteAddr();
        return "localhost".equalsIgnoreCase(host)
                || "127.0.0.1".equals(host)
                || "127.0.0.1".equals(ip)
                || "0:0:0:0:0:0:0:1".equals(ip)
                || "::1".equals(ip);
    }

    private static String rootCause(Throwable e) {
        Throwable cur = e;
        while (cur.getCause() != null) cur = cur.getCause();
        return cur.getClass().getName() + ": " + cur.getMessage();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Chỉ cho phép test trên localhost để an toàn
        if (!isLocal(req)) {
            resp.setStatus(404);
            resp.getWriter().print("Not Found");
            return;
        }

        resp.setContentType("text/plain; charset=UTF-8");

        // In cấu hình SMTP đang đọc được (để biết ENV có ăn không)
        resp.getWriter().println("=== SMTP CONFIG CHECK ===");
        resp.getWriter().println("SMTP_HOST=" + AppConfig.get("SMTP_HOST", ""));
        resp.getWriter().println("SMTP_PORT=" + AppConfig.get("SMTP_PORT", ""));
        resp.getWriter().println("SMTP_USER=" + AppConfig.get("SMTP_USER", ""));
        resp.getWriter().println("SMTP_PASS=" + (AppConfig.get("SMTP_PASS", "").isBlank() ? "" : "***"));
        resp.getWriter().println("SMTP_TLS=" + AppConfig.get("SMTP_TLS", "true"));
        resp.getWriter().println("SMTP_SSL=" + AppConfig.get("SMTP_SSL", "false"));
        resp.getWriter().println("MAIL_DEBUG=" + AppConfig.get("MAIL_DEBUG", "false"));
        resp.getWriter().println("=========================");

        String to = req.getParameter("to");
        if (to == null || to.isBlank()) {
            resp.getWriter().println("Dùng: /mail-test?to=you@gmail.com");
            return;
        }

        try {
            MailUtil.sendResetPasswordEmail(to.trim(), "http://localhost/test-reset");
            resp.getWriter().println("OK: Gửi mail thành công tới " + to);
        } catch (Exception e) {
            resp.getWriter().println("FAIL: " + e.getMessage());
            resp.getWriter().println("ROOT: " + rootCause(e));
        }
    }
}
