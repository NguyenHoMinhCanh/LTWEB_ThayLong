package com.japansport.model;

public class Product {

    private int id;
    private String name;
    private String description;   // mô tả chi tiết sản phẩm (có thể null)
    private String image_url;
    private double price;
    private double old_price;
    private String gender;        // men / women / unisex...
    private Integer categoryId;   // id danh mục, có thể null
    private Integer brandId;      // id thương hiệu, có thể null
    private boolean active = true;   // 1: hiển thị, 0: ẩn

    // Tham chiếu sang Brand (dùng khi JOIN để hiển thị logo, tên brand)
    private Brand brand;

    public Product() {
    }

    // ========== ID ==========
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // ========== NAME ==========
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // ========== DESCRIPTION ==========
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // ========== IMAGE URL ==========
    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    // ========== PRICE / OLD_PRICE ==========
    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getOld_price() {
        return old_price;
    }

    public void setOld_price(double old_price) {
        this.old_price = old_price;
    }

    // ========== GENDER ==========
    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    // ========== CATEGORY ==========
    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    // ========== BRAND ID ==========
    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    // ========== BRAND OBJECT ==========
    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }
}
