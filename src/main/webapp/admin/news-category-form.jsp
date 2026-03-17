<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    request.setAttribute("pageTitle", "Thêm/Sửa Danh mục Tin tức - Admin");
    request.setAttribute("activePage", "news");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">${pageTitle}</h2>
        <a href="${ctx}/admin/news-categories?action=list" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Quay lại
        </a>
    </div>

    <div class="card">
        <div class="card-body">
            <form method="post" action="${ctx}/admin/news-categories">
                <input type="hidden" name="action" value="${category != null ? 'update' : 'create'}">
                <c:if test="${category != null}">
                    <input type="hidden" name="id" value="${category.id}">
                </c:if>

                <div class="mb-3">
                    <label class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="name" value="${category != null ? category.name : ''}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Slug</label>
                    <input type="text" class="form-control" name="slug" value="${category != null ? category.slug : ''}">
                </div>

                <div class="mb-4">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="active" ${category == null || category.status == 'active' ? 'selected' : ''}>Active</option>
                        <option value="inactive" ${category != null && category.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <a href="${ctx}/admin/news-categories?action=list" class="btn btn-outline-secondary">Hủy</a>
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-save me-1"></i> Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
