<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- Nếu chưa login -> đá về login kèm back -->
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp">
        <c:param name="back" value="/change-password"/>
    </c:redirect>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Japan Sport - Đổi mật khẩu</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">

    <!-- App CSS -->
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

<!-- HEADER + navbar -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<!-- MAIN -->
<section class="py-4">
    <div class="container" style="max-width: 960px;">

        <div class="d-flex align-items-center justify-content-between mb-3">
            <h4 class="mb-0">Đổi mật khẩu</h4>
            <a class="btn btn-outline-secondary btn-sm" href="${ctx}/account">Quay lại tài khoản</a>
        </div>

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger">${requestScope.errorMessage}</div>
        </c:if>

        <div class="card shadow-sm">
            <div class="card-body">
                <form method="post" action="${ctx}/change-password" class="row g-3">
                    <input type="hidden" name="csrf" value="${sessionScope.CSRF_TOKEN}"/>

                    <div class="col-12">
                        <label class="form-label">Mật khẩu hiện tại</label>
                        <input type="password" class="form-control" name="old_password" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" name="new_password" minlength="8" required>
                        <div class="form-text">Tối thiểu 8 ký tự.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Xác nhận mật khẩu mới</label>
                        <input type="password" class="form-control" name="confirm_password" minlength="8" required>
                    </div>

                    <div class="col-12 d-flex gap-2 flex-wrap">
                        <button type="submit" class="btn btn-danger">Cập nhật</button>
                        <a href="${ctx}/account" class="btn btn-outline-secondary">Hủy</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</section>

<%-- footer --%>
<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<script>
    const STORAGE_KEY = 'cartItems';
    const getCart = () => JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
    const qs = (sel, root = document) => root.querySelector(sel);

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
