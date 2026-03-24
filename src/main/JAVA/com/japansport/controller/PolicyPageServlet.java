package com.japansport.controller;

import com.japansport.dao.PolicyDao;
import com.japansport.model.Policy;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "PolicyPageServlet", urlPatterns = {"/policy"})
public class PolicyPageServlet extends HttpServlet {

    private PolicyDao dao;

    @Override
    public void init() {
        dao = new PolicyDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String slug = request.getParameter("slug");
        if (slug == null || slug.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        Policy p = dao.getBySlug(slug);
        if (p == null || !p.isActive()) {
            response.sendError(404);
            return;
        }

        request.setAttribute("policy", p);
        request.getRequestDispatcher("/policy.jsp").forward(request, response);
    }
}
