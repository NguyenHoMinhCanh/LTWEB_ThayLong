<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${news.title}</title>

    <!-- Bootstrap & Icons (để layout header/footer không bị vỡ) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${ctx}/assets/css/style.css">
    <style>
        .wrap { max-width: 900px; margin: 24px auto; padding: 0 12px; }
        .thumb { width:100%; max-height:320px; object-fit:cover; border-radius:12px; margin: 12px 0; }
        .meta { color:#777; font-size:13px; margin-top:6px; }
        .content { line-height:1.7; margin-top:16px;  }
    </style>
</head>
<body>
<!-- Banner quảng cáo -->
<div class="topbar section hidden-xs hidden-sm">
    <a class="section block a-center" href="#">
        <img src="${ctx}/assets/images/banner.webp" alt="Siêu bão khuyến mãi cuối năm"
             style="width:100%;height:auto;display:flex;">
    </a>
</div>

<!-- HEADER + navbar -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<div class="wrap">
    <a href="${ctx}/news">← Quay lại Tin tức</a>

    <h1 style="margin-bottom:6px;">${news.title}</h1>
    <div class="meta">
        <span>View: ${news.viewCount}</span>
        <c:if test="${not empty news.author}">
            <span style="margin-left:10px;">Tác giả: ${news.author}</span>
        </c:if>
        <span style="margin-left:10px;">${news.createdAt}</span>
    </div>

    <c:if test="${not empty news.thumbnailUrl}">
        <img class="thumb" src="${news.thumbnailUrl}" alt="${news.title}">
    </c:if>

    <c:if test="${not empty news.summary}">
        <p style="color:#444; font-size:16px;"><b>${news.summary}</b></p>
    </c:if>

    <div class="content"><c:out value="${news.content}" escapeXml="false"/></div>
</div>

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
