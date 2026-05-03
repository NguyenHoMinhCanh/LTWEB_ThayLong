package com.japansport.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.japansport.dao.UserDao;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.URI;
import java.net.http.*;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

@WebServlet("/auth/google/callback")
public class GoogleCallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String code = req.getParameter("code");
        String state = req.getParameter("state");
        String error = req.getParameter("error");

        // Người dùng từ chối cấp quyền
        if (error != null) {
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        // Kiểm tra state chống CSRF
        HttpSession session = req.getSession(false);
        String savedState = (session != null) ? (String) session.getAttribute("GOOGLE_OAUTH_STATE") : null;
        if (savedState == null || !savedState.equals(state)) {
            req.setAttribute("errorMessage", "Xác thực Google thất bại, vui lòng thử lại.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        session.removeAttribute("GOOGLE_OAUTH_STATE");

        try {
            Properties props = GoogleAuthServlet.loadConfig();
            String clientId = props.getProperty("google.clientId");
            String clientSecret = props.getProperty("google.clientSecret");
            String redirectUri = props.getProperty("google.redirectUri");

            // Bước 1: đổi code lấy access token
            String accessToken = exchangeCodeForToken(code, clientId, clientSecret, redirectUri);
            if (accessToken == null) {
                req.setAttribute("errorMessage", "Không lấy được token từ Google.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            // Bước 2: lấy thông tin user từ Google
            JsonObject userInfo = fetchUserInfo(accessToken);
            String email = userInfo.get("email").getAsString().trim().toLowerCase();
            String name = userInfo.has("name") ? userInfo.get("name").getAsString() : email;

            // Bước 3: kiểm tra email có trong DB chưa
            UserDao dao = new UserDao();
            User user = dao.findByEmail(email);

            if (user == null) {
                // Chưa có tài khoản -> tạo mới
                user = dao.insertGoogleUser(email, name);
            }

            // Bước 4: đăng nhập
            req.changeSessionId();
            HttpSession newSession = req.getSession();
            newSession.setAttribute("currentUser", user);

            resp.sendRedirect(req.getContextPath() + "/account");

        } catch (Exception e) {
            req.setAttribute("errorMessage", "Có lỗi khi đăng nhập bằng Google.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }

    private String exchangeCodeForToken(String code, String clientId,
            String clientSecret, String redirectUri) throws Exception {

        String body = "code=" + encode(code)
                + "&client_id=" + encode(clientId)
                + "&client_secret=" + encode(clientSecret)
                + "&redirect_uri=" + encode(redirectUri)
                + "&grant_type=authorization_code";

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://oauth2.googleapis.com/token"))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        JsonObject json = JsonParser.parseString(response.body()).getAsJsonObject();

        if (!json.has("access_token"))
            return null;
        return json.get("access_token").getAsString();
    }

    private JsonObject fetchUserInfo(String accessToken) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://www.googleapis.com/oauth2/v2/userinfo"))
                .header("Authorization", "Bearer " + accessToken)
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        return JsonParser.parseString(response.body()).getAsJsonObject();
    }

    private String encode(String s) {
        return java.net.URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}
