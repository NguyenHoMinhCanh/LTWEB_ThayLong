<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    request.setAttribute("pageTitle", "Chính sách - Admin");
    request.setAttribute("activePage", "policies");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">${pageTitle}</h2>
        <a href="${ctx}/admin/policies?action=add" class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i> Thêm chính sách
        </a>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Tiêu đề</th>
                        <th>Slug</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${policies}" var="p">
                        <tr>
                            <td>${p.id}</td>
                            <td class="fw-medium">${p.title}</td>
                            <td><code>${p.slug}</code></td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.active}">
                                        <span class="badge bg-success">Đang hiển thị</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Đang ẩn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <a href="${ctx}/policy?slug=${p.slug}" class="btn btn-sm btn-outline-secondary" target="_blank" title="Xem trên shop">
                                    <i class="bi bi-box-arrow-up-right"></i>
                                </a>
                                <a href="${ctx}/admin/policies?action=edit&id=${p.id}" class="btn btn-sm btn-outline-primary" title="Sửa">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="${ctx}/admin/policies?action=delete&id=${p.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xóa chính sách này?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty policies}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">
                                Không có chính sách nào
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
