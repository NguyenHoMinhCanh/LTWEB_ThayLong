<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Japan Sport - Đặt lại mật khẩu</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

<!-- Header + navbar -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<!-- Main -->
<section class="py-4">
    <div class="container" style="max-width: 720px;">

        <h4 class="mb-3">Đặt lại mật khẩu</h4>

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger">${requestScope.errorMessage}</div>
        </c:if>

        <div class="card shadow-sm">
            <div class="card-body">
                <form method="post" action="${ctx}/reset-password" class="row g-3">
                    <input type="hidden" name="csrf" value="${sessionScope.CSRF_TOKEN}"/>
                    <input type="hidden" name="token" value="${requestScope.token}"/>

                    <div class="col-12">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" name="new_password" minlength="8" required>
                        <div class="form-text">Tối thiểu 8 ký tự.</div>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Xác nhận mật khẩu mới</label>
                        <input type="password" class="form-control" name="confirm_password" minlength="8" required>
                    </div>

                    <div class="col-12 d-flex gap-2">
                        <button type="submit" class="btn btn-danger">Cập nhật</button>
                        <a href="${ctx}/login.jsp" class="btn btn-outline-secondary">Về đăng nhập</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</section>

<%-- footer --%>
<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

</body>
</html>
