package com.japansport.controller;

import com.japansport.dao.CategoryDao;
import com.japansport.model.Category;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ManageCategoryAdminServlet", urlPatterns = {"/admin/categories"})
@MultipartConfig
public class ManageCategoryAdminServlet extends HttpServlet {

    private CategoryDao categoryDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        categoryDao = new CategoryDao();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("list".equals(action) || "getAll".equals(action)) {
            getAllCategories(request, response);
        } else if ("getById".equals(action)) {
            getCategoryById(request, response);
        } else if ("getParents".equals(action)) {
            getParentCategories(request, response);
        } else {
            // Forward đến trang JSP
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createCategory(request, response);
        } else if ("update".equals(action)) {
            updateCategory(request, response);
        } else if ("delete".equals(action)) {
            deleteCategory(request, response);
        } else {
            sendJsonError(response, "Invalid action", 400);
        }
    }

    /**
     * Lấy tất cả danh mục
     */
    private void getAllCategories(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            List<Category> categories = categoryDao.getAll();
            sendJsonResponse(response, categories);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi lấy danh sách danh mục: " + e.getMessage(), 500);
        }
    }

    /**
     * Lấy danh mục theo ID
     */
    private void getCategoryById(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Category category = categoryDao.getById(id);

            if (category != null) {
                sendJsonResponse(response, category);
            } else {
                sendJsonError(response, "Không tìm thấy danh mục", 404);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "ID không hợp lệ", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi lấy danh mục: " + e.getMessage(), 500);
        }
    }

    /**
     * Lấy danh mục cha (để chọn parent)
     */
    private void getParentCategories(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            List<Category> parents = categoryDao.getParentCategories();
            sendJsonResponse(response, parents);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi lấy danh mục cha: " + e.getMessage(), 500);
        }
    }

    /**
     * Tạo danh mục mới
     */
    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            // Đọc dữ liệu từ request
            Category category = new Category();
            category.setName(request.getParameter("name"));
            category.setImage_url(request.getParameter("image_url"));
            category.setLink(request.getParameter("link"));

            // Slug: tự động tạo nếu để trống
            String slug = request.getParameter("slug");
            if (slug == null || slug.trim().isEmpty()) {
                slug = Category.generateSlug(category.getName());
            }
            category.setSlug(slug);

            // Parent ID
            String parentIdStr = request.getParameter("parent_id");
            if (parentIdStr != null && !parentIdStr.trim().isEmpty()) {
                category.setParent_id(Integer.parseInt(parentIdStr));
            }

            // Display order
            String displayOrderStr = request.getParameter("display_order");
            category.setDisplay_order(displayOrderStr != null ?
                    Integer.parseInt(displayOrderStr) : 0);

            // Is featured
            String isFeaturedStr = request.getParameter("is_featured");
            category.setIs_featured("1".equals(isFeaturedStr) || "true".equals(isFeaturedStr) ? 1 : 0);

            // Active
            String activeStr = request.getParameter("active");
            category.setActive("1".equals(activeStr) || "true".equals(activeStr) ? 1 : 0);

            // Validate
            if (category.getName() == null || category.getName().trim().isEmpty()) {
                sendJsonError(response, "Tên danh mục không được để trống", 400);
                return;
            }

            // Insert vào database
            int newId = categoryDao.insert(category);

            if (newId > 0) {
                category.setId(newId);
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("message", "Tạo danh mục thành công");
                result.put("data", category);
                sendJsonResponse(response, result);
            } else {
                sendJsonError(response, "Không thể tạo danh mục", 500);
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "Dữ liệu số không hợp lệ", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi tạo danh mục: " + e.getMessage(), 500);
        }
    }

    /**
     * Cập nhật danh mục
     */
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Category category = categoryDao.getById(id);

            if (category == null) {
                sendJsonError(response, "Không tìm thấy danh mục", 404);
                return;
            }

            // Cập nhật thông tin
            category.setName(request.getParameter("name"));
            category.setImage_url(request.getParameter("image_url"));
            category.setLink(request.getParameter("link"));

            // Slug
            String slug = request.getParameter("slug");
            if (slug == null || slug.trim().isEmpty()) {
                slug = Category.generateSlug(category.getName());
            }
            category.setSlug(slug);

            // Parent ID
            String parentIdStr = request.getParameter("parent_id");
            if (parentIdStr != null && !parentIdStr.trim().isEmpty()) {
                category.setParent_id(Integer.parseInt(parentIdStr));
            } else {
                category.setParent_id(null);
            }

            // Display order
            String displayOrderStr = request.getParameter("display_order");
            category.setDisplay_order(displayOrderStr != null ?
                    Integer.parseInt(displayOrderStr) : 0);

            // Is featured
            String isFeaturedStr = request.getParameter("is_featured");
            category.setIs_featured("1".equals(isFeaturedStr) || "true".equals(isFeaturedStr) ? 1 : 0);

            // Active
            String activeStr = request.getParameter("active");
            category.setActive("1".equals(activeStr) || "true".equals(activeStr) ? 1 : 0);

            // Validate
            if (category.getName() == null || category.getName().trim().isEmpty()) {
                sendJsonError(response, "Tên danh mục không được để trống", 400);
                return;
            }

            // Update
            boolean success = categoryDao.update(category);

            if (success) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("message", "Cập nhật danh mục thành công");
                result.put("data", category);
                sendJsonResponse(response, result);
            } else {
                sendJsonError(response, "Không thể cập nhật danh mục", 500);
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "ID không hợp lệ", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi cập nhật danh mục: " + e.getMessage(), 500);
        }
    }

    /**
     * Xóa danh mục
     */
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            boolean success = categoryDao.delete(id);

            if (success) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("message", "Xóa danh mục thành công");
                sendJsonResponse(response, result);
            } else {
                sendJsonError(response, "Không thể xóa danh mục. Có thể đang được sử dụng.", 500);
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "ID không hợp lệ", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi xóa danh mục: " + e.getMessage(), 500);
        }
    }

    /**
     * Helper: Gửi JSON response thành công
     */
    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    /**
     * Helper: Gửi JSON error
     */
    private void sendJsonError(HttpServletResponse response, String message, int status)
            throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(error));
        out.flush();
    }
}