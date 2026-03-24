package com.japansport.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class MailUtil {

    public static boolean isSmtpConfigured() {
        String host = AppConfig.get("SMTP_HOST", "");
        String user = AppConfig.get("SMTP_USER", "");
        String pass = AppConfig.get("SMTP_PASS", "");
        return !host.isBlank() && !user.isBlank() && !pass.isBlank();
    }

    public static void sendResetPasswordEmail(String toEmail, String resetLink) {
        String host = AppConfig.get("SMTP_HOST", "");
        int port = AppConfig.getInt("SMTP_PORT", 587);

        String user = AppConfig.get("SMTP_USER", "");
        String pass = AppConfig.get("SMTP_PASS", "");
        String from = AppConfig.get("SMTP_FROM", user);

        boolean tls = AppConfig.getBool("SMTP_TLS", true);   // 587
        boolean ssl = AppConfig.getBool("SMTP_SSL", false);  // 465
        boolean debug = AppConfig.getBool("MAIL_DEBUG", false);

        if (host.isBlank() || user.isBlank() || pass.isBlank()) {
            throw new IllegalStateException("SMTP chưa cấu hình đủ: SMTP_HOST/SMTP_USER/SMTP_PASS");
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", String.valueOf(port));
        props.put("mail.smtp.auth", "true");

        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");

        if (ssl) {
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.trust", host);
        } else if (tls) {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.trust", host);
        }

        Session session = Session.getInstance(props, new Authenticator() {
            @Override protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });
        session.setDebug(debug);

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from, "JapanSport", "UTF-8"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            msg.setSubject("Đặt lại mật khẩu", "UTF-8");

            String safeLink = escapeHtml(resetLink);
            String html = ""
                    + "<div style='font-family:Arial,sans-serif;font-size:14px'>"
                    + "<p>Bạn đã yêu cầu đặt lại mật khẩu.</p>"
                    + "<p>Nhấn vào link sau để đặt lại mật khẩu (hết hạn sau 30 phút):</p>"
                    + "<p><a href='" + safeLink + "'>" + safeLink + "</a></p>"
                    + "<p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>"
                    + "</div>";

            msg.setContent(html, "text/html; charset=UTF-8");
            Transport.send(msg);

        } catch (Exception e) {
            throw new RuntimeException("Gửi email thất bại: " + e.getMessage(), e);
        }
    }

    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
}
