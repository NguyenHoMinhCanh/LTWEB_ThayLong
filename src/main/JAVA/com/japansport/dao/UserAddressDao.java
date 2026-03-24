package com.japansport.dao;

import com.japansport.model.UserAddress;

import java.sql.*;

/**
 * UserAddressDao: chỉ xử lý địa chỉ giao hàng của user (bảng user_addresses).
 * Mục tiêu: đơn giản nhưng đúng chuẩn ecommerce -> 1 địa chỉ mặc định.
 */
public class UserAddressDao extends DAO {

    public UserAddress getDefaultByUserId(int userId) {
        String sql = "SELECT id, user_id, full_name, phone, address_line, city, district, ward, is_default, created_at " +
                "FROM user_addresses WHERE user_id=? AND is_default=1 ORDER BY id DESC LIMIT 1";
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                UserAddress a = new UserAddress();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setFullName(rs.getString("full_name"));
                a.setPhone(rs.getString("phone"));
                a.setAddressLine(rs.getString("address_line"));
                a.setCity(rs.getString("city"));
                a.setDistrict(rs.getString("district"));
                a.setWard(rs.getString("ward"));
                a.setDefault(rs.getInt("is_default") == 1);
                a.setCreatedAt(rs.getTimestamp("created_at"));
                return a;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Lưu địa chỉ mặc định:
     * - Clear is_default của user
     * - Insert bản ghi mới is_default=1
     * (Giống logic đặt hàng trong OrderDao, nhưng dùng cho trang Account)
     */
    public boolean saveDefaultAddress(int userId,
                                      String fullName,
                                      String phone,
                                      String addressLine,
                                      String city,
                                      String district,
                                      String ward) {

        String clear = "UPDATE user_addresses SET is_default=0 WHERE user_id=?";
        String ins = "INSERT INTO user_addresses(user_id, full_name, phone, address_line, city, district, ward, is_default) " +
                "VALUES(?,?,?,?,?,?,?,1)";

        Connection cn = null;
        try {
            cn = getConnection();
            cn.setAutoCommit(false);

            try (PreparedStatement ps = cn.prepareStatement(clear)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = cn.prepareStatement(ins)) {
                ps.setInt(1, userId);
                ps.setString(2, fullName);
                ps.setString(3, phone);
                ps.setString(4, addressLine);
                ps.setString(5, city);
                ps.setString(6, district);
                ps.setString(7, ward);
                ps.executeUpdate();
            }

            cn.commit();
            return true;

        } catch (Exception e) {
            if (cn != null) {
                try { cn.rollback(); } catch (SQLException ignored) {}
            }
            throw new RuntimeException(e);
        } finally {
            if (cn != null) {
                try { cn.setAutoCommit(true); } catch (SQLException ignored) {}
                try { cn.close(); } catch (SQLException ignored) {}
            }
        }
    }
}
