<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    request.setAttribute("pageTitle", "Quản lý Voucher - Admin");
    request.setAttribute("activePage", "vouchers");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb mb-0">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
        <li class="breadcrumb-item active">Voucher</li>
    </ol>
</nav>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0">Quản lý Voucher</h4>
    <a href="voucher?action=add" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>Thêm Voucher mới
    </a>
</div>

<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle" id="tblVouchers">
                <thead>
                <tr>
                    <th style="width: 80px">ID</th>
                    <th>Mã Voucher</th>
                    <th>Tên</th>
                    <th>Giảm giá</th>
                    <th>Đơn tối thiểu</th>
                    <th>Thời hạn</th>
                    <th>Đã dùng</th>
                    <th>Trạng thái</th>
                    <th style="width: 140px" class="text-end">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${vouchers}">
                    <tr>
                        <td>${v.id}</td>
                        <td><strong class="text-primary">${v.code}</strong></td>
                        <td>${v.name}</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.discountType == 'percent'}">
                                    <span class="badge bg-info">${v.discountValue}%</span>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${v.discountValue}" pattern="#,###"/> ₫
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatNumber value="${v.minOrderValue}" pattern="#,###"/> ₫</td>
                        <td>
                            <small>
                                <c:choose>
                                    <c:when test="${v.startDate != null}">
                                        ${v.startDate.toString().substring(0, 10)}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                                →
                                <c:choose>
                                    <c:when test="${v.endDate != null}">
                                        ${v.endDate.toString().substring(0, 10)}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </small>
                        </td>
                        <td>${v.usedCount} / ${v.usageLimit != null ? v.usageLimit : '∞'}</td>
                        <td>
                                <span class="badge ${v.active ? 'bg-success' : 'bg-danger'}">
                                        ${v.active ? 'Hoạt động' : 'Tắt'}
                                </span>
                        </td>
                        <td class="text-end">
                            <a href="voucher?action=edit&id=${v.id}" class="btn btn-sm btn-warning">
                                <i class="bi bi-pencil"></i>
                            </a>
                            <a href="voucher?action=delete&id=${v.id}"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Bạn có chắc muốn xóa voucher này?')">
                                <i class="bi bi-trash"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>