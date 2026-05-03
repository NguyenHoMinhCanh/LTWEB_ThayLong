package com.japansport.model;

import java.time.LocalDateTime;

public class Promotion {

    private int id;
    private String name;       // Tên đợt: "Flash Sale 30/4"
    private String label;      // Nhãn hiển thị: "SALE", "HOT", "-30%"
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private boolean active;
    private LocalDateTime createdAt;

    public Promotion() {}

    // ========== ID ==========
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    // ========== NAME ==========
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    // ========== LABEL ==========
    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    // ========== DATE ==========
    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

    // ========== ACTIVE ==========
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    // ========== CREATED AT ==========
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    // Kiểm tra promotion có đang trong thời hạn không
    public boolean isCurrentlyValid() {
        if (!active) return false;
        LocalDateTime now = LocalDateTime.now();
        if (startDate != null && now.isBefore(startDate)) return false;
        if (endDate != null && now.isAfter(endDate)) return false;
        return true;
    }
}
