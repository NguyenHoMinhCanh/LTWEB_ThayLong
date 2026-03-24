package com.japansport.controller;

import com.japansport.dao.PolicyDao;
import com.japansport.filter.MenuFilter;
import com.japansport.model.Policy;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.Normalizer;
import java.util.Locale;
import java.util.regex.Pattern;

@WebServlet(name = "ManagePolicyAdminServlet", urlPatterns = {"/admin/policies"})
public class ManagePolicyAdminServlet extends HttpServlet {

    private PolicyDao dao;

    @Override
    public void init() {
        dao = new PolicyDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.setAttribute("pageTitle", "Thêm chính sách");
                request.getRequestDispatcher("/admin/policy-form.jsp").forward(request, response);
                break;

            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                Policy p = dao.getById(id);
                if (p == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/policies?error=notfound");
                    return;
                }
                request.setAttribute("policy", p);
                request.setAttribute("pageTitle", "Sửa chính sách");
                request.getRequestDispatcher("/admin/policy-form.jsp").forward(request, response);
                break;
            }

            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.delete(id);
                MenuFilter.invalidatePolicyCache(getServletContext());
                response.sendRedirect(request.getContextPath() + "/admin/policies?success=" + (ok ? "delete" : "0"));
                break;
            }

            case "list":
            default:
                request.setAttribute("policies", dao.getAll());
                request.setAttribute("pageTitle", "Chính sách");
                request.getRequestDispatcher("/admin/policies.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            Policy p = readFromRequest(new Policy(), request);

            if (p.getTitle() == null || p.getTitle().isBlank()) {
                request.setAttribute("error", "Vui lòng nhập tiêu đề.");
                request.setAttribute("pageTitle", "Thêm chính sách");
                request.getRequestDispatcher("/admin/policy-form.jsp").forward(request, response);
                return;
            }

            int id = dao.insert(p);
            MenuFilter.invalidatePolicyCache(getServletContext());
            response.sendRedirect(request.getContextPath() + "/admin/policies?success=" + (id > 0 ? "create" : "0"));
            return;
        }

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Policy p = dao.getById(id);
            if (p == null) {
                response.sendRedirect(request.getContextPath() + "/admin/policies?error=notfound");
                return;
            }

            p = readFromRequest(p, request);

            if (p.getTitle() == null || p.getTitle().isBlank()) {
                request.setAttribute("error", "Vui lòng nhập tiêu đề.");
                request.setAttribute("policy", p);
                request.setAttribute("pageTitle", "Sửa chính sách");
                request.getRequestDispatcher("/admin/policy-form.jsp").forward(request, response);
                return;
            }

            boolean ok = dao.update(p);
            MenuFilter.invalidatePolicyCache(getServletContext());
            response.sendRedirect(request.getContextPath() + "/admin/policies?success=" + (ok ? "update" : "0"));
        }
    }

    private Policy readFromRequest(Policy p, HttpServletRequest request) {
        p.setTitle(trimToNull(request.getParameter("title")));
        String slugParam = trimToNull(request.getParameter("slug"));
        if (slugParam != null) {
            p.setSlug(slugify(slugParam));
        } else if (p.getSlug() == null && p.getTitle() != null) {
            p.setSlug(slugify(p.getTitle()));
        }
        p.setContent(trimToNull(request.getParameter("content")));
        p.setPolicyType(trimToNull(request.getParameter("policyType")));
        if (p.getPolicyType() == null) p.setPolicyType("GENERAL");

        try {
            p.setDisplayOrder(Integer.parseInt(request.getParameter("displayOrder")));
        } catch (Exception e) {
            p.setDisplayOrder(0);
        }

        p.setActive("on".equals(request.getParameter("active")));
        return p;
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
        return slug.isEmpty() ? "policy" : slug;
    }
}
