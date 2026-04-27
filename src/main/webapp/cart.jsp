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

    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet"/>

    <!-- App CSS -->
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
<!-- Banner quảng cáo -->
<div class="topbar section hidden-xs hidden-sm">
    <a class="section block a-center" href="#">
        <img src="assets/images/banner.webp" alt="Siêu bão khuyến mãi cuối năm"
             style="width:100%;height:auto;display:flex;">
    </a>
</div>

<!-- HEADER + navbar -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<!-- Main Content -->
<main class="bg-light py-5">
    <div class="cart-container">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h1 class="cart-title">Giỏ hàng của bạn</h1>
            <a href="${ctx}/list-product" class="continue-link btn btn-outline-dark">Tiếp tục mua hàng</a>
        </div>

        <!-- Cart Table -->
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
                            <img src="<%=it.getImageUrl()%>"
                                 style="width:90px;height:90px;object-fit:cover;border-radius:10px;"
                                 class="cart-img-link">
                        </a>
                    </td>
                    <td>
                        <div class="fw-semibold">
                            <a href="<%=ctx%>/product-detail?id=<%=it.getProductId()%>"
                               class="text-decoration-none text-dark product-detail-link">
                                <%=it.getProductName()%>
                            </a>
                        </div>
                        <% if (it.getVariantId() != null) { %>
                        <div class="text-muted small">Màu: <%=it.getColor()%> | Size: <%=it.getSize()%></div>
                        <% } %>
                    </td>
                    <td><%=String.format("%,.0f", it.getUnitPrice())%>₫</td>
                    <td>
                        <input type="number" class="form-control" style="max-width:110px"
                               name="qty" min="1" value="<%=it.getQuantity()%>"
                               onchange="updateCartItemQty(<%=it.getCartItemId()%>, this.value, <%=it.getUnitPrice()%>)"/>
                    </td>
                    <td id="item-subtotal-<%=it.getCartItemId()%>">
                        <%=String.format("%,.0f", it.getSubtotal())%>₫
                    <td class="text-center">
                        <form method="post" action="<%=ctx%>/cart"
                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?');">
                            <input type="hidden" name="action" value="remove"/>
                            <input type="hidden" name="cartItemId" value="<%=it.getCartItemId()%>"/>

                            <button class="btn btn-outline-danger btn-sm" type="submit" title="Xóa sản phẩm">
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
                <div class="totals-box">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span>Tạm tính</span>
                        <strong id="subtotal"><%=String.format("%,.0f", subtotal)%>₫</strong>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span>Phí vận chuyển</span>
                        <span id="shipping">0₫</span>
                    </div>
                    <div class="line my-3"></div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="fs-5">Thành tiền</span>
                        <strong class="fs-5" id="grandTotal"><%=String.format("%,.0f", subtotal)%>₫</strong>
                    </div>
                    <div class="mt-3 d-grid gap-2">
                        <a class="btn btn-danger btn-lg checkout-btn fw-bold shadow-sm" href="<%=request.getContextPath()%>/checkout">
                            MUA NGAY
                        </a>
                        <a class="btn btn-warning checkout-btn fw-semibold" href="<%=request.getContextPath()%>/installment_payment.jsp">
                            HƯỚNG DẪN TRẢ GÓP
                        </a>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<!-- Features Service -->
<section class="bg-light py-4">
    <div class="container">
        <div class="row g-3">
            <div class="col-lg-3 col-6">  <!--srv1-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 pt-2 ">
                            <img src="assets/images/footer/srv_1.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">VẬN CHUYỂN SIÊU TỐC</h6>
                            <small class="text-muted">Vận chuyển nội thành HN trong 2 tiếng!</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6">  <!--srv2-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_2.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">ĐỔI HÀNG</h6>
                            <small class="text-muted">Đổi hàng trong 7 ngày miễn phí!</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6"> <!--srv3-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_3.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">TIẾT KIỆM THỜI GIAN</h6>
                            <small class="text-muted">Mua sắm dễ hơn khi online</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6"> <!--srv4-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_4.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">ĐỊA CHỈ CỬA HÀNG</h6>
                            <small class="text-muted">Lotus 4, Vinhome Gardenia, Hàm Nghi, Từ Liêm, HN</small></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<!-- Back to top -->
<button class="btn btn-danger position-fixed bottom-0 end-0 m-4 rounded-circle"
        style="width:50px;height:50px;z-index:1000;"
        onclick="window.scrollTo({top:0,behavior:'smooth'})"
        title="Lên đầu trang" aria-label="Lên đầu trang">
    <i class="bi bi-arrow-up"></i>
</button>
<style>
    .product-detail-link:hover {
        color: #dc3545 !important; /* Màu đỏ Accent */
        text-decoration: underline !important;
    }
    .cart-img-link:hover {
        opacity: 0.8;
        transition: 0.3s;
    }
</style>
<script>
    function updateCartItemQty(cartItemId, newQty, unitPrice) {
        if (newQty < 1) return;

        // Hàm định dạng tiền tệ VNĐ
        const formatVND = (amount) => {
            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
        };

        // 1. Cập nhật ngay "Thành tiền" của sản phẩm đó trên giao diện (Tạo cảm giác mượt mà tức thì)
        const newSubtotalItem = newQty * unitPrice;
        document.getElementById('item-subtotal-' + cartItemId).innerText = formatVND(newSubtotalItem);

        // 2. Gửi request ngầm lên Server để lưu vào Session/Database
        fetch(`<%=ctx%>/cart-api/update`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `cartItemId=${cartItemId}&qty=${newQty}`
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Server trả về tổng tiền mới của toàn bộ giỏ hàng -> Cập nhật hiển thị
                    document.getElementById('subtotal').innerText = formatVND(data.newTotal);
                    document.getElementById('grandTotal').innerText = formatVND(data.newTotal);
                } else {
                    alert('Có lỗi xảy ra: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Lỗi khi gọi AJAX:', error);
                // alert('Không thể kết nối đến máy chủ.');
            });
    }

</script>



</body>
</html>
