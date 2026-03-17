<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    request.setAttribute("pageTitle", "Tin tức - Admin");
    request.setAttribute("activePage", "news");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">${pageTitle}</h2>
        <a href="${ctx}/admin/news?action=add" class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i> Thêm bài viết
        </a>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Tiêu đề</th>
                        <th>Danh mục</th>
                        <th>Slug</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${newsList}" var="n">
                        <tr>
                            <td>${n.id}</td>
                            <td class="fw-medium">${n.title}</td>
                            <td>${newsCategoryNames[n.id]}</td>
                            <td><code>${n.slug}</code></td>
                            <td>
                                <c:choose>
                                    <c:when test="${n.status == 'PUBLISHED'}">
                                        <span class="badge bg-success">Đã đăng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Nháp</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${n.createdAt}</td>
                            <td class="text-end">
                                <a href="${ctx}/admin/news?action=toggleStatus&id=${n.id}"
                                   class="btn btn-sm btn-outline-secondary"
                                   title="${n.status == 'PUBLISHED' ? 'Gỡ xuống (chuyển sang Nháp)' : 'Đăng bài'}">
                                    <i class="bi ${n.status == 'PUBLISHED' ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                </a>
                                <a href="${ctx}/admin/news?action=edit&id=${n.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="${ctx}/admin/news?action=delete&id=${n.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xóa bài viết này?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty newsList}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                Không có bài viết nào
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
