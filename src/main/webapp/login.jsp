<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<% // ===== CSRF + biến tiện dùng (scriptlet bình thường) =====
    if (session.getAttribute("CSRF_TOKEN") == null) {
        java.security.SecureRandom rng = new java.security.SecureRandom();
        byte[] buf = new byte[32];
        rng.nextBytes(buf);
        String token = java.util.Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
        session.setAttribute("CSRF_TOKEN", token);
    }

    String ctx = request.getContextPath();
    String msg = (String) request.getAttribute("msg");      // từ LoginServlet
    String msgType = (String) request.getAttribute("msgType");  // "error" | "success"
    if (msg == null) {
        msg = (String) session.getAttribute("FLASH_MSG");
        msgType = (String) session.getAttribute("FLASH_TYPE");
        session.removeAttribute("FLASH_MSG");
        session.removeAttribute("FLASH_TYPE");
    }

    String back = request.getParameter("back");
    String emailParam = request.getParameter("email");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Japan Sport - Đăng nhập tài khoản</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet"/>

    <!-- App CSS -->
    <link href="<%=ctx%>/assets/css/style.css" rel="stylesheet"/>
</head>
<body>
<!-- Banner -->
<div class="topbar section hidden-xs hidden-sm">
    <a class="section block a-center" href="#">
        <img src="<%=ctx%>/assets/images/banner.webp" alt="Siêu bão khuyến mãi cuối năm"
             style="width:100%;height:auto;display:flex;">
    </a>
</div>

<!-- Header + navbar -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<!-- Main Content -->
<main class="bg-light py-5">
    <div class="container">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb justify-content-center">
                <li class="breadcrumb-item"><a href="<%=ctx%>/index.jsp" class="text-decoration-none">Trang chủ</a></li>
                <li class="breadcrumb-item active text-danger" aria-current="page">Đăng nhập tài khoản</li>
            </ol>
        </nav>

        <!-- Title -->
        <div class="text-center mb-5">
            <h2 class="text-danger fw-bold">Đăng nhập tài khoản</h2>
        </div>

        <div class="row justify-content-center g-5">
            <!-- Login -->
            <div class="col-lg-5 col-md-6">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <h4 class="card-title mb-3">ĐĂNG NHẬP TÀI KHOẢN</h4>
                        <p class="text-muted mb-4">Nếu bạn đã có tài khoản, đăng nhập tại đây</p>

                        <% if (msg != null && !msg.isBlank()) { %>
                        <div class="alert <%= "error".equals(msgType) ? "alert-danger" : "alert-success" %>">
                            <%= msg %>
                        </div>
                        <% } %>

                        <!-- FORM: POST tới /login -->
                        <form id="loginForm" method="post" action="<%=ctx%>/login" novalidate>
                            <input type="hidden" name="csrf" value="<%= session.getAttribute("CSRF_TOKEN") %>"/>
                            <% if (back != null && !back.isBlank()) { %>
                            <input type="hidden" name="back" value="<%= esc(back) %>"/>
                            <% } %>

                            <div class="mb-3">
                                <label for="loginEmail" class="form-label">Email <span
                                        class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="loginEmail" name="email"
                                       placeholder="Email" required value="<%= esc(emailParam) %>">
                            </div>
                            <div class="mb-4">
                                <label for="loginPassword" class="form-label">Mật khẩu <span
                                        class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="loginPassword" name="password"
                                       placeholder="Mật khẩu" required>
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="remember" name="remember">
                                <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                            </div>

                            <div class="d-flex gap-3">
                                <button type="submit" class="btn btn-danger px-4">Đăng nhập</button>
                                <%
                                    String error = (String) request.getAttribute("errorMessage");
                                    if (error != null) {
                                %>
                                <p style="color:red; text-align:center;"><%= error %>
                                </p>
                                <%
                                    }
                                %>
                                <a href="<%=ctx%>/register.jsp"
                                   class="btn btn-link text-decoration-none p-0 align-self-center">Đăng ký</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Reset (placeholder) -->
            <div class="col-lg-5 col-md-6">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <p class="text-muted mb-4">Bạn quên mật khẩu? Nhập địa chỉ email để lấy lại mật khẩu qua
                            email.</p>
                        <form method="post" action="<%=ctx%>/forgot">
                            <input type="hidden" name="csrf" value="<%= session.getAttribute("CSRF_TOKEN") %>"/>
                            <div class="mb-4">
                                <label for="resetEmail" class="form-label">Email <span
                                        class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="resetEmail" name="email"
                                       placeholder="Email" required>
                            </div>
                            <button type="submit" class="btn btn-danger px-4">Lấy lại mật khẩu</button>
                        </form>
                    </div>
                </div>
            </div>
        </div> <!-- /row -->
    </div>
</main>

<!-- Features Service  -->

<!-- Footer  -->
<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>


<!-- Back to top -->
<button class="btn btn-danger position-fixed bottom-0 end-0 m-4 rounded-circle"
        style="width:50px;height:50px;z-index:1000;"
        onclick="window.scrollTo({top:0,behavior:'smooth'})"
        title="Lên đầu trang" aria-label="Lên đầu trang">
    <i class="bi bi-arrow-up"></i>
</button>

<!-- App JS nhỏ (KHÔNG chặn submit form) -->
<script>
    // Tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(el => new bootstrap.Tooltip(el));

    // Hiệu ứng focus search
    document.addEventListener('DOMContentLoaded', function () {
        const searchInput = document.querySelector('.search-input');
        if (searchInput) {
            searchInput.addEventListener('focus', function () {
                this.parentElement.style.transform = 'scale(1.02)';
                this.parentElement.style.transition = 'transform 0.2s ease';
            });
            searchInput.addEventListener('blur', function () {
                this.parentElement.style.transform = 'scale(1)';
            });
        }
    });

    // Cart badge
    const STORAGE_KEY = 'cartItems';
    const getCart = () => JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
    const qs = (s, r = document) => r.querySelector(s);

    function updateCartCount() {
        const total = getCart().reduce((s, it) => s + (it.qty || 1), 0);
        const badge = qs('#cartCount');
        if (badge) {
            badge.textContent = total;
            badge.style.display = total > 0 ? 'inline-block' : 'none';
        }
    }

    document.addEventListener('DOMContentLoaded', updateCartCount);
</script>
</body>
</html>
