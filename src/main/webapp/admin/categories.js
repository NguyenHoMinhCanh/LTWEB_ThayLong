const API_URL = `${CTX}/admin/categories`;

function slugify(str) {
    if (!str) return '';
    return str.toString().toLowerCase().trim()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/đ/g, 'd')
        .replace(/[^a-z0-9\s-]/g, '')
        .replace(/\s+/g, '-')
        .replace(/-+/g, '-')
        .replace(/^-+|-+$/g, '');
}

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} position-fixed top-0 end-0 m-3`;
    toast.style.zIndex = '9999';
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => toast.remove(), 3000);
}

async function fetchCategories() {
    try {
        const response = await fetch(`${API_URL}?action=list`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching categories:', error);
        showToast('Lỗi khi tải danh sách danh mục', 'danger');
        return [];
    }
}

async function fetchCategoryById(id) {
    try {
        const response = await fetch(`${API_URL}?action=getById&id=${id}`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching category:', error);
        showToast('Lỗi khi tải thông tin danh mục', 'danger');
        return null;
    }
}

async function fetchParentCategories() {
    try {
        const response = await fetch(`${API_URL}?action=getParents`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching parent categories:', error);
        return [];
    }
}

async function saveCategory(formData) {
    try {
        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showToast(result.message || 'Lưu thành công', 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi lưu danh mục', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error saving category:', error);
        showToast('Lỗi kết nối server: ' + error.message, 'danger');
        return false;
    }
}

async function deleteCategory(id) {
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
            showToast(result.message || 'Xóa thành công', 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi xóa danh mục', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error deleting category:', error);
        showToast('Lỗi kết nối server: ' + error.message, 'danger');
        return false;
    }
}

let allCategories = [];
let categoryModal = null;
let editingCategoryId = null;

async function renderCategories() {
    const tbody = document.querySelector('#tblCategories tbody');
    if (!tbody) return;

    allCategories = await fetchCategories();
    const searchQuery = (document.getElementById('searchInput')?.value || '').toLowerCase();

    const filtered = allCategories.filter(cat => {
        const searchText = (cat.name + (cat.slug || '')).toLowerCase();
        return searchText.includes(searchQuery);
    });

    tbody.innerHTML = '';

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center py-4">Không có dữ liệu</td></tr>';
        return;
    }

    filtered.forEach(cat => {
        const tr = document.createElement('tr');

        tr.innerHTML = `
            <td>${cat.id}</td>
            <td>${cat.name}</td>
            <td><code>${cat.slug || ''}</code></td>
            <td>
                ${cat.image_url
            ? `<img src="${cat.image_url}" alt="" class="thumb" style="width:50px;height:50px;object-fit:cover;border-radius:8px;">`
            : '<span class="text-muted">-</span>'}
            </td>
            <td>${cat.display_order ?? 0}</td>
            <td>
                ${cat.active === 1
            ? '<span class="badge bg-success">Hiển thị</span>'
            : '<span class="badge bg-secondary">Ẩn</span>'}
            </td>
            <td class="text-end">
                <button class="btn btn-sm btn-outline-secondary me-1" onclick="openEditModal(${cat.id})">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" onclick="handleDelete(${cat.id})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

async function loadParentOptions() {
    const select = document.getElementById('categoryParent');
    if (!select) return;

    const parents = await fetchParentCategories();
    select.innerHTML = '<option value="">-- Không có (Danh mục gốc) --</option>';

    parents.forEach(cat => {
        const option = document.createElement('option');
        option.value = cat.id;
        option.textContent = cat.name;
        select.appendChild(option);
    });
}

async function openAddModal() {
    editingCategoryId = null;

    document.getElementById('modalTitle').textContent = 'Thêm danh mục';
    document.getElementById('formAction').value = 'create';

    const form = document.getElementById('formCategory');
    form.reset();

    // reset state
    document.getElementById('categoryId').value = '';
    document.getElementById('categoryFeatured').checked = false;
    document.getElementById('categoryOrder').value = 0;
    document.getElementById('categoryActive').value = '1';

    // reset slug manual flag
    const slugInput = document.getElementById('categorySlug');
    if (slugInput) delete slugInput.dataset.manualEdit;

    await loadParentOptions();
    document.getElementById('categoryParent').value = '';

    categoryModal.show();
}

async function openEditModal(id) {
    const category = await fetchCategoryById(id);
    if (!category) return;

    editingCategoryId = id;

    document.getElementById('modalTitle').textContent = 'Sửa danh mục';
    document.getElementById('formAction').value = 'update';

    document.getElementById('categoryId').value = category.id;
    document.getElementById('categoryName').value = category.name;
    document.getElementById('categorySlug').value = category.slug || '';
    document.getElementById('categoryImage').value = category.image_url || '';
    document.getElementById('categoryLink').value = category.link || '';
    document.getElementById('categoryOrder').value = category.display_order ?? 0;

    // giữ is_featured nhưng ẩn (preserve data)
    document.getElementById('categoryFeatured').checked = (Number(category.is_featured ?? 0) === 1);

    document.getElementById('categoryActive').value = String(category.active ?? 1);

    await loadParentOptions();
    document.getElementById('categoryParent').value = category.parent_id || '';

    categoryModal.show();
}

async function handleDelete(id) {
    if (!confirm('Bạn có chắc muốn xóa danh mục này?')) return;

    const success = await deleteCategory(id);
    if (success) await renderCategories();
}

// FORM SUBMIT
document.getElementById('formCategory')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const formData = new FormData(e.target);

    if (!formData.get('name') || formData.get('name').trim() === '') {
        showToast('Vui lòng nhập tên danh mục', 'warning');
        return;
    }

    // Auto-generate slug if empty
    if (!formData.get('slug') || formData.get('slug').trim() === '') {
        formData.set('slug', slugify(formData.get('name')));
    }

    // Nếu bạn muốn "Nổi bật" luôn tắt: đảm bảo is_featured = 0
    if (!formData.get('is_featured')) formData.set('is_featured', '0');

    const success = await saveCategory(formData);
    if (success) {
        categoryModal.hide();
        await renderCategories();
    }
});

// Auto-generate slug from name (chỉ khi user chưa tự edit slug)
document.getElementById('categoryName')?.addEventListener('input', (e) => {
    const slugInput = document.getElementById('categorySlug');
    if (slugInput && !slugInput.dataset.manualEdit) {
        slugInput.value = slugify(e.target.value);
    }
});

document.getElementById('categorySlug')?.addEventListener('input', (e) => {
    e.target.dataset.manualEdit = 'true';
});

document.getElementById('btnAddCategory')?.addEventListener('click', openAddModal);
document.getElementById('searchInput')?.addEventListener('input', renderCategories);

document.addEventListener('DOMContentLoaded', async () => {
    const modalEl = document.getElementById('modalCategory');
    if (modalEl) categoryModal = new bootstrap.Modal(modalEl);

    await renderCategories();
});

window.openEditModal = openEditModal;
window.handleDelete = handleDelete;
