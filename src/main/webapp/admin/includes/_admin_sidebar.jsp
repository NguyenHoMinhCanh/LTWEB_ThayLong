<%@ page pageEncoding="UTF-8" %>
<%
    String ap = (String) request.getAttribute("activePageResolved");
    if (ap == null) ap = "";

    String activeDashboard  = "dashboard".equals(ap)  ? "active" : "";
    String activeProducts   = "products".equals(ap)   ? "active" : "";
    String activeCategories = "categories".equals(ap) ? "active" : "";
    String activeBrands     = "brands".equals(ap)     ? "active" : "";
    String activeNews       = "news".equals(ap)       ? "active" : "";
    String activeBanners    = "banners".equals(ap)    ? "active" : "";
    String activeOrders     = "orders".equals(ap)     ? "active" : "";
    String activePolicies   = "policies".equals(ap)   ? "active" : "";
    String activeUsers      = "users".equals(ap)      ? "active" : "";
%>

<aside id="sidebar" class="adm-sidebar">
    <div class="adm-sidebar__inner">

        <div class="adm-section">TỔNG QUAN</div>
        <a class="adm-item <%= activeDashboard %>" href="${ctx}/admin/dashboard">
            <i class="bi bi-speedometer2"></i><span>Dashboard</span>
        </a>

        <div class="adm-section">QUẢN LÝ</div>
        <a class="adm-item <%= activeProducts %>" href="${ctx}/admin/products">
            <i class="bi bi-box-seam"></i><span>Sản phẩm</span>
        </a>

        <a class="adm-item <%= activeCategories %>" href="${ctx}/admin/categories">
            <i class="bi bi-tags"></i><span>Danh mục</span>
        </a>

        <a class="adm-item <%= activeBrands %>" href="${ctx}/admin/brands">
            <i class="bi bi-award"></i><span>Thương hiệu</span>
        </a>

        <div class="adm-section">NỘI DUNG</div>
        <a class="adm-item <%= activeNews %>" href="${ctx}/admin/news">
            <i class="bi bi-newspaper"></i><span>Tin tức</span>
        </a>


        <a class="adm-item <%= activeBanners %>" href="${ctx}/admin/banners">
            <i class="bi bi-images"></i><span>Banner</span>
        </a>

        <div class="adm-section">BÁN HÀNG</div>
        <a class="adm-item <%= activeOrders %>" href="${ctx}/admin/orders">
            <i class="bi bi-receipt"></i><span>Đơn hàng</span>
        </a>

        <div class="adm-section">HỆ THỐNG</div>
        <a class="adm-item <%= activePolicies %>" href="${ctx}/admin/policies">
            <i class="bi bi-shield-check"></i><span>Chính sách</span>
        </a>

        <a class="adm-item <%= activeUsers %>" href="${ctx}/admin/users">
            <i class="bi bi-people"></i><span>Users</span>
        </a>

        <a class="adm-item" href="${ctx}/logout">
            <i class="bi bi-box-arrow-right"></i><span>Đăng xuất</span>
        </a>

    </div>
</aside>
