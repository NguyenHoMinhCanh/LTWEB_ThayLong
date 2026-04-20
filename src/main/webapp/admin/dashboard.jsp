<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    request.setAttribute("pageTitle", "Dashboard - Admin");
    request.setAttribute("activePage", "dashboard");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<style>
/* Dashboard: Status Colors */
.status-pill {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px 14px;
    border-radius: 10px;
    margin-bottom: 10px;
    font-size: 0.9rem;
    font-weight: 500;
    transition: transform 0.15s ease;
}
.status-pill:hover { transform: translateX(3px); }
.status-pill .status-count {
    font-size: 1.25rem;
    font-weight: 700;
    min-width: 40px;
    text-align: right;
}
.status-pill .status-icon { font-size: 1.1rem; margin-right: 8px; }

/* Màu trạng thái */
.sp-pending  { background: #fff8e1; color: #e65100; border-left: 4px solid #ff9800; }
.sp-paid     { background: #e3f2fd; color: #0d47a1; border-left: 4px solid #1976d2; }
.sp-shipping { background: #e8f5e9; color: #1b5e20; border-left: 4px solid #43a047; }
.sp-done     { background: #ede7f6; color: #4527a0; border-left: 4px solid #7e57c2; }
.sp-cancel   { background: #ffebee; color: #b71c1c; border-left: 4px solid #e53935; }

/*Chart*/
.chart-box {
    position: relative;
    height: 280px;
}

/*Recent orders: status badge màu*/
.badge-pending  { background: #ff9800; color: #fff; }
.badge-paid     { background: #1976d2; color: #fff; }
.badge-shipping { background: #43a047; color: #fff; }
.badge-done     { background: #7e57c2; color: #fff; }
.badge-cancel   { background: #e53935; color: #fff; }
</style>

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

        <!-- Revenue 12 months chart -->
        <div class="col-12 col-xl-8">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h6 class="mb-0">Xu hướng doanh thu 12 tháng</h6>
                        <span class="badge bg-light text-dark">Tính PAID/DONE</span>
                    </div>
                    <div class="chart-box"><canvas id="revenueMonthChart"></canvas></div>
                </div>
            </div>
        </div>

        <!-- Order status -->
        <div class="col-12 col-xl-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="mb-3 fw-semibold">Trạng thái đơn hàng</h6>

                    <%-- Tính tổng để vẽ progress --%>
                    <c:set var="totalOrdersForBar"
                           value="${orderStatusCounts.PENDING + orderStatusCounts.PAID + orderStatusCounts.SHIPPING + orderStatusCounts.DONE + orderStatusCounts.CANCEL}"/>
                    <c:if test="${totalOrdersForBar == 0}"><c:set var="totalOrdersForBar" value="1"/></c:if>

                    <%-- PENDING --%>
                    <div class="status-pill sp-pending">
                        <div>
                            <span class="status-icon">⏳</span>Chờ xử lý
                        </div>
                        <span class="status-count">${orderStatusCounts.PENDING}</span>
                    </div>
                    <div class="progress mb-3" style="height:4px;">
                        <div class="progress-bar" style="width:${orderStatusCounts.PENDING * 100 / totalOrdersForBar}%;background:#ff9800;"></div>
                    </div>

                    <%-- PAID --%>
                    <div class="status-pill sp-paid">
                        <div>
                            <span class="status-icon">💳</span>Đã thanh toán
                        </div>
                        <span class="status-count">${orderStatusCounts.PAID}</span>
                    </div>
                    <div class="progress mb-3" style="height:4px;">
                        <div class="progress-bar" style="width:${orderStatusCounts.PAID * 100 / totalOrdersForBar}%;background:#1976d2;"></div>
                    </div>

                    <%-- SHIPPING --%>
                    <div class="status-pill sp-shipping">
                        <div>
                            <span class="status-icon">🚚</span>Đang giao hàng
                        </div>
                        <span class="status-count">${orderStatusCounts.SHIPPING}</span>
                    </div>
                    <div class="progress mb-3" style="height:4px;">
                        <div class="progress-bar" style="width:${orderStatusCounts.SHIPPING * 100 / totalOrdersForBar}%;background:#43a047;"></div>
                    </div>

                    <%-- DONE --%>
                    <div class="status-pill sp-done">
                        <div>
                            <span class="status-icon">✅</span>Hoàn tất
                        </div>
                        <span class="status-count">${orderStatusCounts.DONE}</span>
                    </div>
                    <div class="progress mb-3" style="height:4px;">
                        <div class="progress-bar" style="width:${orderStatusCounts.DONE * 100 / totalOrdersForBar}%;background:#7e57c2;"></div>
                    </div>

                    <%-- CANCEL --%>
                    <div class="status-pill sp-cancel">
                        <div>
                            <span class="status-icon">❌</span>Đã hủy
                        </div>
                        <span class="status-count">${orderStatusCounts.CANCEL}</span>
                    </div>
                    <div class="progress mb-2" style="height:4px;">
                        <div class="progress-bar" style="width:${orderStatusCounts.CANCEL * 100 / totalOrdersForBar}%;background:#e53935;"></div>
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
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status == 'PENDING'}">
                                                <span class="badge badge-pending">⏳ Chờ xử lý</span>
                                            </c:when>
                                            <c:when test="${o.status == 'PAID'}">
                                                <span class="badge badge-paid">💳 Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${o.status == 'SHIPPING'}">
                                                <span class="badge badge-shipping">🚚 Đang giao</span>
                                            </c:when>
                                            <c:when test="${o.status == 'DONE'}">
                                                <span class="badge badge-done">✅ Hoàn tất</span>
                                            </c:when>
                                            <c:when test="${o.status == 'CANCEL'}">
                                                <span class="badge badge-cancel">❌ Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary"><c:out value="${o.statusVi}"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
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
(function () {
    const labels = [
        <c:forEach items="${chartLabels}" var="l" varStatus="st">"${l}"<c:if test="${!st.last}">,</c:if></c:forEach>
    ];
    const values = [
        <c:forEach items="${chartValues}" var="v" varStatus="st">${v}<c:if test="${!st.last}">,</c:if></c:forEach>
    ];

    const canvas = document.getElementById('revenueChart');
    if (!canvas) return;
    const ctx2d = canvas.getContext('2d');

    /* Gradient fill cho bar */
    const gradient = ctx2d.createLinearGradient(0, 0, 0, 280);
    gradient.addColorStop(0, 'rgba(25, 118, 210, 0.85)');
    gradient.addColorStop(1, 'rgba(25, 118, 210, 0.15)');

    /* Định dạng tiền VN */
    function fmtVND(val) {
        return Number(val).toLocaleString('vi-VN') + ' VNĐ';
    }

    new Chart(canvas, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu',
                data: values,
                backgroundColor: gradient,
                borderColor: 'rgba(25, 118, 210, 1)',
                borderWidth: 1.5,
                borderRadius: 6,
                borderSkipped: false,
                hoverBackgroundColor: 'rgba(25, 118, 210, 0.95)',
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            animation: { duration: 600, easing: 'easeInOutQuart' },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { color: '#555', font: { size: 12 } }
                },
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(0,0,0,0.06)' },
                    ticks: {
                        color: '#555',
                        font: { size: 11 },
                        callback: function (value) {
                            if (value === 0) return '0';
                            if (value >= 1_000_000)
                                return (value / 1_000_000).toLocaleString('vi-VN') + 'tr';
                            if (value >= 1_000)
                                return (value / 1_000).toLocaleString('vi-VN') + 'k';
                            return value;
                        }
                    }
                }
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1a237e',
                    titleColor: '#90caf9',
                    bodyColor: '#fff',
                    padding: 12,
                    cornerRadius: 8,
                    callbacks: {
                        label: function (ctx) {
                            return '  ' + fmtVND(ctx.parsed.y);
                        }
                    }
                }
            }
        }
    });
})();

/* ===== Line chart: Doanh thu 12 tháng ===== */
(function () {
    const mLabels = [
        <c:forEach items="${monthLabels}" var="l" varStatus="st">"${l}"<c:if test="${!st.last}">,</c:if></c:forEach>
    ];
    const mValues = [
        <c:forEach items="${monthValues}" var="v" varStatus="st">${v}<c:if test="${!st.last}">,</c:if></c:forEach>
    ];

    const canvas = document.getElementById('revenueMonthChart');
    if (!canvas) return;
    const ctx2d = canvas.getContext('2d');

    const gradient = ctx2d.createLinearGradient(0, 0, 0, 280);
    gradient.addColorStop(0, 'rgba(67, 160, 71, 0.35)');
    gradient.addColorStop(1, 'rgba(67, 160, 71, 0.02)');

    function fmtVND(val) {
        return Number(val).toLocaleString('vi-VN') + ' VNĐ';
    }

    new Chart(canvas, {
        type: 'line',
        data: {
            labels: mLabels,
            datasets: [{
                label: 'Doanh thu',
                data: mValues,
                borderColor: 'rgba(67, 160, 71, 1)',
                backgroundColor: gradient,
                fill: true,
                tension: 0.35,
                pointRadius: 4,
                pointHoverRadius: 7,
                pointBackgroundColor: 'rgba(67, 160, 71, 1)',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                borderWidth: 2.5,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            animation: { duration: 800, easing: 'easeInOutQuart' },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { color: '#555', font: { size: 11 }, maxRotation: 45 }
                },
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(0,0,0,0.06)' },
                    ticks: {
                        color: '#555',
                        font: { size: 11 },
                        callback: function (value) {
                            if (value === 0) return '0';
                            if (value >= 1_000_000)
                                return (value / 1_000_000).toLocaleString('vi-VN') + 'tr';
                            if (value >= 1_000)
                                return (value / 1_000).toLocaleString('vi-VN') + 'k';
                            return value;
                        }
                    }
                }
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1b5e20',
                    titleColor: '#a5d6a7',
                    bodyColor: '#fff',
                    padding: 12,
                    cornerRadius: 8,
                    callbacks: {
                        label: function (ctx) {
                            return '  ' + fmtVND(ctx.parsed.y);
                        }
                    }
                }
            }
        }
    });
})();
</script>
<%@ include file="/admin/includes/_admin_layout_close.jspf" %>