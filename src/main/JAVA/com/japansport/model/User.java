package com.japansport.model;

public class User {
    int id;
    String email;
    String password;
    String name;
    int active;
    String authProvider; // "local" hoặc "google"

    // update#profile (optional; phone nên để String)
    String phone;            // VARCHAR trong DB (giữ số 0 đầu, +84...)
    String avatar;           // vd: uploads/avatars/u18_xxx.png
    String gender;           // MALE/FEMALE/OTHER
    java.sql.Date birthday;  // yyyy-MM-dd

    // ✅ Role code lấy từ bảng roles (ADMIN/STAFF/USER...)
    String roleCode;

    public User(int id, String email, String name, String password, int active) {
        this.active = active;
        this.email = email;
        this.id = id;
        this.name = name;
        this.password = password;
        this.roleCode = "USER";
        this.authProvider = "local";
    }

    // (Tuỳ chọn) constructor có role
    public User(int id, String email, String name, String password, int active, String roleCode) {
        this(id, email, name, password, active);
        this.roleCode = (roleCode == null || roleCode.isBlank()) ? "USER" : roleCode;
    }

    public User() {
        this.roleCode = "USER";
        this.authProvider = "local";
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // ===== update#profile getters/setters =====
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public java.sql.Date getBirthday() {
        return birthday;
    }

    public void setBirthday(java.sql.Date birthday) {
        this.birthday = birthday;
    }

    public String getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(String authProvider) {
        this.authProvider = (authProvider == null) ? "local" : authProvider;
    }

    // ===== role getters/setters =====
    public String getRoleCode() {
        return roleCode;
    }

    public void setRoleCode(String roleCode) {
        this.roleCode = (roleCode == null || roleCode.isBlank()) ? "USER" : roleCode;
    }

    // ✅ AdminAuthFilter sẽ gọi hàm này
    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.roleCode) || "STAFF".equalsIgnoreCase(this.roleCode);
    }

    public boolean isActive() {
        return active == 1;
    }

    @Override
    public String toString() {
        return "User{" +
                "active=" + active +
                ", id=" + id +
                ", email='" + email + '\'' +
                ", password='" + password + '\'' +
                ", name='" + name + '\'' +
                ", roleCode='" + roleCode + '\'' +
                '}';
    }
}
