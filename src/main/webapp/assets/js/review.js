(() => {
    "use strict";

    // ===== Helpers =====
    const $ = (sel, root = document) => root.querySelector(sel);
    const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));

    const escapeHtml = (s) =>
        String(s ?? "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");

    const maskName = (name) => {
        const n = String(name ?? "").trim();
        if (!n) return "Ẩn danh";
        if (n.length <= 2) return n[0] + "*";
        return n.slice(0, 3) + "***";
    };

    const formatDate = (v) => {
        if (!v) return "";
        // hỗ trợ "2025-12-11 23:45:59" hoặc ISO
        const s = String(v).replace(" ", "T");
        const d = new Date(s);
        if (isNaN(d.getTime())) return String(v);
        const pad = (x) => String(x).padStart(2, "0");
        return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(
            d.getHours()
        )}:${pad(d.getMinutes())}`;
    };

    const starIcons = (rating) => {
        const r = Math.max(0, Math.min(5, Number(rating || 0)));
        let html = "";
        for (let i = 1; i <= 5; i++) {
            html += i <= r ? "★" : "☆";
        }
        return html;
    };

    // ===== Normalize API Response =====
    // Chấp nhận nhiều format:
    // 1) Array reviews
    // 2) {reviews:[], total, stats}
    // 3) {data:[], meta:{...}}
    // 4) {items:[]}
    function normalizeResponse(json) {
        if (Array.isArray(json)) {
            return { reviews: json, total: json.length, stats: null };
        }

        if (json && Array.isArray(json.reviews)) {
            return {
                reviews: json.reviews,
                total: json.total ?? json.reviews.length,
                stats: json.stats ?? null,
            };
        }

        if (json && Array.isArray(json.data)) {
            return {
                reviews: json.data,
                total: json.total ?? json.data.length,
                stats: json.stats ?? json.meta?.stats ?? null,
            };
        }

        if (json && Array.isArray(json.items)) {
            return { reviews: json.items, total: json.total ?? json.items.length, stats: json.stats ?? null };
        }

        return { reviews: [], total: 0, stats: null };
    }

    function computeStats(reviews) {
        const counts = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
        let sum = 0;

        for (const r of reviews) {
            const rating = Number(r.rating ?? r.stars ?? 0);
            if (rating >= 1 && rating <= 5) counts[rating] += 1;
            sum += rating;
        }

        const total = reviews.length;
        const avg = total ? sum / total : 0;

        return { avg, total, counts };
    }

    function renderStats(stats) {
        const avgEl = $("#rvAvg");
        const countTextEl = $("#rvCountText");
        const avgStarsEl = $("#rvAvgStars");

        const avg = Number(stats?.avg ?? 0);
        const total = Number(stats?.total ?? 0);
        const counts = stats?.counts ?? { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };

        if (avgEl) avgEl.textContent = avg.toFixed(1);
        if (countTextEl) countTextEl.textContent = `${total} đánh giá`;
        if (avgStarsEl) avgStarsEl.textContent = starIcons(Math.round(avg));

        for (let i = 1; i <= 5; i++) {
            const cntEl = $(`#rvCnt${i}`);
            const barEl = $(`#rvBar${i}`);
            const c = Number(counts[i] ?? 0);
            if (cntEl) cntEl.textContent = c;

            if (barEl) {
                const percent = total ? (c / total) * 100 : 0;
                barEl.style.width = `${percent}%`;
                barEl.setAttribute("aria-valuenow", String(percent));
            }
        }
    }

    function renderList(reviews) {
        const listEl = $("#rvList");
        if (!listEl) return;

        if (!reviews || reviews.length === 0) {
            listEl.innerHTML = `<div class="text-muted py-3">Chưa có đánh giá nào.</div>`;
            return;
        }

        const html = reviews
            .map((r) => {
                const name =
                    r.userName ?? r.username ?? r.fullName ?? r.name ?? r.user_name ?? "Ẩn danh";
                const rating = Number(r.rating ?? r.stars ?? 0);
                const comment = r.comment ?? r.content ?? "";
                const created = r.createdAt ?? r.created_at ?? r.created ?? "";

                return `
          <div class="border rounded-3 p-3 mb-3">
            <div class="d-flex justify-content-between align-items-start gap-3">
              <div>
                <div class="fw-bold">${escapeHtml(maskName(name))}</div>
                <div class="text-muted small">${escapeHtml(formatDate(created))}</div>
              </div>
              <div class="text-end" style="color:#f5a623; font-size:18px; line-height:1;">
                ${starIcons(rating)}
                <div class="text-muted small" style="color:#6c757d;">${rating}/5</div>
              </div>
            </div>
            <div class="mt-2">${escapeHtml(comment)}</div>
          </div>
        `;
            })
            .join("");

        listEl.innerHTML = html;
    }

    // ===== Main =====
    document.addEventListener("DOMContentLoaded", async () => {
        const section = document.getElementById("reviewSection");
        if (!section) return;

        const productId =
            section.dataset.productId || new URLSearchParams(location.search).get("id");
        const apiUrl = section.dataset.api; // vd: /demo/api/reviews
        if (!apiUrl || !productId) {
            console.warn("Missing data-api or productId for reviews");
            return;
        }

        const sortEl = document.getElementById("rvSort");
        const filterWrap = document.getElementById("rvFilters");

        const state = {
            rating: 0, // 0 = all
            sort: sortEl ? sortEl.value : "newest",
        };

        const setLoading = (on) => {
            const loadingEl = document.getElementById("rvLoading");
            if (loadingEl) loadingEl.style.display = on ? "block" : "none";
        };

        const setError = (msg) => {
            const errEl = document.getElementById("rvError");
            if (!errEl) return;
            if (!msg) {
                errEl.style.display = "none";
                errEl.textContent = "";
            } else {
                errEl.style.display = "block";
                errEl.textContent = msg;
            }
        };

        const buildUrl = () => {
            const u = new URL(apiUrl, window.location.origin);
            u.searchParams.set("productId", productId);

            if (state.rating && Number(state.rating) > 0) {
                u.searchParams.set("rating", String(state.rating));
            }
            if (state.sort) {
                u.searchParams.set("sort", state.sort);
            }
            return u.toString();
        };

        async function loadReviews() {
            setError("");
            setLoading(true);

            try {
                const res = await fetch(buildUrl(), {
                    headers: { Accept: "application/json" },
                });

                if (!res.ok) throw new Error(`HTTP ${res.status}`);

                const json = await res.json();
                const norm = normalizeResponse(json);

                // Nếu API trả cả stats thì ưu tiên, không thì tự tính
                const stats = norm.stats
                    ? {
                        avg: Number(norm.stats.avg ?? norm.stats.average ?? 0),
                        total: Number(norm.stats.total ?? norm.total ?? norm.reviews.length),
                        counts:
                            norm.stats.counts ??
                            norm.stats.breakdown ??
                            norm.stats.byStar ??
                            computeStats(norm.reviews).counts,
                    }
                    : computeStats(norm.reviews);

                renderStats(stats);
                renderList(norm.reviews);
            } catch (e) {
                console.error(e);
                renderStats({ avg: 0, total: 0, counts: { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 } });
                renderList([]);
                setError(`Không tải được đánh giá. (${e.message})`);
            } finally {
                setLoading(false);
            }
        }

        // Filter buttons: bắt theo data-rating
        if (filterWrap) {
            filterWrap.addEventListener("click", (ev) => {
                const btn = ev.target.closest("[data-rating]");
                if (!btn) return;

                state.rating = Number(btn.dataset.rating || 0);

                // Active UI
                $$("#rvFilters [data-rating]").forEach((b) => b.classList.remove("active"));
                btn.classList.add("active");

                loadReviews();
            });
        }

        // Sort dropdown
        if (sortEl) {
            sortEl.addEventListener("change", () => {
                state.sort = sortEl.value;
                loadReviews();
            });
        }

        // First load
        loadReviews();
    });
})();
