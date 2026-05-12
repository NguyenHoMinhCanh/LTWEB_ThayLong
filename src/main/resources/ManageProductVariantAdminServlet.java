package com.japansport.controller;

import com.google.gson.Gson;
import com.japansport.dao.ProductVariantDAO;
import com.japansport.model.ProductVariant;
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

@WebServlet(name = "ManageProductVariantAdminServlet", urlPatterns = {"/admin/product-variants"})
@MultipartConfig
public class ManageProductVariantAdminServlet extends HttpServlet {

    private final ProductVariantDAO variantDAO = new ProductVariantDAO();
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
            List<ProductVariant> list = variantDAO.findByProductId(productId);
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

        ProductVariant v = new ProductVariant();
        v.setProductId(productId);
        v.setColor(trimToNull(request.getParameter("color")));
        v.setSize(trimToNull(request.getParameter("size")));
        v.setStockQty(parseInt(request.getParameter("stock_qty"), 0));
        v.setSku(trimToNull(request.getParameter("sku")));

        String priceStr = trimToNull(request.getParameter("price"));
        if (priceStr != null) {
            try {
                v.setPrice(Double.parseDouble(priceStr));
            } catch (Exception e) {
                v.setPrice(null);
            }
        } else {
            v.setPrice(null);
        }

        if (v.getColor() == null || v.getSize() == null) {
            sendError(response, "Color and Size are required");
            return;
        }

        int newId = variantDAO.insert(v);
        if (newId > 0) {
            v.setId(newId);
            sendSuccess(response, "Added", v);
        } else {
            sendError(response, "Failed to add variant (maybe duplicate color+size?)");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseInt(request.getParameter("id"), -1);
        if (id <= 0) {
            sendError(response, "Missing id");
            return;
        }

        ProductVariant v = variantDAO.findById(id);
        if (v == null) {
            sendError(response, "Variant not found");
            return;
        }

        String color = trimToNull(request.getParameter("color"));
        String size = trimToNull(request.getParameter("size"));
        if (color == null || size == null) {
            sendError(response, "Color and Size are required");
            return;
        }

        v.setColor(color);
        v.setSize(size);
        v.setStockQty(parseInt(request.getParameter("stock_qty"), v.getStockQty()));
        v.setSku(trimToNull(request.getParameter("sku")));

        String priceStr = trimToNull(request.getParameter("price"));
        if (priceStr != null) {
            try {
                v.setPrice(Double.parseDouble(priceStr));
            } catch (Exception e) {
                v.setPrice(null);
            }
        } else {
            v.setPrice(null);
        }

        boolean ok = variantDAO.update(v);
        if (ok) sendSuccess(response, "Updated", v);
        else sendError(response, "Failed to update variant (maybe duplicate color+size?)");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseInt(request.getParameter("id"), -1);
        if (id <= 0) {
            sendError(response, "Missing id");
            return;
        }
        boolean ok = variantDAO.delete(id);
        if (ok) sendSuccess(response, "Deleted", null);
        else sendError(response, "Failed to delete");
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
