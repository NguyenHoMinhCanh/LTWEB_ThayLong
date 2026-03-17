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
        text-transform: uppercase;
        font-size: 0.7rem;
    }
    /* Cố định độ rộng để không đẩy Sidebar khi Zoom 100% */
    .table td {
        max-width: 250px;
        word-wrap: break-word;
        white-space: normal;
        vertical-align: middle;
    }
    .action-buttons .btn {
        margin-right: 2px;
    }
</style>

<div class="container-fluid">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="h3 mb-0">Quản lý Banner</h2>
        <a class="btn btn-primary" href="${ctx}/admin/banners?action=create">
            <i class="bi bi-plus-circle me-1"></i> Thêm banner
        </a>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>Thành công: <b>${param.success}</b>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3">
            <form class="row g-2 align-items-end" method="get" action="${ctx}/admin/banners">
                <input type="hidden" name="action" value="list"/>
                <div class="col-12 col-md-4">
                    <label class="form-label small mb-1">Lọc theo vị trí</label>
                    <select class="form-select form-select-sm" name="position">
                        <option value="">-- Tất cả vị trí --</option>
                        <c:forEach var="p" items="${positions}">
                            <option value="${p}" <c:if test="${p == selectedPosition}">selected</c:if>>${p}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-6 col-md-2">
                    <button class="btn btn-outline-secondary btn-sm w-100" type="submit">
                        <i class="bi bi-funnel me-1"></i>Lọc
                    </button>
                </div>
                <div class="col-6 col-md-2">
                    <a class="btn btn-outline-dark btn-sm w-100" href="${ctx}/admin/banners">
                        <i class="bi bi-arrow-counterclockwise me-1"></i>Reset
                    </a>
                </div>
            </form>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th style="width: 160px;">Ảnh</th>
                        <th>Tiêu đề</th>
                        <th style="width: 150px;">Vị trí</th>
                        <th style="max-width: 250px;">Link</th>
                        <th style="width: 110px;">Trạng thái</th>
                        <th style="width: 160px;" class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="b" items="${bannerList}">
                        <tr>
                            <td class="text-muted">#${b.id}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${fn:startsWith(b.image_url, 'http')}">
                                        <img class="bn-img" src="${b.image_url}" alt="banner"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img class="bn-img" src="${ctx}/${b.image_url}" alt="banner"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="fw-semibold text-dark">${empty b.title ? "(Không tiêu đề)" : b.title}</div>
                                <div class="text-muted small" style="font-size: 0.75rem;">${b.image_url}</div>
                            </td>
                            <td>
                                <span class="badge text-bg-info badge-pos">${empty b.position ? "NULL" : b.position}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${empty b.link}">
                                        <span class="text-muted">—</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${b.link}" target="_blank" class="text-decoration-none small">${b.link}</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.active == 1}">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle">ACTIVE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">OFF</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end action-buttons">
                                <a class="btn btn-sm ${b.active == 1 ? 'btn-outline-secondary' : 'btn-outline-success'}"
                                   href="${ctx}/admin/banners?action=toggle&id=${b.id}" title="Đổi trạng thái">
                                    <i class="bi bi-eye${b.active == 1 ? '-slash' : ''}"></i>
                                </a>
                                <a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/banners?action=edit&id=${b.id}" title="Sửa">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a class="btn btn-sm btn-outline-danger" href="${ctx}/admin/banners?action=delete&id=${b.id}"
                                   onclick="return confirm('Xóa banner #${b.id}?');" title="Xóa">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bannerList}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">
                                <i class="bi bi-image fs-2 d-block mb-2"></i> Không có banner nào.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-white border-0 py-3">
            <div class="text-muted small">
                <i class="bi bi-info-circle me-1"></i>
            </div>
        </div>
    </div>
</div>

<script>
    if (window.location.search.includes('success') || window.location.search.includes('error')) {
        setTimeout(function () {
            const url = new URL(window.location);
            url.searchParams.delete('success');
            url.searchParams.delete('error');
            window.history.replaceState({}, document.title, url.pathname + url.search);
        }, 1500);
    }
</script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>