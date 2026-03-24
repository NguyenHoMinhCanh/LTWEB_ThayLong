<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%
    request.setAttribute("pageTitle", "Thêm/Sửa Thương hiệu - Admin");
    request.setAttribute("activePage", "brands");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<style>
    .logo-preview {
        width: 120px;
        height: 120px;
        border: 2px dashed #dee2e6;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #f8f9fa;
        margin-bottom: 15px;
        position: relative;
        overflow: hidden;
    }

    .logo-preview img {
        width: 100%;
        height: 100%;
        object-fit: contain;
        background-color: white;
        padding: 10px;
    }

    .logo-preview .placeholder {
        color: #6c757d;
        text-align: center;
    }

    .required-field::after {
        content: " *";
        color: #dc3545;
    }
</style>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="h3 mb-0">${pageTitle}</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${ctx}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${ctx}/admin/brands?action=list">Thương hiệu</a></li>
                    <li class="breadcrumb-item active">${brand != null ? 'Chỉnh sửa' : 'Thêm mới'}</li>
                </ol>
            </nav>
        </div>
        <a href="${ctx}/admin/brands?action=list" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Quay lại
        </a>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">
                        <i class="bi bi-award me-2 text-primary"></i>
                        ${brand != null ? 'Thông tin thương hiệu' : 'Tạo thương hiệu mới'}
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${ctx}/admin/brands" id="brandForm">
                        <input type="hidden" name="action" value="${brand != null ? 'update' : 'create'}">
                        <c:if test="${brand != null}">
                            <input type="hidden" name="id" value="${brand.id}">
                        </c:if>

                        <div class="mb-3">
                            <label for="name" class="form-label required-field">Tên thương hiệu</label>
                            <input type="text" class="form-control" id="name" name="name"
                                   value="${brand != null ? brand.name : ''}" required>
                            <div class="form-text">Tên hiển thị của thương hiệu</div>
                        </div>

                        <div class="mb-3">
                            <label for="slug" class="form-label">Slug</label>
                            <input type="text" class="form-control" id="slug" name="slug"
                                   value="${brand != null ? brand.slug : ''}">
                            <div class="form-text">URL-friendly name (tự động tạo nếu để trống)</div>
                        </div>

                        <div class="mb-3">
                            <label for="logoUrl" class="form-label">Logo URL</label>
                            <input type="url" class="form-control" id="logoUrl" name="logoUrl"
                                   value="${brand != null ? brand.logoUrl : ''}"
                                   placeholder="https://example.com/logo.png">
                            <div class="form-text">Link ảnh logo thương hiệu</div>
                        </div>

                        <div class="mb-4 form-check">
                            <input class="form-check-input" type="checkbox" id="active" name="active" value="1"
                            ${brand == null || brand.active ? 'checked' : ''}>
                            <label class="form-check-label" for="active">
                                Hiển thị (Active)
                            </label>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${ctx}/admin/brands?action=list" class="btn btn-outline-secondary">
                                Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save me-1"></i>
                                ${brand != null ? 'Cập nhật' : 'Tạo mới'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h6 class="mb-0">Preview Logo</h6>
                </div>
                <div class="card-body text-center">
                    <div class="logo-preview mx-auto" id="logoPreview">
                        <c:choose>
                            <c:when test="${brand != null && not empty brand.logoUrl}">
                                <img src="${brand.logoUrl}" alt="Logo Preview" id="previewImg">
                            </c:when>
                            <c:otherwise>
                                <div class="placeholder">
                                    <i class="bi bi-image fs-1 d-block mb-2"></i>
                                    <small>Chưa có logo</small>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <small class="text-muted">Logo sẽ hiển thị như thế này trên website</small>
                </div>
            </div>

            <div class="card shadow-sm mt-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0">Tips</h6>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2"><i class="bi bi-check-circle text-success me-2"></i>Sử dụng logo nền trong suốt
                        </li>
                        <li class="mb-2"><i class="bi bi-check-circle text-success me-2"></i>Kích thước đề xuất:
                            200x200px
                        </li>
                        <li class="mb-0"><i class="bi bi-check-circle text-success me-2"></i>Định dạng: PNG, JPG</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const logoUrlInput = document.getElementById('logoUrl');
        const logoPreview = document.getElementById('logoPreview');

        function updateLogoPreview(url) {
            if (url && url.trim()) {
                logoPreview.innerHTML = '<img src="' + url + '" alt="Logo Preview" id="previewImg">';
                const img = logoPreview.querySelector('img');
                img.onerror = function () {
                    logoPreview.innerHTML = '<div class="placeholder"><i class="bi bi-image fs-1 d-block mb-2"></i><small>Link logo không hợp lệ</small></div>';
                };
            } else {
                logoPreview.innerHTML = '<div class="placeholder"><i class="bi bi-image fs-1 d-block mb-2"></i><small>Chưa có logo</small></div>';
            }
        }

        logoUrlInput.addEventListener('input', function () {
            updateLogoPreview(this.value);
        });

        // Auto-generate slug from name
        const nameInput = document.getElementById('name');
        const slugInput = document.getElementById('slug');

        nameInput.addEventListener('input', function () {
            if (!slugInput.value.trim()) {
                const slug = this.value
                    .toLowerCase()
                    .normalize('NFD').replace(/[\u0300-\u036f]/g, '') // Remove accents
                    .replace(/đ/g, 'd')
                    .replace(/[^a-z0-9\s-]/g, '') // Remove special chars
                    .trim()
                    .replace(/\s+/g, '-') // Replace spaces with -
                    .replace(/-+/g, '-'); // Replace multiple - with single -
                slugInput.value = slug;
            }
        });
    });
</script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
