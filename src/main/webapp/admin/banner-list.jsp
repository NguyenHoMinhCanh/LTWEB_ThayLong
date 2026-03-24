<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%
    request.setAttribute("pageTitle", "Banner - Admin");
    request.setAttribute("activePage", "banners");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<style>
    .bn-img {
        width: 140px;
        height: 60px;
        object-fit: cover;
        border-radius: 10px;
        border: 1px solid rgba(0,0,0,.08);
        background: #fff;
    }
    .badge-pos {
        font-weight: 600;
        letter-spacing: .2px;
    }
</style>

<div class="d-flex align-items-center justify-content-between mb-3">
    <div>
        <h4 class="mb-1">Quản lý Banner</h4>
        <div class="text-muted small">Quản lý ảnh banner theo vị trí hiển thị ở Shop.</div>
    </div>

    <a class="btn btn-primary" href="${ctx}/admin/banners?action=create">
        <i class="bi bi-plus-lg me-1"></i> Thêm banner
    </a>
</div>

<!-- Alerts -->
<c:if test="${not empty param.success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        Thao tác thành công: <b>${param.success}</b>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        Có lỗi xảy ra: <b>${param.error}</b>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="card shadow-sm border-0">
    <div class="card-body">

        <form class="row g-2 align-items-end mb-3" method="get" action="${ctx}/admin/banners">
            <input type="hidden" name="action" value="list"/>

            <div class="col-12 col-md-4">
                <label class="form-label mb-1">Lọc theo vị trí</label>
                <select class="form-select" name="position">
                    <option value="">-- Tất cả --</option>
                    <c:forEach var="p" items="${positions}">
                        <option value="${p}" <c:if test="${p == selectedPosition}">selected</c:if>>${p}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-12 col-md-2">
                <button class="btn btn-outline-secondary w-100" type="submit">
                    <i class="bi bi-funnel me-1"></i>Lọc
                </button>
            </div>

            <div class="col-12 col-md-2">
                <a class="btn btn-outline-dark w-100" href="${ctx}/admin/banners">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>Reset
                </a>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table align-middle table-hover">
                <thead>
                <tr>
                    <th style="width: 80px;">ID</th>
                    <th style="width: 170px;">Ảnh</th>
                    <th>Tiêu đề</th>
                    <th style="width: 180px;">Vị trí</th>
                    <th>Link</th>
                    <th style="width: 120px;">Trạng thái</th>
                    <th style="width: 220px;">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${bannerList}">
                    <tr>
                        <td>#${b.id}</td>
                        <td>
                            <c:choose>
                                <c:when test="${fn:startsWith(b.image_url, 'http')}">
                                    <img class="bn-img" src="${b.image_url}" alt="${b.title}"/>
                                </c:when>
                                <c:otherwise>
                                    <img class="bn-img" src="${ctx}/${b.image_url}" alt="${b.title}"/>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="fw-semibold">${empty b.title ? "(Không tiêu đề)" : b.title}</div>
                            <div class="text-muted small">${b.image_url}</div>
                        </td>
                        <td>
                            <span class="badge text-bg-info badge-pos">${empty b.position ? "(null)" : b.position}</span>
                        </td>
                        <td style="max-width: 260px;">
                            <c:choose>
                                <c:when test="${empty b.link}">
                                    <span class="text-muted">—</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${b.link}" target="_blank" rel="noopener">${b.link}</a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${b.active == 1}">
                                    <span class="badge text-bg-success">ACTIVE</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge text-bg-secondary">OFF</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a class="btn btn-sm btn-outline-primary"
                               href="${ctx}/admin/banners?action=edit&id=${b.id}">
                                <i class="bi bi-pencil-square me-1"></i>Sửa
                            </a>

                            <a class="btn btn-sm btn-outline-warning"
                               href="${ctx}/admin/banners?action=toggle&id=${b.id}">
                                <i class="bi bi-toggle-${b.active == 1 ? 'on' : 'off'} me-1"></i>
                                    ${b.active == 1 ? "Tắt" : "Bật"}
                            </a>

                            <a class="btn btn-sm btn-outline-danger"
                               href="${ctx}/admin/banners?action=delete&id=${b.id}"
                               onclick="return confirm('Xóa banner #${b.id}? Hành động không thể hoàn tác.');">
                                <i class="bi bi-trash me-1"></i>Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty bannerList}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">
                            Không có banner nào.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <div class="text-muted small mt-2">
            Gợi ý: HOME_TOP có thể tạo nhiều banner (slider). Các vị trí còn lại thường chỉ cần 1 banner ACTIVE.
        </div>
    </div>
</div>

<script>
    // Remove URL parameters after showing alert to prevent reload loop
    if (window.location.search.includes('success') || window.location.search.includes('error')) {
        setTimeout(function () {
            const url = new URL(window.location);
            url.searchParams.delete('success');
            url.searchParams.delete('error');
            window.history.replaceState({}, document.title, url.pathname + url.search);
        }, 200);
    }
</script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
