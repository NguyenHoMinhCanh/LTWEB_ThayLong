package com.japansport.controller;

import com.japansport.dao.NewsDao;
import com.japansport.dao.NewsCategoryDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "NewsListServlet", urlPatterns = {"/news"})
public class NewsListServlet extends HttpServlet {

    private NewsDao newsDao;
    private NewsCategoryDao categoryDao;

    @Override
    public void init() {
        newsDao = new NewsDao();
        categoryDao = new NewsCategoryDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");
        Integer categoryId = null;

        try {
            String cat = request.getParameter("categoryId");
            if (cat != null && !cat.isBlank()) categoryId = Integer.parseInt(cat);
        } catch (Exception ignored) {}

        // pagination cơ bản
        int page = 1;
        try {
            String p = request.getParameter("page");
            if (p != null) page = Math.max(1, Integer.parseInt(p));
        } catch (Exception ignored) {}

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        request.setAttribute("categories", categoryDao.getAllActive());
        request.setAttribute("newsList", newsDao.shopGetPublished(categoryId, keyword, pageSize, offset));

        request.setAttribute("page", page);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("q", keyword);

        request.getRequestDispatcher("/news.jsp").forward(request, response);
    }
}
