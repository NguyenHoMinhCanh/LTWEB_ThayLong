package com.japansport.filter;

import com.japansport.dao.BrandDao;
import com.japansport.dao.CategoryDao;
import com.japansport.dao.PolicyDao;
import com.japansport.model.Brand;
import com.japansport.model.Category;
import com.japansport.model.Policy;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.List;

/**
 * Load menu data (categories, brands, policies) once per TTL and put into application scope
 * so header/footer can render without querying DB every request.
 */
@WebFilter("/*")
public class MenuFilter implements Filter {

    // Application-scope attribute keys (giữ ổn định để các JSP/servlet khác không bị lệch)
    public static final String APP_CATEGORIES = "APP_MENU_CATEGORIES";
    public static final String APP_BRANDS = "APP_MENU_BRANDS";
    public static final String APP_POLICIES = "APP_MENU_POLICIES";
    public static final String APP_LAST_LOAD = "APP_MENU_LAST_LOAD";

    // 5 phút cache
    private static final long TTL_MS = 5 * 60 * 1000L;

    private CategoryDao categoryDao;
    private BrandDao brandDao;
    private PolicyDao policyDao;

    @Override
    public void init(FilterConfig filterConfig) {
        categoryDao = new CategoryDao();
        brandDao = new BrandDao();
        policyDao = new PolicyDao();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof HttpServletRequest httpReq) {
            String uri = httpReq.getRequestURI();
            // Tránh cache menu cho file tĩnh (css/js/img) để giảm overhead
            if (!isStaticResource(uri)) {
                ensureMenuLoaded(httpReq.getServletContext());
            }
        }

        chain.doFilter(request, response);
    }

    private void ensureMenuLoaded(ServletContext app) {
        if (app == null) return;

        Long last = (Long) app.getAttribute(APP_LAST_LOAD);
        long now = System.currentTimeMillis();

        boolean expired = (last == null) || (now - last > TTL_MS);
        boolean missingAny =
                app.getAttribute(APP_CATEGORIES) == null ||
                        app.getAttribute(APP_BRANDS) == null ||
                        app.getAttribute(APP_POLICIES) == null;

        if (!expired && !missingAny) return;

        // Load categories/brands/policies active for shop menu/footer
        List<Category> categories = categoryDao.getAllActive();
        List<Brand> brands = brandDao.getAllActive();
        List<Policy> policies = policyDao.getAllActiveForMenu();

        app.setAttribute(APP_CATEGORIES, categories);
        app.setAttribute(APP_BRANDS, brands);
        app.setAttribute(APP_POLICIES, policies);
        app.setAttribute(APP_LAST_LOAD, now);
    }

    private boolean isStaticResource(String uri) {
        if (uri == null) return false;
        String u = uri.toLowerCase();
        return u.endsWith(".css") || u.endsWith(".js") || u.endsWith(".png") || u.endsWith(".jpg")
                || u.endsWith(".jpeg") || u.endsWith(".gif") || u.endsWith(".svg") || u.endsWith(".webp")
                || u.endsWith(".ico") || u.endsWith(".woff") || u.endsWith(".woff2") || u.endsWith(".ttf")
                || u.endsWith(".map");
    }

    // ===== Invalidate caches (gọi sau khi admin CRUD để shop cập nhật ngay) =====

    public static void invalidateCategoryCache(ServletContext app) {
        if (app == null) return;
        app.removeAttribute(APP_CATEGORIES);
        app.removeAttribute(APP_LAST_LOAD);
    }

    public static void invalidateBrandCache(ServletContext app) {
        if (app == null) return;
        app.removeAttribute(APP_BRANDS);
        app.removeAttribute(APP_LAST_LOAD);
    }

    public static void invalidatePolicyCache(ServletContext app) {
        if (app == null) return;
        app.removeAttribute(APP_POLICIES);
        app.removeAttribute(APP_LAST_LOAD);
    }

    @Override
    public void destroy() {
        // no-op
    }
}
