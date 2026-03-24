package com.japansport.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "SearchServlet", value = "/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String q = req.getParameter("q");
        if (q == null) q = "";
        q = q.trim();

        // Nếu không nhập gì -> chuyển về trang list-product
        if (q.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/list-product");
            return;
        }

        String encoded = URLEncoder.encode(q, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/list-product?keyword=" + encoded);
    }
}
