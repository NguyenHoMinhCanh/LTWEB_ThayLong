// ============== HELPERS ==============
const API_URL = `${CTX}/admin/users`;


function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} position-fixed top-0 end-0 m-3`;
    toast.style.zIndex = '9999';
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.remove();
    }, 3000);
}

function formatDate(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    return date.toLocaleDateString('vi-VN');
}

// ============== API CALLS ==============
async function fetchUsers() {
    try {
        const response = await fetch(`${API_URL}?action=list`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching users:', error);
        showToast('Lỗi khi tải danh sách users', 'danger');
        return [];
    }
}

async function toggleUserStatus(id) {
    try {
        const formData = new FormData();
        formData.append('action', 'toggle-status');
        formData.append('id', id);

        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showToast(result.message, 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi cập nhật trạng thái', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error toggling user status:', error);
        showToast('Lỗi khi cập nhật trạng thái', 'danger');
        return false;
    }
}

async function updateUserRole(id, newRole) {
    try {
        const formData = new FormData();
        formData.append('action', 'update-role');
        formData.append('id', id);
        formData.append('role', newRole);

        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showToast(result.message, 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi cập nhật role', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error updating user role:', error);
        showToast('Lỗi khi cập nhật role', 'danger');
        return false;
    }
}

async function deleteUser(id) {
    try {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('id', id);

        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showToast(result.message, 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi xóa user', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error deleting user:', error);
        showToast('Lỗi khi xóa user', 'danger');
        return false;
    }
}

// ============== UI RENDERING ==============
let allUsers = [];

async function renderUsers() {
    const tbody = document.querySelector('#tblUsers tbody');
    if (!tbody) return;

    allUsers = await fetchUsers();
    const searchQuery = document.getElementById('searchInput')?.value.toLowerCase() || '';

    const filtered = allUsers.filter(user => {
        const role = (user.roleCode || user.role || '').toString();
        const searchText = (`${user.name || ''} ${user.email || ''} ${role}`).toLowerCase();
        return searchText.includes(searchQuery);
    });

    tbody.innerHTML = '';

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4">Không có dữ liệu</td></tr>';
        return;
    }

    filtered.forEach(user => {
        const tr = document.createElement('tr');

        const roleCode = (user.roleCode || user.role || 'USER').toString().toUpperCase();
        const roleBadge = roleCode === 'ADMIN'
            ? '<span class="badge bg-danger">ADMIN</span>'
            : (roleCode === 'STAFF'
                ? '<span class="badge bg-warning text-dark">STAFF</span>'
                : '<span class="badge bg-secondary">USER</span>');

        // Status badge
        const statusBadge = user.active === 1
            ? '<span class="badge bg-success">Hoạt động</span>'
            : '<span class="badge bg-warning">Bị khóa</span>';

        // Action buttons
        const toggleBtn = user.active === 1
            ? `<button class="btn btn-sm btn-warning" onclick="handleToggleStatus(${user.id})" title="Khóa tài khoản">
                <i class="bi bi-lock"></i>
               </button>`
            : `<button class="btn btn-sm btn-success" onclick="handleToggleStatus(${user.id})" title="Mở khóa">
                <i class="bi bi-unlock"></i>
               </button>`;

        // UI gửi role theo chuẩn servlet đang map: admin/customer
        const roleToggleBtn = roleCode !== 'ADMIN'
            ? `<button class="btn btn-sm btn-outline-primary" onclick="handleChangeRole(${user.id}, 'admin')" title="Nâng lên ADMIN">
                <i class="bi bi-shield-check"></i>
               </button>`
            : `<button class="btn btn-sm btn-outline-secondary" onclick="handleChangeRole(${user.id}, 'customer')" title="Hạ xuống USER">
                <i class="bi bi-person"></i>
               </button>`;

        tr.innerHTML = `
            <td>${user.id}</td>
            <td>${user.name ?? '-'}</td>
            <td>${user.email ?? '-'}</td>
            <td>${roleBadge}</td>
            <td>${statusBadge}</td>
            <td class="text-end">
                ${toggleBtn}
                ${roleToggleBtn}
                <button class="btn btn-sm btn-outline-danger" onclick="handleDelete(${user.id})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

// ============== EVENT HANDLERS ==============
async function handleToggleStatus(id) {
    const user = allUsers.find(u => u.id === id);
    if (!user) return;

    const action = user.active === 1 ? 'khóa' : 'mở khóa';
    if (!confirm(`Bạn có chắc muốn ${action} tài khoản này?`)) return;

    const success = await toggleUserStatus(id);
    if (success) {
        await renderUsers();
    }
}

async function handleChangeRole(id, newRole) {
    const roleText = newRole === 'admin' ? 'Admin' : 'Customer';
    if (!confirm(`Bạn có chắc muốn đổi quyền thành ${roleText}?`)) return;

    const success = await updateUserRole(id, newRole);
    if (success) {
        await renderUsers();
    }
}

async function handleDelete(id) {
    if (!confirm('Bạn có chắc muốn XÓA tài khoản này? Hành động không thể hoàn tác!')) return;

    const success = await deleteUser(id);
    if (success) {
        await renderUsers();
    }
}

// ============== EVENT LISTENERS ==============
document.getElementById('searchInput')?.addEventListener('input', renderUsers);

// Sidebar toggle for mobile
document.getElementById('btnToggleSidebar')?.addEventListener('click', () => {
    document.getElementById('sidebar')?.classList.toggle('show');
});

// ============== INIT ==============
document.addEventListener('DOMContentLoaded', async () => {
    await renderUsers();
});

// Make functions global for inline onclick
window.handleToggleStatus = handleToggleStatus;
window.handleChangeRole = handleChangeRole;
window.handleDelete = handleDelete;


