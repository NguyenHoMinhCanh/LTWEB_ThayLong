<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%
    request.setAttribute("pageTitle", "Thêm/Sửa Voucher - Admin");
    request.setAttribute("activePage", "vouchers");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb mb-0">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
        <li class="breadcrumb-item"><a href="voucher">Voucher</a></li>
        <li class="breadcrumb-item active">${action == 'edit' ? 'Sửa' : 'Thêm'} Voucher</li>
    </ol>
</nav>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${action == 'edit' ? 'Sửa Voucher' : 'Thêm Voucher Mới'}</h5>
    </div>
    <div class="card-body">
        <form action="voucher" method="post" class="row g-3">
            <input type="hidden" name="action" value="${action == 'edit' ? 'update' : 'add'}">
            <c:if test="${action == 'edit'}">
                <input type="hidden" name="id" value="${voucher.id}">
            </c:if>

            <div class="col-md-6">
                <label class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                <input type="text" class="form-control text-uppercase" name="code"
                       value="${voucher.code}" required maxlength="50">
            </div>

            <div class="col-md-6">
                <label class="form-label">Tên Voucher</label>
                <input type="text" class="form-control" name="name"
                       value="${voucher.name}">
            </div>

            <div class="col-md-6">
                <label class="form-label">Loại giảm giá</label>
                <select class="form-select" name="discountType" required>
                    <option value="percent" ${voucher.discountType == 'percent' ? 'selected' : ''}>Phần trăm (%)</option>
                    <option value="fixed" ${voucher.discountType == 'fixed' ? 'selected' : ''}>Số tiền cố định (₫)</option>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">Giá trị giảm <span class="text-danger">*</span></label>
                <input type="number" step="0.01" class="form-control" name="discountValue"
                       value="${voucher.discountValue}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">Đơn hàng tối thiểu (₫)</label>
                <input type="number" class="form-control" name="minOrderValue"
                       value="${voucher.minOrderValue != null ? voucher.minOrderValue : 0}">
            </div>

            <div class="col-md-6">
                <label class="form-label">Giảm tối đa (₫) <small>(chỉ áp dụng khi là %)</small></label>
                <input type="number" class="form-control" name="maxDiscount"
                       value="${voucher.maxDiscount}">
            </div>

            <div class="col-md-6">
                <label class="form-label">Ngày bắt đầu</label>
                <input type="datetime-local" class="form-control" name="startDate"
                       value="${voucher.startDate != null ? fn:substring(voucher.startDate.toString(), 0, 16) : ''}">
            </div>

            <div class="col-md-6">
                <label class="form-label">Ngày kết thúc</label>
                <input type="datetime-local" class="form-control" name="endDate"
                       value="${voucher.endDate != null ? fn:substring(voucher.endDate.toString(), 0, 16) : ''}">
            </div>

            <div class="col-md-6">
                <label class="form-label">Giới hạn sử dụng</label>
                <input type="number" class="form-control" name="usageLimit"
                       value="${voucher.usageLimit}" min="0">
            </div>

            <div class="col-md-6">
                <label class="form-label">Trạng thái</label>
                <div class="form-check form-switch mt-2">
                    <input class="form-check-input" type="checkbox" name="isActive" value="1"
                    ${voucher.active || action != 'edit' ? 'checked' : ''} id="isActive">
                    <label class="form-check-label" for="isActive">Hoạt động</label>
                </div>
            </div>

            <div class="col-12 mt-4">
                <button type="submit" class="btn btn-primary me-2">
                    <i class="bi bi-save"></i> ${action == 'edit' ? 'Cập nhật' : 'Thêm mới'}
                </button>
                <a href="voucher" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>