<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Chi tiết đơn hàng</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/account.css">
</head>

<body>

<%@ include file="/WEB-INF/jspf/site_header.jspf" %>


<section class="py-4">
    <div class="container account-wrap">
        <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
            <div>
                <h4 class="mb-1 account-section-title">Chi tiết đơn #${order.id}</h4>
                <div class="text-muted small">
                    <i class="bi bi-clock me-1"></i> <c:out value="${order.createdAt}"/>
                </div>
            </div>
            <div class="d-flex gap-2">
                <a class="btn btn-outline-secondary rounded-pill" href="${ctx}/orders">
                    <i class="bi bi-arrow-left me-1"></i> Danh sách đơn
                </a>
                <a class="btn btn-outline-danger rounded-pill" href="${ctx}/home">
                    <i class="bi bi-bag me-1"></i> Mua thêm
                </a>

                <c:if test="${order.status == 'PENDING'}">
                    <form method="post" action="${ctx}/order-cancel"
                          style="display:inline-block;"
                          onsubmit="return confirm('Bạn chắc chắn muốn hủy đơn #${order.id} ?');">
                        <input type="hidden" name="id" value="${order.id}"/>
                        <input type="hidden" name="redirect" value="/order-detail?id=${order.id}"/>
                        <input type="hidden" name="csrf" value="${sessionScope.CSRF_TOKEN}"/>

                        <button type="submit" class="btn btn-outline-danger rounded-pill">
                            <i class="bi bi-x-circle me-1"></i> Hủy đơn
                        </button>
                    </form>
                </c:if>

            </div>
        </div>

        <!-- Stepper trạng thái -->
        <c:set var="st" value="${order.status}"/>
        <div class="stepper mb-3">
            <div class="step ${st=='PENDING' || st=='PAID' || st=='SHIPPING' || st=='DONE' ? 'active' : ''}">
                <span class="dot"></span>
                <div class="t">Tạo đơn</div>
                <div class="d">Đã ghi nhận</div>
            </div>
            <div class="step ${st=='PAID' || st=='SHIPPING' || st=='DONE' ? 'active' : ''}">
                <span class="dot"></span>
                <div class="t">Xử lý</div>
                <div class="d">Chuẩn bị hàng</div>
            </div>
            <div class="step ${st=='SHIPPING' || st=='DONE' ? 'active' : ''}">
                <span class="dot"></span>
                <div class="t">Vận chuyển</div>
                <div class="d">Đang giao</div>
            </div>
            <div class="step ${st=='DONE' ? 'active' : ''}">
                <span class="dot"></span>
                <div class="t">Hoàn tất</div>
                <div class="d">Đã nhận</div>
            </div>
        </div>

        <div class="row g-3">
            <!-- Info -->
            <div class="col-lg-5">
                <div class="card soft-card mb-3">
                    <div class="card-header">
                        <i class="bi bi-truck me-2 text-danger"></i>Thông tin giao hàng
                    </div>
                    <div class="card-body">
                        <div class="fw-bold">${order.fullName}</div>
                        <div class="text-muted">${order.phone}</div>
                        <div class="mt-2">
                            <i class="bi bi-geo-alt me-1"></i>
                            <c:out value="${order.fullAddress}"/>
                        </div>

                        <hr class="my-3"/>

                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted">Trạng thái</div>
                            <div>
                                <c:choose>
                                    <c:when test="${st=='PENDING'}"><span class="badge-status badge-pending">Chờ xử lý</span></c:when>
                                    <c:when test="${st=='PAID'}"><span class="badge-status badge-paid">Đã thanh toán</span></c:when>
                                    <c:when test="${st=='SHIPPING'}"><span class="badge-status badge-shipping">Đang giao</span></c:when>
                                    <c:when test="${st=='DONE'}"><span class="badge-status badge-done">Hoàn tất</span></c:when>
                                    <c:when test="${st=='CANCEL'}"><span class="badge-status badge-cancel">Đã hủy</span></c:when>
                                    <c:otherwise><span class="badge-status badge-pending">${st}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <hr class="my-3"/>

                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted">Tổng tiền</div>
                            <div class="fw-bold money" data-money="${order.totalAmount}"></div>
                        </div>
                    </div>
                </div>

                <div class="card soft-card">
                    <div class="card-header">
                        <i class="bi bi-info-circle me-2 text-danger"></i>Lưu ý
                    </div>
                    <div class="card-body text-muted small">
                        Nếu cần hỗ trợ đổi trả, vui lòng xem mục “Chính sách đổi trả” hoặc liên hệ hotline.
                    </div>
                </div>
            </div>

            <!-- Items -->
            <div class="col-lg-7">
                <div class="card soft-card">
                    <div class="card-header">
                        <i class="bi bi-bag-check me-2 text-danger"></i>Sản phẩm trong đơn
                    </div>
                    <div class="card-body">
                        <c:forEach var="it" items="${items}">
                            <div class="d-flex gap-3 py-3 border-bottom">
                                <img src="${it.productImageUrl}" alt="${it.productName}"
                                     style="width:84px;height:84px;object-fit:cover;border-radius:14px;"/>
                                <div class="flex-grow-1">
                                    <div class="fw-bold">${it.productName}</div>
                                    <div class="text-muted small">
                                        <c:if test="${not empty it.color}">Màu: ${it.color}</c:if>
                                        <c:if test="${not empty it.size}"> | Size: ${it.size}</c:if>
                                    </div>
                                    <div class="small mt-2">
                                        SL: <b>${it.quantity}</b>
                                        • Đơn giá: <span class="money" data-money="${it.unitPrice}"></span>
                                        • Tạm tính: <span class="money" data-money="${it.subtotal}"></span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <div class="pt-3 d-flex justify-content-between">
                            <div class="text-muted">Tổng cộng</div>
                            <div class="fw-bold money" data-money="${order.totalAmount}"></div>
                        </div>
                    </div>
                </div>

                <div class="mt-3 d-flex gap-2 flex-wrap">
                    <a class="btn btn-outline-secondary rounded-pill" href="${ctx}/orders">
                        <i class="bi bi-arrow-left me-1"></i> Quay lại
                    </a>
                    <a class="btn btn-danger rounded-pill" href="${ctx}/home">
                        <i class="bi bi-bag me-1"></i> Mua sắm tiếp
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>


<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    function qs(sel){ return document.querySelector(sel); }
    function getCart(){
        try { return JSON.parse(localStorage.getItem('cart') || '[]'); }
        catch(e){ return []; }
    }
    function updateCartCount() {
        const total = getCart().reduce((s, it) => s + (it.qty || 1), 0);
        const badge = qs('#cartCount');
        if (badge) { badge.textContent = total; badge.style.display = total>0?'inline-block':'none'; }
    }
    function fmtVND(n){ return (Number(n||0)).toLocaleString('vi-VN') + '₫'; }
    document.addEventListener('DOMContentLoaded', () => {
        updateCartCount();
        document.querySelectorAll('.money').forEach(el => el.textContent = fmtVND(el.getAttribute('data-money')));
    });
</script>
</body>
</html>
