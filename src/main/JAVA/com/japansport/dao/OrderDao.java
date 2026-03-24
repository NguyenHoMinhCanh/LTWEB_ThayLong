package com.japansport.dao;

import com.japansport.model.CartItem;
import com.japansport.model.Order;
import com.japansport.model.OrderItem;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao extends DAO {

    public int placeOrderFromCart(
            int userId,
            String fullName, String phone,
            String addressLine, String city, String district, String ward,
            String payMethod, String note
    ) throws SQLException {

        Connection conn = getConnection();
        boolean oldAuto = conn.getAutoCommit();
        conn.setAutoCommit(false);

        try {
            // 1) Lấy cart ACTIVE (hướng B)
            int cartId = getOrCreateActiveCartId(conn, userId);

            // 2) Lock items để checkout an toàn (tránh đổi qty khi đang đặt)
            List<CartItem> items = getCartItemsForUpdate(conn, cartId);
            if (items.isEmpty()) {
                throw new SQLException("Giỏ hàng trống.");
            }

            // 3) Lưu địa chỉ (set default)
            int addressId = insertAddressAsDefault(
                    conn, userId, fullName, phone, addressLine, city, district, ward
            );

            // 4) Tính tổng tiền
            double total = 0;
            for (CartItem it : items) total += it.getSubtotal();

            // 5) Tạo order
            int orderId = insertOrder(conn, userId, addressId, total, "PENDING");

            // 6) Tạo order_items
            insertOrderItems(conn, orderId, items);

            // 7) Trừ tồn kho variant (nếu có variant)
            for (CartItem it : items) {
                if (it.getVariantId() != null) {
                    String upd = "UPDATE product_variants " +
                            "SET stock_qty = stock_qty - ? " +
                            "WHERE id=? AND stock_qty >= ?";
                    try (PreparedStatement ps = conn.prepareStatement(upd)) {
                        ps.setInt(1, it.getQuantity());
                        ps.setInt(2, it.getVariantId());
                        ps.setInt(3, it.getQuantity());
                        int affected = ps.executeUpdate();
                        if (affected != 1) {
                            throw new SQLException("Không đủ tồn kho cho biến thể: " + it.getVariantId());
                        }
                    }
                }
            }

            // 8) Clear cart_items
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM cart_items WHERE cart_id=?")) {
                ps.setInt(1, cartId);
                ps.executeUpdate();
            }

            // 9) Chốt cart ACTIVE -> ORDERED (Hướng B)
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE carts " +
                            "SET status='ORDERED', is_active=0, active_key=NULL, updated_at=CURRENT_TIMESTAMP " +
                            "WHERE id=?"
            )) {
                ps.setInt(1, cartId);
                ps.executeUpdate();
            }

            conn.commit();
            return orderId;

        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(oldAuto);
        }
    }

    /**
     * Hướng B:
     * - Tìm cart ACTIVE: carts.user_id = ? AND is_active = 1
     * - Nếu chưa có: tạo cart mới ACTIVE (active_key = user_id)
     * - Nếu bị trùng UNIQUE(active_key) do race-condition: query lại cart ACTIVE và trả về.
     */
    private int getOrCreateActiveCartId(Connection conn, int userId) throws SQLException {
        String find = "SELECT id FROM carts WHERE user_id=? AND is_active=1 ORDER BY updated_at DESC, id DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(find)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        }

        String ins = "INSERT INTO carts(user_id, status, is_active, active_key) VALUES(?, 'ACTIVE', 1, ?)";
        try (PreparedStatement ps = conn.prepareStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException ex) {
            // Nếu trùng UNIQUE(active_key) => đã có cart ACTIVE được tạo bởi request khác
            try (PreparedStatement ps2 = conn.prepareStatement(find)) {
                ps2.setInt(1, userId);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) return rs2.getInt("id");
                }
            }
            throw ex;
        }

        throw new SQLException("Cannot create active cart");
    }

    private List<CartItem> getCartItemsForUpdate(Connection conn, int cartId) throws SQLException {
        String sql =
                "SELECT ci.id AS cart_item_id, ci.product_id, ci.variant_id, ci.quantity, " +
                        "p.name, p.image_url, v.color, v.size, COALESCE(v.price, p.price) AS unit_price, v.stock_qty " +
                        "FROM cart_items ci " +
                        "JOIN products p ON p.id = ci.product_id " +
                        "LEFT JOIN product_variants v ON v.id = ci.variant_id " +
                        "WHERE ci.cart_id=? FOR UPDATE";

        List<CartItem> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem it = new CartItem();
                    it.setCartItemId(rs.getInt("cart_item_id"));
                    it.setProductId(rs.getInt("product_id"));

                    int vid = rs.getInt("variant_id");
                    it.setVariantId(rs.wasNull() ? null : vid);

                    it.setQuantity(rs.getInt("quantity"));
                    it.setProductName(rs.getString("name"));
                    it.setImageUrl(rs.getString("image_url"));
                    it.setColor(rs.getString("color"));
                    it.setSize(rs.getString("size"));
                    it.setUnitPrice(rs.getDouble("unit_price"));

                    int stock = rs.getInt("stock_qty");
                    it.setStockQty(rs.wasNull() ? -1 : stock);

                    list.add(it);
                }
            }
        }
        return list;
    }

    private int insertAddressAsDefault(Connection conn, int userId,
                                       String fullName, String phone, String addressLine,
                                       String city, String district, String ward) throws SQLException {

        try (PreparedStatement ps = conn.prepareStatement("UPDATE user_addresses SET is_default=0 WHERE user_id=?")) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }

        String ins =
                "INSERT INTO user_addresses(user_id, full_name, phone, address_line, city, district, ward, is_default) " +
                        "VALUES(?,?,?,?,?,?,?,1)";
        try (PreparedStatement ps = conn.prepareStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, addressLine);
            ps.setString(5, city);
            ps.setString(6, district);
            ps.setString(7, ward);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }

        throw new SQLException("Cannot insert address");
    }

    private int insertOrder(Connection conn, int userId, int addressId, double total, String status) throws SQLException {
        String ins = "INSERT INTO orders(user_id, address_id, total_amount, status) VALUES(?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, addressId);
            ps.setDouble(3, total);
            ps.setString(4, status);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }

        throw new SQLException("Cannot insert order");
    }

    private void insertOrderItems(Connection conn, int orderId, List<CartItem> items) throws SQLException {
        String ins = "INSERT INTO order_items(order_id, product_id, variant_id, color, size, quantity, unit_price, subtotal) " +
                "VALUES(?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(ins)) {
            for (CartItem it : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, it.getProductId());

                if (it.getVariantId() == null) ps.setNull(3, Types.INTEGER);
                else ps.setInt(3, it.getVariantId());

                ps.setString(4, it.getColor());
                ps.setString(5, it.getSize());
                ps.setInt(6, it.getQuantity());
                ps.setDouble(7, it.getUnitPrice());
                ps.setDouble(8, it.getSubtotal());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        try {
            String sql =
                    "SELECT o.id, o.user_id, o.address_id, o.total_amount, o.status, o.created_at, o.updated_at, " +
                            "u.name AS user_name, u.email AS user_email, " +
                            "ua.full_name, ua.phone, ua.address_line, ua.city, ua.district, ua.ward " +
                            "FROM orders o " +
                            "JOIN users u ON u.id = o.user_id " +
                            "JOIN user_addresses ua ON ua.id = o.address_id " +
                            "WHERE o.user_id = ? " +
                            "ORDER BY o.created_at DESC, o.id DESC";

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setAddressId(rs.getInt("address_id"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                o.setUpdatedAt(rs.getTimestamp("updated_at"));

                o.setUserName(rs.getString("user_name"));
                o.setUserEmail(rs.getString("user_email"));

                o.setFullName(rs.getString("full_name"));
                o.setPhone(rs.getString("phone"));
                o.setAddressLine(rs.getString("address_line"));
                o.setCity(rs.getString("city"));
                o.setDistrict(rs.getString("district"));
                o.setWard(rs.getString("ward"));

                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return list;
    }


    public Order getOrderByIdForUser(int orderId, int userId) {
        try {
            String sql =
                    "SELECT o.id, o.user_id, o.address_id, o.total_amount, o.status, o.created_at, o.updated_at, " +
                            "u.name AS user_name, u.email AS user_email, " +
                            "ua.full_name, ua.phone, ua.address_line, ua.city, ua.district, ua.ward " +
                            "FROM orders o " +
                            "JOIN users u ON u.id = o.user_id " +
                            "JOIN user_addresses ua ON ua.id = o.address_id " +
                            "WHERE o.id = ? AND o.user_id = ?";

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, orderId);
            ps.setInt(2, userId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setAddressId(rs.getInt("address_id"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                o.setUpdatedAt(rs.getTimestamp("updated_at"));

                o.setUserName(rs.getString("user_name"));
                o.setUserEmail(rs.getString("user_email"));

                o.setFullName(rs.getString("full_name"));
                o.setPhone(rs.getString("phone"));
                o.setAddressLine(rs.getString("address_line"));
                o.setCity(rs.getString("city"));
                o.setDistrict(rs.getString("district"));
                o.setWard(rs.getString("ward"));
                return o;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return null;
    }


    // update#2
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        try {
            String sql =
                    "SELECT oi.id, oi.order_id, oi.product_id, oi.variant_id, oi.color, oi.size, " +
                            "oi.quantity, oi.unit_price, oi.subtotal, " +
                            "p.name AS product_name, p.image_url AS product_image_url " +
                            "FROM order_items oi " +
                            "JOIN products p ON p.id = oi.product_id " +
                            "WHERE oi.order_id = ? " +
                            "ORDER BY oi.id ASC";

            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem it = new OrderItem();
                it.setId(rs.getInt("id"));
                it.setOrderId(rs.getInt("order_id"));
                it.setProductId(rs.getInt("product_id"));

                int v = rs.getInt("variant_id");
                it.setVariantId(rs.wasNull() ? null : v);

                it.setColor(rs.getString("color"));
                it.setSize(rs.getString("size"));
                it.setQuantity(rs.getInt("quantity"));
                it.setUnitPrice(rs.getDouble("unit_price"));
                it.setSubtotal(rs.getDouble("subtotal"));

                it.setProductName(rs.getString("product_name"));
                it.setProductImageUrl(rs.getString("product_image_url"));

                list.add(it);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return list;
    }

    /**
     * Hủy đơn hàng của user.
     * Quy ước:
     *  - Chỉ cho hủy khi đơn đang ở trạng thái PENDING (chờ xử lý).
     *  - Khi hủy: cập nhật orders.status = 'CANCEL' và hoàn lại stock_qty cho các variant trong order_items.
     *
     * @return 1 nếu hủy thành công; 0 nếu không tìm thấy/không thuộc user; -1 nếu trạng thái không cho phép hủy
     */
    public int cancelOrderForUser(int orderId, int userId) {
        Connection conn = null;
        boolean oldAuto = true;

        try {
            conn = getConnection();
            oldAuto = conn.getAutoCommit();
            conn.setAutoCommit(false);

            // Lock order row để tránh race-condition
            String lockOrder = "SELECT status FROM orders WHERE id=? AND user_id=? FOR UPDATE";
            String status = null;
            try (PreparedStatement ps = conn.prepareStatement(lockOrder)) {
                ps.setInt(1, orderId);
                ps.setInt(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) status = rs.getString("status");
                    else {
                        conn.rollback();
                        return 0;
                    }
                }
            }

            if (status == null || !"PENDING".equalsIgnoreCase(status)) {
                conn.rollback();
                return -1;
            }

            // Update status -> CANCEL (chỉ khi đang PENDING)
            String upd = "UPDATE orders SET status='CANCEL', updated_at=CURRENT_TIMESTAMP WHERE id=? AND user_id=? AND status='PENDING'";
            try (PreparedStatement ps = conn.prepareStatement(upd)) {
                ps.setInt(1, orderId);
                ps.setInt(2, userId);
                int affected = ps.executeUpdate();
                if (affected != 1) {
                    conn.rollback();
                    return -1;
                }
            }

            // Hoàn lại tồn kho cho variant (nếu có)
            String itemsSql = "SELECT variant_id, quantity FROM order_items WHERE order_id=? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(itemsSql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int vid = rs.getInt("variant_id");
                        if (rs.wasNull()) continue;
                        int qty = rs.getInt("quantity");

                        String addStock = "UPDATE product_variants SET stock_qty = stock_qty + ? WHERE id=?";
                        try (PreparedStatement ps2 = conn.prepareStatement(addStock)) {
                            ps2.setInt(1, qty);
                            ps2.setInt(2, vid);
                            ps2.executeUpdate();
                        }
                    }
                }
            }

            conn.commit();
            return 1;

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ignored) {}
            e.printStackTrace();
            return 0;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(oldAuto);
            } catch (Exception ignored) {}
        }
    }

    // ================== ADMIN METHODS (added) ==================

    /**
     * Admin hủy đơn: chỉ cho hủy khi đơn đang PENDING, đồng thời hoàn tồn kho.
     * @return 1: success; 0: not found; -1: invalid status; -2: error
     */
    public int adminCancelOrder(int orderId) {
        Connection conn = null;
        boolean oldAuto = true;

        try {
            conn = getConnection();
            oldAuto = conn.getAutoCommit();
            conn.setAutoCommit(false);

            // Lock order row
            String lockOrder = "SELECT status FROM orders WHERE id=? FOR UPDATE";
            String status = null;
            try (PreparedStatement ps = conn.prepareStatement(lockOrder)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) status = rs.getString("status");
                    else {
                        conn.rollback();
                        return 0;
                    }
                }
            }

            if (status == null || !"PENDING".equalsIgnoreCase(status)) {
                conn.rollback();
                return -1;
            }

            // Update status -> CANCEL (chỉ khi đang PENDING)
            String upd = "UPDATE orders SET status='CANCEL', updated_at=CURRENT_TIMESTAMP WHERE id=? AND status='PENDING'";
            try (PreparedStatement ps = conn.prepareStatement(upd)) {
                ps.setInt(1, orderId);
                int affected = ps.executeUpdate();
                if (affected != 1) {
                    conn.rollback();
                    return -1;
                }
            }

            // Hoàn lại tồn kho
            String itemsSql = "SELECT variant_id, quantity FROM order_items WHERE order_id=? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(itemsSql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int vid = rs.getInt("variant_id");
                        if (rs.wasNull()) continue;
                        int qty = rs.getInt("quantity");

                        String addStock = "UPDATE product_variants SET stock_qty = stock_qty + ? WHERE id=?";
                        try (PreparedStatement ps2 = conn.prepareStatement(addStock)) {
                            ps2.setInt(1, qty);
                            ps2.setInt(2, vid);
                            ps2.executeUpdate();
                        }
                    }
                }
            }

            conn.commit();
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return -2;
        } finally {
            try { if (conn != null) conn.setAutoCommit(oldAuto); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }


    public List<Order> adminGetAll(String status, String keyword) {
        List<Order> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.id, o.user_id, o.address_id, o.total_amount, o.status, o.created_at, o.updated_at, ");
        sql.append("u.name AS user_name, u.email AS user_email, ");
        sql.append("a.full_name, a.phone, a.address_line, a.city, a.district, a.ward ");
        sql.append("FROM orders o ");
        sql.append("JOIN users u ON u.id = o.user_id ");
        sql.append("JOIN user_addresses a ON a.id = o.address_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (status != null) {
            sql.append(" AND o.status = ? ");
            params.add(status);
        }

        if (keyword != null) {
            sql.append(" AND (a.full_name LIKE ? OR a.phone LIKE ? OR u.email LIKE ? OR u.name LIKE ?) ");
            String k = "%" + keyword + "%";
            params.add(k); params.add(k); params.add(k); params.add(k);
        }

        sql.append(" ORDER BY o.created_at DESC, o.id DESC");

        try {
            PreparedStatement ps = getPreparedStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setAddressId(rs.getInt("address_id"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                o.setUpdatedAt(rs.getTimestamp("updated_at"));

                o.setFullName(rs.getString("full_name"));
                o.setPhone(rs.getString("phone"));
                o.setAddressLine(rs.getString("address_line"));
                o.setCity(rs.getString("city"));
                o.setDistrict(rs.getString("district"));
                o.setWard(rs.getString("ward"));

                list.add(o);
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return list;
        }
    }

    public Order adminGetById(int orderId) {
        String sql =
                "SELECT o.id, o.user_id, o.address_id, o.total_amount, o.status, o.created_at, o.updated_at, " +
                        "u.name AS user_name, u.email AS user_email, " +
                        "a.full_name, a.phone, a.address_line, a.city, a.district, a.ward " +
                        "FROM orders o " +
                        "JOIN users u ON u.id = o.user_id " +
                        "JOIN user_addresses a ON a.id = o.address_id " +
                        "WHERE o.id = ?";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setAddressId(rs.getInt("address_id"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                o.setUpdatedAt(rs.getTimestamp("updated_at"));

                o.setFullName(rs.getString("full_name"));
                o.setPhone(rs.getString("phone"));
                o.setAddressLine(rs.getString("address_line"));
                o.setCity(rs.getString("city"));
                o.setDistrict(rs.getString("district"));
                o.setWard(rs.getString("ward"));

                return o;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean adminUpdateStatus(int orderId, String status) {
        // status hợp lệ tuỳ bạn định nghĩa, ở đây chấp nhận chuỗi bất kỳ để bạn test nhanh
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // ================== DASHBOARD STATS ==================

    /** Tổng số đơn hàng (không lọc status). */
    public int countAllOrders() {
        String sql = "SELECT COUNT(*) AS total FROM orders";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** Đếm đơn theo status (PENDING/PAID/SHIPPING/DONE/CANCEL). */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) AS total FROM orders WHERE status = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** Doanh thu: chỉ tính đơn đã thanh toán / hoàn tất. */
    public double sumRevenuePaidDone() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) AS total FROM orders WHERE status IN ('PAID','DONE')";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble("total");
            return 0d;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0d;
        }
    }

    /**
     * Doanh thu theo ngày trong N ngày gần nhất (tính PAID/DONE).
     * Trả về list: mỗi phần tử là Object[]{java.sql.Date day, Double total}
     */
    public List<Object[]> revenueByDayLastNDays(int days) {
        List<Object[]> list = new ArrayList<>();
        String sql =
                "SELECT DATE(COALESCE(updated_at, created_at)) AS d, COALESCE(SUM(total_amount),0) AS total " +
                        "FROM orders " +
                        "WHERE status IN ('PAID','DONE') " +
                        "    AND COALESCE(updated_at, created_at) >= DATE_SUB(CURDATE(), INTERVAL ? DAY) " +
                        "GROUP BY DATE(COALESCE(updated_at, created_at)) " +
                        "ORDER BY d";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, Math.max(0, days - 1));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{rs.getDate("d"), rs.getDouble("total")});
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return list;
        }
    }
}