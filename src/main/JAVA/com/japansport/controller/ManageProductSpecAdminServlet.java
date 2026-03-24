package com.japansport.controller;

import com.google.gson.Gson;
import com.japansport.dao.ProductSpecDao;
import com.japansport.model.ProductSpec;
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

@WebServlet(name = "ManageProductSpecAdminServlet", urlPatterns = {"/admin/product-specs"})
@MultipartConfig
public class ManageProductSpecAdminServlet extends HttpServlet {

    private final ProductSpecDao specDao = new ProductSpecDao();
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
            List<ProductSpec> list = specDao.findByProductId(productId);
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

        String key = trimToNull(request.getParameter("spec_key"));
        String value = trimToNull(request.getParameter("spec_value"));
        if (key == null || value == null) {
            sendError(response, "spec_key and spec_value are required");
            return;
        }

        ProductSpec s = new ProductSpec();
        s.setProductId(productId);
        s.setSpecKey(key);
        s.setSpecValue(value);
        s.setSortOrder(parseInt(request.getParameter("sort_order"), 0));

        int newId = specDao.insert(s);
        if (newId > 0) {
            s.setId(newId);
            sendSuccess(response, "Added", s);
        } else {
            sendError(response, "Failed to add spec");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseInt(request.getParameter("id"), -1);
        if (id <= 0) {
            sendError(response, "Missing id");
            return;
        }

        String key = trimToNull(request.getParameter("spec_key"));
        String value = trimToNull(request.getParameter("spec_value"));
        if (key == null || value == null) {
            sendError(response, "spec_key and spec_value are required");
            return;
        }

        ProductSpec s = new ProductSpec();
        s.setId(id);
        s.setSpecKey(key);
        s.setSpecValue(value);
        s.setSortOrder(parseInt(request.getParameter("sort_order"), 0));

        boolean ok = specDao.update(s);
        if (ok) sendSuccess(response, "Updated", s);
        else sendError(response, "Failed to update spec");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseInt(request.getParameter("id"), -1);
        if (id <= 0) {
            sendError(response, "Missing id");
            return;
        }
        boolean ok = specDao.delete(id);
        if (ok) sendSuccess(response, "Deleted", null);
        else sendError(response, "Failed to delete spec");
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
