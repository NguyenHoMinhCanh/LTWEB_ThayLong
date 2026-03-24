package com.japansport.controller;

import com.japansport.dao.BrandDao;
import com.japansport.filter.MenuFilter;
import com.japansport.model.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.Normalizer;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

@WebServlet(name = "ManageBrandAdminServlet", urlPatterns = {"/admin/brands"})
@MultipartConfig
public class ManageBrandAdminServlet extends HttpServlet {

    private BrandDao brandDao;

    @Override
    public void init() {
        brandDao = new BrandDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                showBrandList(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBrand(request, response);
                break;
            case "toggle":
                toggleBrandActive(request, response);
                break;
            default:
                showBrandList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createBrand(request, response);
        } else if ("update".equals(action)) {
            updateBrand(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list");
        }
    }

    private void showBrandList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = trimToNull(request.getParameter("search"));
        List<Brand> brandList = (search == null) ? brandDao.getAll() : brandDao.searchAll(search);

// alert message mapping
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            switch (success) {
                case "create":
                    request.setAttribute("successMessage", "Thêm thương hiệu thành công.");
                    break;
                case "update":
                    request.setAttribute("successMessage", "Cập nhật thương hiệu thành công.");
                    break;
                case "delete":
                    request.setAttribute("successMessage", "Xóa thương hiệu thành công.");
                    break;
                case "toggle_on":
                    request.setAttribute("successMessage", "Đã bật hiển thị thương hiệu trên shop.");
                    break;
                case "toggle_off":
                    request.setAttribute("successMessage", "Đã ẩn thương hiệu khỏi shop.");
                    break;
            }
        }
        if (error != null) {
            switch (error) {
                case "notfound":
                    request.setAttribute("errorMessage", "Không tìm thấy thương hiệu.");
                    break;
                case "delete":
                    request.setAttribute("errorMessage", "Không thể xóa thương hiệu (có thể đang được dùng bởi sản phẩm).");
                    break;
                case "toggle":
                    request.setAttribute("errorMessage", "Không thể thay đổi trạng thái hiển thị thương hiệu.");
                    break;
                default:
                    request.setAttribute("errorMessage", "Có lỗi xảy ra.");
                    break;
            }
        }

        request.setAttribute("brandList", brandList);
// FIX: brand-list.jsp đang dùng items="${brands}"
        request.setAttribute("brands", brandList);
        request.setAttribute("pageTitle", "Quản lý Nhãn hàng");
        request.getRequestDispatcher("/admin/brand-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Thêm Nhãn hàng mới");
        request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
    }

    private void createBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = trimToNull(request.getParameter("name"));
        String logoUrl = trimToNull(request.getParameter("logoUrl"));
        boolean active = "on".equals(request.getParameter("active"));

        if (name == null) {
            request.setAttribute("error", "Vui lòng nhập tên nhãn hàng.");
            showAddForm(request, response);
            return;
        }

        // tạo slug ngay tại servlet (vì Brand.java của LTWEB không có generateSlug)
        String slug = slugify(name);

        Brand brand = new Brand();
        brand.setName(name);
        brand.setSlug(slug);
        brand.setLogoUrl(logoUrl);
        brand.setActive(active);

        int brandId = brandDao.insert(brand);

        if (brandId > 0) {
            MenuFilter.invalidateBrandCache(getServletContext());
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&success=create");
        } else {
            request.setAttribute("error", "Không thể thêm nhãn hàng.");
            showAddForm(request, response);
        }
    }


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?error=notfound");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?error=notfound");
            return;
        }

        Brand brand = brandDao.getById(id);
        if (brand == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?error=notfound");
            return;
        }

        request.setAttribute("brand", brand);
        request.setAttribute("pageTitle", "Sửa Nhãn hàng");
        request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
    }

    private void updateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String name = trimToNull(request.getParameter("name"));
        String logoUrl = trimToNull(request.getParameter("logoUrl"));
        boolean active = "on".equals(request.getParameter("active"));

        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?error=notfound");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?error=notfound");
            return;
        }

        Brand brand = brandDao.getById(id);
        if (brand == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?error=notfound");
            return;
        }

        if (name == null) {
            request.setAttribute("error", "Vui lòng nhập tên nhãn hàng.");
            request.setAttribute("brand", brand);
            request.setAttribute("pageTitle", "Sửa Nhãn hàng");
            request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
            return;
        }

        brand.setName(name);
        brand.setSlug(slugify(name));
        brand.setLogoUrl(logoUrl);
        brand.setActive(active);

        boolean updated = brandDao.update(brand);

        if (updated) {
            MenuFilter.invalidateBrandCache(getServletContext());
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&success=update");
        } else {
            request.setAttribute("error", "Không thể cập nhật nhãn hàng.");
            request.setAttribute("brand", brand);
            request.setAttribute("pageTitle", "Sửa Nhãn hàng");
            request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
        }
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&error=delete");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&error=delete");
            return;
        }

        boolean deleted = brandDao.delete(id);
        if (deleted) {
            MenuFilter.invalidateBrandCache(getServletContext());
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&error=delete");
        }
    }

    private void toggleBrandActive(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&error=toggle");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&error=toggle");
            return;
        }

        Brand brand = brandDao.getById(id);
        if (brand == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&error=notfound");
            return;
        }

        boolean newActive = !brand.isActive();
        boolean ok = brandDao.updateActive(id, newActive);
        if (ok) {
            MenuFilter.invalidateBrandCache(getServletContext());
            response.sendRedirect(request.getContextPath()
                    + "/admin/brands?action=list&success=" + (newActive ? "toggle_on" : "toggle_off"));
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&error=toggle");
        }
    }

    // ===== Helpers (không đụng Brand.java) =====

    private static String trimToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private static final Pattern NONLATIN = Pattern.compile("[^a-z0-9\\s-]");
    private static final Pattern WHITESPACE = Pattern.compile("[\\s]+");

    /** Tạo slug an toàn cho tiếng Việt */
    private static String slugify(String input) {
        String nowhitespace = WHITESPACE.matcher(input.trim()).replaceAll("-");
        String normalized = Normalizer.normalize(nowhitespace, Normalizer.Form.NFD);
        String slug = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        slug = slug.toLowerCase(Locale.ROOT);
        slug = NONLATIN.matcher(slug).replaceAll("");
        slug = slug.replaceAll("-{2,}", "-");
        slug = slug.replaceAll("^-|-$", "");
        if (slug.isEmpty()) slug = "brand";
        return slug;
    }
}
