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
                        <img src="<%=it.getImageUrl()%>" style="width:90px;height:90px;object-fit:cover;border-radius:10px;">
                    </td>
                    <td>
                        <div class="fw-semibold"><%=it.getProductName()%></div>
                        <% if (it.getVariantId() != null) { %>
                        <div class="text-muted small">Màu: <%=it.getColor()%> | Size: <%=it.getSize()%></div>
                        <% } %>
                    </td>
                    <td><%=String.format("%,.0f", it.getUnitPrice())%>₫</td>
                    <td>
                        <form class="d-flex gap-2" method="post" action="<%=ctx%>/cart">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="cartItemId" value="<%=it.getCartItemId()%>"/>
                            <input type="number" class="form-control" style="max-width:110px"
                                   name="qty" min="1" value="<%=it.getQuantity()%>"/>
                            <button class="btn btn-outline-secondary" type="submit">Cập nhật</button>
                        </form>
                    </td>
                    <td><%=String.format("%,.0f", it.getSubtotal())%>₫</td>
                    <td>
                        <form method="post" action="<%=ctx%>/cart">
                            <input type="hidden" name="action" value="remove"/>
                            <input type="hidden" name="cartItemId" value="<%=it.getCartItemId()%>"/>
                            <button class="btn btn-outline-danger btn-sm" type="submit">X</button>
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
                        <button class="btn btn-danger checkout-btn" id="btnBuyNow">MUA NGAY - GIAO HÀNG THANH TOÁN
                        </button>
                        <a class="btn btn-primary checkout-btn" href="<%=request.getContextPath()%>/checkout">MUA NGAY</a>
                        <button class="btn btn-info checkout-btn text-white" id="btnInstallment">TRẢ GÓP QUA THẺ
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




</body>
</html>
