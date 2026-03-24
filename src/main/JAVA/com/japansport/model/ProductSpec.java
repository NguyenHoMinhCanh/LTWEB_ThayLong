package com.japansport.model;

import java.sql.Timestamp;

/**
 * Thông số kỹ thuật dạng key-value cho từng sản phẩm.
 * Ví dụ: (Chất liệu, Mesh), (Đế, Cao su), (Trọng lượng, 250g)...
 */
public class ProductSpec {

    private int id;
    private int productId;
    private String specKey;
    private String specValue;
    private int sortOrder;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public ProductSpec() {
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

    public String getSpecKey() {
        return specKey;
    }

    public void setSpecKey(String specKey) {
        this.specKey = specKey;
    }

    public String getSpecValue() {
        return specValue;
    }

    public void setSpecValue(String specValue) {
        this.specValue = specValue;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
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
