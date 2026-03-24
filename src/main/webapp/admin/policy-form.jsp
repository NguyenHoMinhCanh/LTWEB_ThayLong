<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    request.setAttribute("pageTitle", "Thêm/Sửa Chính sách - Admin");
    request.setAttribute("activePage", "policies");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">${pageTitle}</h2>
        <a href="${ctx}/admin/policies?action=list" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Quay lại
        </a>
    </div>

    <div class="card">
        <div class="card-body">
            <form method="post" action="${ctx}/admin/policies">
                <input type="hidden" name="action" value="${policy != null ? 'update' : 'create'}">
                <c:if test="${policy != null}">
                    <input type="hidden" name="id" value="${policy.id}">
                </c:if>

                <div class="mb-3">
                    <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="title" value="${policy != null ? policy.title : ''}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Nội dung</label>
                    <textarea class="form-control" name="content" rows="10">${policy != null ? policy.content : ''}</textarea>
                </div>


                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Loại chính sách</label>
                        <select class="form-select" name="policyType">
                            <option value="GENERAL" ${policy == null || policy.policyType == 'GENERAL' ? 'selected' : ''}>Chung</option>
                            <option value="TERMS" ${policy != null && policy.policyType == 'TERMS' ? 'selected' : ''}>Điều khoản</option>
                            <option value="PRIVACY" ${policy != null && policy.policyType == 'PRIVACY' ? 'selected' : ''}>Bảo mật</option>
                            <option value="SHIPPING" ${policy != null && policy.policyType == 'SHIPPING' ? 'selected' : ''}>Vận chuyển</option>
                            <option value="RETURN" ${policy != null && policy.policyType == 'RETURN' ? 'selected' : ''}>Đổi trả</option>
                            <option value="PAYMENT" ${policy != null && policy.policyType == 'PAYMENT' ? 'selected' : ''}>Thanh toán</option>
                            <option value="ORDER_GUIDE" ${policy != null && policy.policyType == 'ORDER_GUIDE' ? 'selected' : ''}>Hướng dẫn đặt hàng</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Thứ tự hiển thị</label>
                        <input type="number" class="form-control" name="displayOrder"
                               value="${policy != null ? policy.displayOrder : 0}" min="0">
                        <div class="form-text">Số nhỏ sẽ hiển thị trước (trong mục Chính sách ở footer).</div>
                    </div>

                    <div class="col-md-4 d-flex align-items-end">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="active" name="active"
                            ${policy == null || policy.active ? 'checked' : ''}>
                            <label class="form-check-label" for="active">Hiển thị trên shop</label>
                        </div>
                    </div>
                </div>

                <div class="mb-3 mt-3">
                    <label class="form-label">Slug (tuỳ chọn)</label>
                    <input type="text" class="form-control" name="slug"
                           value="${policy != null ? policy.slug : ''}"
                           placeholder="de-trong-se-tu-tao-tu-tieu-de">
                    <div class="form-text">Nếu để trống khi tạo mới, hệ thống sẽ tự tạo slug từ tiêu đề. Khi sửa, bạn có thể giữ slug cũ để link không bị đổi.</div>
                </div>
                <div class="d-flex justify-content-end gap-2">
                    <a href="${ctx}/admin/policies?action=list" class="btn btn-outline-secondary">Hủy</a>
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-save me-1"></i> Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
