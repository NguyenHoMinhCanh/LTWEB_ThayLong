<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    request.setAttribute("pageTitle", "Dashboard - Admin");
    request.setAttribute("activePage", "dashboard");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">Dashboard</h2>
            <div class="text-muted">Xin chào, <strong><c:out value="${adminName}"/></strong></div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-outline-primary" href="${ctx}/admin/products">
                <i class="bi bi-box-seam me-1"></i> Sản phẩm
            </a>
            <a class="btn btn-outline-primary" href="${ctx}/admin/orders?action=list">
                <i class="bi bi-receipt me-1"></i> Đơn hàng
            </a>
            <a class="btn btn-outline-primary" href="${ctx}/admin/users">
                <i class="bi bi-people me-1"></i> Người dùng
            </a>
        </div>
    </div>

    <!-- KPI cards -->
    <div class="row g-3 mb-3">
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <div class="text-muted">Sản phẩm (Active)</div>
                            <div class="display-6 fw-semibold"><c:out value="${totalProducts}"/></div>
                        </div>
                        <div class="fs-2 text-primary"><i class="bi bi-box-seam"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <div class="text-muted">Đơn hàng</div>
                            <div class="display-6 fw-semibold"><c:out value="${totalOrders}"/></div>
                        </div>
                        <div class="fs-2 text-primary"><i class="bi bi-receipt"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <div class="text-muted">Người dùng</div>
                            <div class="display-6 fw-semibold"><c:out value="${totalUsers}"/></div>
                            <div class="small text-muted">Active: <c:out value="${activeUsers}"/></div>
                        </div>
                        <div class="fs-2 text-primary"><i class="bi bi-people"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <div class="text-muted">Doanh thu (PAID + DONE)</div>
                            <div class="display-6 fw-semibold">
                                <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> ₫
                            </div>
                        </div>
                        <div class="fs-2 text-primary"><i class="bi bi-cash-coin"></i></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3">
        <!-- Chart -->
        <div class="col-12 col-xl-8">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h6 class="mb-0">Doanh thu 7 ngày gần nhất</h6>
                        <span class="badge bg-light text-dark">Tính PAID/DONE</span>
                    </div>
                    <div class="chart-box"><canvas id="revenueChart"></canvas></div>
                </div>
            </div>
        </div>

        <!-- Order status -->
        <div class="col-12 col-xl-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="mb-3">Trạng thái đơn hàng</h6>

                    <div class="d-flex justify-content-between mb-2">
                        <span>Chờ xử lý</span>
                        <span class="badge bg-secondary"><c:out value="${orderStatusCounts.PENDING}"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Đã thanh toán</span>
                        <span class="badge bg-primary"><c:out value="${orderStatusCounts.PAID}"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Đang giao</span>
                        <span class="badge bg-info text-dark"><c:out value="${orderStatusCounts.SHIPPING}"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Hoàn tất</span>
                        <span class="badge bg-success"><c:out value="${orderStatusCounts.DONE}"/></span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span>Đã hủy</span>
                        <span class="badge bg-danger"><c:out value="${orderStatusCounts.CANCEL}"/></span>
                    </div>

                    <hr class="my-3"/>
                    <div class="d-grid gap-2">
                        <a class="btn btn-outline-primary" href="${ctx}/admin/orders?action=list">
                            <i class="bi bi-receipt me-1"></i> Quản lý đơn hàng
                        </a>
                        <a class="btn btn-outline-primary" href="${ctx}/admin/news?action=list">
                            <i class="bi bi-newspaper me-1"></i> Quản lý tin tức
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <!-- Recent orders -->
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h6 class="mb-0">Đơn hàng gần đây</h6>
                        <a class="btn btn-sm btn-outline-secondary" href="${ctx}/admin/orders?action=list">
                            Xem tất cả
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
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
                            <c:forEach items="${recentOrders}" var="o">
                                <tr>
                                    <td>#${o.id}</td>
                                    <td>
                                        <c:out value="${o.fullName}"/>
                                        <c:if test="${not empty o.phone}">
                                            <div class="text-muted small"><c:out value="${o.phone}"/></div>
                                        </c:if>
                                    </td>
                                    <td><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> ₫</td>
                                    <td><c:out value="${o.statusVi}"/></td>
                                    <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td class="text-end">
                                        <a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/orders?action=detail&id=${o.id}">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty recentOrders}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">Chưa có đơn hàng</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js (CDN) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    (function() {
        const labels = [
            <c:forEach items="${chartLabels}" var="l" varStatus="st">"${l}"<c:if test="${!st.last}">,</c:if></c:forEach>
        ];
        const values = [
            <c:forEach items="${chartValues}" var="v" varStatus="st">${v}<c:if test="${!st.last}">,</c:if></c:forEach>
        ];

        const ctx = document.getElementById('revenueChart');
        if (!ctx) return;

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (PAID + DONE)',
                    data: values,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                try {
                                    return Number(value).toLocaleString('vi-VN') + ' đ';
                                } catch (e) {
                                    return value;
                                }
                            }
                        }
                    }
                },
                plugins: {
                    legend: { display: false }
                }
            }
        });
    })();
</script>
<%@ include file="/admin/includes/_admin_layout_close.jspf" %>