package com.japansport.controller;

import com.japansport.dao.NewsDao;
import com.japansport.model.News;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "NewsDetailServlet", urlPatterns = {"/news-detail"})
public class NewsDetailServlet extends HttpServlet {

    private NewsDao newsDao;

    @Override
    public void init() {
        newsDao = new NewsDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String slug = request.getParameter("slug");
        if (slug == null || slug.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/news");
            return;
        }

        News n = newsDao.shopGetPublishedBySlug(slug);
        if (n == null) {
            response.sendError(404);
            return;
        }

        // tăng view
        newsDao.increaseViewCount(n.getId());
        n.setViewCount(n.getViewCount() + 1);

        request.setAttribute("news", n);
        // JSP đang nằm ở /src/main/webapp/news-detail.jsp (không phải /WEB-INF)
        request.getRequestDispatcher("/news-detail.jsp").forward(request, response);


    }
}
