<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Đơn hàng của tôi</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/account.css">
</head>

<body>
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>


<section class="py-4">
    <div class="container account-wrap">

        <c:if test="${not empty sessionScope.FLASH_MSG}">
            <div class="alert ${sessionScope.FLASH_TYPE == 'success' ? 'alert-success' : 'alert-danger'}">
                    ${sessionScope.FLASH_MSG}
            </div>
            <c:remove var="FLASH_MSG" scope="session"/>
            <c:remove var="FLASH_TYPE" scope="session"/>
        </c:if>

        <div class="row g-4">
            <!-- Sidebar -->
            <div class="col-lg-4 col-xl-3">
                <div class="account-sidebar">
                    <div class="account-card">
                        <div class="account-hero d-flex align-items-center gap-3">
                            <div class="account-avatar">
                                <i class="bi bi-person"></i>
                            </div>
                            <div>
                                <p class="account-user-name mb-0">Tài khoản</p>
                                <p class="account-user-email mb-0">Quản lý đơn hàng</p>
                            </div>
                        </div>
                        <div class="p-3">
                            <div class="account-nav d-grid gap-2">
                                <a href="${ctx}/account"><i class="bi bi-person-badge"></i> Hồ sơ tài khoản</a>
                                <a class="active" href="${ctx}/orders"><i class="bi bi-receipt"></i> Đơn hàng của
                                    tôi</a>
                                <a href="${ctx}/change-password"><i class="bi bi-shield-lock"></i> Bảo mật & mật
                                    khẩu</a>
                                <a href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content -->
            <div class="col-lg-8 col-xl-9">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div>
                        <h4 class="mb-1 account-section-title">Đơn hàng của tôi</h4>
                        <div class="text-muted">Xem trạng thái, chi tiết và sản phẩm đã mua</div>
                    </div>
                    <a class="btn btn-outline-danger rounded-pill" href="${ctx}/home">
                        <i class="bi bi-bag me-1"></i> Mua thêm
                    </a>
                </div>

                <!-- Search / Filter UI (client-side) -->
                <div class="card soft-card mb-3">
                    <div class="card-body">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                                    <input id="orderSearch" class="form-control"
                                           placeholder="Tìm theo mã đơn (ví dụ: 12)">
                                </div>
                            </div>
                            <div class="col-md-6 d-flex gap-2 justify-content-md-end flex-wrap">
                                <button class="btn btn-outline-secondary rounded-pill btn-sm" data-filter="ALL">Tất cả
                                </button>
                                <button class="btn btn-outline-secondary rounded-pill btn-sm" data-filter="PENDING">Chờ
                                    xử lý
                                </button>
                                <button class="btn btn-outline-secondary rounded-pill btn-sm" data-filter="SHIPPING">
                                    Đang giao
                                </button>
                                <button class="btn btn-outline-secondary rounded-pill btn-sm" data-filter="DONE">Hoàn
                                    tất
                                </button>
                                <button class="btn btn-outline-secondary rounded-pill btn-sm" data-filter="CANCEL">Đã
                                    hủy
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${empty orders}">
                    <div class="card soft-card">
                        <div class="card-body text-center py-5">
                            <h6 class="mb-2">Bạn chưa có đơn hàng nào</h6>
                            <div class="text-muted mb-3">Hãy chọn sản phẩm bạn thích và đặt hàng nhé.</div>
                            <a class="btn btn-danger rounded-pill px-4" href="${ctx}/home">
                                <i class="bi bi-bag me-1"></i> Mua sắm ngay
                            </a>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty orders}">
                    <div class="d-grid gap-3" id="ordersList">
                        <c:forEach var="o" items="${orders}">
                            <c:set var="st" value="${o.status}"/>
                            <c:set var="badgeClass" value="badge-status badge-pending"/>

                            <c:choose>
                                <c:when test="${st == 'PAID'}"><c:set var="badgeClass" value="badge-status badge-paid"/></c:when>
                                <c:when test="${st == 'SHIPPING'}"><c:set var="badgeClass"
                                                                          value="badge-status badge-shipping"/></c:when>
                                <c:when test="${st == 'DONE'}"><c:set var="badgeClass" value="badge-status badge-done"/></c:when>
                                <c:when test="${st == 'CANCEL'}"><c:set var="badgeClass"
                                                                        value="badge-status badge-cancel"/></c:when>
                                <c:otherwise><c:set var="badgeClass" value="badge-status badge-pending"/></c:otherwise>
                            </c:choose>

                            <div class="order-card order-item" data-orderid="${o.id}" data-status="${st}">
                                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                                    <div>
                                        <div class="order-meta">
                                            <div class="fw-bold">Đơn #${o.id}</div>
                                            <span class="${badgeClass}">
                                                <c:choose>
                                                    <c:when test="${st=='PENDING'}">Chờ xử lý</c:when>
                                                    <c:when test="${st=='PAID'}">Đã thanh toán</c:when>
                                                    <c:when test="${st=='SHIPPING'}">Đang giao</c:when>
                                                    <c:when test="${st=='DONE'}">Hoàn tất</c:when>
                                                    <c:when test="${st=='CANCEL'}">Đã hủy</c:when>
                                                    <c:otherwise>${st}</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="text-muted small">
                                                <i class="bi bi-clock me-1"></i><c:out value="${o.createdAt}"/>
                                            </span>
                                        </div>
                                        <div class="text-muted small mt-1">
                                            <i class="bi bi-geo-alt me-1"></i>
                                            <c:out value="${o.fullAddress}"/>
                                        </div>
                                    </div>

                                    <div class="text-end">
                                        <div class="fw-bold money" data-money="${o.totalAmount}"></div>
                                        <a class="btn btn-outline-danger rounded-pill btn-sm mt-2"
                                           href="${ctx}/order-detail?id=${o.id}">
                                            Xem chi tiết <i class="bi bi-arrow-right ms-1"></i>
                                        </a>

                                        <c:if test="${st == 'PENDING'}">
                                            <form method="post" action="${ctx}/order-cancel" class="mt-2"
                                                  onsubmit="return confirm('Bạn chắc chắn muốn hủy đơn #${o.id} ?');">
                                                <input type="hidden" name="id" value="${o.id}"/>
                                                <input type="hidden" name="redirect" value="/orders"/>
                                                <input type="hidden" name="csrf" value="${sessionScope.CSRF_TOKEN}"/>

                                                <button type="submit" class="btn btn-outline-danger rounded-pill btn-sm">
                                                    <i class="bi bi-x-circle me-1"></i> Hủy đơn
                                                </button>
                                            </form>
                                        </c:if>

                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>


<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    function qs(sel) {
        return document.querySelector(sel);
    }

    function qsa(sel) {
        return document.querySelectorAll(sel);
    }

    function getCart() {
        try {
            return JSON.parse(localStorage.getItem('cart') || '[]');
        } catch (e) {
            return [];
        }
    }

    function updateCartCount() {
        const total = getCart().reduce((s, it) => s + (it.qty || 1), 0);
        const badge = qs('#cartCount');
        if (badge) {
            badge.textContent = total;
            badge.style.display = total > 0 ? 'inline-block' : 'none';
        }
    }

    function fmtVND(n) {
        return (Number(n || 0)).toLocaleString('vi-VN') + '₫';
    }

    document.addEventListener('DOMContentLoaded', () => {
        updateCartCount();
        qsa('.money').forEach(el => el.textContent = fmtVND(el.getAttribute('data-money')));

        // client-side filter
        const buttons = qsa('[data-filter]');
        const items = qsa('.order-item');
        let active = 'ALL';

        function apply() {
            const q = (qs('#orderSearch')?.value || '').trim();
            items.forEach(it => {
                const st = it.getAttribute('data-status') || '';
                const id = it.getAttribute('data-orderid') || '';
                const okStatus = (active === 'ALL') || (st === active);
                const okQuery = (!q) || id.includes(q);
                it.style.display = (okStatus && okQuery) ? '' : 'none';
            });
        }

        buttons.forEach(b => {
            b.addEventListener('click', () => {
                active = b.getAttribute('data-filter');
                buttons.forEach(x => x.classList.remove('btn-danger'));
                buttons.forEach(x => x.classList.add('btn-outline-secondary'));
                b.classList.remove('btn-outline-secondary');
                b.classList.add('btn-danger');
                apply();
            });
        });

        const inp = qs('#orderSearch');
        if (inp) inp.addEventListener('input', apply);

        // default highlight ALL
        const first = qs('[data-filter="ALL"]');
        if (first) first.click();
    });
</script>

</body>
</html>
