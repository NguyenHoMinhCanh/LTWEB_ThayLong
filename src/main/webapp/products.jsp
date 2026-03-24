<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.japansport.model.Product" %>
<%@ page import="com.japansport.model.Category" %>
<%@ page import="com.japansport.model.Brand" %>
<%@ page import="com.japansport.model.Banner" %>
<%
    List<Product> list = (List<Product>) request.getAttribute("listProduct");
    if (list == null) {
        response.sendRedirect(request.getContextPath() + "/list-product");
        return;
    }
    String ctx = request.getContextPath();
    List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
    String selectedCategoryId = (String) request.getAttribute("selectedCategoryId");
    String selectedSort = (String) request.getAttribute("selectedSort");

    List<Brand> brandList = (List<Brand>) request.getAttribute("brandList");

    String[] selectedBrandIdsArr = (String[]) request.getAttribute("selectedBrandIds");
    Set<String> selectedBrandIdSet = new HashSet<>();
    if (selectedBrandIdsArr != null) {
        selectedBrandIdSet.addAll(Arrays.asList(selectedBrandIdsArr));
    }

    // Phân trang
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    Integer totalProductsObj = (Integer) request.getAttribute("totalProducts");

    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    int totalPages = (totalPagesObj != null) ? totalPagesObj : 0;
    int totalProducts = (totalProductsObj != null) ? totalProductsObj : list.size();

    Banner shopTopBanner = (Banner) request.getAttribute("shopTopBanner");

    // Từ khoá search
    String keywordAttr = (String) request.getAttribute("keyword");

    // Các khoảng giá đang được chọn (từ controller gửi xuống)
    String[] selectedPricesArr = (String[]) request.getAttribute("selectedPrices");
    Set<String> selectedPriceSet = new HashSet<>();
    if (selectedPricesArr != null) {
        selectedPriceSet.addAll(Arrays.asList(selectedPricesArr));
    }
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null || pageTitle.trim().isEmpty()) pageTitle = "Tất cả sản phẩm";

    String breadcrumbCurrent = (String) request.getAttribute("breadcrumbCurrent");
    if (breadcrumbCurrent == null || breadcrumbCurrent.trim().isEmpty()) breadcrumbCurrent = pageTitle;

    String selectedGender = (String) request.getAttribute("selectedGender");
    Boolean showGenderFilterObj = (Boolean) request.getAttribute("showGenderFilter");
    boolean showGenderFilter = (showGenderFilterObj != null && showGenderFilterObj);

    String saleParam = request.getParameter("sale"); // nếu bạn dùng menu sale


%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Japan Sport - <%= pageTitle %></title>

    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet"/>
    <!-- App CSS -->
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>

<!-- ===== Banner (động từ DB: position = SHOP_TOP) ===== -->
<% if (shopTopBanner != null && shopTopBanner.getActive() == 1) { %>
<div class="container my-4">
    <a href="<%= (shopTopBanner.getLink() == null || shopTopBanner.getLink().trim().isEmpty()) ? "#" : shopTopBanner.getLink() %>">
        <%
            String img = shopTopBanner.getImage_url();
            String imgSrc = "";
            if (img != null) {
                img = img.trim();
                if (img.startsWith("http://") || img.startsWith("https://")) imgSrc = img;
                else if (img.startsWith("/")) imgSrc = ctx + img;
                else imgSrc = ctx + "/" + img;
            }
        %>
        <img src="<%= imgSrc %>" alt="<%= (shopTopBanner.getTitle() == null ? "banner" : shopTopBanner.getTitle()) %>"
             style="width: 100%; max-height: 320px; object-fit: cover; border-radius: 16px;">
    </a>
</div>
<% } %>

<!-- ===== Header + Navbar ===== -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<!-- ===== Breadcrumb + Title ===== -->
<div class="bg-light py-3 border-bottom">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 justify-content-center">
                <li class="breadcrumb-item"><a href="index.jsp">Trang chủ</a></li>
                <li class="breadcrumb-item active text-danger" aria-current="page"><%= breadcrumbCurrent %></li>
            </ol>
        </nav>
    </div>
</div>

<div class="container my-4">
    <h2 class="text-center text-danger fw-bold mb-4"><%= pageTitle %></h2>

    <div class="row">
        <!-- ===== Sidebar ===== -->
        <aside class="col-lg-3 mb-4">
            <div class="widget-box mb-4">
                <div class="widget-title">DANH MỤC SẢN PHẨM</div>
                <ul class="category-list list-unstyled mb-0">

                    <!-- Tất cả -->
                    <li>
                        <a href="<%= ctx %>/list-product"
                           class="<% if (selectedCategoryId == null) { %>fw-bold text-danger<% } %>">
                            Tất cả sản phẩm
                        </a>
                        <i class="bi bi-chevron-right"></i>
                    </li>

                    <%
                        if (categoryList != null) {
                            for (Category c : categoryList) {
                                boolean active = (selectedCategoryId != null) &&
                                        selectedCategoryId.equals(String.valueOf(c.getId()));
                    %>
                    <li>
                        <a href="<%= ctx %>/list-product?categoryId=<%= c.getId() %>"
                           class="<% if (active) { %>fw-bold text-danger<% } %>">
                            <%= c.getName() %>
                        </a>
                        <i class="bi bi-chevron-right"></i>
                    </li>
                    <% }
                    }
                    %>
                </ul>
            </div>

            <!-- FORM LỌC (THƯƠNG HIỆU + MỨC GIÁ + LOẠI SẢN PHẨM) -->
            <form method="get" action="<%= ctx %>/list-product">

                <!-- giữ lại category, sort, keyword hiện tại -->
                <% if (selectedCategoryId != null && !selectedCategoryId.isEmpty()) { %>
                <input type="hidden" name="categoryId" value="<%= selectedCategoryId %>">
                <% } %>
                <% if (selectedSort != null && !selectedSort.isEmpty()) { %>
                <input type="hidden" name="sort" value="<%= selectedSort %>">
                <% } %>
                <% if (keywordAttr != null && !keywordAttr.isEmpty()) { %>
                <input type="hidden" name="keyword" value="<%= keywordAttr %>">
                <% } %>


                <%-- GIỚI TÍNH: chỉ hiện khi vào theo THỂ LOẠI hoặc THƯƠNG HIỆU --%>
                <% if (showGenderFilter) { %>
                <div class="widget-box mb-4">
                    <div class="widget-title">GIỚI TÍNH</div>

                    <label class="form-check">
                        <input class="form-check-input" type="radio" name="gender" value=""
                            <%= (selectedGender == null) ? "checked" : "" %>>
                        <span class="form-check-label">Tất cả</span>
                    </label>

                    <label class="form-check">
                        <input class="form-check-input" type="radio" name="gender" value="men"
                            <%= "men".equalsIgnoreCase(selectedGender) ? "checked" : "" %>>
                        <span class="form-check-label">Giày nam</span>
                    </label>

                    <label class="form-check">
                        <input class="form-check-input" type="radio" name="gender" value="women"
                            <%= "women".equalsIgnoreCase(selectedGender) ? "checked" : "" %>>
                        <span class="form-check-label">Giày nữ</span>
                    </label>

                    <label class="form-check">
                        <input class="form-check-input" type="radio" name="gender" value="unisex"
                            <%= "unisex".equalsIgnoreCase(selectedGender) ? "checked" : "" %>>
                        <span class="form-check-label">Unisex</span>
                    </label>
                </div>
                <% } else { %>
                <%-- Không hiện block giới tính, nhưng nếu đang có gender thì phải GIỮ lại để không mất filter --%>
                <% if (selectedGender != null && !selectedGender.isEmpty()) { %>
                <input type="hidden" name="gender" value="<%= selectedGender %>">
                <% } %>
                <% } %>


                <!-- THƯƠNG HIỆU  -->
                <div class="widget-box mb-4">
                    <div class="widget-title">THƯƠNG HIỆU</div>
                    <div class="brand-list">
                        <% if (brandList != null) {
                            for (Brand b : brandList) { %>
                        <label class="form-check">
                            <input class="form-check-input"
                                   type="checkbox"
                                   name="brandId"
                                   value="<%= b.getId() %>"
                                <%= selectedBrandIdSet.contains(String.valueOf(b.getId())) ? "checked" : "" %>>
                            <span class="form-check-label"><%= b.getName() %></span>
                        </label>
                        <% }
                        } else { %>
                        <p class="text-muted mb-0">Chưa có thương hiệu nào.</p>
                        <% } %>
                    </div>
                </div>

                <!-- MỨC GIÁ -->
                <div class="widget-box mb-4">
                    <div class="widget-title">MỨC GIÁ</div>
                    <div class="brand-list">
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="0-500"
                                <%= selectedPriceSet.contains("0-500") ? "checked" : "" %>>
                            <span class="form-check-label">Giá dưới 500.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="500-1000"
                                <%= selectedPriceSet.contains("500-1000") ? "checked" : "" %>>
                            <span class="form-check-label">500.000đ - 1.000.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="1000-1500"
                                <%= selectedPriceSet.contains("1000-1500") ? "checked" : "" %>>
                            <span class="form-check-label">1.000.000đ - 1.500.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="1500-2000"
                                <%= selectedPriceSet.contains("1500-2000") ? "checked" : "" %>>
                            <span class="form-check-label">1.500.000đ - 2.000.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="2000-2500"
                                <%= selectedPriceSet.contains("2000-2500") ? "checked" : "" %>>
                            <span class="form-check-label">2.000.000đ - 2.500.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="2500-3000"
                                <%= selectedPriceSet.contains("2500-3000") ? "checked" : "" %>>
                            <span class="form-check-label">2.500.000đ - 3.000.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="3000+"
                                <%= selectedPriceSet.contains("3000+") ? "checked" : "" %>>
                            <span class="form-check-label">Giá trên 3.000.000đ</span>
                        </label>
                    </div>
                </div>

                <!-- LOẠI SẢN PHẨM (UI, chưa có cột type trong DB) -->
                <div class="widget-box">
                    <div class="widget-title">LOẠI SẢN PHẨM</div>
                    <div class="brand-list">
                        <!-- giữ nguyên các checkbox loại sản phẩm hiện có -->
                    </div>
                </div>

                <button type="submit" class="btn btn-danger w-100 mt-3">
                    Lọc sản phẩm
                </button>
            </form>

        </aside>

        <!-- ===== Product list ===== -->
        <section class="col-lg-9">
            <!-- sort line -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0"><%= pageTitle.toUpperCase() %></h4>
                <form method="get" action="<%= ctx %>/list-product" class="d-flex align-items-center gap-2">
                    <%-- Giữ lại categoryId nếu đang lọc theo danh mục --%>
                    <% if (selectedCategoryId != null) { %>
                    <input type="hidden" name="categoryId" value="<%= selectedCategoryId %>">
                    <% } %>


                    <% if (keywordAttr != null && !keywordAttr.isEmpty()) { %>
                    <input type="hidden" name="keyword" value="<%= keywordAttr %>">
                    <% } %>

                    <% if (selectedGender != null && !selectedGender.isEmpty()) { %>
                    <input type="hidden" name="gender" value="<%= selectedGender %>">
                    <% } %>

                    <% if (saleParam != null && !saleParam.isEmpty()) { %>
                    <input type="hidden" name="sale" value="<%= saleParam %>">
                    <% } %>

                    <% if (selectedBrandIdsArr != null) {
                        for (String bid : selectedBrandIdsArr) { %>
                    <input type="hidden" name="brandId" value="<%= bid %>">
                    <%  }
                    } %>

                    <% if (selectedPricesArr != null) {
                        for (String pr : selectedPricesArr) { %>
                    <input type="hidden" name="price" value="<%= pr %>">
                    <%  }
                    } %>

                    <label for="sortSelect" class="me-1 fw-semibold" style="white-space: nowrap;">Sắp xếp:</label>
                    <select id="sortSelect" name="sort" class="form-select form-select-sm"
                            onchange="this.form.submit()">
                        <option value=""
                                <% if (selectedSort == null || selectedSort.isEmpty()) { %>selected<% } %>>
                            Mặc định
                        </option>
                        <option value="newest"
                                <% if ("newest".equals(selectedSort)) { %>selected<% } %>>
                            Mới nhất
                        </option>
                        <option value="price_asc"
                                <% if ("price_asc".equals(selectedSort)) { %>selected<% } %>>
                            Giá tăng dần
                        </option>
                        <option value="price_desc"
                                <% if ("price_desc".equals(selectedSort)) { %>selected<% } %>>
                            Giá giảm dần
                        </option>
                    </select>
                </form>
            </div>

            <% if (keywordAttr != null && !keywordAttr.isEmpty()) { %>
            <p class="text-muted mb-3">
                Kết quả tìm kiếm cho:
                <strong><%= keywordAttr %>
                </strong>
            </p>
            <% } %>

            <div class="row g-4">
                    <% for (Product p : list) { %>
                <!-- card sản phẩm -->
                    <% } %>


                <%-- ==== BẮT ĐẦU GRID DANH SÁCH ==== --%>
                <div class="row g-4">
                    <% if (list.isEmpty()) { %>
                    <div class="col-12">
                        <div class="alert alert-warning mb-0">Chưa có sản phẩm nào.</div>
                    </div>
                    <% } else { %>
                    <% for (Product p : list) { %>
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="product-card h-100 d-flex flex-column">

                            <%-- RIBBON (giữ nguyên nếu bạn có) --%>
                            <span class="ribbon">SALE</span>

                            <%-- ẢNH: GIỮ CLASS product-thumb, chỉ thêm khung tỉ lệ để đồng đều --%>
                            <a class="product-thumb ratio ratio-1x1 mb-0"
                               href="<%= ctx %>/product?id=<%= p.getId() %>">
                                <img src="<%= p.getImage_url() %>" alt="<%= p.getName() %>" class="img-cover">

                            </a>

                            <div class="p-3 d-flex flex-column flex-fill">
                                <%-- TÊN: giữ class product-title, clamp 2 dòng để không vỡ hàng --%>
                                <h6 class="product-title line-clamp-2 mb-2">
                                    <a href="<%= ctx %>/product?id=<%= p.getId() %>"
                                       class="text-dark text-decoration-none">
                                        <%= p.getName() %>
                                    </a>

                                </h6>
                                <%-- GIÁ --%>
                                <div class="product-footer mt-auto d-flex justify-content-between align-items-end gap-2">
                                    <div class="product-price text-danger">
                                        <div class="price-now">
                                            <%= String.format("%,.0f", p.getPrice()) %>đ
                                        </div>
                                        <% if (p.getOld_price() > 0) { %>
                                        <div class="old-price">
                                            <del>
                                                <%= String.format("%,.0f", p.getOld_price()) %>đ
                                            </del>
                                        </div>
                                        <% } %>
                                    </div>

                                    <a class="btn btn-danger btn-sm px-3" href="<%= ctx %>/product?id=<%= p.getId() %>">Chi
                                        tiết</a>
                                </div>

                            </div>
                        </div>
                    </div>
                    <% } %>
                    <% } %>
                </div>
                <%-- ==== HẾT GRID ==== --%>

                <!-- Pagination -->
                    <%
                // Xây query string giữ lại category, sort, keyword
                StringBuilder baseQuery = new StringBuilder();
                if (selectedCategoryId != null && !selectedCategoryId.isEmpty()) {
                    baseQuery.append("&categoryId=").append(selectedCategoryId);
                }
                if (selectedSort != null && !selectedSort.isEmpty()) {
                    baseQuery.append("&sort=").append(selectedSort);
                }
                if (keywordAttr != null && !keywordAttr.isEmpty()) {
                    baseQuery.append("&keyword=").append(keywordAttr);
                }
                                if (selectedGender != null && !selectedGender.isEmpty()) {
                    baseQuery.append("&gender=").append(selectedGender);
                }
                if (saleParam != null && !saleParam.isEmpty()) {
                    baseQuery.append("&sale=").append(saleParam);
                }
                if (selectedBrandIdsArr != null) {
                    for (String bid : selectedBrandIdsArr) {
                        baseQuery.append("&brandId=").append(bid);
                    }
                }
                if (selectedPricesArr != null) {
                    for (String pr : selectedPricesArr) {
                        baseQuery.append("&price=").append(pr);
                    }
                }

            %>
                    <% if (totalPages > 1) { %>
                <nav class="mt-4" aria-label="Pagination">
                    <ul class="pagination justify-content-center">

                        <!-- Previous -->
                        <li class="page-item <%= (currentPage <= 1) ? "disabled" : "" %>">
                            <a class="page-link"
                               href="<%= ctx %>/list-product?page=<%= currentPage - 1 %><%= baseQuery.toString() %>"
                               aria-label="Previous">
                                &laquo;
                            </a>
                        </li>

                        <!-- Các số trang -->
                        <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                            <a class="page-link"
                               href="<%= ctx %>/list-product?page=<%= i %><%= baseQuery.toString() %>">
                                <%= i %>
                            </a>
                        </li>
                        <% } %>

                        <!-- Next -->
                        <li class="page-item <%= (currentPage >= totalPages) ? "disabled" : "" %>">
                            <a class="page-link"
                               href="<%= ctx %>/list-product?page=<%= currentPage + 1 %><%= baseQuery.toString() %>"
                               aria-label="Next">
                                &raquo;
                            </a>
                        </li>
                    </ul>
                </nav>
                    <% } %>
        </section>
    </div>
</div>
<!-- Features -->
<section class="bg-light py-4">
    <div class="container">
        <div class="row g-3">
            <div class="col-lg-3 col-6">  <!--srv1-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 pt-2 ">
                            <img src="assets/images/footer/srv_1.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">VẬN CHUYỂN SIÊU TỐC</h6>
                            <small class="text-muted">Vận chuyển nội thành HN trong 2 tiếng!</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6">  <!--srv2-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_2.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">ĐỔI HÀNG</h6>
                            <small class="text-muted">Đổi hàng trong 7 ngày miễn phí!</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6"> <!--srv3-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_3.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">TIẾT KIỆM THỜI GIAN</h6>
                            <small class="text-muted">Mua sắm dễ hơn khi online</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6"> <!--srv4-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_4.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">ĐỊA CHỈ CỬA HÀNG</h6>
                            <small class="text-muted">Lotus 4, Vinhome Gardenia, Hàm Nghi, Từ Liêm, HN</small></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FOOTER -->
<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<!-- Back to top -->
<button class="btn btn-danger position-fixed bottom-0 end-0 m-4 rounded-circle"
        style="width:50px;height:50px;z-index:1000;"
        onclick="window.scrollTo({top:0,behavior:'smooth'})"
        title="Lên đầu trang" aria-label="Lên đầu trang">
    <i class="bi bi-arrow-up"></i>
</button>

<script>


    // Tooltips (giống index)
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(el => new bootstrap.Tooltip(el));


</script>
</body>
</html>