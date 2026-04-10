<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    public static String esc(Object o) {
        if (o == null) return "";
        return String.valueOf(o)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
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

    String csrfToken = esc(session.getAttribute("CSRF_TOKEN"));
    String valName = esc(request.getParameter("name"));
    String valEmail = esc(request.getParameter("email"));
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>JapanSport | Đăng ký</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/style.css">
</head>
<body class="bg-light">

<!-- Banner -->
<div class="topbar section hidden-xs hidden-sm">
    <a class="section block a-center" href="#">
        <img src="<%= ctx %>/assets/images/banner.webp" alt="Siêu bão khuyến mãi cuối năm"
             style="width:100%;height:auto;display:flex;">
    </a>
</div>

<!-- Header + navbar -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<!-- ========== REGISTER CARD ========== -->
<section class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-xl-5">
                <div class="card shadow-sm" style="border-radius:16px;">

                    <div class="card-header bg-white">
                        <div class="d-flex align-items-center">
                            <img src="<%= ctx %>/assets/images/logo.webp" class="logo-header me-2" alt="">
                            <h5 class="mb-0">JapanSport</h5>
                        </div>
                    </div>

                    <div class="card-body p-4">
                        <h4 class="mb-3">Tạo tài khoản</h4>

                        <form id="registerForm" method="post" action="<%= ctx %>/register" novalidate>

                            <input type="hidden" name="csrf" value="<%= csrfToken %>">

                            <!-- Họ tên -->
                            <div class="mb-3">
                                <label for="regName" class="form-label">Họ tên <span
                                        class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="regName" name="name"
                                       placeholder="Nhập họ tên" required value="<%= valName %>">
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <label for="regEmail" class="form-label">Email <span
                                        class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="regEmail" name="email"
                                       placeholder="Nhập email" required value="<%= valEmail %>">
                            </div>

                            <!-- Mật khẩu -->
                            <div class="mb-3">
                                <label for="regPassword" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="regPassword"
                                           name="password" placeholder="Nhập mật khẩu" required>
                                    <button class="btn btn-outline-secondary" type="button" id="togglePwd"
                                            tabindex="-1">
                                        <i class="bi bi-eye" id="iconPwd"></i>
                                    </button>
                                </div>
                                <div id="pwdError" class="form-text text-danger d-none"></div>
                            </div>

                            <!-- Xác nhận mật khẩu -->
                            <div class="mb-4">
                                <label for="regConfirmPassword" class="form-label">Xác nhận mật khẩu <span
                                        class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="regConfirmPassword"
                                           name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                                    <button class="btn btn-outline-secondary" type="button" id="toggleConfirm"
                                            tabindex="-1">
                                        <i class="bi bi-eye" id="iconConfirm"></i>
                                    </button>
                                </div>
                                <div id="confirmError" class="form-text d-none"></div>
                            </div>

                            <button type="submit" id="btnRegister" class="btn btn-danger w-100">Đăng ký</button>

                            <% if (err != null) { %>
                            <div class="alert alert-danger mt-3 mb-0"><%= err %>
                            </div>
                            <% } %>

                            <p class="mt-3 mb-0">
                                Đã có tài khoản?
                                <a href="<%= ctx %>/login" class="text-decoration-none">Đăng nhập</a>
                            </p>

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FOOTER -->
<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const pwd = document.getElementById('regPassword');
    const confirmPwd = document.getElementById('regConfirmPassword');
    const pwdError = document.getElementById('pwdError');
    const confirmError = document.getElementById('confirmError');

    // Toggle ẩn/hiện mật khẩu
    document.getElementById('togglePwd').addEventListener('click', function () {
        var show = pwd.type === 'password';
        pwd.type = show ? 'text' : 'password';
        document.getElementById('iconPwd').className = show ? 'bi bi-eye-slash' : 'bi bi-eye';
    });
    document.getElementById('toggleConfirm').addEventListener('click', function () {
        var show = confirmPwd.type === 'password';
        confirmPwd.type = show ? 'text' : 'password';
        document.getElementById('iconConfirm').className = show ? 'bi bi-eye-slash' : 'bi bi-eye';
    });

    function validatePasswords() {
        var pwVal = pwd.value;
        var cfVal = confirmPwd.value;
        var ok = true;

        // Kiểm tra độ dài mật khẩu
        if (pwVal.length > 0 && pwVal.length < 8) {
            pwdError.textContent = 'Mật khẩu phải có ít nhất 8 ký tự.';
            pwdError.classList.remove('d-none');
            pwd.classList.add('is-invalid');
            pwd.classList.remove('is-valid');
            ok = false;
        } else if (pwVal.length >= 8) {
            pwdError.classList.add('d-none');
            pwd.classList.remove('is-invalid');
            pwd.classList.add('is-valid');
        } else {
            pwdError.classList.add('d-none');
            pwd.classList.remove('is-invalid', 'is-valid');
        }

        // Kiểm tra xác nhận mật khẩu
        if (cfVal.length === 0) {
            confirmError.classList.add('d-none');
            confirmPwd.classList.remove('is-invalid', 'is-valid');
        } else if (cfVal !== pwVal) {
            confirmError.textContent = 'Mật khẩu xác nhận không khớp.';
            confirmError.className = 'form-text text-danger';
            confirmPwd.classList.add('is-invalid');
            confirmPwd.classList.remove('is-valid');
            ok = false;
        } else {
            confirmError.textContent = 'Mật khẩu khớp!';
            confirmError.className = 'form-text text-success';
            confirmPwd.classList.remove('is-invalid');
            confirmPwd.classList.add('is-valid');
        }

        return ok;
    }

    pwd.addEventListener('input', validatePasswords);
    confirmPwd.addEventListener('input', validatePasswords);

    document.getElementById('registerForm').addEventListener('submit', function (e) {
        var isValid = validatePasswords();
        if (!isValid || confirmPwd.value !== pwd.value) {
            e.preventDefault();
            if (confirmPwd.value === '') {
                confirmError.textContent = 'Vui lòng nhập xác nhận mật khẩu.';
                confirmError.className = 'form-text text-danger';
                confirmPwd.classList.add('is-invalid');
            }
        }
    });
</script>
</body>
</html>