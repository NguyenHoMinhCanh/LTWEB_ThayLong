package com.japansport.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Cart (giỏ hàng) = phần "header" bao danh sách CartItem.
 * <p>
 * Hướng B (mỗi user chỉ có 1 cart ACTIVE):
 * - Một user có thể có nhiều cart trong lịch sử (ORDERED/ABANDONED),
 * nhưng tại một thời điểm chỉ có 1 cart ACTIVE (isActive=true).
 */
public class Cart {
    private int id;
    private int userId;

    // ACTIVE / ORDERED / ABANDONED (tuỳ hệ thống)
    private String status;
    private boolean active;

    private List<CartItem> items = new ArrayList<>();

    public Cart() {
    }

    public Cart(int id, int userId, String status, boolean active, List<CartItem> items) {
        this.id = id;
        this.userId = userId;
        this.status = status;
        this.active = active;
        setItems(items);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public List<CartItem> getItems() {
        return items == null ? Collections.emptyList() : items;
    }

    public void setItems(List<CartItem> items) {
        this.items = (items == null) ? new ArrayList<>() : new ArrayList<>(items);
    }

    public boolean isEmpty() {
        return getItems().isEmpty();
    }

    /**
     * Tổng số lượng trong giỏ
     */
    public int getTotalQty() {
        int total = 0;
        for (CartItem it : getItems()) total += it.getQuantity();
        return total;
    }

    /**
     * Tổng tiền hàng (chưa ship/giảm giá)
     */
    public double getSubtotal() {
        double total = 0;
        for (CartItem it : getItems()) total += it.getSubtotal();
        return total;
    }
}
