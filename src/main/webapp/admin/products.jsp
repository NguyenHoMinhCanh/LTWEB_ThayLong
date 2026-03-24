<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<%
    request.setAttribute("pageTitle", "Quản lý Sản phẩm - Admin");
    request.setAttribute("activePage", "products");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb mb-0">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
        <li class="breadcrumb-item active">Sản phẩm</li>
    </ol>
</nav>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0">Quản lý Sản phẩm</h4>
    <button class="btn btn-primary" id="btnAdd">
        <i class="bi bi-plus-lg me-1"></i> Thêm sản phẩm
    </button>
</div>

<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table align-middle" id="tblProducts">
                <thead>
                <tr>
                    <th style="width:80px">ID</th>
                    <th>Ảnh</th>
                    <th>Tên</th>
                    <th>Danh mục</th>
                    <th>Thương hiệu</th>
                    <th>Giá</th>
                    <th>Giá cũ</th>
                    <th>Giới tính</th>
                    <th>Hiển thị</th>
                    <th style="width:220px" class="text-end">Thao tác</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<!-- MODAL ADD/EDIT -->
<div class="modal fade" id="modalProduct" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="formProduct">
            <div class="modal-header">
                <h5 id="modalTitle">Thêm sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="productId">
                <input type="hidden" name="action" id="formAction" value="add">

                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="name" id="productName" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Giá <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="price" id="productPrice" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Giá cũ</label>
                        <input type="number" class="form-control" name="old_price" id="productOldPrice">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" name="category_id" id="productCategory"></select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Thương hiệu</label>
                        <select class="form-select" name="brand_id" id="productBrand"></select>
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Giới tính</label>
                    <input type="text" class="form-control" name="gender" id="productGender" placeholder="men / women / unisex">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Hiển thị</label>
                    <select class="form-select" name="active" id="productActive">
                        <option value="1">Hiển thị</option>
                        <option value="0">Ẩn</option>
                    </select>
                </div>

                <div class="col-md-12">
                    <label class="form-label">Ảnh đại diện (URL)</label>
                    <input type="text" class="form-control" name="image_url" id="productImage">
                    <div class="mt-2" id="imagePreview" style="display:none;">
                        <img id="previewImg" alt="" style="max-height:120px;border-radius:10px;object-fit:cover;">
                    </div>
                </div>

                <div class="col-md-12">
                    <label class="form-label">Mô tả</label>
                    <textarea class="form-control" rows="4" name="description" id="productDescription"></textarea>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status" id="status">
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>

                <div class="col-md-6 d-flex align-items-end">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="featured" name="featured">
                        <label class="form-check-label" for="featured">Nổi bật</label>
                    </div>
                </div>
            </div>
    </div>

    <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
        <button type="submit" class="btn btn-primary">Lưu</button>
    </div>
    </form>
</div>
</div>

<script>
    const CTX = '${pageContext.request.contextPath}';
</script>

<script src="${pageContext.request.contextPath}/admin/products.js"></script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
