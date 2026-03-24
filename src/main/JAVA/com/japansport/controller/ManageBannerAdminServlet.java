package com.japansport.controller;

import com.japansport.dao.BannerDao;
import com.japansport.model.Banner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * Admin quản lý Banner.
 *
 * URL: /admin/banners
 * Actions:
 *  - list (default)
 *  - create (GET form) / create (POST save)
 *  - edit (GET form) / update (POST save)
 *  - delete (GET)
 *  - toggle (GET)
 */
@WebServlet(name = "ManageBannerAdminServlet", urlPatterns = {"/admin/banners"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB
        maxFileSize = 10 * 1024 * 1024,       // 10MB
        maxRequestSize = 20 * 1024 * 1024     // 20MB
)
public class ManageBannerAdminServlet extends HttpServlet {

    private BannerDao bannerDao;

    // Các vị trí banner đang dùng trong project (có thể mở rộng trong DB)
    public static final List<String> POSITIONS = Arrays.asList(
            // Home (code mới)
            "HOME_TOP",
            "HOME_MEN",
            "HOME_WOMEN_RIGHT",
            "HOME_WOMEN_BOTTOM",
            "HEADER_TOP",

            // Home (theo DB dump web.sql đang có)
            "HOME_MAIN",
            "HOME_SUB_1",
            "HOME_SUB_2",
            "HOME_SALE",
            "HOME_NEW",

            // Shop
            "SHOP_TOP",
            "PRODUCT_DETAIL_TOP"
    );

    @Override
    public void init() {
        bannerDao = new BannerDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";

        switch (action) {
            case "create":
                showForm(request, response, null);
                break;
            case "edit":
                showEdit(request, response);
                break;
            case "delete":
                deleteBanner(request, response);
                break;
            case "toggle":
                toggleBanner(request, response);
                break;
            default:
                listBanners(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "create";

        switch (action) {
            case "update":
                updateBanner(request, response);
                break;
            case "create":
            default:
                createBanner(request, response);
                break;
        }
    }

    private void listBanners(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String position = request.getParameter("position");
        List<Banner> list;
        if (position != null && !position.trim().isEmpty()) {
            list = bannerDao.getByPositionAdmin(position.trim());
        } else {
            list = bannerDao.getAllAdmin();
        }

        request.setAttribute("bannerList", list);
        request.setAttribute("positions", POSITIONS);
        request.setAttribute("selectedPosition", position);

        request.getRequestDispatcher("/admin/banner-list.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Banner banner)
            throws ServletException, IOException {

        request.setAttribute("banner", banner);
        request.setAttribute("positions", POSITIONS);
        request.getRequestDispatcher("/admin/banner-form.jsp").forward(request, response);
    }

    private void showEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=notfound");
            return;
        }

        Banner banner = bannerDao.getById(id);
        if (banner == null) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=notfound");
            return;
        }
        showForm(request, response, banner);
    }

    private void createBanner(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        Banner b = buildBannerFromRequest(request, null);
        if (b == null) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=invalid");
            return;
        }

        int newId = bannerDao.create(b);
        if (newId > 0) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?success=create");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=create");
        }
    }

    private void updateBanner(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String idStr = request.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=notfound");
            return;
        }

        Banner old = bannerDao.getById(id);
        if (old == null) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=notfound");
            return;
        }

        Banner b = buildBannerFromRequest(request, old);
        if (b == null) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?action=edit&id=" + id + "&error=invalid");
            return;
        }
        b.setId(id);

        boolean ok = bannerDao.update(b);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?success=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=update");
        }
    }

    private void deleteBanner(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=notfound");
            return;
        }

        boolean ok = bannerDao.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/banners?" + (ok ? "success=delete" : "error=delete"));
    }

    private void toggleBanner(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=notfound");
            return;
        }

        Banner b = bannerDao.getById(id);
        if (b == null) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=notfound");
            return;
        }
        int newActive = (b.getActive() == 1) ? 0 : 1;
        boolean ok = bannerDao.setActive(id, newActive);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/admin/banners?success=" + (newActive == 1 ? "toggle_on" : "toggle_off"));
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/banners?error=toggle");
        }
    }

    /**
     * Build Banner từ request.
     * - Nếu có upload file mới: ưu tiên file -> image_url = uploads/banners/...
     * - Nếu update mà không có file và không nhập image_url: giữ lại image_url cũ.
     */
    private Banner buildBannerFromRequest(HttpServletRequest request, Banner old) throws IOException, ServletException {
        String title = trimToNull(request.getParameter("title"));
        String link = trimToNull(request.getParameter("link"));
        String position = trimToNull(request.getParameter("position"));
        int active = (request.getParameter("active") != null) ? 1 : 0;

        // cho phép nhập URL ảnh trực tiếp (VD assets/images/..., uploads/...)
        String imageUrl = trimToNull(request.getParameter("image_url"));

        // upload file (optional)
        Part filePart = null;
        try {
            filePart = request.getPart("imageFile");
        } catch (Exception ignored) {
        }

        if (filePart != null && filePart.getSize() > 0) {
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return null;
            }

            String uploadDirReal = request.getServletContext().getRealPath("/uploads/banners");
            Files.createDirectories(Paths.get(uploadDirReal));

            String original = filePart.getSubmittedFileName();
            String ext = "";
            if (original != null && original.contains(".")) {
                ext = original.substring(original.lastIndexOf('.'));
            }

            String fileName = "banner_" + UUID.randomUUID() + ext;
            File dest = new File(uploadDirReal, fileName);
            filePart.write(dest.getAbsolutePath());

            imageUrl = "uploads/banners/" + fileName;
        }

        if (position == null) return null;

        // image:
// - update: nếu không nhập/không upload thì giữ ảnh cũ
// - create: nếu không nhập/không upload thì dùng placeholder mặc định
        if (imageUrl == null) {
            if (old != null && old.getImage_url() != null && !old.getImage_url().trim().isEmpty()) {
                imageUrl = old.getImage_url().trim();
            } else {
                imageUrl = "assets/images/banner.webp"; // placeholder mặc định để tránh invalid
            }
        }


        Banner b = new Banner();
        b.setTitle(title);
        b.setLink(link);
        b.setPosition(position);
        b.setActive(active);
        b.setImage_url(imageUrl);
        return b;
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
