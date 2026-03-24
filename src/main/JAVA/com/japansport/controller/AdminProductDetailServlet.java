package com.japansport.controller;

import com.japansport.dao.ProductDao;
import com.japansport.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Trang admin quản trị chi tiết sản phẩm: biến thể (size/màu/tồn kho), gallery ảnh, specs.
 */
@WebServlet(name = "AdminProductDetailServlet", urlPatterns = {"/admin/product-detail"})
public class AdminProductDetailServlet extends HttpServlet {

    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        int productId;
        try {
            productId = Integer.parseInt(idParam);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        Product p = productDao.getByIdAdmin(productId);
        if (p == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=notfound");
            return;
        }

        request.setAttribute("product", p);
        request.getRequestDispatcher("/admin/product-detail.jsp").forward(request, response);
    }
}
