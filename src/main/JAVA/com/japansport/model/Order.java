package com.japansport.model;

import java.sql.Timestamp;

public class Order {
    private int id;
    private int userId;
    private int addressId;
    private double totalAmount;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Thông tin user (join từ users)
    private String userName;
    private String userEmail;

    // Thông tin giao hàng (join từ user_addresses) (join từ user_addresses)
    private String fullName;
    private String phone;
    private String addressLine;
    private String city;
    private String district;
    private String ward;

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

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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



    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddressLine() {
        return addressLine;
    }

    public void setAddressLine(String addressLine) {
        this.addressLine = addressLine;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();
        if (addressLine != null && !addressLine.isBlank()) sb.append(addressLine);
        if (ward != null && !ward.isBlank()) sb.append(", ").append(ward);
        if (district != null && !district.isBlank()) sb.append(", ").append(district);
        if (city != null && !city.isBlank()) sb.append(", ").append(city);
        return sb.toString();
    }

    public String getStatusVi() {
        if (status == null) return "Không rõ";
        switch (status.toUpperCase()) {
            case "PENDING":
                return "Chờ xử lý";
            case "PAID":
                return "Đã thanh toán";
            case "SHIPPING":
                return "Đang giao";
            case "DONE":
                return "Hoàn tất";
            case "CANCEL":
                return "Đã hủy";
            default:
                return status;
        }
    }
}
