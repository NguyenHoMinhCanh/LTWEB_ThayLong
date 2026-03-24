package com.japansport.controller;

import com.japansport.dao.NewsDao;
import com.japansport.dao.NewsCategoryDao;
import com.japansport.model.News;
import com.japansport.model.NewsCategory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.Normalizer;
import java.util.*;
import java.util.regex.Pattern;

@WebServlet(name = "ManageNewsAdminServlet", urlPatterns = {"/admin/news"})
public class ManageNewsAdminServlet extends HttpServlet {

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

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.setAttribute("categories", categoryDao.getAll());
                request.setAttribute("pageTitle", "Thêm tin tức");
                request.getRequestDispatcher("/admin/news-form.jsp").forward(request, response);
                break;

            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                News n = newsDao.getById(id);
                if (n == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/news?error=notfound");
                    return;
                }
                request.setAttribute("news", n);
                request.setAttribute("categories", categoryDao.getAll());
                request.setAttribute("pageTitle", "Sửa tin tức");
                request.getRequestDispatcher("/admin/news-form.jsp").forward(request, response);
                break;
            }

            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = newsDao.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin/news?success=" + (ok ? "delete" : "0"));
                break;
            }

            case "toggleStatus": {
                int id = Integer.parseInt(request.getParameter("id"));
                News n = newsDao.getById(id);
                if (n == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/news?error=notfound");
                    return;
                }
                String newStatus = "PUBLISHED".equalsIgnoreCase(n.getStatus()) ? "DRAFT" : "PUBLISHED";
                boolean ok = newsDao.updateStatus(id, newStatus);
                response.sendRedirect(request.getContextPath() + "/admin/news?success=" + (ok ? "toggle" : "0"));
                break;
            }

            case "list":
            default: {
                List<News> list = newsDao.getAll();

                // map categoryId -> name
                Map<Integer, String> catNameById = new HashMap<>();
                for (NewsCategory c : categoryDao.getAll()) {
                    catNameById.put(c.getId(), c.getName());
                }

                // map newsId -> category names (comma separated)
                Map<Integer, String> newsCategoryNames = new HashMap<>();
                for (News n : list) {
                    List<Integer> ids = newsDao.getCategoryIds(n.getId());
                    n.setCategoryIds(ids);

                    if (ids == null || ids.isEmpty()) {
                        newsCategoryNames.put(n.getId(), "-");
                    } else {
                        List<String> names = new ArrayList<>();
                        for (Integer cid : ids) {
                            String nm = catNameById.get(cid);
                            if (nm != null) names.add(nm);
                        }
                        newsCategoryNames.put(n.getId(), names.isEmpty() ? "-" : String.join(", ", names));
                    }
                }

                // flash messages
                String success = request.getParameter("success");
                if ("create".equals(success)) request.setAttribute("successMessage", "Đã tạo bài viết.");
                else if ("update".equals(success)) request.setAttribute("successMessage", "Đã cập nhật bài viết.");
                else if ("delete".equals(success)) request.setAttribute("successMessage", "Đã xoá bài viết.");
                else if ("toggle".equals(success)) request.setAttribute("successMessage", "Đã cập nhật trạng thái bài viết.");

                String error = request.getParameter("error");
                if ("notfound".equals(error)) request.setAttribute("errorMessage", "Không tìm thấy bài viết.");

                request.setAttribute("newsList", list);
                request.setAttribute("newsCategoryNames", newsCategoryNames);
                request.setAttribute("pageTitle", "Tin tức");
                request.getRequestDispatcher("/admin/news.jsp").forward(request, response);
            }}
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            News n = readFromRequest(new News(), request);

            if (isBlank(n.getTitle()) || isBlank(n.getContent())) {
                request.setAttribute("error", "Vui lòng nhập Tiêu đề và Nội dung.");
                request.setAttribute("categories", categoryDao.getAll());
                request.setAttribute("news", n);
                request.setAttribute("pageTitle", "Thêm tin tức");
                request.getRequestDispatcher("/admin/news-form.jsp").forward(request, response);
                return;
            }

            String slug = slugify(n.getTitle());
            if (newsDao.slugExists(slug, null)) {
                slug = slug + "-" + (System.currentTimeMillis() % 10000);
            }
            n.setSlug(slug);
            int id = newsDao.insert(n);
            response.sendRedirect(request.getContextPath() + "/admin/news?success=" + (id > 0 ? "create" : "0"));
            return;
        }

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            News n = newsDao.getById(id);
            if (n == null) {
                response.sendRedirect(request.getContextPath() + "/admin/news?error=notfound");
                return;
            }

            n = readFromRequest(n, request);

            if (isBlank(n.getTitle()) || isBlank(n.getContent())) {
                request.setAttribute("error", "Vui lòng nhập Tiêu đề và Nội dung.");
                request.setAttribute("categories", categoryDao.getAll());
                request.setAttribute("news", n);
                request.setAttribute("pageTitle", "Sửa tin tức");
                request.getRequestDispatcher("/admin/news-form.jsp").forward(request, response);
                return;
            }

            String slug = slugify(n.getTitle());
            if (newsDao.slugExists(slug, n.getId())) {
                slug = slug + "-" + (System.currentTimeMillis() % 10000);
            }
            n.setSlug(slug);
            boolean ok = newsDao.update(n);
            response.sendRedirect(request.getContextPath() + "/admin/news?success=" + (ok ? "update" : "0"));
        }
    }

    private News readFromRequest(News n, HttpServletRequest request) {
        n.setTitle(trimToNull(request.getParameter("title")));
        n.setSummary(trimToNull(request.getParameter("summary")));
        n.setContent(trimToNull(request.getParameter("content")));
        n.setThumbnailUrl(trimToNull(request.getParameter("thumbnailUrl")));
        n.setAuthor(trimToNull(request.getParameter("author")));

        String status = trimToNull(request.getParameter("status"));
        n.setStatus(status == null ? "PUBLISHED" : status);

        n.setFeatured("on".equals(request.getParameter("featured")) ? 1 : 0);

        // multi categories
        String[] catArr = request.getParameterValues("categoryIds");
        List<Integer> ids = new ArrayList<>();
        if (catArr != null) {
            for (String s : catArr) {
                try { ids.add(Integer.parseInt(s)); } catch (Exception ignored) {}
            }
        }
        n.setCategoryIds(ids);
        return n;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    // slugify giống các servlet khác (Brands/Policies)
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
        return slug.isEmpty() ? "news" : slug;
    }
}
