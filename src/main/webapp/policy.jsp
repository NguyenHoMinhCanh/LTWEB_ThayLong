<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${policy.title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<!-- ===== Header + navbar===== -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<div class="container" style="max-width: 900px; margin: 30px auto;">
    <h1 style="margin-bottom: 16px;">${policy.title}</h1>
    <div style="line-height: 1.7; white-space: pre-wrap;">
        <c:out value="${policy.content}" escapeXml="false" />
    </div>
</div>

<!-- ===== Footer ===== -->
<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<button class="btn btn-danger position-fixed bottom-0 end-0 m-4 rounded-circle"
        style="width:50px;height:50px;z-index:1000;"
        onclick="window.scrollTo({top:0,behavior:'smooth'})" title="Lên đầu trang" aria-label="Lên đầu trang">
    <i class="bi bi-arrow-up"></i>
</button>

<script>
    /* Tooltips */
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(el => new bootstrap.Tooltip(el));

    /*Hiệu ứng focus search*/
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

</script>
</body>
</html>
