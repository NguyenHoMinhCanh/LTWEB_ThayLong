<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.japansport.model.Cart" %>
<%@ page import="com.japansport.model.CartItem" %>
<%
    String ctx = request.getContextPath();

    Cart cart = (Cart) request.getAttribute("cart");
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");

    // Fallback để không vỡ nếu controller chưa set "cart"
    if (cart == null) {
        if (cartItems == null) cartItems = Collections.emptyList();
        cart = new Cart(0, 0, "ACTIVE", true, cartItems);
    } else {
        cartItems = cart.getItems();
    }

    double subtotal = cart.getSubtotal();
    int totalQty = cart.getTotalQty();

    String cartError = (String) session.getAttribute("cartError");
    session.removeAttribute("cartError");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Japan Sport - Header với Bootstrap</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet"/>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
<div class="topbar section hidden-xs hidden-sm">
    <a class="section block a-center" href="#">
        <img src="assets/images/banner.webp" alt="Siêu bão khuyến mãi cuối năm" style="width:100%;height:auto;display:flex;">
    </a>
</div>

<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<main class="bg-light py-5">
    <div class="cart-container">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h1 class="cart-title">Giỏ hàng của bạn</h1>
            <a href="${ctx}/list-product" class="continue-link btn btn-outline-dark">Tiếp tục mua hàng</a>
        </div>

        <% if (cartError != null) { %>
        <div class="alert alert-danger"><%=cartError%></div>
        <% } %>

        <% if (cartItems.isEmpty()) { %>
        <div class="alert alert-info">Giỏ hàng đang trống.</div>
        <% } else { %>
        <div class="table-responsive bg-white rounded shadow-sm p-3">
            <table class="table align-middle mb-0">
                <thead>
                <tr>
                    <th style="width:120px">Sản phẩm</th>
                    <th>Tên</th>
                    <th style="width:140px">Giá</th>
                    <th style="width:260px">Số lượng</th>
                    <th style="width:140px">Thành tiền</th>
                    <th style="width:70px"></th>
                </tr>
                </thead>
                <tbody>
                <% for (CartItem it : cartItems) { %>
                <tr>
                    <td>
                        <a href="<%=ctx%>/product-detail?id=<%=it.getProductId()%>">
                            <img src="<%=it.getImageUrl()%>" style="width:90px;height:90px;object-fit:cover;border-radius:10px;" class="cart-img-link">
                        </a>
                    </td>
                    <td>
                        <div class="fw-semibold">
                            <a href="<%=ctx%>/product-detail?id=<%=it.getProductId()%>" class="text-decoration-none text-dark product-detail-link">
                                <%=it.getProductName()%>
                            </a>
                        </div>
                        <% if (it.getVariantId() != null) { %>
                        <div class="text-muted small">Màu: <%=it.getColor()%> | Size: <%=it.getSize()%></div>
                        <% } %>
                    </td>
                    <td><%=String.format("%,.0f", it.getUnitPrice())%>₫</td>
                    <td>
                        <input type="number" class="form-control qty-input" style="max-width:110px"
                               name="qty" min="1" value="<%=it.getQuantity()%>"
                               data-price="<%=it.getUnitPrice()%>"
                               data-id="<%=it.getCartItemId()%>"
                               onchange="updateCartItemQty(this)"/>
                    </td>
                    <td id="item-subtotal-<%=it.getCartItemId()%>">
                        <%=String.format("%,.0f", it.getSubtotal())%>₫
                    </td>
                    <td class="text-center">
                        <form method="post" action="<%=ctx%>/cart" id="delete-form-<%=it.getCartItemId()%>">
                            <input type="hidden" name="action" value="remove"/>
                            <input type="hidden" name="cartItemId" value="<%=it.getCartItemId()%>"/>

                            <button class="btn btn-outline-danger btn-sm rounded-circle" type="button" title="Xóa sản phẩm"
                                    onclick="openDeleteModal(<%=it.getCartItemId()%>)">
                                <i class="bi bi-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <div class="row mt-4 g-4">
            <div class="col-lg-7">
                <form method="post" action="<%=ctx%>/cart" class="d-inline">
                    <input type="hidden" name="action" value="clear"/>
                    <button class="btn btn-outline-secondary" type="submit">
                        <i class="bi bi-trash3 me-1"></i> Xoá toàn bộ giỏ
                    </button>
                </form>
            </div>

            <div class="col-lg-5">
                <div class="totals-box p-4 bg-white rounded shadow-sm border">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted">Tạm tính</span>
                        <strong id="subtotal" class="fs-6"><%=String.format("%,.0f", subtotal)%>₫</strong>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted">Phí vận chuyển</span>
                        <span id="shipping" class="fw-semibold">0₫</span>
                    </div>
                    <hr class="text-muted opacity-25 my-3">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fs-5 fw-bold text-uppercase">Thành tiền</span>
                        <strong class="fs-3 text-danger fw-bolder" id="grandTotal"><%=String.format("%,.0f", subtotal)%>₫</strong>
                    </div>
                    <div class="mt-3 d-grid gap-2">
                        <a class="btn btn-danger btn-lg checkout-btn fw-bold shadow-sm"
                           href="javascript:void(0);"
                           onclick="goToCheckout('<%=ctx%>/checkout')">
                            MUA NGAY
                        </a>
                        <a class="btn btn-warning checkout-btn fw-semibold" href="<%=request.getContextPath()%>/installment_payment.jsp">
                            HƯỚNG DẪN TRẢ GÓP
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<section class="bg-light py-4">
    <div class="container">
        <div class="row g-3">
            <div class="col-lg-3 col-6">
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 pt-2 ">
                            <img src="assets/images/footer/srv_1.png" alt="Service Item" class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">VẬN CHUYỂN SIÊU TỐC</h6>
                            <small class="text-muted">Vận chuyển nội thành HN trong 2 tiếng!</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6">
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_2.png" alt="Service Item" class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">ĐỔI HÀNG</h6>
                            <small class="text-muted">Đổi hàng trong 7 ngày miễn phí!</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6">
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_3.png" alt="Service Item" class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">TIẾT KIỆM THỜI GIAN</h6>
                            <small class="text-muted">Mua sắm dễ hơn khi online</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6">
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_4.png" alt="Service Item" class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">ĐỊA CHỈ CỬA HÀNG</h6>
                            <small class="text-muted">Lotus 4, Vinhome Gardenia, Hàm Nghi, Từ Liêm, HN</small></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-danger rounded-pill px-4" id="btnConfirmDelete">Đồng ý xóa</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<button class="btn btn-danger position-fixed bottom-0 end-0 m-4 rounded-circle"
        style="width:50px;height:50px;z-index:1000;"
        onclick="window.scrollTo({top:0,behavior:'smooth'})"
        title="Lên đầu trang" aria-label="Lên đầu trang">
    <i class="bi bi-arrow-up"></i>
</button>

<style>
    .product-detail-link:hover {
        color: #dc3545 !important;
        text-decoration: underline !important;
    }
    .cart-img-link:hover {
        opacity: 0.8;
        transition: 0.3s;
    }
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<script>
    // --- 1. XỬ LÝ CẬP NHẬT SỐ LƯỢNG (AJAX) ---
    function updateCartItemQty(input) {
        const cartItemId = input.getAttribute('data-id');
        const newQty = parseInt(input.value);
        const unitPrice = parseFloat(input.getAttribute('data-price'));
        const formatVND = (n) => new Intl.NumberFormat('vi-VN').format(n) + '₫';

        if (newQty < 1) return;

        // Cập nhật "Thành tiền" của dòng
        const rowSubtotal = newQty * unitPrice;
        const subtotalEl = document.getElementById('item-subtotal-' + cartItemId);
        if (subtotalEl) subtotalEl.innerText = formatVND(rowSubtotal);

        // Tính lại tổng tiền
        let total = 0;
        document.querySelectorAll('.qty-input').forEach(inp => {
            const price = parseFloat(inp.getAttribute('data-price'));
            const q = parseInt(inp.value);
            total += price * q;
        });

        // Hiển thị tổng tiền mới
        const subtotalTotalEl = document.getElementById('subtotal');
        const grandTotalEl = document.getElementById('grandTotal');
        if (subtotalTotalEl) subtotalTotalEl.innerText = formatVND(total);
        if (grandTotalEl) grandTotalEl.innerText = formatVND(total);

        fetch("<%=ctx%>/cart", {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: "action=update&cartItemId=" + cartItemId + "&qty=" + newQty
        })
            .then(response => {
                if (!response.ok) console.error("Lỗi: Không thể lưu dữ liệu vào máy chủ.");
            })
            .catch(error => console.error('Lỗi kết nối:', error));
    }

    // --- 2. XỬ LÝ CHUYỂN TRANG THANH TOÁN AN TOÀN ---
    async function goToCheckout(checkoutUrl) {
        const btn = document.querySelector('.checkout-btn');
        if (!btn) return;

        const originalText = btn.innerHTML;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang xử lý...';
        btn.style.pointerEvents = 'none';

        try {
            const inputs = document.querySelectorAll('.qty-input');
            const promises = [];

            // Gửi dữ liệu lưu lần cuối trước khi sang trang
            inputs.forEach(input => {
                const cartItemId = input.getAttribute('data-id');
                const qty = input.value;
                if (qty >= 1) {
                    // SỬA LỖI Ở ĐÂY: Dùng nối chuỗi (+)
                    const req = fetch("<%=ctx%>/cart", {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: "action=update&cartItemId=" + cartItemId + "&qty=" + qty
                    });
                    promises.push(req);
                }
            });

            // Chờ lưu xong 100% rồi mới đi
            await Promise.all(promises);
            window.location.href = checkoutUrl;

        } catch (error) {
            console.error('Lỗi khi chuẩn bị thanh toán:', error);
            btn.innerHTML = originalText;
            btn.style.pointerEvents = 'auto';
            alert('Có lỗi xảy ra khi lưu giỏ hàng, vui lòng thử lại!');
        }
    }

    // --- 3. XỬ LÝ MODAL XÁC NHẬN XÓA ---
    let currentDeleteId = null;
    const deleteModalEl = document.getElementById('deleteConfirmModal');
    let deleteModal = null;

    if (deleteModalEl) {
        deleteModal = new bootstrap.Modal(deleteModalEl);
    }

    function openDeleteModal(cartItemId) {
        currentDeleteId = cartItemId;
        if (deleteModal) deleteModal.show();
    }

    const confirmBtn = document.getElementById('btnConfirmDelete');
    if (confirmBtn) {
        confirmBtn.addEventListener('click', function() {
            if (currentDeleteId) {
                const form = document.getElementById('delete-form-' + currentDeleteId);
                if (form) form.submit();
            }
        });
    }
</script>
</body>
</html>