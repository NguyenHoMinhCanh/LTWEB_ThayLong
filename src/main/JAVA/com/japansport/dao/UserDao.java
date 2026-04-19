package com.japansport.dao;

import com.japansport.IDAO;
import com.japansport.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.japansport.util.PasswordUtil;

public class UserDao extends DAO implements IDAO<User> {
    @Override
    public List<User> getAll() {
        String sql = "SELECT u.id, u.email, u.password, u.name, u.phone, u.avatar, u.gender, u.birthday, u.active, " +
                "       (SELECT r.code FROM user_roles ur JOIN roles r ON r.id = ur.role_id " +
                "         WHERE ur.user_id = u.id " +
                "         ORDER BY CASE r.code WHEN 'ADMIN' THEN 1 WHEN 'STAFF' THEN 2 ELSE 3 END " +
                "         LIMIT 1) AS role_code " +
                "FROM users u";
        List<User> users = new ArrayList<>();
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // User ctor: (id, email, name, password, active)
                User u = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("password"),
                        rs.getInt("active"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                u.setGender(rs.getString("gender"));
                u.setBirthday(rs.getDate("birthday"));
                u.setRoleCode(rs.getString("role_code"));
                users.add(u);
            }
            return users;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public User getById(int id) {
        String sql = "SELECT u.id, u.email, u.password, u.name, u.phone, u.avatar, u.gender, u.birthday, u.active, " +
                "       (SELECT r.code FROM user_roles ur JOIN roles r ON r.id = ur.role_id " +
                "         WHERE ur.user_id = u.id " +
                "         ORDER BY CASE r.code WHEN 'ADMIN' THEN 1 WHEN 'STAFF' THEN 2 ELSE 3 END " +
                "         LIMIT 1) AS role_code " +
                "FROM users u WHERE u.id=?";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;

                User u = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("password"),
                        rs.getInt("active"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                u.setGender(rs.getString("gender"));
                u.setBirthday(rs.getDate("birthday"));
                u.setRoleCode(rs.getString("role_code"));
                return u;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(User user) {
        try {
            final Statement statement = getStatement();
            statement.executeUpdate("DELETE FROM users WHERE id=" + user.getId());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int insert(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, name, active) VALUES (?, ?, ?, ?)";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getName());
            ps.setInt(4, user.getActive());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next())
                        user.setId(keys.getInt(1));
                }
            }
            return affected;
        }
    }

    @Override
    public int update(User t) {
        try {
            final Statement statement = getStatement();
            ResultSet rs = statement.executeQuery("SELECT id FROM users WHERE id=" + t.getId());
            if (!rs.next()) {
                System.out.println("User doesn't exists" + t.getId());
                return 0;
            }
            String sql = String.format(
                    "update users set email ='%s', password ='%s', name='%s', active=%d where id=%d",
                    t.getEmail(), t.getPassword(), t.getName(), t.getActive(), t.getId());
            return statement.executeUpdate(sql);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void save(User t) {
        try {
            Statement st = getStatement();

            // Kiểm tra xem id đã tồn tại chưa
            ResultSet rs = st.executeQuery("SELECT id FROM users WHERE id=" + t.getId());
            if (rs.next()) {
                // Tồn tại -> UPDATE
                String sql = String.format(
                        "UPDATE users SET email='%s', password='%s', name='%s', active=%d WHERE id=%d",
                        t.getEmail(), t.getPassword(), t.getName(), t.getActive(), t.getId());
                int affected = st.executeUpdate(sql);
                System.out.println("save: UPDATE affected = " + affected);
            } else {
                // Chưa có -> INSERT với id do bạn truyền vào
                if (t.getId() <= 0) {
                    System.out.println("save: Không thể INSERT vì id <= 0 (đang dùng chiến lược tự đặt id).");
                    return;
                }
                String sql = String.format(
                        "INSERT INTO users (id, email, password, name, active) VALUES (%d,'%s','%s','%s',%d)",
                        t.getId(), t.getEmail(), t.getPassword(), t.getName(), t.getActive());
                int affected = st.executeUpdate(sql);
                System.out.println("save: INSERT affected = " + affected);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override

    public int inserts(List<User> t) {
        if (t == null || t.isEmpty())
            return 0;

        StringBuilder v = new StringBuilder();
        for (User u : t) {
            if (u == null || u.getId() <= 0)
                continue; // chỉ nhận id > 0
            if (v.length() > 0)
                v.append(",");
            v.append(String.format("(%d,'%s','%s','%s',%d)",
                    u.getId(), u.getEmail(), u.getPassword(), u.getName(), u.getActive()));
        }
        if (v.length() == 0)
            return 0;

        String sql = "INSERT IGNORE INTO users (id,email,password,name,active) VALUES " + v;
        try {
            Statement st = getStatement();
            return st.executeUpdate(sql); // số bản ghi chèn thành công
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /* Login */
    public User login(String email, String password) throws SQLException {

        // ✅ Join ra role_code từ bảng roles/user_roles
        // Nếu user có nhiều role -> ORDER ưu tiên ADMIN rồi STAFF rồi USER
        String sql = "SELECT u.id, u.email, u.password, u.name, u.phone, u.avatar, u.gender, u.birthday, u.active, " +
                "       r.code AS role_code " +
                "FROM users u " +
                "LEFT JOIN user_roles ur ON ur.user_id = u.id " +
                "LEFT JOIN roles r ON r.id = ur.role_id " +
                "WHERE u.email=? AND u.active=1 " +
                "ORDER BY CASE " +
                "   WHEN r.code='ADMIN' THEN 1 " +
                "   WHEN r.code='STAFF' THEN 2 " +
                "   WHEN r.code='USER' THEN 3 " +
                "   ELSE 4 END " +
                "LIMIT 1";

        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;

                String dbPass = rs.getString("password");
                if (!PasswordUtil.verify(password, dbPass))
                    return null;

                // Trả về user, KHÔNG set password ra ngoài
                User u = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        "", // không trả password
                        rs.getInt("active"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                u.setGender(rs.getString("gender"));
                u.setBirthday(rs.getDate("birthday"));

                // ✅ set roleCode cho AdminAuthFilter
                String roleCode = rs.getString("role_code");
                u.setRoleCode(roleCode); // null -> tự về USER
                return u;
            }
        }
    }

    // ================== DASHBOARD STATS ==================

    /** Tổng user (kể cả bị khóa). */
    public int countAllUsers() {
        String sql = "SELECT COUNT(*) AS total FROM users";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt("total");
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** Tổng user đang hoạt động (active = 1). */
    public int countActiveUsers() {
        String sql = "SELECT COUNT(*) AS total FROM users WHERE active = 1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt("total");
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /* Register */
    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM users WHERE email=? LIMIT 1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Tìm user theo email, không lọc active (dùng cho OAuth check)
    public User findByEmail(String email) {
        String sql = "SELECT u.id, u.email, u.password, u.name, u.phone, u.avatar, " +
                "u.gender, u.birthday, u.active, u.auth_provider, " +
                "(SELECT r.code FROM user_roles ur JOIN roles r ON r.id = ur.role_id " +
                " WHERE ur.user_id = u.id ORDER BY CASE r.code " +
                " WHEN 'ADMIN' THEN 1 WHEN 'STAFF' THEN 2 ELSE 3 END LIMIT 1) AS role_code " +
                "FROM users u WHERE u.email = ? LIMIT 1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                User u = new User(rs.getInt("id"), rs.getString("email"),
                        rs.getString("name"), rs.getString("password"), rs.getInt("active"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                u.setGender(rs.getString("gender"));
                u.setBirthday(rs.getDate("birthday"));
                u.setRoleCode(rs.getString("role_code"));
                u.setAuthProvider(rs.getString("auth_provider"));
                return u;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Tạo tài khoản từ Google (không có password)
    public User insertGoogleUser(String email, String name) throws SQLException {
        String sql = "INSERT INTO users (email, password, name, active, auth_provider) VALUES (?, '', ?, 1, 'google')";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, name);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (!keys.next()) throw new SQLException("Không lấy được ID sau insert");
                int newId = keys.getInt(1);
                // trả về object đủ thông tin để set session luôn
                User u = new User(newId, email, name, "", 1);
                u.setAuthProvider("google");
                return u;
            }
        }
    }

    /* Account/Profile */
    public boolean updateName(int userId, String name) {
        String sql = "UPDATE users SET name=? WHERE id=? AND active=1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean updatePassword(int userId, String passwordHash) {
        String sql = "UPDATE users SET password=? WHERE id=? AND active=1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, passwordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // update#profile: cập nhật thông tin tài khoản
    public boolean updateProfile(int userId, String name, String phone, String gender, java.sql.Date birthday) {
        String sql = "UPDATE users SET name=?, phone=?, gender=?, birthday=? WHERE id=? AND active=1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, gender);

            if (birthday != null)
                ps.setDate(4, birthday);
            else
                ps.setNull(4, java.sql.Types.DATE);

            ps.setInt(5, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // update#avatar: lưu đường dẫn avatar
    public boolean updateAvatar(int userId, String avatarPath) {
        String sql = "UPDATE users SET avatar=? WHERE id=? AND active=1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, avatarPath);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public User findActiveByEmail(String email) {
        String sql = "SELECT id, email, password, name, phone, avatar, gender, birthday, active " +
                "FROM users WHERE email=? AND active=1 LIMIT 1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;

                User u = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("password"),
                        rs.getInt("active"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                u.setGender(rs.getString("gender"));
                u.setBirthday(rs.getDate("birthday"));
                return u;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Integer getRoleIdByCode(String code) throws SQLException {
        String sql = "SELECT id FROM roles WHERE code = ? LIMIT 1";
        try (Connection cn = getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                return null;
            }
        }
    }

    public boolean setUserRole(int userId, String roleCode) throws SQLException {
        Integer roleId = getRoleIdByCode(roleCode);
        if (roleId == null)
            return false;

        try (Connection cn = getConnection()) {
            cn.setAutoCommit(false);
            try (
                    PreparedStatement del = cn.prepareStatement("DELETE FROM user_roles WHERE user_id=?");
                    PreparedStatement ins = cn
                            .prepareStatement("INSERT INTO user_roles(user_id, role_id) VALUES(?, ?)")) {
                del.setInt(1, userId);
                del.executeUpdate();

                ins.setInt(1, userId);
                ins.setInt(2, roleId);
                ins.executeUpdate();

                cn.commit();
                return true;
            } catch (SQLException e) {
                cn.rollback();
                throw e;
            } finally {
                cn.setAutoCommit(true);
            }
        }
    }

    public static void main(String[] args) throws SQLException {
        UserDao dao = new UserDao();

        // List<User> list = new ArrayList<>();
        // long ts = System.currentTimeMillis();
        //
        // list.add(new User(101, "u101_" + ts + "@mail.com", "123", "User 101", 1));
        // list.add(new User(102, "u102_" + ts + "@mail.com", "123", "User 102", 1));
        // list.add(new User(103, "u103_" + ts + "@mail.com", "123", "User 103", 0));
        // list.add(new User(102, "dup_" + ts + "@mail.com", "123", "Duplicate 102",
        // 1)); // trùng id -> từ chối thêm
        // list.add(new User(0, "bad_" + ts + "@mail.com", "123", "Bad ID 0", 1)); // id
        // <= 0 -> không thêm vào SQL
        //
        // int inserted = dao.inserts(list);
        // System.out.println("Inserted rows = " + inserted); // kỳ vọng 3
        //
        // // (Tuỳ chọn) xem nhanh tổng số user sau khi chèn
        // List<User> all = dao.getAll();
        // System.out.println("Total users now = " + all.size());

        // final List<User> all = dao.getAll();
        // System.out.println(all);

        // /* DELETE */
        // System.out.println(dao.getById(2));
        // dao.delete(dao.getById(102));

        /* INSERT */
        // User u = new User(3, "270803@gmail.com", "NLS", "12345", 1);
        // System.out.println("affected = " + dao.insert(u));

        // /*UPDATE*/
        // User u = new User(2, "270803@gmail.com", "123", "12345", 1);
        // User u1 = new User( 5, "2025@gmail.com", "111", "NLU", 0 );
        // dao.update(u1);
    }
}
