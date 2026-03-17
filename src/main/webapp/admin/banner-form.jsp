<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%
    request.setAttribute("pageTitle", "Banner Form - Admin");
    request.setAttribute("activePage", "banners");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<style>
    .bn-preview {
        width: 100%;
        max-width: 720px;
        height: 220px;
        object-fit: cover;
        border-radius: 16px;
        border: 1px solid rgba(0,0,0,.08);
        background: #fff;
    }
</style>

<c:set var="isEdit" value="${not empty banner}"/>
<c:set var="formAction" value="${isEdit ? 'update' : 'create'}"/>

<div class="d-flex align-items-center justify-content-between mb-3">
    <div>
        <h4 class="mb-1">${isEdit ? "Sửa banner" : "Thêm banner"}</h4>
        <div class="text-muted small">Upload ảnh hoặc nhập đường dẫn ảnh (assets/... hoặc uploads/...)</div>
    </div>

    <a class="btn btn-outline-dark" href="${ctx}/admin/banners">
        <i class="bi bi-arrow-left me-1"></i>Quay lại
    </a>
</div>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        Có lỗi: <b>${param.error}</b>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="card shadow-sm border-0">
    <div class="card-body">

        <form method="post" action="${ctx}/admin/banners" enctype="multipart/form-data" class="row g-3">
            <input type="hidden" name="action" value="${formAction}"/>
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${banner.id}"/>
            </c:if>

            <div class="col-12 col-lg-6">
                <label class="form-label">Tiêu đề</label>
                <input class="form-control" name="title" value="${isEdit ? banner.title : ''}" placeholder="VD: Siêu sale cuối năm"/>
            </div>

            <div class="col-12 col-lg-6">
                <label class="form-label">Link (khi bấm vào banner)</label>
                <input class="form-control" name="link" value="${isEdit ? banner.link : ''}" placeholder="VD: products?sale=1"/>
                <div class="form-text">Có thể để trống nếu banner.</div>
            </div>

            <div class="col-12 col-lg-4">
                <label class="form-label">Vị trí</label>
                <select class="form-select" name="position" required>
                    <option value="" disabled ${isEdit ? "" : "selected"}>-- Chọn vị trí --</option>
                    <c:forEach var="p" items="${positions}">
                        <option value="${p}" <c:if test="${isEdit && p == banner.position}">selected</c:if>>${p}</option>
                    </c:forEach>
                </select>
                <div class="form-text">
                    HOME_TOP: banner top. SHOP_TOP: banner trang products.jsp.
                </div>
            </div>

            <div class="col-12 col-lg-2 d-flex align-items-end">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="active" id="active"
                           <c:if test="${!isEdit || banner.active == 1}">checked</c:if>>
                    <label class="form-check-label" for="active">ACTIVE</label>
                </div>
            </div>

            <div class="col-12 col-lg-6">
                <label class="form-label">Image URL (tùy chọn)</label>
                <input class="form-control" name="image_url" id="image_url"
                       value="${isEdit ? banner.image_url : ''}"
                       placeholder="VD: assets/images/banner.webp hoặc uploads/banners/..."/>
                <div class="form-text">
                </div>
            </div>

            <div class="col-12 col-lg-6">
                <label class="form-label">Upload ảnh banner (tùy chọn)</label>
                <input class="form-control" type="file" name="imageFile" id="imageFile" accept="image/*"/>
                <div class="form-text">Dung lượng tối đa: 10MB.</div>
            </div>

            <div class="col-12">
                <label class="form-label">Preview</label>
                <c:choose>
                    <c:when test="${isEdit}">
                        <c:choose>
                            <c:when test="${fn:startsWith(banner.image_url, 'http')}">
                                <img id="previewImg" class="bn-preview" src="${banner.image_url}" alt="preview"/>
                            </c:when>
                            <c:otherwise>
                                <img id="previewImg" class="bn-preview" src="${ctx}/${banner.image_url}" alt="preview"/>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <img id="previewImg" class="bn-preview" src="${ctx}/assets/images/banner.webp" alt="preview"/>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="col-12 d-flex gap-2">
                <button class="btn btn-primary" type="submit">
                    <i class="bi bi-save me-1"></i>${isEdit ? "Cập nhật" : "Tạo mới"}
                </button>
                <a class="btn btn-outline-secondary" href="${ctx}/admin/banners">Hủy</a>
            </div>
        </form>

    </div>
</div>

<script>
    const fileInput = document.getElementById('imageFile');
    const urlInput = document.getElementById('image_url');
    const previewImg = document.getElementById('previewImg');

    if (fileInput) {
        fileInput.addEventListener('change', function () {
            const f = this.files && this.files[0];
            if (!f) return;
            const reader = new FileReader();
            reader.onload = function (e) {
                previewImg.src = e.target.result;
            };
            reader.readAsDataURL(f);
        });
    }

    if (urlInput) {
        urlInput.addEventListener('blur', function () {
            if (fileInput && fileInput.files && fileInput.files.length > 0) return;
            const v = (this.value || '').trim();
            if (!v) return;

            // Nếu user nhập đường dẫn tương đối (assets/..., uploads/...) -> thêm ctx
            if (v.startsWith('http://') || v.startsWith('https://')) {
                previewImg.src = v;
            } else {
                previewImg.src = '${ctx}/' + v.replace(/^\/+/, '');
            }
        });
    }
</script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
