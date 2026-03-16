// ===== Helpers & store =====
const $ = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
const store = {
    read(k, f) {
        try {
            return JSON.parse(localStorage.getItem(k)) ?? f;
        } catch {
            return f;
        }
    },
    write(k, v) {
        localStorage.setItem(k, JSON.stringify(v));
    }
};


// ===== Seed demo 1 lần =====
if (!store.read("__seeded__")) {
    store.write("products", [
        {
            id: "NK-PEG-40",
            name: "Nike Air Zoom Pegasus 40",
            category: "Nike",
            price: 2990000,
            stock: 22,
            image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600"
        },
        {
            id: "AD-UL-23",
            name: "adidas Ultraboost Light",
            category: "Adidas",
            price: 4490000,
            stock: 12,
            image: "https://images.unsplash.com/photo-1608231387042-66d1773070a5?q=80&w=600"
        }
    ]);
    store.write("customers", [
        {id: "KH001", name: "Nguyễn An", phone: "0901234567", email: "an@example.com", orders: 2},
        {id: "KH002", name: "Trần Bình", phone: "0907654321", email: "binh@example.com", orders: 1}
    ]);
    store.write("orders", [
        {
            id: "DH1001",
            customer: "Nguyễn An",
            date: "2025-09-03",
            items: [{id: "NK-PEG-40", qty: 1, price: 2990000}],
            total: 2990000,
            status: "moi"
        },
        {
            id: "DH1002",
            customer: "Trần Bình",
            date: "2025-09-05",
            items: [{id: "AD-UL-23", qty: 1, price: 4490000}],
            total: 4490000,
            status: "hoantat"
        }
    ]);
    store.write("news", [{
        id: "N001",
        title: "Khai trương tháng 9 - Giảm 20%",
        date: "2025-09-01",
        published: true,
        content: "Ưu đãi lớn cho dòng chạy bộ."
    }]);
    store.write("__seeded__", true);
}
const fmt = n => (n ?? 0).toLocaleString("vi-VN");

// đặt sau fmt hoặc nhóm Helpers
const slugify = (s)=> (s||'').toString().trim()
    .toLowerCase()
    .normalize('NFD').replace(/[\u0300-\u036f]/g,'')
    .replace(/[^a-z0-9]+/g,'-').replace(/(^-|-$)/g,'');

// ===== Sidebar toggle (mobile) =====
$("#btnToggleSidebar")?.addEventListener("click", () => $("#sidebar")?.classList.add("show"));
document.addEventListener("click", (e) => {
    const sb = $("#sidebar");
    if (!sb) return;
    if (e.target?.id === "btnToggleSidebar") return;
    if (window.innerWidth < 992 && !sb.contains(e.target)) sb.classList.remove("show");
});

// ===== Nav switch (chỉ cần cho .s-item) =====
$$(".s-item[data-target]").forEach(btn => {
    btn.addEventListener("click", () => {
        $$(".s-item[data-target]").forEach(b => b.classList.remove("active"));
        btn.classList.add("active");
        $$(".panel").forEach(p => p.classList.remove("show"));
        const target = $(btn.dataset.target);
        target?.classList.add("show");
    });
});

// Chevron demo (không ảnh hưởng chức năng)
$$(".s-item.s-toggle").forEach(it => {
    it.addEventListener("click", () => it.classList.toggle("open"));
});

// ===== Export / Import / Logout =====
$("#btnExport")?.addEventListener("click", () => {
    const blob = new Blob([JSON.stringify({
        products: store.read("products", []),
        orders: store.read("orders", []),
        customers: store.read("customers", []),
        news: store.read("news", [])
    }, null, 2)], {type: "application/json"});
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = `backup_${Date.now()}.json`;
    a.click();
});
$("#btnImport")?.addEventListener("click", () => $("#fileImport")?.click());
$("#fileImport")?.addEventListener("change", async (e) => {
    const f = e.target.files?.[0];
    if (!f) return;
    try {
        const j = JSON.parse(await f.text());
        ["products", "orders", "customers", "news"].forEach(k => Array.isArray(j[k]) && store.write(k, j[k]));
        renderAll();
        alert("Nhập dữ liệu thành công");
    } catch {
        alert("File JSON không hợp lệ");
    }
    e.target.value = "";
});
$("#btnLogout")?.addEventListener("click", () => {
    localStorage.removeItem("isAdmin");
    location.href = "../login.html";
});

// ===== Dashboard stats + charts =====
function refreshStats() {
    const products = store.read("products", []);
    const orders = store.read("orders", []);
    const customers = store.read("customers", []);
    const revenue = orders.filter(o => o.status !== "huy").reduce((s, o) => s + (o.total || 0), 0);
    $("#statProducts") && ($("#statProducts").textContent = fmt(products.length));
    $("#statOrders") && ($("#statOrders").textContent = fmt(orders.length));
    $("#statCustomers") && ($("#statCustomers").textContent = fmt(customers.length));
    $("#statRevenue") && ($("#statRevenue").textContent = fmt(revenue));
}

let saleChart, trafficChart;

function renderCharts() {
    const ctx1 = $("#chartSale");
    const ctx2 = $("#chartTraffic");
    // Nếu dashboard hiện tại không có 2 canvas này thì bỏ qua
    if (!ctx1 || !ctx2 || typeof Chart === "undefined") return;

    saleChart && saleChart.destroy();
    trafficChart && trafficChart.destroy();

    saleChart = new Chart(ctx1, {
        type: "line",
        data: {
            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
            datasets: [{
                label: "Sale",
                data: [30, 50, 40, 35, 28, 45],
                tension: .4,
                borderColor: "#5b57ea",
                backgroundColor: "rgba(91,87,234,.15)",
                fill: true
            }]
        },
        options: {plugins: {legend: {display: false}}, scales: {y: {grid: {color: "rgba(0,0,0,.05)"}}}}
    });

    trafficChart = new Chart(ctx2, {
        type: "bar",
        data: {
            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            datasets: [{
                label: "Traffic",
                data: [72, 78, 80, 29, 26, 10, 48, 81, 55, 21, 14, 96],
                backgroundColor: "#5b57ea"
            }]
        },
        options: {plugins: {legend: {display: false}}, scales: {y: {grid: {color: "rgba(0,0,0,.05)"}}}}
    });
}

// ===== Global search: nếu không có input thì không gắn =====
$("#globalSearch")?.addEventListener("input", (e) => {
    const q = e.target.value.trim().toLowerCase();
    const panel = document.querySelector(".panel.show");
    if (!panel) return;
    panel.querySelectorAll("tbody tr").forEach(tr => {
        tr.style.display = tr.textContent.toLowerCase().includes(q) ? "" : "none";
    });
});
/*hàm load/select Danh mục + Nhãn hàng*/
function getPublishedCategories(){
    try {
        return (store.read("categories", [])||[]).filter(c=>c.published===true || c.published==="true");
    } catch { return []; }
}

function getPublishedBrands(){
    try {
        return (store.read("brands", [])||[]).filter(b=>b.published===true || b.published==="true");
    } catch { return []; }
}

function fillSelectOptions(selectEl, arr, valueKey="slug", labelKey="name"){
    if(!selectEl) return;
    const cur = selectEl.value;
    selectEl.innerHTML = `<option value="">-- Chọn --</option>` + (arr||[])
        .map(x=>`<option value="${x[valueKey]??""}">${x[labelKey]??""}</option>`).join("");
    if(cur) selectEl.value = cur;
}

// ===== Products CRUD =====
const tblProductsBody = $("#tblProducts tbody");
let productModal = null;
const formProduct = $("#formProduct");
try {
    productModal = formProduct ? new bootstrap.Modal("#modalProduct") : null;
} catch {
    productModal = null;
}
let editingProductId = null;

function renderProducts() {

    if (!tblProductsBody) return;
    const cats = store.read("categories", []);   // đọc danh mục đã lưu
    const brands = store.read("brands", []);     // đọc nhãn hàng đã lưu

// hàm phụ: tìm name theo slug
    function labelBySlug(arr, slug){
        return (arr||[]).find(x => x.slug === slug)?.name || (slug || "");
    }

    const list = store.read("products", []);
    const q = $("#productSearch")?.value?.toLowerCase() || "";
    tblProductsBody.innerHTML = "";
    list
        .filter(p => !q || (p.name + p.id).toLowerCase().includes(q))
        .forEach(p => {
            const tr = document.createElement("tr");
            tr.innerHTML = `
        <td>${p.id}</td>
        <td>${p.image ? `<img class="thumb" src="${p.image}" alt="">` : ""}</td>
        <td>${p.name}</td>
        <td>${labelBySlug(cats, p.category)}</td>
        <td>${labelBySlug(brands, p.brand)}</td>
        <td>${fmt(p.price || 0)}</td>
        <td>${p.stock ?? 0}</td>
        <td>${p.published ? '<span class="badge text-bg-success">Hiển thị</span>'
                : '<span class="badge text-bg-secondary">Ẩn</span>'}</td>
        <td class="text-end">
          <button class="btn btn-sm btn-outline-secondary me-1" data-act="edit"><i class="bi bi-pencil"></i></button>
          <button class="btn btn-sm btn-outline-danger" data-act="del"><i class="bi bi-trash"></i></button>
        </td>`;
            tr.querySelector('[data-act="edit"]')?.addEventListener("click", () => openProduct(p));
            tr.querySelector('[data-act="del"]')?.addEventListener("click", () => delProduct(p.id));
            tblProductsBody.appendChild(tr);
        });
    refreshStats();
}

$("#productSearch")?.addEventListener("input", renderProducts);
$("#btnAddProduct")?.addEventListener("click", () => openProduct());

function openProduct(p = null) {
    if (!formProduct || !productModal) {
        alert("Thiếu form/modal sản phẩm trong HTML.");
        return;
    }
    editingProductId = p ? p.id : null;

    $("#titleProduct") && ($("#titleProduct").textContent = p ? "Sửa sản phẩm" : "Thêm sản phẩm");

    // Đổ dropdown từ Categories/Brands đã lưu
    fillSelectOptions(formProduct.category, getPublishedCategories(), "slug", "name");
    fillSelectOptions(formProduct.brand, getPublishedBrands(), "slug", "name");

    // Set giá trị form
    formProduct.id.value = p?.id || "";
    formProduct.name.value = p?.name || "";
    formProduct.slug.value = p?.slug || "";
    formProduct.published.value = String(Boolean(p?.published ?? true));
    formProduct.category.value = p?.category || "";
    formProduct.brand.value = p?.brand || "";
    formProduct.price.value = p?.price || 0;
    formProduct.stock.value = p?.stock || 0;
    formProduct.image.value = p?.image || "";
    if (formProduct.description) formProduct.description.value = p?.description || "";

    // Auto-slug theo tên (cho tới khi user sửa tay slug)
    formProduct.name.oninput = () => {
        const auto = slugify(formProduct.name.value);
        if (!formProduct.slug.value || formProduct.slug.dataset.autofill === "1") {
            formProduct.slug.value = auto;
            formProduct.slug.dataset.autofill = "1";
        }
    };
    formProduct.slug.oninput = () => { formProduct.slug.dataset.autofill = "0"; };

    productModal.show();
}

/*submit của formProduct (để lưu đủ trường mới)*/
formProduct?.addEventListener("submit", (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(formProduct).entries());

    // Chuẩn hoá kiểu dữ liệu
    data.price = Number(data.price) || 0;
    data.stock = Number(data.stock) || 0;
    data.published = (data.published === "true");
    data.slug = (data.slug?.trim()) || slugify(data.name);

    // category/brand: value là slug từ <option>
    data.category = data.category || "";
    data.brand = data.brand || "";

    let list = store.read("products", []);

    // Check trùng mã
    if (editingProductId && editingProductId !== data.id && list.some(x => x.id === data.id)) {
        alert("Mã sản phẩm đã tồn tại!");
        return;
    }
    if (!editingProductId && list.some(x => x.id === data.id)) {
        alert("Mã sản phẩm đã tồn tại!");
        return;
    }

    if (editingProductId) {
        list = list.map(x => x.id === editingProductId ? data : x);
    } else {
        list.push(data);
    }
    store.write("products", list);
    renderProducts();
    productModal?.hide();
});


function delProduct(id) {
    if (confirm("Xoá sản phẩm?")) {
        store.write("products", store.read("products", []).filter(x => x.id !== id));
        renderProducts();
    }
}


// ===== Orders =====
$("#orderSearch")?.addEventListener("input", renderOrders);

// Giữ nguyên mapping trạng thái (đã có ở trên file của bạn)
// const STATUS = {moi: "Mới", xuly: "Đang xử lý", dagiao: "Đang giao", hoantat: "Hoàn tất", huy: "Huỷ"};

function renderOrders() {
    // LẤY tbody MỖI LẦN GỌI → tránh null khi script load trước DOM
    const tblOrdersBody = document.querySelector("#tblOrders tbody");
    if (!tblOrdersBody) return;

    const list = store.read("orders", []);
    const q = (document.querySelector("#orderSearch")?.value || "").toLowerCase();

    tblOrdersBody.innerHTML = "";
    list
        .filter(o => !q || (o.id + o.customer).toLowerCase().includes(q))
        .forEach(o => {
            const tr = document.createElement("tr");
            const items = (o.items || []).map(i => `${i.id} x${i.qty}`).join(", ");
            tr.innerHTML = `
        <td>${o.id}</td>
        <td>${o.customer}</td>
        <td>${o.date}</td>
        <td>${items}</td>
        <td>${fmt(o.total || 0)}</td>
        <td>
          <select class="form-select form-select-sm" data-status>
            ${Object.entries(STATUS).map(([k, v]) =>
                `<option value="${k}" ${o.status === k ? "selected" : ""}>${v}</option>`
            ).join("")}
          </select>
        </td>
        <td class="text-end">
          <button class="btn btn-sm btn-outline-danger" data-act="del">
            <i class="bi bi-trash"></i>
          </button>
        </td>`;

            // đổi trạng thái
            tr.querySelector("[data-status]")?.addEventListener("change", (e) => {
                const arr = store.read("orders", []);
                const i = arr.findIndex(x => x.id === o.id);
                if (i > -1) {
                    arr[i].status = e.target.value;
                    store.write("orders", arr);
                    refreshStats?.();
                }
            });

            // xoá đơn
            tr.querySelector('[data-act="del"]')?.addEventListener("click", () => {
                if (confirm("Xoá đơn hàng?")) {
                    store.write("orders", store.read("orders", []).filter(x => x.id !== o.id));
                    renderOrders();
                    refreshStats?.();
                }
            });

            tblOrdersBody.appendChild(tr);
        });
}


// ===== Customers =====
const tblCustomersBody = $("#tblCustomers tbody");
$("#customerSearch")?.addEventListener("input", renderCustomers);

function renderCustomers() {
    if (!tblCustomersBody) return;
    const list = store.read("customers", []), q = $("#customerSearch")?.value?.toLowerCase() || "";
    tblCustomersBody.innerHTML = "";
    list
        .filter(c => !q || (c.name + c.phone + c.id).toLowerCase().includes(q))
        .forEach(c => {
            const tr = document.createElement("tr");
            tr.innerHTML = `<td>${c.id}</td><td>${c.name}</td><td>${c.phone}</td><td>${c.email || ""}</td><td>${c.orders || 0}</td>`;
            tblCustomersBody.appendChild(tr);
        });
}

// ===== News =====
const tblNewsBody = $("#tblNews tbody");
let newsModal = null;
const formNews = $("#formNews");
try {
    newsModal = formNews ? new bootstrap.Modal("#modalNews") : null;
} catch {
    newsModal = null;
}
let editingNewsId = null;

$("#btnAddNews")?.addEventListener("click", () => openNews());
$("#newsSearch")?.addEventListener("input", renderNews);

function renderNews() {
    if (!tblNewsBody) return;
    const list = store.read("news", []), q = $("#newsSearch")?.value?.toLowerCase() || "";
    tblNewsBody.innerHTML = "";
    list
        .filter(n => !q || n.title.toLowerCase().includes(q))
        .forEach(n => {
            const tr = document.createElement("tr");
            tr.innerHTML = `
        <td>${n.id}</td><td>${n.title}</td><td>${n.date}</td>
        <td>${n.published ? '<span class="badge text-bg-success">Hiển thị</span>' : '<span class="badge text-bg-secondary">Ẩn</span>'}</td>
        <td class="text-end">
          <button class="btn btn-sm btn-outline-secondary me-1" data-act="edit"><i class="bi bi-pencil"></i></button>
          <button class="btn btn-sm btn-outline-danger" data-act="del"><i class="bi bi-trash"></i></button>
        </td>`;
            tr.querySelector('[data-act="edit"]')?.addEventListener("click", () => openNews(n));
            tr.querySelector('[data-act="del"]')?.addEventListener("click", () => {
                if (confirm("Xoá bài viết?")) {
                    store.write("news", store.read("news", []).filter(x => x.id !== n.id));
                    renderNews();
                }
            });
            tblNewsBody.appendChild(tr);
        });
}

function openNews(n = null) {
    if (!formNews || !newsModal) {
        alert("Thiếu form/modal tin tức trong HTML.");
        return;
    }
    editingNewsId = n ? n.id : null;
    $("#titleNews") && ($("#titleNews").textContent = n ? "Sửa bài viết" : "Thêm bài viết");
    formNews.id.value = n?.id || "";
    formNews.title.value = n?.title || "";
    formNews.date.value = n?.date || new Date().toISOString().slice(0, 10);
    formNews.published.value = String(Boolean(n?.published ?? true));
    formNews.content.value = n?.content || "";
    newsModal.show();
}

formNews?.addEventListener("submit", (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(formNews).entries());
    data.published = (data.published === "true");
    let arr = store.read("news", []);
    if (editingNewsId && editingNewsId !== data.id && arr.some(x => x.id === data.id)) {
        alert("Mã bài viết đã tồn tại!");
        return;
    }
    if (editingNewsId) {
        arr = arr.map(x => x.id === editingNewsId ? data : x);
    } else {
        if (arr.some(x => x.id === data.id)) {
            alert("Mã bài viết đã tồn tại!");
            return;
        }
        arr.push(data);
    }
    store.write("news", arr);
    renderNews();
    newsModal?.hide();
});


/* ================= Users block ================= */
function avatarByName(name, i) {
    // ảnh demo: cố định theo vị trí cho đẹp
    const pick = (i % 10) + 1;
    return `https://i.pravatar.cc/48?img=${pick}`;
}

function randFrom(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

function renderUsersTable() {
    const tb = $("#tblUsers tbody");
    if (!tb) return;
    const customers = store.read("customers", []);
    const activityTexts = ["10 seconds ago", "5 minutes ago", "1 hour ago", "1 week ago", "3 months ago", "1 year ago"];

    $("#usersSubtitle") && ($("#usersSubtitle").textContent = `${(1_232_150).toLocaleString("en-US")} registered users`); // text mẫu như ảnh
    tb.innerHTML = "";

    customers.slice(0, 7).forEach((c, idx) => {
        // usage demo dựa trên số đơn
        const usage = Math.min(100, (c.orders || 0) * 25 || 50);
        const act = randFrom(activityTexts);

        const tr = document.createElement("tr");
        tr.innerHTML = `
      <td><img src="${avatarByName(c.name || "U", idx)}" class="rounded-circle" width="36" height="36" alt=""></td>
      <td>
        <div class="fw-semibold">${c.name || "User"}</div>
        <div class="text-secondary small">New | Registered: Jan 10, 2023</div>
      </td>
      <td><span class="small">🇻🇳</span></td>
      <td style="min-width:180px">
        <div class="d-flex align-items-center gap-2">
          <span class="small fw-semibold">${usage}%</span>
          <div class="progress flex-grow-1" style="height:6px">
            <div class="progress-bar" style="width:${usage}%"></div>
          </div>
        </div>
        <div class="text-secondary small">Jun 11, 2023 – Jul 10, 2023</div>
      </td>
      <td>
        <div class="text-secondary small">Last login</div>
        <div class="fw-semibold small">${act}</div>
      </td>`;
        tb.appendChild(tr);
    });
}

let chartUsersSmall, chartConvSmall, chartSessSmall;

function renderUsersSideKpis() {
    const customers = store.read("customers", []);
    $("#kpiUsersSmall") && ($("#kpiUsersSmall").textContent = (26000).toLocaleString("en-US")); // giống ảnh (26K)
    $("#kpiConvSmall") && ($("#kpiConvSmall").textContent = "2.49%");
    $("#kpiSessSmall") && ($("#kpiSessSmall").textContent = "44K");

    if (typeof Chart === "undefined") return;
    // destroy cũ nếu có
    chartUsersSmall && chartUsersSmall.destroy();
    chartConvSmall && chartConvSmall.destroy();
    chartSessSmall && chartSessSmall.destroy();

    const el1 = $("#chartUsersSmall"), el2 = $("#chartConvSmall"), el3 = $("#chartSessSmall");
    if (el1) {
        chartUsersSmall = new Chart(el1, {
            type: "line",
            data: {
                labels: [1, 2, 3, 4, 5, 6, 7, 8],
                datasets: [{data: [18, 16, 22, 25, 24, 19, 21, 17], fill: false, borderColor: "#6f67ff", tension: .35}]
            },
            options: {plugins: {legend: {display: false}}, scales: {x: {display: false}, y: {display: false}}}
        });
    }
    if (el2) {
        chartConvSmall = new Chart(el2, {
            type: "line",
            data: {
                labels: [1, 2, 3, 4, 5, 6, 7, 8],
                datasets: [{
                    data: [2.6, 2.4, 2.7, 2.8, 2.9, 2.1, 2.3, 2.49],
                    fill: false,
                    borderColor: "#f1c40f",
                    tension: .35
                }]
            },
            options: {plugins: {legend: {display: false}}, scales: {x: {display: false}, y: {display: false}}}
        });
    }
    if (el3) {
        chartSessSmall = new Chart(el3, {
            type: "bar",
            data: {
                labels: Array.from({length: 12}, (_, i) => i + 1),
                datasets: [{data: [6, 7, 8, 4, 3, 5, 6, 7, 4, 3, 5, 8], backgroundColor: "#ff6b8a"}]
            },
            options: {plugins: {legend: {display: false}}, scales: {x: {display: false}, y: {display: false}}}
        });
    }
}

// ===== Customers CRUD (SAFE) =====
let customerModal = null;
const formCustomer = document.getElementById("formCustomer");

// chỉ tạo Modal nếu trang hiện có #modalCustomer (vd: customers.html)
try {
    const elCustomerModal = document.getElementById("modalCustomer");
    customerModal = elCustomerModal ? new bootstrap.Modal(elCustomerModal) : null;
} catch (e) {
    customerModal = null;
}

// Nút mở modal
document.getElementById("btnAddCustomer")?.addEventListener("click", () => {
    // nếu không có form/modal trên trang hiện tại thì bỏ qua
    if (!formCustomer || !customerModal) return;
    // reset và show
    formCustomer.reset();
    document.getElementById("titleCustomer").textContent = "Thêm khách hàng";
    customerModal.show();
});

// Submit form customer
formCustomer?.addEventListener("submit", (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(formCustomer).entries());
    data.orders = Number(data.orders) || 0;

    let list = store.read("customers", []);

    if (data.id?.trim() === "") {
        alert("Vui lòng nhập mã khách hàng");
        return;
    }

    // chống trùng mã
    const editingId = window.editingCustomerId; // dùng biến có sẵn của bạn nếu cần
    if (editingId && editingId !== data.id && list.some(c => c.id === data.id)) {
        alert("Mã khách hàng đã tồn tại!");
        return;
    }
    if (!editingId && list.some(c => c.id === data.id)) {
        alert("Mã khách hàng đã tồn tại!");
        return;
    }

    if (editingId) {
        list = list.map(c => c.id === editingId ? data : c);
    } else {
        list.push(data);
    }
    store.write("customers", list);
    // render nếu hàm có tồn tại ở trang hiện tại
    typeof renderCustomers === "function" && renderCustomers();
    customerModal?.hide();
});


// ===== Initial =====
// Auto-run theo trang đang mở:
const page = location.pathname.split("/").pop();

refreshStats();              // header KPI nho nhỏ (nếu có phần tử)
renderCharts();              // chỉ có ý nghĩa ở dashboard

if (page === "dashboard.html") {
    renderUsersTable?.();
    renderUsersSideKpis?.();
}
if (page === "products.html") renderProducts?.();
if (page === "orders.html") renderOrders?.();
if (page === "customers.html") renderCustomers?.();
if (page === "news_admin.html") renderNews?.();

/* =========================
   PATCH: CATEGORIES & BRANDS
   (append to the end of admin.js)
========================= */

// --- 0) Seed an toàn: chỉ tạo khi chưa có ---
(function seedCatBrandOnce(){
    const hasCats = Array.isArray(store.read("categories", null));
    const hasBrands = Array.isArray(store.read("brands", null));

    if (!hasCats) {
        store.write("categories", [
            { id:"CAT01", name:"Giày nam",  slug:"giay-nam",  published:true,  order:1, parent:"" },
            { id:"CAT02", name:"Giày nữ",   slug:"giay-nu",   published:true,  order:2, parent:"" },
            { id:"CAT03", name:"Kính mắt",  slug:"kinh-mat",  published:false, order:3, parent:"" },
            { id:"CAT04", name:"Đồng hồ",   slug:"dong-ho",   published:true,  order:4, parent:"" },
            { id:"CAT05", name:"Tai nghe",  slug:"tai-nghe",  published:false, order:5, parent:"" },
            { id:"CAT06", name:"Laptop",    slug:"laptop",    published:true,  order:6, parent:"" },
        ]);
    }
    if (!hasBrands) {
        store.write("brands", [
            { id:"BR01", name:"ADIDAS",  slug:"adidas",  published:true  },
            { id:"BR02", name:"NIKE",    slug:"nike",    published:true  },
            { id:"BR03", name:"Lacoste", slug:"lacoste", published:true  },
            { id:"BR04", name:"Puma",    slug:"puma",    published:true  },
            { id:"BR05", name:"Reebok",  slug:"reebok",  published:true  },
            { id:"BR06", name:"Mizuno",  slug:"mizuno",  published:true  },
        ]);
    }
})();

// --- 1) Helpers nhỏ ---
function $firstTableBody() {
    const tb = document.querySelector("table tbody");
    return tb || null;
}
function boolBadge(on, textTrue="Hiển thị", textFalse="Tạm ẩn") {
    return on
        ? `<span class="badge text-bg-success">${textTrue}</span>`
        : `<span class="badge text-bg-secondary">${textFalse}</span>`;
}
function ensureSlug(s){
    const v = (s||"").trim();
    return v ? v : slugify(s);
}

// --- 2) CATEGORIES PAGE ---
function renderCategories() {
    const tbody = $firstTableBody();
    if (!tbody) return;

    const list = store.read("categories", []);
    const inp = document.querySelector('input[placeholder*="Tìm"][placeholder*="slug"], input[placeholder*="Tìm tên"]');
    const q = (inp?.value || "").toLowerCase();

    tbody.innerHTML = "";
    list
        .filter(c => !q || (c.id + c.name + c.slug).toLowerCase().includes(q))
        .forEach(c => {
            const tr = document.createElement("tr");
            tr.innerHTML = `
        <td>${c.id}</td>
        <td>${c.name}</td>
        <td>${c.slug}</td>
        <td>${c.parent ? c.parent : '<span class="text-secondary">Tạm ẩn</span>'}</td>
        <td>${c.order ?? ""}</td>
        <td>${boolBadge(!!c.published)}</td>
        <td class="text-end">
          <button class="btn btn-sm btn-outline-secondary me-1" data-act="edit"><i class="bi bi-pencil"></i></button>
          <button class="btn btn-sm btn-outline-danger" data-act="del"><i class="bi bi-trash"></i></button>
        </td>
      `;
            tr.querySelector('[data-act="edit"]')?.addEventListener("click", () => openCatModal(c));
            tr.querySelector('[data-act="del"]')?.addEventListener("click", () => delCategory(c.id));
            tbody.appendChild(tr);
        });
}

function openCatModal(c=null){
    // dùng prompt để đơn giản hoá – không cần sửa HTML
    const id   = prompt("Mã danh mục:", c?.id || "");
    if (id===null) return;
    const name = prompt("Tên danh mục:", c?.name || "");
    if (!name) return;
    const slug = prompt("Slug:", c?.slug || slugify(name)) || slugify(name);
    const parent = prompt('Danh mục cha (để trống nếu không):', c?.parent || "") || "";
    const order = Number(prompt("Thứ tự (số):", c?.order ?? 1) || (c?.order ?? 1));
    const published = confirm('Hiển thị? (OK=Có)');

    let arr = store.read("categories", []);
    const existIdx = arr.findIndex(x => x.id === id);
    if (c){ // edit
        // nếu đổi mã sang id đang dùng bởi item khác
        if (id !== c.id && existIdx > -1) { alert("Mã bị trùng!"); return; }
        arr = arr.map(x => x.id === c.id ? { id, name, slug, parent, order, published } : x);
    } else { // add
        if (existIdx > -1) { alert("Mã đã tồn tại!"); return; }
        arr.push({ id, name, slug, parent, order, published });
    }
    store.write("categories", arr);
    renderCategories();
}

function delCategory(id){
    if (!confirm("Xoá danh mục này?")) return;
    store.write("categories", store.read("categories", []).filter(x => x.id !== id));
    renderCategories();
}

// events
(function wireCategoryPage(){
    const isCatPage = location.pathname.toLowerCase().endsWith("/categories.html")
        || location.pathname.toLowerCase().includes("/categories.html");
    if (!isCatPage) return;

    // nút Thêm nếu có
    const btnAdd = document.querySelector('#btnAddCategory, button:has(.bi-plus-lg)');
    btnAdd?.addEventListener("click", () => openCatModal());

    // ô tìm kiếm
    const inp = document.querySelector('input[placeholder*="Tìm"][placeholder*="slug"], input[placeholder*="Tìm tên"]');
    inp?.addEventListener("input", renderCategories);

    renderCategories();
})();

// --- 3) BRANDS PAGE ---
function renderBrands() {
    const tbody = $firstTableBody();
    if (!tbody) return;

    const list = store.read("brands", []);
    const inp = document.querySelector('input[placeholder*="Tìm"][placeholder*="slug"], input[placeholder*="Tìm tên"]');
    const q = (inp?.value || "").toLowerCase();

    tbody.innerHTML = "";
    list
        .filter(b => !q || (b.id + b.name + b.slug).toLowerCase().includes(q))
        .forEach(b => {
            const tr = document.createElement("tr");
            tr.innerHTML = `
        <td>${b.id}</td>
        <td>${b.name}</td>
        <td>${b.slug}</td>
        <td>${boolBadge(!!b.published)}</td>
        <td class="text-end">
          <button class="btn btn-sm btn-outline-secondary me-1" data-act="edit"><i class="bi bi-pencil"></i></button>
          <button class="btn btn-sm btn-outline-danger" data-act="del"><i class="bi bi-trash"></i></button>
        </td>
      `;
            tr.querySelector('[data-act="edit"]')?.addEventListener("click", () => openBrandModal(b));
            tr.querySelector('[data-act="del"]')?.addEventListener("click", () => delBrand(b.id));
            tbody.appendChild(tr);
        });
}

function openBrandModal(b=null){
    const id   = prompt("Mã nhãn hàng:", b?.id || "");
    if (id===null) return;
    const name = prompt("Tên nhãn hàng:", b?.name || "");
    if (!name) return;
    const slug = prompt("Slug:", b?.slug || slugify(name)) || slugify(name);
    const published = confirm('Hiển thị? (OK=Có)');

    let arr = store.read("brands", []);
    const existIdx = arr.findIndex(x => x.id === id);
    if (b){
        if (id !== b.id && existIdx > -1) { alert("Mã bị trùng!"); return; }
        arr = arr.map(x => x.id === b.id ? { id, name, slug, published } : x);
    } else {
        if (existIdx > -1) { alert("Mã đã tồn tại!"); return; }
        arr.push({ id, name, slug, published });
    }
    store.write("brands", arr);
    renderBrands();
}

function delBrand(id){
    if (!confirm("Xoá nhãn hàng này?")) return;
    store.write("brands", store.read("brands", []).filter(x => x.id !== id));
    renderBrands();
}

// events
(function wireBrandPage(){
    const isBrandPage = location.pathname.toLowerCase().endsWith("/brands.html")
        || location.pathname.toLowerCase().includes("/brands.html");
    if (!isBrandPage) return;

    const btnAdd = document.querySelector('#btnAddBrand, button:has(.bi-plus-lg)');
    btnAdd?.addEventListener("click", () => openBrandModal());

    const inp = document.querySelector('input[placeholder*="Tìm"][placeholder*="slug"], input[placeholder*="Tìm tên"]');
    inp?.addEventListener("input", renderBrands);

    renderBrands();
})();



