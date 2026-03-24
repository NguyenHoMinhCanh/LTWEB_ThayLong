package com.japansport.controller;

import com.japansport.dao.ProductDao;
import com.japansport.dao.CategoryDao;
import com.japansport.dao.BrandDao;
import com.japansport.dao.BannerDao;
import com.japansport.model.Banner;
import com.japansport.model.Product;
import com.japansport.model.Category;
import com.japansport.model.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductListController", value = "/list-product")
public class ProductListController extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final CategoryDao categoryDao = new CategoryDao();
    private final BrandDao brandDao = new BrandDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String keywordParam    = req.getParameter("keyword");
        String categoryIdParam = req.getParameter("categoryId");
        String sortParam       = req.getParameter("sort");
        String pageParam       = req.getParameter("page");

        // NEW
        String genderParam     = req.getParameter("gender"); // men/women/unisex
        String saleParam       = req.getParameter("sale");   // 1/true

        String[] priceParams   = req.getParameterValues("price");
        String[] brandIdParams = req.getParameterValues("brandId");

        final int PAGE_SIZE = 16;

        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignore) {
                page = 1;
            }
        }

        // Parse categoryId sớm để dùng nhiều chỗ
        Integer categoryId = null;
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam);
            } catch (NumberFormatException ignore) {
                categoryId = null;
            }
        }

        // Normalize gender + sale
        String normalizedGender = normalizeGender(genderParam); // men/women/unisex hoặc null
        boolean saleOnly = "1".equals(saleParam) || "true".equalsIgnoreCase(saleParam);

        List<Product> allProducts;

        // 1) keyword -> search
        if (keywordParam != null && !keywordParam.trim().isEmpty()) {
            String keyword = keywordParam.trim();
            allProducts = productDao.searchByName(keyword);
            req.setAttribute("keyword", keyword);
        } else {
            // 2) category + sort / all + sort
            if (categoryId != null) {
                allProducts = productDao.getByCategorySorted(categoryId, sortParam);
                req.setAttribute("selectedCategoryId", categoryIdParam);
            } else {
                allProducts = productDao.getAllSorted(sortParam);
            }
        }

        // 3) filter brand
        if (brandIdParams != null && brandIdParams.length > 0
                && allProducts != null && !allProducts.isEmpty()) {

            List<Integer> brandIdFilter = new ArrayList<>();
            for (String s : brandIdParams) {
                try {
                    brandIdFilter.add(Integer.parseInt(s));
                } catch (NumberFormatException ignore) {}
            }

            if (!brandIdFilter.isEmpty()) {
                List<Product> filteredByBrand = new ArrayList<>();
                for (Product p : allProducts) {
                    Integer bId = p.getBrandId();
                    if (bId != null && brandIdFilter.contains(bId)) {
                        filteredByBrand.add(p);
                    }
                }
                allProducts = filteredByBrand;
            }
        }

        // 4) filter price
        if (priceParams != null && priceParams.length > 0
                && allProducts != null && !allProducts.isEmpty()) {

            List<Product> filteredByPrice = new ArrayList<>();
            for (Product p : allProducts) {
                double price = p.getPrice();

                boolean matchAnyRange = false;
                for (String range : priceParams) {
                    if (isPriceInRange(price, range)) {
                        matchAnyRange = true;
                        break;
                    }
                }

                if (matchAnyRange) {
                    filteredByPrice.add(p);
                }
            }
            allProducts = filteredByPrice;
        }

        // 4.5) NEW: filter gender (GIÀY NAM/NỮ hoặc sidebar gender)
        if (normalizedGender != null
                && allProducts != null && !allProducts.isEmpty()) {

            List<Product> filteredByGender = new ArrayList<>();
            for (Product p : allProducts) {
                if (p.getGender() != null && p.getGender().equalsIgnoreCase(normalizedGender)) {
                    filteredByGender.add(p);
                }
            }
            allProducts = filteredByGender;
            req.setAttribute("selectedGender", normalizedGender);
        }

        // 4.6) NEW: filter sale (nếu bạn dùng menu KHUYẾN MÃI)
        if (saleOnly && allProducts != null && !allProducts.isEmpty()) {
            List<Product> filteredSale = new ArrayList<>();
            for (Product p : allProducts) {
                if (p.getOld_price() > 0 && p.getOld_price() > p.getPrice()) {
                    filteredSale.add(p);
                }
            }
            allProducts = filteredSale;
            req.setAttribute("selectedSale", "1");
        }

        // 5) pagination
        int totalProducts = (allProducts != null) ? allProducts.size() : 0;
        int totalPages;
        List<Product> productsPage;

        if (totalProducts == 0) {
            totalPages = 0;
            page = 1;
            productsPage = allProducts;
        } else {
            totalPages = (int) Math.ceil(totalProducts * 1.0 / PAGE_SIZE);
            if (page > totalPages) page = totalPages;

            int fromIndex = (page - 1) * PAGE_SIZE;
            int toIndex = Math.min(fromIndex + PAGE_SIZE, totalProducts);
            productsPage = allProducts.subList(fromIndex, toIndex);
        }

        // 6) sidebar data
        List<Category> categories = categoryDao.getAllActive();
        List<Brand> brands = brandDao.getAllActive();

        req.setAttribute("categoryList", categories);
        req.setAttribute("brandList", brands);

        // NEW: show gender filter chỉ khi vào theo THỂ LOẠI hoặc THƯƠNG HIỆU
        boolean showGenderFilter = (categoryId != null) || (brandIdParams != null && brandIdParams.length > 0);
        req.setAttribute("showGenderFilter", showGenderFilter);

        // NEW: title + breadcrumb
        String pageTitle = buildPageTitle(
                keywordParam, saleOnly, categoryId, categories,
                brandIdParams, brands, normalizedGender
        );
        req.setAttribute("pageTitle", pageTitle);
        req.setAttribute("breadcrumbCurrent", pageTitle);

        // 7) send data
        req.setAttribute("selectedSort", sortParam);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);

        req.setAttribute("selectedPrices", priceParams);
        req.setAttribute("selectedBrandIds", brandIdParams);

        req.setAttribute("listProduct", productsPage);

        // Banner trang shop (products.jsp)
        BannerDao bannerDao = new BannerDao();
        Banner shopTopBanner = bannerDao.getOneBannerByPosition("SHOP_TOP");
        req.setAttribute("shopTopBanner", shopTopBanner);

        req.getRequestDispatcher("products.jsp").forward(req, resp);
    }

    private String buildPageTitle(
            String keywordParam,
            boolean saleOnly,
            Integer categoryId,
            List<Category> categories,
            String[] brandIdParams,
            List<Brand> brands,
            String gender
    ) {
        // gender label
        String genderLabel = toGenderLabel(gender);

        // base title theo ưu tiên
        String base;
        if (keywordParam != null && !keywordParam.trim().isEmpty()) {
            base = "Kết quả tìm kiếm: " + keywordParam.trim();
        } else if (saleOnly) {
            base = "Khuyến mãi";
        } else if (categoryId != null) {
            base = findCategoryName(categories, categoryId, "Thể loại");
        } else if (brandIdParams != null && brandIdParams.length == 1) {
            Integer brandId = tryParseInt(brandIdParams[0]);
            base = (brandId != null) ? findBrandName(brands, brandId, "Thương hiệu") : "Thương hiệu";
        } else if (brandIdParams != null && brandIdParams.length > 1) {
            base = "Nhiều thương hiệu";
        } else if (gender != null) {
            base = genderLabel; // “Giày nam/giày nữ/unisex”
        } else {
            base = "Tất cả sản phẩm";
        }

        // Nếu đang ở category/brand/sale/search mà có gender -> append để ra đúng context
        boolean baseIsGenderOnly = (gender != null && (categoryId == null) && (brandIdParams == null || brandIdParams.length == 0) && !saleOnly
                && (keywordParam == null || keywordParam.trim().isEmpty()));

        if (!baseIsGenderOnly && genderLabel != null) {
            // ví dụ: "Running - Giày nam" / "Nike - Giày nữ"
            base = base + " - " + genderLabel;
        }

        return base;
    }

    private String findCategoryName(List<Category> list, int id, String fallback) {
        if (list != null) {
            for (Category c : list) {
                if (c.getId() == id) return c.getName();
            }
        }
        return fallback;
    }

    private String findBrandName(List<Brand> list, int id, String fallback) {
        if (list != null) {
            for (Brand b : list) {
                if (b.getId() == id) return b.getName();
            }
        }
        return fallback;
    }

    private Integer tryParseInt(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return null; }
    }

    private String toGenderLabel(String g) {
        if (g == null) return null;
        switch (g.toLowerCase()) {
            case "men": return "Giày nam";
            case "women": return "Giày nữ";
            case "unisex": return "Unisex";
            default: return null;
        }
    }

    private String normalizeGender(String genderParam) {
        if (genderParam == null) return null;
        String g = genderParam.trim().toLowerCase();
        if (g.isEmpty()) return null;

        if (g.equals("m") || g.equals("male")) return "men";
        if (g.equals("f") || g.equals("female")) return "women";

        if (g.equals("men") || g.equals("women") || g.equals("unisex")) return g;
        return null;
    }

    private boolean isPriceInRange(double price, String range) {
        switch (range) {
            case "0-500":
                return price < 500_000;
            case "500-1000":
                return price >= 500_000 && price < 1_000_000;
            case "1000-1500":
                return price >= 1_000_000 && price < 1_500_000;
            case "1500-2000":
                return price >= 1_500_000 && price < 2_000_000;
            case "2000-2500":
                return price >= 2_000_000 && price < 2_500_000;
            case "2500-3000":
                return price >= 2_500_000 && price < 3_000_000;
            case "3000+":
                return price >= 3_000_000;
            default:
                return true;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
