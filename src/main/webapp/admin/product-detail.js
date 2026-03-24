const API_VARIANTS = `${CTX}/admin/product-variants`;
const API_IMAGES = `${CTX}/admin/product-images`;
const API_SPECS = `${CTX}/admin/product-specs`;

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} position-fixed top-0 end-0 m-3`;
    toast.style.zIndex = '9999';
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 2500);
}

function fmtPrice(p) {
    if (p === null || p === undefined || p === '') return '-';
    const n = Number(p);
    if (Number.isNaN(n)) return '-';
    return n.toLocaleString('vi-VN') + 'đ';
}

async function apiGet(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return await res.json();
}

async function apiPost(url, formData) {
    const res = await fetch(url, { method: 'POST', body: formData });
    const data = await res.json().catch(() => ({}));
    if (!res.ok || !data.success) {
        throw new Error(data.message || `HTTP ${res.status}`);
    }
    return data;
}

// ================= VARIANTS =================
let variants = [];

async function loadVariants() {
    variants = await apiGet(`${API_VARIANTS}?action=list&productId=${PRODUCT_ID}`);
    renderVariants();
}

function renderVariants() {
    const tbody = document.querySelector('#tblVariants tbody');
    tbody.innerHTML = '';
    if (!variants || variants.length === 0) {
        tbody.innerHTML = `<tr><td colspan="7" class="text-center py-4 text-muted">Chưa có biến thể</td></tr>`;
        return;
    }

    variants.forEach(v => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${v.id}</td>
            <td>${v.color}</td>
            <td>${v.size}</td>
            <td>${v.stockQty ?? 0}</td>
            <td>${v.sku ?? '-'}</td>
            <td>${v.price != null ? fmtPrice(v.price) : '-'}</td>
            <td class="text-end">
                <button class="btn btn-sm btn-outline-secondary me-1" data-act="edit" data-id="${v.id}">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" data-act="del" data-id="${v.id}">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function resetVariantForm() {
    document.getElementById('variantId').value = '';
    document.getElementById('variantColor').value = '';
    document.getElementById('variantSize').value = '';
    document.getElementById('variantStock').value = 0;
    document.getElementById('variantSku').value = '';
    document.getElementById('variantPrice').value = '';
    document.getElementById('btnVariantSave').innerHTML = '<i class="bi bi-save me-1"></i>Lưu';
}

async function submitVariantForm(e) {
    e.preventDefault();
    const id = document.getElementById('variantId').value;
    const fd = new FormData();
    fd.append('action', id ? 'update' : 'add');
    if (id) fd.append('id', id);
    fd.append('product_id', PRODUCT_ID);
    fd.append('color', document.getElementById('variantColor').value);
    fd.append('size', document.getElementById('variantSize').value);
    fd.append('stock_qty', document.getElementById('variantStock').value || '0');
    fd.append('sku', document.getElementById('variantSku').value);
    fd.append('price', document.getElementById('variantPrice').value);

    try {
        await apiPost(API_VARIANTS, fd);
        showToast(id ? 'Đã cập nhật biến thể' : 'Đã thêm biến thể');
        resetVariantForm();
        await loadVariants();
    } catch (err) {
        console.error(err);
        showToast(err.message || 'Lỗi', 'danger');
    }
}

async function handleVariantTableClick(e) {
    const btn = e.target.closest('button');
    if (!btn) return;
    const act = btn.dataset.act;
    const id = btn.dataset.id;
    const v = variants.find(x => String(x.id) === String(id));
    if (!act || !id) return;

    if (act === 'edit' && v) {
        document.getElementById('variantId').value = v.id;
        document.getElementById('variantColor').value = v.color || '';
        document.getElementById('variantSize').value = v.size || '';
        document.getElementById('variantStock').value = v.stockQty ?? 0;
        document.getElementById('variantSku').value = v.sku || '';
        document.getElementById('variantPrice').value = v.price ?? '';
        document.getElementById('btnVariantSave').innerHTML = '<i class="bi bi-save me-1"></i>Cập nhật';
        window.scrollTo({ top: 0, behavior: 'smooth' });
        return;
    }

    if (act === 'del') {
        if (!confirm('Xóa biến thể này?')) return;
        const fd = new FormData();
        fd.append('action', 'delete');
        fd.append('id', id);
        try {
            await apiPost(API_VARIANTS, fd);
            showToast('Đã xóa biến thể');
            await loadVariants();
        } catch (err) {
            console.error(err);
            showToast(err.message || 'Lỗi', 'danger');
        }
    }
}

// ================= IMAGES =================
let images = [];

async function loadImages() {
    images = await apiGet(`${API_IMAGES}?action=list&productId=${PRODUCT_ID}`);
    renderImages();
}

function renderImages() {
    const tbody = document.querySelector('#tblImages tbody');
    tbody.innerHTML = '';
    if (!images || images.length === 0) {
        tbody.innerHTML = `<tr><td colspan="7" class="text-center py-4 text-muted">Chưa có ảnh</td></tr>`;
        return;
    }

    images.forEach(img => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${img.id}</td>
            <td>
                <img src="${img.imageUrl}" alt="" style="width:56px;height:56px;object-fit:cover;border-radius:10px;" onerror="this.style.display='none'">
            </td>
            <td>${img.color ?? '-'}</td>
            <td>${img.mainImage ? '<span class="badge text-bg-primary">Main</span>' : '-'}</td>
            <td>${img.sortOrder ?? 0}</td>
            <td>${img.active ? '<span class="badge text-bg-success">On</span>' : '<span class="badge text-bg-secondary">Off</span>'}</td>
            <td class="text-end">
                <button class="btn btn-sm btn-outline-primary me-1" data-act="main" data-id="${img.id}">
                    <i class="bi bi-star"></i>
                </button>
                <button class="btn btn-sm btn-outline-secondary me-1" data-act="edit" data-id="${img.id}">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" data-act="del" data-id="${img.id}">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function resetImageForm() {
    document.getElementById('imageId').value = '';
    document.getElementById('imageUrl').value = '';
    document.getElementById('imageAlt').value = '';
    document.getElementById('imageColor').value = '';
    document.getElementById('imageSort').value = 0;
    document.getElementById('imageActive').checked = true;
    document.getElementById('imageMain').checked = false;
    document.getElementById('btnImageSave').innerHTML = '<i class="bi bi-save me-1"></i>Lưu';
    hideImagePreview();
}

function showImagePreview(url) {
    const wrap = document.getElementById('imagePreviewWrap');
    const img = document.getElementById('imagePreview');
    if (!url) {
        hideImagePreview();
        return;
    }
    img.src = url;
    wrap.style.display = 'block';
}

function hideImagePreview() {
    const wrap = document.getElementById('imagePreviewWrap');
    const img = document.getElementById('imagePreview');
    img.src = '';
    wrap.style.display = 'none';
}

async function submitImageForm(e) {
    e.preventDefault();
    const id = document.getElementById('imageId').value;
    const fd = new FormData();
    fd.append('action', id ? 'update' : 'add');
    if (id) fd.append('id', id);
    fd.append('product_id', PRODUCT_ID);
    fd.append('image_url', document.getElementById('imageUrl').value);
    fd.append('alt', document.getElementById('imageAlt').value);
    fd.append('color', document.getElementById('imageColor').value);
    fd.append('sort_order', document.getElementById('imageSort').value || '0');
    fd.append('active', document.getElementById('imageActive').checked ? '1' : '0');
    fd.append('is_main', document.getElementById('imageMain').checked ? '1' : '0');

    try {
        await apiPost(API_IMAGES, fd);
        showToast(id ? 'Đã cập nhật ảnh' : 'Đã thêm ảnh');
        resetImageForm();
        await loadImages();
    } catch (err) {
        console.error(err);
        showToast(err.message || 'Lỗi', 'danger');
    }
}

async function handleImageTableClick(e) {
    const btn = e.target.closest('button');
    if (!btn) return;
    const act = btn.dataset.act;
    const id = btn.dataset.id;
    const img = images.find(x => String(x.id) === String(id));
    if (!act || !id) return;

    if (act === 'edit' && img) {
        document.getElementById('imageId').value = img.id;
        document.getElementById('imageUrl').value = img.imageUrl || '';
        document.getElementById('imageAlt').value = img.alt || '';
        document.getElementById('imageColor').value = img.color || '';
        document.getElementById('imageSort').value = img.sortOrder ?? 0;
        document.getElementById('imageActive').checked = !!img.active;
        document.getElementById('imageMain').checked = !!img.mainImage;
        document.getElementById('btnImageSave').innerHTML = '<i class="bi bi-save me-1"></i>Cập nhật';
        showImagePreview(img.imageUrl);
        window.scrollTo({ top: 0, behavior: 'smooth' });
        return;
    }

    if (act === 'main' && img) {
        const fd = new FormData();
        fd.append('action', 'setMain');
        fd.append('id', img.id);
        fd.append('product_id', PRODUCT_ID);
        fd.append('color', img.color || '');
        try {
            await apiPost(API_IMAGES, fd);
            showToast('Đã đặt ảnh main');
            await loadImages();
        } catch (err) {
            console.error(err);
            showToast(err.message || 'Lỗi', 'danger');
        }
        return;
    }

    if (act === 'del') {
        if (!confirm('Xóa ảnh này?')) return;
        const fd = new FormData();
        fd.append('action', 'delete');
        fd.append('id', id);
        try {
            await apiPost(API_IMAGES, fd);
            showToast('Đã xóa ảnh');
            await loadImages();
        } catch (err) {
            console.error(err);
            showToast(err.message || 'Lỗi', 'danger');
        }
    }
}

// ================= SPECS =================
let specs = [];

async function loadSpecs() {
    specs = await apiGet(`${API_SPECS}?action=list&productId=${PRODUCT_ID}`);
    renderSpecs();
}

function renderSpecs() {
    const tbody = document.querySelector('#tblSpecs tbody');
    tbody.innerHTML = '';
    if (!specs || specs.length === 0) {
        tbody.innerHTML = `<tr><td colspan="5" class="text-center py-4 text-muted">Chưa có specs</td></tr>`;
        return;
    }

    specs.forEach(s => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${s.id}</td>
            <td>${s.specKey}</td>
            <td>${s.specValue}</td>
            <td>${s.sortOrder ?? 0}</td>
            <td class="text-end">
                <button class="btn btn-sm btn-outline-secondary me-1" data-act="edit" data-id="${s.id}">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" data-act="del" data-id="${s.id}">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function resetSpecForm() {
    document.getElementById('specId').value = '';
    document.getElementById('specKey').value = '';
    document.getElementById('specValue').value = '';
    document.getElementById('specSort').value = 0;
    document.getElementById('btnSpecSave').innerHTML = '<i class="bi bi-save me-1"></i>Lưu';
}

async function submitSpecForm(e) {
    e.preventDefault();
    const id = document.getElementById('specId').value;
    const fd = new FormData();
    fd.append('action', id ? 'update' : 'add');
    if (id) fd.append('id', id);
    fd.append('product_id', PRODUCT_ID);
    fd.append('spec_key', document.getElementById('specKey').value);
    fd.append('spec_value', document.getElementById('specValue').value);
    fd.append('sort_order', document.getElementById('specSort').value || '0');

    try {
        await apiPost(API_SPECS, fd);
        showToast(id ? 'Đã cập nhật spec' : 'Đã thêm spec');
        resetSpecForm();
        await loadSpecs();
    } catch (err) {
        console.error(err);
        showToast(err.message || 'Lỗi', 'danger');
    }
}

async function handleSpecTableClick(e) {
    const btn = e.target.closest('button');
    if (!btn) return;
    const act = btn.dataset.act;
    const id = btn.dataset.id;
    const s = specs.find(x => String(x.id) === String(id));
    if (!act || !id) return;

    if (act === 'edit' && s) {
        document.getElementById('specId').value = s.id;
        document.getElementById('specKey').value = s.specKey || '';
        document.getElementById('specValue').value = s.specValue || '';
        document.getElementById('specSort').value = s.sortOrder ?? 0;
        document.getElementById('btnSpecSave').innerHTML = '<i class="bi bi-save me-1"></i>Cập nhật';
        window.scrollTo({ top: 0, behavior: 'smooth' });
        return;
    }

    if (act === 'del') {
        if (!confirm('Xóa spec này?')) return;
        const fd = new FormData();
        fd.append('action', 'delete');
        fd.append('id', id);
        try {
            await apiPost(API_SPECS, fd);
            showToast('Đã xóa spec');
            await loadSpecs();
        } catch (err) {
            console.error(err);
            showToast(err.message || 'Lỗi', 'danger');
        }
    }
}

// ================= INIT =================
document.addEventListener('DOMContentLoaded', async () => {
    // sidebar mobile
    document.getElementById('btnToggleSidebar')?.addEventListener('click', () => {
        document.getElementById('sidebar')?.classList.toggle('show');
    });

    // Variants
    document.getElementById('formVariant')?.addEventListener('submit', submitVariantForm);
    document.getElementById('btnVariantReset')?.addEventListener('click', resetVariantForm);
    document.getElementById('btnReloadVariants')?.addEventListener('click', loadVariants);
    document.querySelector('#tblVariants')?.addEventListener('click', handleVariantTableClick);

    // Images
    document.getElementById('formImage')?.addEventListener('submit', submitImageForm);
    document.getElementById('btnImageReset')?.addEventListener('click', resetImageForm);
    document.getElementById('btnReloadImages')?.addEventListener('click', loadImages);
    document.querySelector('#tblImages')?.addEventListener('click', handleImageTableClick);
    document.getElementById('imageUrl')?.addEventListener('input', (e) => showImagePreview(e.target.value));

    // Specs
    document.getElementById('formSpec')?.addEventListener('submit', submitSpecForm);
    document.getElementById('btnSpecReset')?.addEventListener('click', resetSpecForm);
    document.getElementById('btnReloadSpecs')?.addEventListener('click', loadSpecs);
    document.querySelector('#tblSpecs')?.addEventListener('click', handleSpecTableClick);

    // Load all
    try {
        await Promise.all([loadVariants(), loadImages(), loadSpecs()]);
    } catch (err) {
        console.error(err);
        showToast('Không tải được dữ liệu (check console)', 'danger');
    }
});
