package com.japansport.model;

public class Category {
    private int id;
    private String name;
    private String image_url;
    private String link;
    private int is_featured;
    private int active;

    // ✅ field thêm cho ADMIN
    private String slug;           // SEO friendly URL
    private Integer parent_id;     // null = danh mục gốc
    private int display_order;     // thứ tự hiển thị

    // field phụ (không lưu DB) - join để hiển thị
    private String parentName;

    public Category() {
        this.active = 1;
        this.is_featured = 0;
        this.display_order = 0;
    }

    // constructor cũ (để không vỡ code bán hàng)
    public Category(int id, String name, String image_url,
                    String link, int is_featured, int active) {
        this.id = id;
        this.name = name;
        this.image_url = image_url;
        this.link = link;
        this.is_featured = is_featured;
        this.active = active;
        this.display_order = 0;
    }

    // constructor mới (admin)
    public Category(int id, String name, String slug, String image_url,
                    String link, Integer parent_id, int display_order,
                    int is_featured, int active) {
        this.id = id;
        this.name = name;
        this.slug = slug;
        this.image_url = image_url;
        this.link = link;
        this.parent_id = parent_id;
        this.display_order = display_order;
        this.is_featured = is_featured;
        this.active = active;
    }

    // ===== GETTER / SETTER =====
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public int getIs_featured() {
        return is_featured;
    }

    public void setIs_featured(int is_featured) {
        this.is_featured = is_featured;
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public Integer getParent_id() {
        return parent_id;
    }

    public void setParent_id(Integer parent_id) {
        this.parent_id = parent_id;
    }

    public int getDisplay_order() {
        return display_order;
    }

    public void setDisplay_order(int display_order) {
        this.display_order = display_order;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    // ===== helper =====
    public boolean isFeatured() {
        return this.is_featured == 1;
    }

    public boolean isActive() {
        return this.active == 1;
    }

    public boolean isParentCategory() {
        return this.parent_id == null;
    }

    // ✅ admin servlet có gọi Category.generateSlug(...)
    public static String generateSlug(String name) {
        if (name == null || name.trim().isEmpty()) return "";

        return name.toLowerCase()
                .trim()
                .replaceAll("\\s+", "-")
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9-]", "")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", slug='" + slug + '\'' +
                ", active=" + active +
                ", is_featured=" + is_featured +
                ", display_order=" + display_order +
                '}';
    }
}
