<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Hướng dẫn trả góp - Japan Sport</title>

  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet"/>
  <link href="assets/css/style.css" rel="stylesheet"/>

  <style>
    .step-icon {
      width: 60px;
      height: 60px;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #f8f9fa;
      color: #dc3545;
      border-radius: 50%;
      font-size: 1.5rem;
      margin-bottom: 15px;
    }
    .contact-box {
      background-color: #fff;
      border-top: 4px solid #dc3545;
      box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05);
      border-radius: 8px;
    }
  </style>
</head>
<body class="bg-light">

<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<main class="container py-5">
  <div class="text-center mb-5">
    <h1 class="fw-bold text-uppercase">Hướng dẫn mua hàng trả góp</h1>
    <p class="text-muted fs-5">Thủ tục nhanh gọn - Nhận hàng ngay - Không cần chứng minh thu nhập</p>
  </div>

  <div class="row g-5">
    <div class="col-lg-7">
      <h3 class="fw-bold mb-4">Quy trình trả góp tại Japan Sport</h3>

      <div class="row g-4">
        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <div class="step-icon"><i class="bi bi-cart-check"></i></div>
              <h5 class="fw-bold">Bước 1: Chọn sản phẩm</h5>
              <p class="text-muted small">Lựa chọn đôi giày hoặc trang phục thể thao bạn yêu thích trên website Japan Sport.</p>
            </div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <div class="step-icon"><i class="bi bi-headset"></i></div>
              <h5 class="fw-bold">Bước 2: Để lại thông tin</h5>
              <p class="text-muted small">Điền thông tin vào form liên hệ bên cạnh hoặc gọi hotline. Nhân viên của chúng tôi sẽ gọi lại ngay lập tức.</p>
            </div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <div class="step-icon"><i class="bi bi-file-earmark-person"></i></div>
              <h5 class="fw-bold">Bước 3: Xét duyệt hồ sơ</h5>
              <p class="text-muted small">Chỉ cần CMND/CCCD và Bằng lái xe (hoặc Hộ khẩu). Duyệt hồ sơ online chỉ trong 15 phút.</p>
            </div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <div class="step-icon"><i class="bi bi-box-seam"></i></div>
              <h5 class="fw-bold">Bước 4: Nhận sản phẩm</h5>
              <p class="text-muted small">Ký hợp đồng và nhận ngay sản phẩm tại cửa hàng hoặc giao hàng tận nơi trên toàn quốc.</p>
            </div>
          </div>
        </div>
      </div>

      <div class="alert alert-info mt-4">
        <i class="bi bi-info-circle-fill me-2"></i> <strong>Lưu ý:</strong> Áp dụng cho đơn hàng có tổng giá trị từ <strong>3.000.000₫</strong> trở lên. Hỗ trợ trả góp qua thẻ tín dụng (Lãi suất 0%) hoặc qua công ty tài chính.
      </div>
    </div>

    <div class="col-lg-5">
      <div class="contact-box p-4">
        <h4 class="fw-bold mb-3 text-center">Đăng ký tư vấn trả góp</h4>
        <p class="text-muted text-center small mb-4">Nhân viên tổng đài sẽ liên hệ với bạn trong vòng 15 phút.</p>

        <%
          String msg = (String) request.getAttribute("message");
          if (msg != null) {
        %>
        <div class="alert alert-success py-2"><%=msg%></div>
        <% } %>

        <form action="<%=ctx%>/submit-installment" method="POST">
          <div class="mb-3">
            <label class="form-label fw-semibold">Họ và tên của bạn <span class="text-danger">*</span></label>
            <input type="text" name="fullName" class="form-control" placeholder="Nhập họ và tên" required>
          </div>
          <div class="mb-3">
            <label class="form-label fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
            <input type="tel" name="phone" class="form-control" placeholder="Nhập số điện thoại" required>
          </div>
          <div class="mb-3">
            <label class="form-label fw-semibold">Sản phẩm muốn mua</label>
            <input type="text" name="productName" class="form-control" placeholder="Ví dụ: Giày Adidas Ultraboost">
          </div>
          <div class="mb-4">
            <label class="form-label fw-semibold">Ghi chú thêm (Nếu có)</label>
            <textarea name="note" class="form-control" rows="3" placeholder="Bạn muốn trả góp qua thẻ tín dụng hay CMND?"></textarea>
          </div>

          <button type="submit" class="btn btn-danger w-100 py-2 fw-bold fs-5">
            YÊU CẦU GỌI LẠI TƯ VẤN
          </button>
        </form>

        <div class="text-center mt-4">
          <p class="mb-1 text-muted">Hoặc gọi trực tiếp Hotline</p>
          <a href="tel:0984843218" class="text-danger fw-bold fs-4 text-decoration-none">
            <i class="bi bi-telephone-fill"></i> 0984 843 218
          </a>
        </div>
      </div>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>