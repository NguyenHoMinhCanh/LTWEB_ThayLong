<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%
    request.setAttribute("pageTitle", "Thêm/Sửa Tin tức - Admin");
    request.setAttribute("activePage", "news");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">${pageTitle}</h2>
        <a href="${ctx}/admin/news?action=list" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Quay lại
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card">
        <div class="card-body">
            <form method="post" action="${ctx}/admin/news">
                <input type="hidden" name="action" value="${news != null ? 'update' : 'create'}">
                <c:if test="${news != null}">
                    <input type="hidden" name="id" value="${news.id}">
                </c:if>

                <div class="mb-3">
                    <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="title" value="${news != null ? news.title : ''}"
                           required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Danh mục</label>
                    <select class="form-select" name="categoryIds" multiple size="5">
                        <c:forEach items="${categories}" var="c1">
                            <option value="${c1.id}"
                                    <c:if test="${news != null && not empty news.categoryIds
                && fn:contains(concat(',', news.categoryIds, ','), concat(',', c1.id, ','))}">
                                        selected="selected"
                                    </c:if>>
                                    ${c1.name}
                            </option>

                        </c:forEach>
                    </select>
                    <div class="form-text">Giữ Ctrl (Windows) / Cmd (Mac) để chọn nhiều danh mục.</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Ảnh thumbnail (URL)</label>
                    <input type="text" class="form-control" name="thumbnailUrl"
                           value="${news != null ? news.thumbnailUrl : ''}" placeholder="https://...">
                </div>

                <div class="mb-3">
                    <label class="form-label">Tóm tắt</label>
                    <textarea class="form-control" name="summary"
                              rows="3">${news != null ? news.summary : ''}</textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Tác giả</label>
                    <input type="text" class="form-control" name="author" value="${news != null ? news.author : ''}"
                           placeholder="Admin / Biên tập viên...">
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="featured"
                           id="featured" ${news != null && news.featured == 1 ? 'checked' : ''}>
                    <label class="form-check-label" for="featured">Bài nổi bật (Featured)</label>
                </div>

                <div class="mb-3">
                    <label class="form-label">Nội dung</label>
                    <textarea class="form-control" name="content"
                              rows="8">${news != null ? news.content : ''}</textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="PUBLISHED" ${news == null || news.status == 'PUBLISHED' ? 'selected' : ''}>
                            PUBLISHED
                        </option>
                        <option value="DRAFT" ${news != null && news.status == 'DRAFT' ? 'selected' : ''}>DRAFT</option>
                    </select>
                    <div class="form-text">Shop chỉ hiển thị bài ở trạng thái <strong>PUBLISHED</strong>.</div>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <a href="${ctx}/admin/news?action=list" class="btn btn-outline-secondary">Hủy</a>
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-save me-1"></i> Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
