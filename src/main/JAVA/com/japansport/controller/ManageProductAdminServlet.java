package com.japansport.controller;

import com.japansport.dao.ProductDao;
import com.japansport.dao.CategoryDao;
import com.japansport.dao.BrandDao;
import com.japansport.model.Product;
import com.japansport.model.Category;
import com.japansport.model.Brand;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ManageProductAdminServlet", urlPatterns = {"/admin/products"})
@MultipartConfig
public class ManageProductAdminServlet extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final CategoryDao categoryDao = new CategoryDao();
    private final BrandDao brandDao = new BrandDao();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Nếu không có action -> hiển thị trang JSP
        if (action == null || action.isEmpty()) {
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
            return;
        }

        // Nếu có action -> trả về JSON
        switch (action) {
            case "list":
                listProducts(request, response);
                break;
            case "get":
                getProduct(request, response);
                break;
            case "categories":
                getCategories(request, response);
                break;
            case "brands":
                getBrands(request, response);
                break;
            default:
                listProducts(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            sendErrorResponse(response, "Missing action parameter");
            return;
        }

        switch (action) {
            case "add":
                addProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            case "toggleActive":
                toggleActive(request, response);
                break;
            default:
                sendErrorResponse(response, "Invalid action");
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        List<Product> products = productDao.getAllAdmin();

        // Gắn thông tin brand cho mỗi sản phẩm
        for (Product p : products) {
            if (p.getBrandId() != null && p.getBrand() == null) {
                Brand brand = brandDao.getById(p.getBrandId());
                p.setBrand(brand);
            }
        }

        sendJsonResponse(response, products);
    }

    private void getProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDao.getByIdAdmin(id);

            if (product != null) {
                // Gắn brand nếu có
                if (product.getBrandId() != null && product.getBrand() == null) {
                    Brand brand = brandDao.getById(product.getBrandId());
                    product.setBrand(brand);
                }
                sendJsonResponse(response, product);
            } else {
                sendErrorResponse(response, "Product not found");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid product ID");
        }
    }

    private void getCategories(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Category> categories = categoryDao.getAllActive();
        sendJsonResponse(response, categories);
    }

    private void getBrands(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Brand> brands = brandDao.getAllActive();
        sendJsonResponse(response, brands);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Product product = new Product();

            // Thông tin cơ bản
            product.setName(request.getParameter("name"));
            product.setDescription(request.getParameter("description")); // ✅ THÊM DÒNG NÀY
            product.setImage_url(request.getParameter("image_url"));

            // Giá
            String priceStr = request.getParameter("price");
            product.setPrice(priceStr != null ? Double.parseDouble(priceStr) : 0);

            String oldPriceStr = request.getParameter("old_price");
            product.setOld_price(oldPriceStr != null ? Double.parseDouble(oldPriceStr) : 0);

            // Gender
            String gender = request.getParameter("gender");
            if (gender != null && !gender.trim().isEmpty()) {
                product.setGender(gender);
            }

            // Category ID
            String categoryIdStr = request.getParameter("category_id");
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                product.setCategoryId(Integer.parseInt(categoryIdStr));
            }

            // Brand ID
            String brandIdStr = request.getParameter("brand_id");
            if (brandIdStr != null && !brandIdStr.trim().isEmpty()) {
                product.setBrandId(Integer.parseInt(brandIdStr));
            }

            // Active (tuỳ chọn)
            String activeStr = request.getParameter("active");
            if (activeStr != null && !activeStr.trim().isEmpty()) {
                product.setActive("1".equals(activeStr) || "true".equalsIgnoreCase(activeStr));
            }

            // Insert vào DB
            boolean success = insertProduct(product);

            if (success) {
                sendSuccessResponse(response, "Product added successfully", product);
            } else {
                sendErrorResponse(response, "Failed to add product");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error: " + e.getMessage());
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDao.getByIdAdmin(id);

            if (product == null) {
                sendErrorResponse(response, "Product not found");
                return;
            }

            // Cập nhật thông tin
            product.setName(request.getParameter("name"));
            product.setDescription(request.getParameter("description")); // ✅ THÊM DÒNG NÀY
            product.setImage_url(request.getParameter("image_url"));

            String priceStr = request.getParameter("price");
            product.setPrice(priceStr != null ? Double.parseDouble(priceStr) : 0);

            String oldPriceStr = request.getParameter("old_price");
            product.setOld_price(oldPriceStr != null ? Double.parseDouble(oldPriceStr) : 0);

            String gender = request.getParameter("gender");
            product.setGender(gender);

            String categoryIdStr = request.getParameter("category_id");
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                product.setCategoryId(Integer.parseInt(categoryIdStr));
            } else {
                product.setCategoryId(null);
            }

            String brandIdStr = request.getParameter("brand_id");
            if (brandIdStr != null && !brandIdStr.trim().isEmpty()) {
                product.setBrandId(Integer.parseInt(brandIdStr));
            } else {
                product.setBrandId(null);
            }

            // Update trong DB
            boolean success = updateProductInDb(product);

            if (success) {
                sendSuccessResponse(response, "Product updated successfully", product);
            } else {
                sendErrorResponse(response, "Failed to update product");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error: " + e.getMessage());
        }
    }


    private void toggleActive(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDao.getByIdAdmin(id);

            if (product == null) {
                sendErrorResponse(response, "Product not found");
                return;
            }

            boolean newActive = !product.isActive();
            boolean success = productDao.setActive(id, newActive);

            if (success) {
                // trả về trạng thái mới để JS refresh nếu cần
                product.setActive(newActive);
                sendSuccessResponse(response, "Cập nhật trạng thái thành công", product);
            } else {
                sendErrorResponse(response, "Failed to toggle active");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Invalid product ID");
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = deleteProductFromDb(id);

            if (success) {
                sendSuccessResponse(response, "Product deleted successfully", null);
            } else {
                sendErrorResponse(response, "Failed to delete product");
            }

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid product ID");
        }
    }

    private boolean insertProduct(Product product) {
        try {
            int newId = productDao.insert(product); // ProductDao.insert trả về int
            if (newId > 0) {
                product.setId(newId);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean updateProductInDb(Product product) {
        try {
            // ProductDao.update trả về số dòng bị ảnh hưởng (int)
            return productDao.update(product) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean deleteProductFromDb(int id) {
        try {
            // ProductDao của LTWEB là deleteById(int)
            return productDao.deleteById(id) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    private void sendSuccessResponse(HttpServletResponse response, String message, Object data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String json = String.format(
                "{\"success\": true, \"message\": \"%s\", \"data\": %s}",
                message,
                data != null ? gson.toJson(data) : "null"
        );

        out.print(json);
        out.flush();
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        PrintWriter out = response.getWriter();

        String json = String.format("{\"success\": false, \"message\": \"%s\"}", message);
        out.print(json);
        out.flush();
    }
}
