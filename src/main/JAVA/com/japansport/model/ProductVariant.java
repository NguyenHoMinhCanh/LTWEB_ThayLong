package com.japansport.model;

import java.io.Serializable;
import java.sql.Timestamp;


public class ProductVariant implements Serializable {
    private int id;
    private int productId;
    private String color;
    private String size;
    private int stockQty;
    private String sku;
    private Double price; // nullable
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public ProductVariant() {
    }

    public ProductVariant(int id, int productId, String color, String size, int stockQty, String sku, Double price) {
        this.id = id;
        this.productId = productId;
        this.color = color;
        this.size = size;
        this.stockQty = stockQty;
        this.sku = sku;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    // IMPORTANT: JSP của bạn dùng v.getStockQty()
    public int getStockQty() {
        return stockQty;
    }

    public void setStockQty(int stockQty) {
        this.stockQty = stockQty;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
