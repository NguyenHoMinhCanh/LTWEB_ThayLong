<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    request.setAttribute("pageTitle", "Danh mục Tin tức - Admin");
    request.setAttribute("activePage", "news");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">${pageTitle}</h2>
        <a href="${ctx}/admin/news-categories?action=add" class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i> Thêm danh mục
        </a>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Tên danh mục</th>
                        <th>Slug</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${categories}" var="cat">
                        <tr>
                            <td>${cat.id}</td>
                            <td class="fw-medium">${cat.name}</td>
                            <td><code>${cat.slug}</code></td>
                            <td>
                                <c:choose>
                                    <c:when test="${cat.status == 'active'}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <a href="${ctx}/admin/news-categories?action=edit&id=${cat.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="${ctx}/admin/news-categories?action=delete&id=${cat.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xóa danh mục này?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty categories}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">
                                Không có danh mục nào
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
