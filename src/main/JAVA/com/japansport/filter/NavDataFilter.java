package com.japansport.filter;

import com.japansport.dao.BannerDao;
import com.japansport.dao.BrandDao;
import com.japansport.dao.CategoryDao;
import com.japansport.model.Banner;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;
import java.util.Base64;
import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class NavDataFilter implements Filter {

    private CategoryDao categoryDao;
    private BrandDao brandDao;
    private BannerDao bannerDao;

    private static final String CSRF_KEY = "CSRF_TOKEN";

    @Override
    public void init(FilterConfig filterConfig) {
        categoryDao = new CategoryDao();
        brandDao = new BrandDao();
        bannerDao = new BannerDao();
    }

    private boolean isStaticAsset(String uri) {
        if (uri == null) return false;
        uri = uri.toLowerCase();
        return uri.endsWith(".css")
                || uri.endsWith(".js")
                || uri.endsWith(".png")
                || uri.endsWith(".jpg")
                || uri.endsWith(".jpeg")
                || uri.endsWith(".webp")
                || uri.endsWith(".gif")
                || uri.endsWith(".svg")
                || uri.endsWith(".ico")
                || uri.endsWith(".woff")
                || uri.endsWith(".woff2")
                || uri.endsWith(".ttf");
    }

    private void ensureCsrf(HttpSession session) {
        if (session == null) return;
        if (session.getAttribute(CSRF_KEY) == null) {
            byte[] bytes = new byte[32];
            new SecureRandom().nextBytes(bytes);
            String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
            session.setAttribute(CSRF_KEY, token);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof HttpServletRequest) {
            HttpServletRequest req = (HttpServletRequest) request;
            String uri = req.getRequestURI();

            if (!isStaticAsset(uri)) {
                ensureCsrf(req.getSession());

                // chỉ set khi trang chưa set (tránh overwrite)
                if (req.getAttribute("categoryList") == null) {
                    req.setAttribute("categoryList", categoryDao.getAllActive());
                }
                if (req.getAttribute("brandList") == null) {
                    req.setAttribute("brandList", brandDao.getAllActive());
                }

                // NEW: banner trên header tất cả trang
                if (req.getAttribute("headerBanners") == null) {
                    List<Banner> headerBanners = bannerDao.getBannersByPosition("HEADER_TOP");
                    req.setAttribute("headerBanners", headerBanners);
                }
            }
        }

        chain.doFilter(request, response);
    }
}
