<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside id="sidebar" class="sidebar border-end bg-white">
    <div class="sidebar-inner">
        <ul class="s-nav">
            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </a></li>
        </ul>
        <div class="s-title">QUẢN LÝ</div>
        <ul class="s-nav">
            <li class="has-children">
                <a class="s-item s-parent" href="#" onclick="return false;">
                    <span><i class="bi bi-box-seam me-2"></i>Sản phẩm</span>
                    <i class="bi bi-chevron-down ms-auto small chev"></i>
                </a>
                <ul class="s-subnav">
                    <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/products">
                        <i class="bi bi-list-ul me-2"></i>Quản lý sản phẩm
                    </a></li>
                    <li><a class="s-subitem active" href="${pageContext.request.contextPath}/admin/categories">
                        <i class="bi bi-tags me-2"></i>Danh mục sản phẩm
                    </a></li>
                </ul>
            </li>
            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/brands">
                <i class="bi bi-award me-2"></i>Thương hiệu
            </a></li>
            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/users">
                <i class="bi bi-people me-2"></i>Người dùng
            </a></li>
            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/orders">
                <i class="bi bi-receipt me-2"></i>Đơn hàng
            </a></li>

            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/news">
                <i class="bi bi-newspaper me-2"></i>Tin tức
            </a></li>

            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/news-categories">
                <i class="bi bi-folder2-open me-2"></i>Danh mục tin tức
            </a></li>

            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/policies">
                <i class="bi bi-shield-check me-2"></i>Chính sách
            </a></li>

            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/banners">
                <i class="bi bi-image me-2"></i>Banner
            </a></li>
        </ul>
    </div>
</aside>
