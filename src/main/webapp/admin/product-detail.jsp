<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.japansport.model.Product" %>
<%
    Product p = (Product) request.getAttribute("product");
    request.setAttribute("pageTitle", "Chi tiết sản phẩm - Admin");
    request.setAttribute("activePage", "products");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb mb-0">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a></li>
        <li class="breadcrumb-item active">Chi tiết</li>
    </ol>
</nav>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
    <div>
        <h4 class="mb-1">Quản trị chi tiết sản phẩm</h4>
        <div class="text-muted">
            <span class="me-2">ID: <b><%= p.getId() %></b></span>
            <span>Tên: <b><%= p.getName() %></b></span>
        </div>
    </div>
    <div class="d-flex gap-2">
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/products">
            <i class="bi bi-arrow-left"></i> Quay lại
        </a>
        <a class="btn btn-outline-primary" target="_blank" href="${pageContext.request.contextPath}/product-detail?id=<%= p.getId() %>">
            <i class="bi bi-box-arrow-up-right"></i> Xem trang shop
        </a>
    </div>
</div>

<ul class="nav nav-tabs" id="pdTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="tab-variants" data-bs-toggle="tab" data-bs-target="#pane-variants" type="button" role="tab">
            <i class="bi bi-grid-3x3-gap me-1"></i>Biến thể (size/màu/kho)
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="tab-images" data-bs-toggle="tab" data-bs-target="#pane-images" type="button" role="tab">
            <i class="bi bi-images me-1"></i>Gallery ảnh
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="tab-specs" data-bs-toggle="tab" data-bs-target="#pane-specs" type="button" role="tab">
            <i class="bi bi-card-checklist me-1"></i>Thông số (specs)
        </button>
    </li>
</ul>

<div class="tab-content border border-top-0 rounded-bottom p-3 bg-white">

    <!-- VARIANTS -->
    <div class="tab-pane fade show active" id="pane-variants" role="tabpanel">
        <div class="row g-3">
            <div class="col-12 col-xl-4">
                <div class="card">
                    <div class="card-header fw-semibold">Thêm / Cập nhật biến thể</div>
                    <div class="card-body">
                        <form id="formVariant">
                            <input type="hidden" name="id" id="variantId">
                            <div class="mb-2">
                                <label class="form-label">Màu <span class="text-danger">*</span></label>
                                <input class="form-control" name="color" id="variantColor" placeholder="VD: Black" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Size <span class="text-danger">*</span></label>
                                <input class="form-control" name="size" id="variantSize" placeholder="VD: 40" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Tồn kho</label>
                                <input type="number" class="form-control" name="stock_qty" id="variantStock" value="0" min="0">
                            </div>
                            <div class="mb-2">
                                <label class="form-label">SKU</label>
                                <input class="form-control" name="sku" id="variantSku" placeholder="VD: P1-BLK-40">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá riêng (nếu khác giá chung)</label>
                                <input type="number" class="form-control" name="price" id="variantPrice" placeholder="Để trống = dùng giá sản phẩm">
                            </div>

                            <div class="d-flex gap-2">
                                <button class="btn btn-primary" type="submit" id="btnVariantSave">
                                    <i class="bi bi-save me-1"></i>Lưu
                                </button>
                                <button class="btn btn-outline-secondary" type="button" id="btnVariantReset">Làm mới</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-12 col-xl-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Danh sách biến thể</span>
                        <button class="btn btn-sm btn-outline-secondary" id="btnReloadVariants">
                            <i class="bi bi-arrow-clockwise"></i>
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="tblVariants">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Màu</th>
                                <th>Size</th>
                                <th>Kho</th>
                                <th>SKU</th>
                                <th>Giá riêng</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="text-muted small mt-2">
                    Lưu ý: bảng <code>product_variants</code> có unique (product_id + color + size). Nếu trùng sẽ báo lỗi.
                </div>
            </div>
        </div>
    </div>

    <!-- IMAGES -->
    <div class="tab-pane fade" id="pane-images" role="tabpanel">
        <div class="row g-3">
            <div class="col-12 col-xl-4">
                <div class="card">
                    <div class="card-header fw-semibold">Thêm / Cập nhật ảnh</div>
                    <div class="card-body">
                        <form id="formImage">
                            <input type="hidden" name="id" id="imageId">
                            <div class="mb-2">
                                <label class="form-label">Image URL <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" name="image_url" id="imageUrl" placeholder="Nhập URL hoặc chọn file bên dưới">
                                    <button class="btn btn-outline-secondary" type="button" id="btnPickFile" title="Chọn ảnh từ máy tính">
                                        <i class="bi bi-folder2-open me-1"></i>Chọn ảnh
                                    </button>
                                </div>
                                <input type="file" id="imageFileInput" accept="image/*" style="display:none;">
                                <div id="uploadProgress" class="mt-1" style="display:none;">
                                    <div class="d-flex align-items-center gap-2 text-muted small">
                                        <div class="spinner-border spinner-border-sm" role="status"></div>
                                        <span>Đang tải ảnh lên server...</span>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Alt</label>
                                <input class="form-control" name="alt" id="imageAlt">
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Màu (để gắn ảnh theo màu)</label>
                                <input class="form-control" name="color" id="imageColor" placeholder="VD: Black (có thể để trống)">
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Sort order</label>
                                <input type="number" class="form-control" name="sort_order" id="imageSort" value="0">
                            </div>
                            <div class="mb-2 form-check">
                                <input class="form-check-input" type="checkbox" id="imageActive" checked>
                                <label class="form-check-label" for="imageActive">Active</label>
                            </div>
                            <div class="mb-3 form-check">
                                <input class="form-check-input" type="checkbox" id="imageMain">
                                <label class="form-check-label" for="imageMain">Đặt làm ảnh chính (main) của nhóm màu này</label>
                            </div>

                            <div class="d-flex gap-2">
                                <button class="btn btn-primary" type="submit" id="btnImageSave">
                                    <i class="bi bi-save me-1"></i>Lưu
                                </button>
                                <button class="btn btn-outline-secondary" type="button" id="btnImageReset">Làm mới</button>
                            </div>
                        </form>

                        <div class="mt-3" id="imagePreviewWrap" style="display:none;">
                            <div class="fw-semibold mb-1">Preview</div>
                            <img id="imagePreview" src="" alt="" style="max-width:100%;border-radius:10px;">
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-xl-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Danh sách ảnh</span>
                        <button class="btn btn-sm btn-outline-secondary" id="btnReloadImages">
                            <i class="bi bi-arrow-clockwise"></i>
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="tblImages">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Ảnh</th>
                                <th>Màu</th>
                                <th>Main</th>
                                <th>Order</th>
                                <th>Active</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="text-muted small mt-2">
                    Tip: ảnh main được set theo <b>nhóm màu</b> (color). Nếu color trống thì thuộc nhóm NULL.
                </div>
            </div>
        </div>
    </div>

    <!-- SPECS -->
    <div class="tab-pane fade" id="pane-specs" role="tabpanel">
        <div class="row g-3">
            <div class="col-12 col-xl-4">
                <div class="card">
                    <div class="card-header fw-semibold">Thêm / Cập nhật spec</div>
                    <div class="card-body">
                        <form id="formSpec">
                            <input type="hidden" name="id" id="specId">
                            <div class="mb-2">
                                <label class="form-label">Tên thông số (key) <span class="text-danger">*</span></label>
                                <input class="form-control" name="spec_key" id="specKey" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Giá trị (value) <span class="text-danger">*</span></label>
                                <input class="form-control" name="spec_value" id="specValue" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Sort order</label>
                                <input type="number" class="form-control" name="sort_order" id="specSort" value="0">
                            </div>
                            <div class="d-flex gap-2">
                                <button class="btn btn-primary" type="submit" id="btnSpecSave">
                                    <i class="bi bi-save me-1"></i>Lưu
                                </button>
                                <button class="btn btn-outline-secondary" type="button" id="btnSpecReset">Làm mới</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-12 col-xl-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Danh sách specs</span>
                        <button class="btn btn-sm btn-outline-secondary" id="btnReloadSpecs">
                            <i class="bi bi-arrow-clockwise"></i>
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="tblSpecs">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Key</th>
                                <th>Value</th>
                                <th>Order</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
    const CTX = '${pageContext.request.contextPath}';
    const PRODUCT_ID = <%= (p != null ? p.getId() : 0) %>;
</script>

<script src="${pageContext.request.contextPath}/admin/product-detail.js"></script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
