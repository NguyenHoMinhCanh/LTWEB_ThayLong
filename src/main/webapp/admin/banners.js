const API_URL = `${CTX}/admin/banners`;

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} position-fixed top-0 end-0 m-3 shadow`;
    toast.style.zIndex = '9999';
    toast.innerHTML = message;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 2500);
}

function buildImgSrc(imageUrl) {
    if (!imageUrl) return '';
    const u = imageUrl.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    if (u.startsWith('/')) return `${CTX}${u}`;
    return `${CTX}/${u}`;
}

async function fetchBanners(position = '') {
    const url = position ? `${API_URL}?action=list&position=${encodeURIComponent(position)}` : `${API_URL}?action=list`;
    const res = await fetch(url);
    return await res.json();
}

async function fetchBannerById(id) {
    const res = await fetch(`${API_URL}?action=getById&id=${id}`);
    return await res.json();
}

async function postForm(action, formData) {
    formData.set('action', action);
    const res = await fetch(API_URL, { method: 'POST', body: formData });
    return await res.json();
}

function renderTable(list) {
    const tbody = document.getElementById('bannerTbody');
    tbody.innerHTML = '';

    if (!list || list.length === 0) {
        tbody.innerHTML = `<tr><td colspan="7" class="text-center text-muted py-4">Không có banner</td></tr>`;
        return;
    }

    for (const b of list) {
        const imgSrc = buildImgSrc(b.image_url);
        const activeBadge = (b.active === 1)
            ? `<span class="badge text-bg-success">Hiển thị</span>`
            : `<span class="badge text-bg-secondary">Ẩn</span>`;

        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${b.id}</td>
            <td>
                <img src="${imgSrc}" style="width:120px;height:54px;object-fit:cover;border-radius:8px;border:1px solid #eee;" />
            </td>
            <td>${b.title ?? ''}</td>
            <td><code>${b.position ?? ''}</code></td>
            <td style="max-width:260px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                ${b.link ?? ''}
            </td>
            <td>${activeBadge}</td>
            <td class="text-end">
                <button class="btn btn-outline-primary btn-sm me-1" data-action="edit" data-id="${b.id}">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-outline-warning btn-sm me-1" data-action="toggle" data-id="${b.id}" data-active="${b.active}">
                    <i class="bi bi-eye${b.active === 1 ? '-slash' : ''}"></i>
                </button>
                <button class="btn btn-outline-danger btn-sm" data-action="delete" data-id="${b.id}">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    }
}

function applyKeywordFilter(list, keyword) {
    if (!keyword) return list;
    const kw = keyword.toLowerCase().trim();
    return list.filter(b =>
        (b.title ?? '').toLowerCase().includes(kw) ||
        (b.link ?? '').toLowerCase().includes(kw) ||
        (b.position ?? '').toLowerCase().includes(kw) ||
        String(b.id).includes(kw)
    );
}

// ===== Modal helpers =====

const bannerModalEl = document.getElementById('bannerModal');
const bannerModal = new bootstrap.Modal(bannerModalEl);

function resetForm() {
    document.getElementById('bannerId').value = '';
    document.getElementById('bannerModalTitle').innerText = 'Thêm banner';
    document.getElementById('position').value = '';
    document.getElementById('title').value = '';
    document.getElementById('link').value = '';
    document.getElementById('image_url').value = '';
    document.getElementById('active').checked = true;
    document.getElementById('imageFile').value = '';
    document.getElementById('previewImg').src = '';
}

function fillForm(b) {
    document.getElementById('bannerId').value = b.id;
    document.getElementById('bannerModalTitle').innerText = `Sửa banner #${b.id}`;
    document.getElementById('position').value = b.position ?? '';
    document.getElementById('title').value = b.title ?? '';
    document.getElementById('link').value = b.link ?? '';
    document.getElementById('image_url').value = b.image_url ?? '';
    document.getElementById('active').checked = (b.active === 1);
    document.getElementById('imageFile').value = '';
    document.getElementById('previewImg').src = buildImgSrc(b.image_url);
}

// ===== Main =====

let lastList = [];

async function reload() {
    const pos = document.getElementById('filterPosition').value;
    const kw = document.getElementById('keyword').value;

    const data = await fetchBanners(pos);
    // Nếu server trả lỗi dạng {success:false,message:"..."} thì handle:
    if (data && data.success === false) {
        showToast(data.message || 'Lỗi tải banner', 'danger');
        renderTable([]);
        return;
    }

    lastList = data;
    const filtered = applyKeywordFilter(lastList, kw);
    renderTable(filtered);
}

document.getElementById('btnReload').addEventListener('click', reload);
document.getElementById('filterPosition').addEventListener('change', reload);
document.getElementById('keyword').addEventListener('input', () => {
    const kw = document.getElementById('keyword').value;
    renderTable(applyKeywordFilter(lastList, kw));
});

document.getElementById('btnAddBanner').addEventListener('click', () => {
    resetForm();
    bannerModal.show();
});

document.getElementById('image_url').addEventListener('input', () => {
    const url = document.getElementById('image_url').value.trim();
    document.getElementById('previewImg').src = buildImgSrc(url);
});

document.getElementById('imageFile').addEventListener('change', (e) => {
    const f = e.target.files?.[0];
    if (!f) return;
    const url = URL.createObjectURL(f);
    document.getElementById('previewImg').src = url;
});

document.getElementById('bannerForm').addEventListener('submit', async (e) => {
    e.preventDefault();

    const id = document.getElementById('bannerId').value.trim();
    const form = new FormData();

    form.set('id', id);
    form.set('position', document.getElementById('position').value);
    form.set('title', document.getElementById('title').value);
    form.set('link', document.getElementById('link').value);
    form.set('image_url', document.getElementById('image_url').value);
    form.set('active', document.getElementById('active').checked ? '1' : '0');

    const file = document.getElementById('imageFile').files?.[0];
    if (file) form.set('imageFile', file);

    const action = id ? 'update' : 'create';
    const res = await postForm(action, form);

    if (res && res.success === false) {
        showToast(res.message || 'Lỗi lưu banner', 'danger');
        return;
    }

    showToast(res.message || 'OK', 'success');
    bannerModal.hide();
    await reload();
});

document.getElementById('tblBanners').addEventListener('click', async (e) => {
    const btn = e.target.closest('button[data-action]');
    if (!btn) return;

    const action = btn.dataset.action;
    const id = btn.dataset.id;

    if (action === 'edit') {
        const b = await fetchBannerById(id);
        if (b && b.success === false) {
            showToast(b.message || 'Không tải được banner', 'danger');
            return;
        }
        resetForm();
        fillForm(b);
        bannerModal.show();
        return;
    }

    if (action === 'toggle') {
        const current = Number(btn.dataset.active);
        const next = current === 1 ? 0 : 1;

        const fd = new FormData();
        fd.set('id', id);
        fd.set('active', String(next));

        const res = await postForm('toggle', fd);
        if (res && res.success === false) {
            showToast(res.message || 'Lỗi cập nhật trạng thái', 'danger');
            return;
        }
        showToast(res.message || 'OK', 'success');
        await reload();
        return;
    }

    if (action === 'delete') {
        if (!confirm(`Xóa banner #${id}?`)) return;

        const fd = new FormData();
        fd.set('id', id);

        const res = await postForm('delete', fd);
        if (res && res.success === false) {
            showToast(res.message || 'Lỗi xóa', 'danger');
            return;
        }
        showToast(res.message || 'OK', 'success');
        await reload();
    }
});

// init
reload();
