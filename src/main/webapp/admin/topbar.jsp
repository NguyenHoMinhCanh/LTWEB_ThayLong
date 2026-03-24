<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- TOPBAR kiểu CoreUI -->
<header class="cui-topbar">
    <div class="cui-topbar__inner container-fluid">
        <div class="d-flex align-items-center gap-3">
            <button class="btn btn-link text-white d-lg-none p-0" id="btnToggleSidebar">
                <i class="bi bi-list fs-3"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center text-white text-decoration-none">
                <span class="fw-semibold">JAPAN SPORT</span>
                <span class="badge bg-white text-primary ms-2">ADMIN</span>
            </a>
        </div>

        <!-- Right icons -->
        <ul class="cui-icons list-unstyled d-flex align-items-center mb-0 ms-auto">
            <li class="dropdown">
                <a class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                   href="#" data-bs-toggle="dropdown">
                    <span class="me-2">${sessionScope.currentUser.name}</span>
                    <i class="bi bi-person-circle fs-4"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                    </a></li>
                </ul>
            </li>
        </ul>
    </div>
</header>