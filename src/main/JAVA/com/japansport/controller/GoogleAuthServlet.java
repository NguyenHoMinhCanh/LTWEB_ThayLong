package com.japansport.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

@WebServlet("/auth/google")
public class GoogleAuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Nếu đã đăng nhập thì không cần OAuth nữa
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        Properties props = loadConfig();
        String clientId = props.getProperty("google.clientId");
        String redirectUri = props.getProperty("google.redirectUri");

        // Tạo state token chống CSRF
        String state = java.util.UUID.randomUUID().toString();
        req.getSession().setAttribute("GOOGLE_OAUTH_STATE", state);

        String authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                + "&response_type=code"
                + "&scope=openid%20email%20profile"
                + "&state=" + state
                + "&prompt=select_account";

        resp.sendRedirect(authUrl);
    }

    static Properties loadConfig() throws IOException {
        Properties p = new Properties();
        try (InputStream in = GoogleAuthServlet.class
                .getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null)
                p.load(in);
        }
        return p;
    }
}
