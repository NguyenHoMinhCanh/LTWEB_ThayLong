<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    // Escape an toàn để hiển thị lại input khi có lỗi
    public static String esc(Object o) {
        if (o == null) return "";
        String s = String.valueOf(o);
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#x27;");
    }
%>
<%
    String ctx = request.getContextPath();
    String err = (String) request.getAttribute("errorMessage");
    if (session.getAttribute("CSRF_TOKEN") == null) {
        java.security.SecureRandom rng = new java.security.SecureRandom();
        byte[] buf = new byte[32];
        rng.nextBytes(buf);
        String token = java.util.Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
        session.setAttribute("CSRF_TOKEN", token);
    }


%>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>JapanSport | Đăng ký</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap & Icons (nếu login.jsp cũng dùng, để nguyên) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- CSS của site -->
    <link rel="stylesheet" href="<%=ctx%>/assets/css/style.css">
</head>
<body class="bg-light">

<!-- Banner -->
<div class="topbar section hidden-xs hidden-sm">
    <a class="section block a-center" href="#">
        <img src="<%=ctx%>/assets/images/banner.webp" alt="Siêu bão khuyến mãi cuối năm"
             style="width:100%;height:auto;display:flex;">
    </a>
</div>

<!-- Header + navbar -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<!-- ========== REGISTER CARD  ========== -->
<section class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-xl-5">
                <div class="card shadow-sm" style="border-radius:16px;">
                    <div class="card-header bg-white">
                        <div class="d-flex align-items-center">
                            <img src="<%=ctx%>/assets/images/logo.webp" class="logo-header me-2" alt="">
                            <h5 class="mb-0">JapanSport</h5>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <h4 class="mb-3">Tạo tài khoản</h4>

                        <form id="registerForm" method="post" action="<%=ctx%>/register" novalidate>
                            <!-- CSRF nếu bạn có -->
                            <input type="hidden" name="csrf" value="<%= esc(session.getAttribute("CSRF_TOKEN")) %>"/>

                            <div class="mb-3">
                                <label for="regName" class="form-label">Họ tên <span
                                        class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="regName" name="name"
                                       placeholder="Nhập họ tên" required
                                       value="<%= esc(request.getParameter("name")) %>">
                            </div>

                            <div class="mb-3">
                                <label for="regEmail" class="form-label">Email <span
                                        class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="regEmail" name="email"
                                       placeholder="Nhập email" required
                                       value="<%= esc(request.getParameter("email")) %>">
                            </div>

                            <div class="mb-4">
                                <label for="regPassword" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="regPassword" name="password"
                                       placeholder="Nhập mật khẩu" required minlength="3">
                            </div>

                            <button type="submit" class="btn btn-danger w-100">Đăng ký</button>

                            <% if (err != null) { %>
                            <div class="alert alert-danger mt-3 mb-0"><%= err %>
                            </div>
                            <% } %>

                            <p class="mt-3 mb-0">
                                Đã có tài khoản?
                                <a href="<%=ctx%>/login.jsp" class="text-decoration-none">Đăng nhập</a>
                            </p>
                        </form>
                    </div>
                </div>
            </div><!-- col -->
        </div>
    </div>
</section>

<!-- FOOTER  -->
<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
