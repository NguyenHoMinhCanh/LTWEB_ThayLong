<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%
    request.setAttribute("pageTitle", "Thương hiệu - Admin");
    request.setAttribute("activePage", "brands");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<style>
    .brand-logo {
        width: 60px;
        height: 60px;
        object-fit: contain;
        border: 1px solid #e9ecef;
        border-radius: 6px;
        background-color: #fff;
        padding: 5px;
    }

    .action-buttons .btn {
        margin-right: 5px;
    }

    .action-buttons .btn:last-child {
        margin-right: 0;
    }
</style>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="h3 mb-0">${pageTitle}</h2>
        <a href="${ctx}/admin/brands?action=add" class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i>Thêm thương hiệu
        </a>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-header bg-white">
            <div class="row align-items-center">
                <div class="col">
                    <h5 class="mb-0">Danh sách thương hiệu</h5>
                </div>
                <div class="col-auto">
                    <form class="d-flex" method="get" action="${ctx}/admin/brands">
                        <input type="hidden" name="action" value="list">
                        <input type="search" name="search" class="form-control form-control-sm me-2"
                               placeholder="Tìm kiếm..." value="${param.search}">
                        <button class="btn btn-outline-secondary btn-sm" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Logo</th>
                        <th>Tên thương hiệu</th>
                        <th>Slug</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${brandList}" var="brand">
                        <tr>
                            <td>${brand.id}</td>
                            <td>
                                <c:if test="${not empty brand.logoUrl}">
                                    <img src="${brand.logoUrl}" alt="${brand.name}" class="brand-logo">
                                </c:if>
                                <c:if test="${empty brand.logoUrl}">
                                    <div class="brand-logo d-flex align-items-center justify-content-center text-muted">
                                        <i class="bi bi-image"></i>
                                    </div>
                                </c:if>
                            </td>
                            <td class="fw-medium">${brand.name}</td>
                            <td><code>${brand.slug}</code></td>
                            <td>
                                <c:choose>
                                    <c:when test="${brand.active}">
                                        <span class="badge bg-success">Hiển thị</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Ẩn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end action-buttons">
                                <c:choose>
                                    <c:when test="${brand.active}">
                                        <a href="${ctx}/admin/brands?action=toggle&id=${brand.id}"
                                           class="btn btn-sm btn-outline-secondary"
                                           title="Ẩn khỏi shop">
                                            <i class="bi bi-eye-slash"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${ctx}/admin/brands?action=toggle&id=${brand.id}"
                                           class="btn btn-sm btn-outline-success"
                                           title="Hiển thị lên shop">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${ctx}/admin/brands?action=edit&id=${brand.id}"
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="${ctx}/admin/brands?action=delete&id=${brand.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa thương hiệu này?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty brandList}">
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                Không có thương hiệu nào
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function (alert) {
            setTimeout(function () {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });

        if (window.location.search.includes('success') || window.location.search.includes('error')) {
            setTimeout(function () {
                const url = new URL(window.location);
                url.searchParams.delete('success');
                url.searchParams.delete('error');
                window.history.replaceState({}, document.title, url.pathname + url.search);
            }, 100);
        }
    });
</script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
