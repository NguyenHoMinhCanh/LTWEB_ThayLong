<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Quản lý Danh mục - Admin");
    request.setAttribute("activePage", "categories");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb mb-0">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
        <li class="breadcrumb-item active">Danh mục</li>
    </ol>
</nav>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0">Quản lý Danh mục</h4>
    <button class="btn btn-primary" id="btnAddCategory">
        <i class="bi bi-plus-lg me-1"></i>Thêm danh mục
    </button>
</div>

<div class="card">
    <div class="card-body">
        <div class="d-flex justify-content-end mb-3">
            <div class="input-group" style="max-width: 360px;">
                <span class="input-group-text"><i class="bi bi-search"></i></span>
                <input type="text" class="form-control" id="searchInput" placeholder="Tìm theo tên / slug...">
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle" id="tblCategories">
                <thead>
                <tr>
                    <th style="width: 80px">ID</th>
                    <th>Tên danh mục</th>
                    <th style="width: 220px">Slug</th>
                    <th style="width: 120px">Ảnh</th>
                    <th style="width: 100px">Thứ tự</th>
                    <th style="width: 120px">Trạng thái</th>
                    <th style="width: 140px" class="text-end">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <!-- JS load -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Form -->
<div class="modal fade" id="modalCategory" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="formCategory">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Thêm danh mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="categoryId" name="id">
                <input type="hidden" id="formAction" name="action" value="create">

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="categoryName" name="name" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Slug</label>
                        <input type="text" class="form-control" id="categorySlug" name="slug" placeholder="Tự tạo nếu để trống">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Danh mục cha</label>
                        <select class="form-select" id="categoryParent" name="parent_id">
                            <option value="">-- Không có (Danh mục gốc) --</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" id="categoryActive" name="active">
                            <option value="1">Hiển thị</option>
                            <option value="0">Ẩn</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Ảnh (image_url)</label>
                        <input type="text" class="form-control" id="categoryImage" name="image_url" placeholder="https://...">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Link (tùy chọn)</label>
                        <input type="text" class="form-control" id="categoryLink" name="link" placeholder="/list-product?categoryId=...">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Thứ tự hiển thị (display_order)</label>
                        <input type="number" class="form-control" id="categoryOrder" name="display_order" value="0" min="0">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label d-block">Nổi bật (hiển thị ở 3 khối dưới banner)</label>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox"
                                   id="categoryFeatured" name="is_featured" value="1">
                            <label class="form-check-label" for="categoryFeatured">
                                Bật để đưa danh mục lên trang chủ
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-save me-1"></i>Lưu
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    const CTX = '${pageContext.request.contextPath}';
</script>

<script src="${pageContext.request.contextPath}/admin/categories.js"></script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
