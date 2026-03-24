package com.japansport.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession old = req.getSession(false);
        if (old != null) {
            old.invalidate();
        }

        // tạo session mới chỉ để mang flash message
        HttpSession session = req.getSession(true);
        session.setAttribute("FLASH_MSG", "Bạn đã đăng xuất.");
        session.setAttribute("FLASH_TYPE", "success");

        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
