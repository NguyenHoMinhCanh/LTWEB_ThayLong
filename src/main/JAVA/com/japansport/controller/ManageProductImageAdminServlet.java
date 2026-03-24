package com.japansport.controller;

import com.google.gson.Gson;
import com.japansport.dao.ProductImageDao;
import com.japansport.model.ProductImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ManageProductImageAdminServlet", urlPatterns = {"/admin/product-images"})
@MultipartConfig
public class ManageProductImageAdminServlet extends HttpServlet {

    private final ProductImageDao imageDao = new ProductImageDao();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";

        if ("list".equals(action)) {
            int productId = parseInt(request.getParameter("productId"), -1);
            if (productId <= 0) {
                sendError(response, "Missing productId");
                return;
            }
            List<ProductImage> list = imageDao.adminGetAllByProductId(productId);
            sendJson(response, list);
            return;
        }

        sendError(response, "Invalid action");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            sendError(response, "Missing action");
            return;
        }

        switch (action) {
            case "add":
                handleAdd(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "setMain":
                handleSetMain(request, response);
                break;
            default:
                sendError(response, "Invalid action");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = parseInt(request.getParameter("product_id"), -1);
        if (productId <= 0) {
            sendError(response, "Missing product_id");
            return;
        }

        String url = trimToNull(request.getParameter("image_url"));
        if (url == null) {
            sendError(response, "image_url is required");
            return;
        }

        ProductImage img = new ProductImage();
        img.setProductId(productId);
        img.setImageUrl(url);
        img.setAlt(trimToNull(request.getParameter("alt")));
        img.setColor(trimToNull(request.getParameter("color")));
        img.setSortOrder(parseInt(request.getParameter("sort_order"), 0));
        img.setActive(!"0".equals(request.getParameter("active")));
        img.setMainImage("1".equals(request.getParameter("is_main")) || "on".equals(request.getParameter("is_main")));

        int newId = imageDao.insert(img);
        if (newId > 0) {
            img.setId(newId);
            sendSuccess(response, "Added", img);
        } else {
            sendError(response, "Failed to add image");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseInt(request.getParameter("id"), -1);
        int productId = parseInt(request.getParameter("product_id"), -1);
        if (id <= 0) {
            sendError(response, "Missing id");
            return;
        }
        if (productId <= 0) {
            sendError(response, "Missing product_id");
            return;
        }

        // Admin update: bắt buộc có url
        String url = trimToNull(request.getParameter("image_url"));
        if (url == null) {
            sendError(response, "image_url is required");
            return;
        }

        ProductImage img = new ProductImage();
        img.setId(id);
        img.setProductId(productId);
        img.setImageUrl(url);
        img.setAlt(trimToNull(request.getParameter("alt")));
        img.setColor(trimToNull(request.getParameter("color")));
        img.setSortOrder(parseInt(request.getParameter("sort_order"), 0));
        img.setActive(!"0".equals(request.getParameter("active")));

        // ✅ nếu admin tick "main" trong form update => đảm bảo main duy nhất theo (product + color)
        boolean wantMain = "1".equals(request.getParameter("is_main")) || "on".equalsIgnoreCase(request.getParameter("is_main"));

        boolean ok = imageDao.update(img);
        if (!ok) {
            sendError(response, "Failed to update image");
            return;
        }

        if (wantMain) {
            boolean okMain = imageDao.setMain(id, productId, img.getColor());
            if (!okMain) {
                // update ok nhưng setMain lỗi => báo rõ để admin biết
                sendError(response, "Updated but failed to set main image");
                return;
            }
            img.setMainImage(true);
        }

        sendSuccess(response, "Updated", img);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseInt(request.getParameter("id"), -1);
        if (id <= 0) {
            sendError(response, "Missing id");
            return;
        }
        boolean ok = imageDao.delete(id);
        if (ok) sendSuccess(response, "Deleted", null);
        else sendError(response, "Failed to delete image");
    }

    private void handleSetMain(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseInt(request.getParameter("id"), -1);
        int productId = parseInt(request.getParameter("product_id"), -1);
        String color = trimToNull(request.getParameter("color"));
        if (id <= 0 || productId <= 0) {
            sendError(response, "Missing id/product_id");
            return;
        }
        boolean ok = imageDao.setMain(id, productId, color);
        if (ok) sendSuccess(response, "Set main", null);
        else sendError(response, "Failed to set main");
    }

    // ====== JSON helpers ======
    private void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    private void sendSuccess(HttpServletResponse response, String message, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> payload = new HashMap<>();
        payload.put("success", true);
        payload.put("message", message);
        payload.put("data", data);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(payload));
        out.flush();
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> payload = new HashMap<>();
        payload.put("success", false);
        payload.put("message", message);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(payload));
        out.flush();
    }

    private static int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}
