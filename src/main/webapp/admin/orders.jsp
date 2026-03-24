<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    request.setAttribute("pageTitle", "Đơn hàng - Admin");
    request.setAttribute("activePage", "orders");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="container-fluid py-3">
    <h2 class="mb-4">${pageTitle}</h2>

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
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach items="${orders}" var="o">
                        <tr>
                            <td>${o.id}</td>

                            <!-- FIX: customerName -> fullName -->
                            <td>
                                <c:out value="${o.fullName}" />
                                <c:if test="${not empty o.phone}">
                                    <div class="text-muted small">${o.phone}</div>
                                </c:if>
                            </td>

                            <td>
                                <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0" /> ₫
                            </td>

                            <!-- Nếu muốn tiếng Việt: dùng statusVi -->
                            <td>
                                <c:out value="${o.statusVi}" />
                            </td>

                            <td>
                                <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                            </td>

                            <td class="text-end">
                                <a href="${ctx}/admin/orders?action=detail&id=${o.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-eye"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">Không có đơn hàng</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
