<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Quản lý Banner - Admin");
    request.setAttribute("activePage", "banners");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb mb-0">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
        <li class="breadcrumb-item active">Banner</li>
    </ol>
</nav>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0">Quản lý Banner</h4>
    <button class="btn btn-primary" id="btnAddBanner">
        <i class="bi bi-plus-lg me-1"></i> Thêm banner
    </button>
</div>

<div class="card">
    <div class="card-body">
        <div class="row g-2 align-items-center mb-3">
            <div class="col-md-4">
                <label class="form-label mb-1">Lọc theo Position</label>
                <select class="form-select" id="filterPosition">
                    <option value="">Tất cả</option>
                    <option value="HEADER_TOP">HEADER_TOP (banner trên header tất cả trang)</option>
                    <option value="HOME_TOP">HOME_TOP (banner trên trang chủ)</option>
                    <option value="HOME_MEN">HOME_MEN (banner trái giày nam)</option>
                    <option value="HOME_WOMEN_RIGHT">HOME_WOMEN_RIGHT (banner phải giày nữ)</option>
                    <option value="HOME_WOMEN_BOTTOM">HOME_WOMEN_BOTTOM (banner dưới giày nữ)</option>
                    <option value="SHOP_TOP">SHOP_TOP (banner trang danh sách sản phẩm)</option>
                    <option value="PRODUCT_DETAIL_TOP">PRODUCT_DETAIL_TOP (banner trang chi tiết sản phẩm)</option>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label mb-1">Tìm nhanh</label>
                <input class="form-control" id="keyword" placeholder="Nhập title / link / position..." />
            </div>
            <div class="col-md-4 d-flex align-items-end justify-content-end">
                <button class="btn btn-outline-secondary" id="btnReload">
                    <i class="bi bi-arrow-clockwise me-1"></i> Tải lại
                </button>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table align-middle" id="tblBanners">
                <thead>
                <tr>
                    <th style="width:80px">ID</th>
                    <th style="width:140px">Ảnh</th>
                    <th>Tiêu đề</th>
                    <th style="width:180px">Position</th>
                    <th>Link</th>
                    <th style="width:110px">Hiển thị</th>
                    <th style="width:180px" class="text-end">Thao tác</th>
                </tr>
                </thead>
                <tbody id="bannerTbody">
                <tr>
                    <td colspan="7" class="text-center text-muted py-4">Đang tải...</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: Add/Edit -->
<div class="modal fade" id="bannerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <form id="bannerForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="bannerModalTitle">Thêm banner</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" id="bannerId" name="id" />

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Position</label>
                            <select class="form-select" id="position" name="position" required>
                                <option value="">-- Chọn vị trí --</option>
                                <option value="HEADER_TOP">HEADER_TOP (banner trên header tất cả trang)</option>
                                <option value="HOME_TOP">HOME_TOP (banner trên trang chủ)</option>
                                <option value="HOME_MEN">HOME_MEN (banner trái giày nam)</option>
                                <option value="HOME_WOMEN_RIGHT">HOME_WOMEN_RIGHT (banner phải giày nữ)</option>
                                <option value="HOME_WOMEN_BOTTOM">HOME_WOMEN_BOTTOM (banner dưới giày nữ)</option>
                                <option value="SHOP_TOP">SHOP_TOP (banner trang danh sách sản phẩm)</option>
                                <option value="PRODUCT_DETAIL_TOP">PRODUCT_DETAIL_TOP (banner trang chi tiết sản phẩm)</option>
                            </select>
                            <div class="form-text">Bạn có thể mở rộng thêm position mới (nếu cần) bằng cách sửa dropdown này.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Trạng thái</label>
                            <div class="form-check mt-2">
                                <input class="form-check-input" type="checkbox" id="active" name="active" value="1" checked>
                                <label class="form-check-label" for="active">Hiển thị (active)</label>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Tiêu đề (title)</label>
                            <input class="form-control" id="title" name="title" placeholder="Ví dụ: Sale cuối tuần..." />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Link (click vào banner)</label>
                            <input class="form-control" id="link" name="link" placeholder="Ví dụ: products?gender=M" />
                        </div>

                        <div class="col-md-8">
                            <label class="form-label">Image URL (nếu không upload)</label>
                            <input class="form-control" id="image_url" name="image_url" placeholder="Ví dụ: assets/images/banner.webp hoặc https://..." />
                            <div class="form-text">Nếu bạn upload ảnh thì không cần nhập Image URL.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Upload ảnh</label>
                            <input class="form-control" type="file" id="imageFile" name="imageFile" accept="image/*" />
                        </div>

                        <div class="col-12">
                            <label class="form-label">Preview</label>
                            <div class="border rounded p-2 bg-light">
                                <img id="previewImg" src="" alt="preview" style="max-width: 100%; height: 160px; object-fit: contain;">
                            </div>
                        </div>

                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary" id="btnSaveBanner">
                        <i class="bi bi-save me-1"></i> Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>

<script src="${pageContext.request.contextPath}/admin/banners.js"></script>
