// ============== USERS ADMIN (AJAX) ==============
const API_URL = `${CTX}/admin/users`;

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} position-fixed top-0 end-0 m-3 shadow`;
    toast.style.zIndex = '9999';
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => toast.remove(), 2500);
}

async function fetchUsers() {
    try {
        const res = await fetch(`${API_URL}?action=list`, {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        });
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const data = await res.json();
        return Array.isArray(data) ? data : [];
    } catch (e) {
        console.error(e);
        showToast('Không tải được danh sách users', 'danger');
        return [];
    }
}

async function postAction(action, bodyObj) {
    const form = new URLSearchParams();
    form.set('action', action);
    Object.entries(bodyObj || {}).forEach(([k, v]) => {
        if (v !== undefined && v !== null) form.set(k, String(v));
    });

    const res = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: form.toString()
    });

    let json;
    try {
        json = await res.json();
    } catch {
        json = null;
    }

    if (!res.ok || !json) {
        throw new Error(`Request failed (${res.status})`);
    }

    return json;
}

function normalizeRoleCode(user) {
    // backend trả roleCode: ADMIN/STAFF/USER (có thể null)
    const rc = (user.roleCode || user.role || '').toString().toUpperCase();
    return rc || 'USER';
}

function renderRoleBadge(roleCode) {
    switch (roleCode) {
        case 'ADMIN':
            return '<span class="badge bg-danger">ADMIN</span>';
        case 'STAFF':
            return '<span class="badge bg-primary">STAFF</span>';
        default:
            return '<span class="badge bg-secondary">USER</span>';
    }
}

function renderStatusBadge(active) {
    return active === 1
        ? '<span class="badge bg-success">Hoạt động</span>'
        : '<span class="badge bg-warning text-dark">Bị khóa</span>';
}

let allUsers = [];

async function renderUsers() {
    const tbody = document.querySelector('#tblUsers tbody');
    if (!tbody) return;

    allUsers = await fetchUsers();

    const qEl = document.getElementById('searchInput');
    const q = (qEl?.value || '').trim().toLowerCase();

    const filtered = !q
        ? allUsers
        : allUsers.filter(u => {
            const roleCode = normalizeRoleCode(u).toLowerCase();
            return (
                (u.name || '').toLowerCase().includes(q) ||
                (u.email || '').toLowerCase().includes(q) ||
                roleCode.includes(q)
            );
        });

    tbody.innerHTML = '';

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted">Không có dữ liệu</td></tr>';
        return;
    }

    filtered.forEach(user => {
        const tr = document.createElement('tr');

        const roleCode = normalizeRoleCode(user);
        const roleBadge = renderRoleBadge(roleCode);
        const statusBadge = renderStatusBadge(user.active);

        const toggleBtn = user.active === 1
            ? `<button class="btn btn-sm btn-warning" onclick="handleToggleStatus(${user.id})" title="Khóa tài khoản">
                    <i class="bi bi-lock"></i>
               </button>`
            : `<button class="btn btn-sm btn-success" onclick="handleToggleStatus(${user.id})" title="Mở khóa">
                    <i class="bi bi-unlock"></i>
               </button>`;

        // Toggle role giữa ADMIN <-> USER (đúng với servlet đang map admin/customer)
        const roleToggleBtn = roleCode === 'ADMIN'
            ? `<button class="btn btn-sm btn-outline-secondary" onclick="handleChangeRole(${user.id}, 'customer')" title="Hạ xuống USER">
                    <i class="bi bi-person"></i>
               </button>`
            : `<button class="btn btn-sm btn-outline-primary" onclick="handleChangeRole(${user.id}, 'admin')" title="Nâng lên ADMIN">
                    <i class="bi bi-shield-check"></i>
               </button>`;

        tr.innerHTML = `
            <td>${user.id}</td>
            <td>${user.name ?? ''}</td>
            <td>${user.email ?? ''}</td>
            <td>${roleBadge}</td>
            <td>${statusBadge}</td>
            <td class="text-end">
                ${toggleBtn}
                ${roleToggleBtn}
                <button class="btn btn-sm btn-outline-danger" onclick="handleDelete(${user.id})" title="Xóa user">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;

        tbody.appendChild(tr);
    });
}

// ============== EVENT HANDLERS ==============
async function handleToggleStatus(id) {
    try {
        const res = await postAction('toggle-status', { id });
        if (res.success) {
            showToast(res.message || 'Cập nhật trạng thái thành công');
            await renderUsers();
        } else {
            showToast(res.message || 'Không cập nhật được trạng thái', 'danger');
        }
    } catch (e) {
        console.error(e);
        showToast('Lỗi khi cập nhật trạng thái user', 'danger');
    }
}

async function handleChangeRole(id, role) {
    try {
        const res = await postAction('update-role', { id, role });
        if (res.success) {
            showToast(res.message || 'Cập nhật role thành công');
            await renderUsers();
        } else {
            showToast(res.message || 'Không cập nhật được role', 'danger');
        }
    } catch (e) {
        console.error(e);
        showToast('Lỗi khi cập nhật role user', 'danger');
    }
}

async function handleDelete(id) {
    if (!confirm('Xóa user này?')) return;

    try {
        const res = await postAction('delete', { id });
        if (res.success) {
            showToast(res.message || 'Đã xóa user');
            await renderUsers();
        } else {
            showToast(res.message || 'Không xóa được user', 'danger');
        }
    } catch (e) {
        console.error(e);
        showToast('Lỗi khi xóa user', 'danger');
    }
}

// ============== INIT ==============
document.addEventListener('DOMContentLoaded', () => {
    const qEl = document.getElementById('searchInput');
    if (qEl) {
        qEl.addEventListener('input', () => {
            // không gọi API lại, chỉ filter trên allUsers
            renderUsers();
        });
    }

    const btnRefresh = document.getElementById('btnRefresh');
    if (btnRefresh) {
        btnRefresh.addEventListener('click', () => renderUsers());
    }

    renderUsers();
});
