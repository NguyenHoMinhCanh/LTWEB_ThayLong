<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp">
        <c:param name="back" value="/account"/>
    </c:redirect>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tài khoản của tôi</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/assets/css/style.css" />

    <style>
        /* ===== Sidebar giống layout /orders ===== */
        .acc-side{ border-radius: 18px; box-shadow: 0 8px 18px rgba(0,0,0,.08); overflow: hidden; background: #fff; }
        .acc-side__head{ background:#1f2937; color:#fff; padding:16px; }
        .acc-side__title{ font-weight:700; }
        .acc-side__sub{ font-size: 12px; opacity:.8; }

        /* Avatar: chỉ làm to lên + click upload */
        .acc-avatar-wrap{
            width: 64px; height: 64px; border-radius: 50%;
            overflow:hidden; position:relative; flex:0 0 auto;
            cursor:pointer; background: rgba(255,255,255,.12);
            border: 2px solid rgba(255,255,255,.35);
        }
        .acc-avatar-img{ width:100%; height:100%; object-fit:cover; display:block; }
        .acc-avatar-fallback{
            width:100%; height:100%; display:grid; place-items:center;
            font-weight:800; font-size:22px; color:#fff; background:#374151;
        }
        .acc-avatar-edit{
            position:absolute; right:3px; bottom:3px;
            width:22px; height:22px; border-radius:50%;
            display:grid; place-items:center;
            background:#fff; border:1px solid rgba(0,0,0,.08);
            box-shadow: 0 6px 14px rgba(0,0,0,.16);
            font-size: 12px; color:#111827;
        }
        .acc-avatar-wrap input[type="file"]{ display:none; }

        /* Menu items giống /orders (active nền hồng nhạt + icon đỏ) */
        .acc-menu{ padding: 10px; }
        .acc-menu a{
            display:flex; align-items:center; gap:10px;
            padding: 10px 12px;
            border-radius: 12px;
            text-decoration:none;
            color:#111827;
        }
        .acc-menu a i{ color:#ef4444; }
        .acc-menu a:hover{ background:#f8fafc; }
        .acc-menu a.active{
            background:#ffecec;
            border: 1px solid rgba(239,68,68,.22);
        }
        .acc-note{
            padding: 0 14px 14px;
            color:#6b7280;
            font-size: 12px;
        }

        /* ===== Main cards ===== */
        .acc-card{ border-radius: 18px; box-shadow: 0 8px 18px rgba(0,0,0,.06); }
        .acc-soft{ background:#f3f4f6; }

        /* (Bạn đã bảo bỏ 3 ô trên, nên không có CSS cho phần đó nữa) */
    </style>
</head>

<body>

<!-- HEADER/NAVBAR dùng chung -->
<%@ include file="/WEB-INF/jspf/site_header.jspf" %>

<section class="py-4">
    <div class="container">

        <!-- Flash / Error -->
        <c:if test="${not empty sessionScope.FLASH_MSG}">
            <c:set var="t" value="${sessionScope.FLASH_TYPE}" />
            <div class="alert
                 ${t == 'success' ? 'alert-success' :
                   t == 'warning' ? 'alert-warning' :
                   t == 'info' ? 'alert-info' : 'alert-danger'}">
                    ${sessionScope.FLASH_MSG}
            </div>
            <c:remove var="FLASH_MSG" scope="session"/>
            <c:remove var="FLASH_TYPE" scope="session"/>
        </c:if>

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger">${requestScope.errorMessage}</div>
        </c:if>

        <div class="row g-4">
            <!-- ===== LEFT SIDEBAR (GIỐNG /orders) ===== -->
            <div class="col-lg-3">
                <div class="acc-side">
                    <div class="acc-side__head">
                        <div class="d-flex align-items-center gap-3">
                            <!-- Avatar upload -->
                            <form action="${ctx}/account/avatar" method="post" enctype="multipart/form-data" class="m-0">
                                <input type="hidden" name="csrf" value="${sessionScope.CSRF_TOKEN}"/>
                                <label class="acc-avatar-wrap" title="Bấm để đổi avatar">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.currentUser.avatar}">
                                            <img class="acc-avatar-img" src="${ctx}/${sessionScope.currentUser.avatar}" alt="avatar"/>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="acc-avatar-fallback">
                                                    ${fn:substring(sessionScope.currentUser.name, 0, 1)}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="acc-avatar-edit"><i class="bi bi-camera"></i></span>
                                    <input type="file" name="avatar" accept="image/*" onchange="this.form.submit()"/>
                                </label>
                            </form>

                            <div>
                                <div class="acc-side__title">Tài khoản</div>
                                <div class="acc-side__sub">Quản lý hồ sơ</div>
                            </div>
                        </div>
                    </div>

                    <div class="acc-menu">
                        <a class="active" href="${ctx}/account"><i class="bi bi-person"></i> Hồ sơ tài khoản</a>
                        <a href="${ctx}/orders"><i class="bi bi-receipt"></i> Đơn hàng của tôi</a>
                        <a href="${ctx}/change-password"><i class="bi bi-shield-lock"></i> Bảo mật & mật khẩu</a>
                        <a href="#"><i class="bi bi-arrow-repeat"></i> Chính sách đổi trả</a>
                        <a class="text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
                    </div>

                    <div class="acc-note">
                        Mẹo: Bạn có thể xem lịch sử mua hàng trong mục “Đơn hàng của tôi”.
                    </div>
                </div>
            </div>

            <!-- ===== RIGHT MAIN ===== -->
            <div class="col-lg-9">
                <div class="d-flex align-items-start justify-content-between mb-3">
                    <div>
                        <h4 class="mb-1">Tài khoản của tôi</h4>
                        <div class="text-muted">Quản lý hồ sơ, đơn hàng và bảo mật</div>
                    </div>
                    <a class="btn btn-outline-danger btn-sm" href="${ctx}/home">
                        <i class="bi bi-bag me-1"></i> Tiếp tục mua sắm
                    </a>
                </div>

                <!-- ✅ BỎ 3 Ô “Xem lịch sử / Đổi mật khẩu / Hỗ trợ” (theo yêu cầu của bạn) -->

                <!-- Thông tin tài khoản -->
                <div class="card acc-card mb-3">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="fw-semibold">
                                <i class="bi bi-info-circle me-2 text-danger"></i> Thông tin tài khoản
                            </div>
                            <div class="text-muted small">Cập nhật thông tin hiển thị</div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input class="form-control acc-soft" value="${sessionScope.currentUser.email}" disabled>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Trạng thái</label>
                                <input class="form-control acc-soft" value="Đang hoạt động" disabled>
                            </div>
                        </div>

                        <form method="post" action="${ctx}/account" class="row g-3">
                            <input type="hidden" name="csrf" value="${sessionScope.CSRF_TOKEN}"/>

                            <div class="col-md-6">
                                <label class="form-label">Tên hiển thị</label>
                                <input class="form-control" name="name"
                                       value="${sessionScope.currentUser.name}" maxlength="80" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <input class="form-control" name="phone"
                                       value="${sessionScope.currentUser.phone}"
                                       placeholder="VD: 090xxxxxxx hoặc +84...">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Giới tính</label>
                                <select class="form-select" name="gender">
                                    <option value="">-- Chọn --</option>
                                    <option value="MALE" ${sessionScope.currentUser.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                    <option value="FEMALE" ${sessionScope.currentUser.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                    <option value="OTHER" ${sessionScope.currentUser.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Ngày sinh</label>
                                <input class="form-control" type="date" name="birthday"
                                       value="${sessionScope.currentUser.birthday}">
                            </div>

                            <div class="col-12 d-flex gap-2 flex-wrap mt-2">
                                <button type="submit" class="btn btn-danger">
                                    <i class="bi bi-check2-circle me-1"></i> Lưu thay đổi
                                </button>
                                <a href="${ctx}/change-password" class="btn btn-outline-secondary">
                                    <i class="bi bi-shield-lock me-1"></i> Đổi mật khẩu
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Địa chỉ giao hàng mặc định (không phá layout: thêm 1 card giống style phía trên) -->
                <c:set var="addr" value="${requestScope.defaultAddress}" />
                <div class="card acc-card mb-3">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="fw-semibold">
                                <i class="bi bi-geo-alt me-2 text-danger"></i> Địa chỉ giao hàng mặc định
                            </div>
                            <div class="text-muted small">Dùng để tự điền nhanh khi thanh toán</div>
                        </div>

                        <form method="post" action="${ctx}/account" class="row g-3">
                            <input type="hidden" name="csrf" value="${sessionScope.CSRF_TOKEN}"/>
                            <input type="hidden" name="formType" value="address"/>

                            <div class="col-md-6">
                                <label class="form-label">Họ tên người nhận</label>
                                <input class="form-control" name="fullName"
                                       value="${not empty addr ? addr.fullName : sessionScope.currentUser.name}"
                                       maxlength="150" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại nhận hàng</label>
                                <input class="form-control" name="addrPhone"
                                       value="${not empty addr ? addr.phone : sessionScope.currentUser.phone}"
                                       placeholder="VD: 090xxxxxxx hoặc +84..." maxlength="20" required>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Địa chỉ (số nhà, tên đường)</label>
                                <input class="form-control" name="addressLine"
                                       value="${not empty addr ? addr.addressLine : ''}"
                                       placeholder="VD: 123 Lê Lợi" maxlength="255" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Tỉnh/Thành</label>
                                <input class="form-control" name="city"
                                       value="${not empty addr ? addr.city : ''}"
                                       placeholder="VD: TP. Hồ Chí Minh" maxlength="100">
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Quận/Huyện</label>
                                <input class="form-control" name="district"
                                       value="${not empty addr ? addr.district : ''}"
                                       placeholder="VD: Quận 1" maxlength="100">
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Phường/Xã</label>
                                <input class="form-control" name="ward"
                                       value="${not empty addr ? addr.ward : ''}"
                                       placeholder="VD: Bến Thành" maxlength="100">
                            </div>

                            <div class="col-12 d-flex gap-2 flex-wrap mt-2">
                                <button type="submit" class="btn btn-danger">
                                    <i class="bi bi-check2-circle me-1"></i> Lưu địa chỉ
                                </button>
                                <a href="${ctx}/checkout" class="btn btn-outline-secondary">
                                    <i class="bi bi-credit-card me-1"></i> Thử thanh toán
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ✅ Thao tác nhanh (giữ lại ở dưới theo yêu cầu) -->
                <div class="card acc-card">
                    <div class="card-body">
                        <div class="fw-semibold mb-3">
                            <i class="bi bi-lightning-charge me-2 text-danger"></i> Thao tác nhanh
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="border rounded-4 p-3 h-100">
                                    <div class="fw-semibold">Theo dõi đơn hàng</div>
                                    <div class="text-muted small mb-2">
                                        Xem trạng thái từng đơn, chi tiết sản phẩm đã mua.
                                    </div>
                                    <a class="btn btn-outline-danger btn-sm" href="${ctx}/orders">
                                        Mở danh sách đơn <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="border rounded-4 p-3 h-100">
                                    <div class="fw-semibold">Chính sách đổi trả</div>
                                    <div class="text-muted small mb-2">
                                        Xem điều kiện đổi trả, bảo hành, hoàn tiền.
                                    </div>
                                    <a class="btn btn-outline-secondary btn-sm" href="#">
                                        Xem chính sách <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>

    </div>
</section>

<%@ include file="/WEB-INF/jspf/site_footer.jspf" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
