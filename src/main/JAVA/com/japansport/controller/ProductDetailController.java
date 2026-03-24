package com.japansport.controller;

import com.japansport.dao.ProductDao;
import com.japansport.dao.BannerDao;
import com.japansport.model.Banner;
import com.japansport.dao.ProductImageDao;
import com.japansport.dao.ProductVariantDAO;
import com.japansport.dao.ProductSpecDao;
import com.japansport.model.Product;
import com.japansport.model.ProductImage;
import com.japansport.model.ProductVariant;
import com.japansport.model.ProductSpec;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "ProductDetailController", urlPatterns = {"/product-detail", "/product"})
public class ProductDetailController extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final ProductImageDao productImageDao = new ProductImageDao();
    private final ProductVariantDAO variantDAO = new ProductVariantDAO();
    private final ProductSpecDao specDao = new ProductSpecDao();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Accept both: /product-detail?id=1  OR  /product-detail?productId=1
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            idParam = request.getParameter("productId");
        }

        int productId;
        try {
            productId = Integer.parseInt(idParam);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/list-product");
            return;
        }

        Product product = productDao.getById(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/list-product");
            return;
        }

        List<ProductImage> images;
        try {
            images = productImageDao.getByProductId(productId);
        } catch (Exception e) {
            images = Collections.emptyList();
        }

        List<ProductVariant> variants;
        try {
            variants = variantDAO.findByProductId(productId);
        } catch (Exception e) {
            variants = Collections.emptyList();
        }

        List<ProductSpec> specs;
        try {
            specs = specDao.findByProductId(productId);
        } catch (Exception e) {
            specs = Collections.emptyList();
        }



        request.setAttribute("product", product);
        request.setAttribute("images", images);
        request.setAttribute("variants", variants);
        request.setAttribute("specs", specs);

        // Banner trang chi tiết sản phẩm
        BannerDao bannerDao = new BannerDao();
        Banner productDetailTopBanner = bannerDao.getOneBannerByPosition("PRODUCT_DETAIL_TOP");
        request.setAttribute("productDetailTopBanner", productDetailTopBanner);

        request.getRequestDispatcher("/product_detail.jsp").forward(request, response);
    }
}
