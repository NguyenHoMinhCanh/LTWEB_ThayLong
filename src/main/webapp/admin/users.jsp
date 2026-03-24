<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setAttribute("pageTitle", "Quản lý Users - Admin");
    request.setAttribute("activePage", "users");
%>

<%@ include file="/admin/includes/_admin_layout_open.jspf" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0">Quản lý Users</h4>
</div>

<div class="card mb-3">
    <div class="card-body">
        <div class="row g-2 align-items-center">
            <div class="col-md-5">
                <input id="searchInput" class="form-control" placeholder="Tìm theo tên / email / role..." />
            </div>
            <div class="col-md-2">
                <button id="btnRefresh" class="btn btn-outline-secondary w-100">
                    <i class="bi bi-arrow-clockwise me-1"></i> Làm mới
                </button>
            </div>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table align-middle" id="tblUsers">
                <thead>
                <tr>
                    <th style="width:80px">ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th style="width:160px">Thao tác</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<script>
    const CTX = '${pageContext.request.contextPath}';
</script>

<script src="${pageContext.request.contextPath}/admin/users.js"></script>

<%@ include file="/admin/includes/_admin_layout_close.jspf" %>
