package com.japansport.controller;

import com.japansport.dao.BrandDao;
import com.japansport.dao.ProductDao;
import com.japansport.model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.japansport.dao.BannerDao;
import com.japansport.model.Banner;
import com.japansport.model.Category;
import com.japansport.model.Brand;
import com.japansport.dao.CategoryDao;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", value = "/home")
public class HomeController extends HttpServlet {

    private ProductDao productDao;
    private BannerDao bannerDao;
    private CategoryDao categoryDao;
    private BrandDao brandDao;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDao();
        bannerDao = new BannerDao();
        categoryDao = new CategoryDao();
        brandDao = new BrandDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            // [update#1] Sản phẩm mới nhất (limit 12)
            List<Product> productList = productDao.getLatest(12);

            // [update#1] Sản phẩm bán chạy (limit 12)
            List<Product> bestSellerProducts = productDao.getBestSellers(12);

            // Lấy banner theo từng vị trí
            List<Banner> topBanners = bannerDao.getBannersByPosition("HOME_TOP");
            Banner menBanner = bannerDao.getOneBannerByPosition("HOME_MEN");
            Banner womenRightBanner = bannerDao.getOneBannerByPosition("HOME_WOMEN_RIGHT");
            Banner womenBottomBanner = bannerDao.getOneBannerByPosition("HOME_WOMEN_BOTTOM");

            // Lấy sản phẩm nam
            List<Product> menProducts = productDao.getByGender("M", 8);

            // Lấy sản phẩm nữ
            List<Product> womenProducts = productDao.getByGender("F", 8);

            // Lấy 6 danh mục nổi bật
            List<Category> featuredCategories = categoryDao.getFeaturedCategories(3);

            List<Brand> brands = brandDao.getAllActive();

            // Debug xem có dữ liệu không
            System.out.println("HomeController - productList(latest) size = " + productList.size());
            System.out.println("HomeController - bestSellerProducts size = " + bestSellerProducts.size());

            /* SET ATTRIBUTE (gắn giá trị) */
            request.setAttribute("productList", productList);        // Sản phẩm mới nhất
            request.setAttribute("bestSellerProducts", bestSellerProducts); // Sản phẩm bán chạy

            // Gắn attribute cho banner
            request.setAttribute("topBanners", topBanners);
            request.setAttribute("menBanner", menBanner);
            request.setAttribute("womenRightBanner", womenRightBanner);
            request.setAttribute("womenBottomBanner", womenBottomBanner);

            // Gắn attribute cho sản phẩm nam/nữ
            request.setAttribute("menProducts", menProducts);
            request.setAttribute("womenProducts", womenProducts);

            // Gắn attribute cho danh mục nổi bật
            request.setAttribute("featuredCategories", featuredCategories);

            request.setAttribute("brands", brands);

            // Trả về index.jsp
            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi truy xuất dữ liệu sản phẩm");
        }
    }
}
