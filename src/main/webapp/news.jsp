<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tin tức</title>

    <!-- Bootstrap & Icons (để layout header/footer không bị vỡ) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">

    <!-- App CSS -->
    <link rel="stylesheet" href="${ctx}/assets/css/style.css">
    <style>
        .news-container { max-width: 1100px; margin: 24px auto; padding: 0 12px; }
        .news-grid { display: grid; grid-template-columns: 1fr 320px; gap: 18px; }
        .news-card { background: #fff; border: 1px solid #eee; border-radius: 10px; padding: 14px; margin-bottom: 12px; }
        .news-card h3 { margin: 0 0 6px 0; }
        .news-card p { margin: 0; color: #555; }
        .side-box { background: #fff; border: 1px solid #eee; border-radius: 10px; padding: 14px; }
        .cat-link { display:block; padding:6px 0; color:#222; text-decoration:none; }
        .cat-link:hover { text-decoration: underline; }
        .thumb { width:100%; max-height:180px; object-fit:cover; border-radius:8px; margin-bottom:10px; }
        .meta { font-size: 13px; color:#777; margin-top:6px; }
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

<div class="news-container">
    <h1>Tin tức</h1>

    <div class="news-grid">
        <!-- LEFT: LIST -->
        <div>
            <form method="get" action="${ctx}/news" style="display:flex; gap:8px; margin-bottom:12px;">
                <input type="hidden" name="categoryId" value="${categoryId}">
                <input name="q" value="${q}" placeholder="Tìm bài viết..." style="flex:1; padding:10px; border:1px solid #ddd; border-radius:8px;">
                <button style="padding:10px 14px; border:1px solid #ddd; border-radius:8px; background:#f7f7f7;">Tìm</button>
            </form>

            <c:forEach var="n" items="${newsList}">
                <div class="news-card">
                    <c:if test="${not empty n.thumbnailUrl}">
                        <img class="thumb" src="${n.thumbnailUrl}" alt="${n.title}">
                    </c:if>

                    <h3>
                        <a href="${ctx}/news-detail?slug=${n.slug}" style="text-decoration:none; color:#111;">
                                ${n.title}
                        </a>
                    </h3>

                    <c:if test="${not empty n.summary}">
                        <p>${n.summary}</p>
                    </c:if>

                    <div class="meta">
                        <span>View: ${n.viewCount}</span>
                        <span style="margin-left:10px;">${n.createdAt}</span>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty newsList}">
                <div class="news-card">
                    <div style="color:#777;">Chưa có bài viết.</div>
                </div>
            </c:if>

            <!-- pagination đơn giản -->
            <div style="display:flex; gap:10px; margin-top:12px;">
                <c:if test="${page > 1}">
                    <a href="${ctx}/news?page=${page-1}&categoryId=${categoryId}&q=${q}">← Trang trước</a>
                </c:if>
                <a href="${ctx}/news?page=${page+1}&categoryId=${categoryId}&q=${q}">Trang sau →</a>
            </div>
        </div>

        <!-- RIGHT: CATEGORIES -->
        <div>
            <div class="side-box">
                <h3 style="margin-top:0;">Danh mục tin tức</h3>

                <a class="cat-link" href="${ctx}/news">Tất cả</a>
                <c:forEach var="c" items="${categories}">
                    <a class="cat-link" href="${ctx}/news?categoryId=${c.id}">
                            ${c.name}
                    </a>
                </c:forEach>

                <c:if test="${empty categories}">
                    <div style="color:#777;">Chưa có danh mục tin tức.</div>
                </c:if>
            </div>
        </div>

    </div>
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
