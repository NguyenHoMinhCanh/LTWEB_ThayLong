package com.japansport.controller;

import com.japansport.dao.NewsCategoryDao;
import com.japansport.model.NewsCategory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.Normalizer;
import java.util.Locale;
import java.util.regex.Pattern;

@WebServlet(name = "ManageNewsCategoryAdminServlet", urlPatterns = {"/admin/news-categories"})
public class ManageNewsCategoryAdminServlet extends HttpServlet {

    private NewsCategoryDao dao;

    @Override
    public void init() {
        dao = new NewsCategoryDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.setAttribute("pageTitle", "Thêm danh mục tin tức");
                request.getRequestDispatcher("/admin/news-category-form.jsp").forward(request, response);
                break;
            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                NewsCategory c = dao.getById(id);
                if (c == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/news-categories?error=notfound");
                    return;
                }
                request.setAttribute("category", c);
                request.setAttribute("pageTitle", "Sửa danh mục tin tức");
                request.getRequestDispatcher("/admin/news-category-form.jsp").forward(request, response);
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin/news-categories?success=" + (ok ? "delete" : "0"));
                break;
            }
            case "list":
            default:
                request.setAttribute("categories", dao.getAll());
                request.setAttribute("pageTitle", "Danh mục tin tức");
                request.getRequestDispatcher("/admin/news-categories.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            String name = trimToNull(request.getParameter("name"));
            String description = trimToNull(request.getParameter("description"));
            boolean active = "on".equals(request.getParameter("active"));

            if (name == null) {
                request.setAttribute("error", "Vui lòng nhập tên danh mục.");
                request.setAttribute("pageTitle", "Thêm danh mục tin tức");
                request.getRequestDispatcher("/admin/news-category-form.jsp").forward(request, response);
                return;
            }

            NewsCategory c = new NewsCategory();
            c.setName(name);
            c.setSlug(slugify(name));
            c.setDescription(description);
            c.setActive(active);

            int id = dao.insert(c);
            response.sendRedirect(request.getContextPath() + "/admin/news-categories?success=" + (id > 0 ? "create" : "0"));
            return;
        }

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = trimToNull(request.getParameter("name"));
            String description = trimToNull(request.getParameter("description"));
            boolean active = "on".equals(request.getParameter("active"));

            NewsCategory c = dao.getById(id);
            if (c == null) {
                response.sendRedirect(request.getContextPath() + "/admin/news-categories?error=notfound");
                return;
            }
            if (name == null) {
                request.setAttribute("error", "Vui lòng nhập tên danh mục.");
                request.setAttribute("category", c);
                request.setAttribute("pageTitle", "Sửa danh mục tin tức");
                request.getRequestDispatcher("/admin/news-category-form.jsp").forward(request, response);
                return;
            }

            c.setName(name);
            c.setSlug(slugify(name));
            c.setDescription(description);
            c.setActive(active);

            boolean ok = dao.update(c);
            response.sendRedirect(request.getContextPath() + "/admin/news-categories?success=" + (ok ? "update" : "0"));
        }
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private static final Pattern NONLATIN = Pattern.compile("[^a-z0-9\\s-]");
    private static final Pattern WHITESPACE = Pattern.compile("[\\s]+");

    private static String slugify(String input) {
        String nowhitespace = WHITESPACE.matcher(input.trim()).replaceAll("-");
        String normalized = Normalizer.normalize(nowhitespace, Normalizer.Form.NFD);
        String slug = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        slug = slug.toLowerCase(Locale.ROOT);
        slug = NONLATIN.matcher(slug).replaceAll("");
        slug = slug.replaceAll("-{2,}", "-");
        slug = slug.replaceAll("^-|-$", "");
        return slug.isEmpty() ? "category" : slug;
    }
}
