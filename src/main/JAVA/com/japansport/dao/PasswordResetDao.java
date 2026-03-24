package com.japansport.dao;

import com.japansport.model.PasswordResetToken;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class PasswordResetDao extends DAO {

    public boolean create(int userId, String tokenHash, Timestamp expiresAt, String requestIp) {
        String sql = "INSERT INTO password_reset_tokens (user_id, token_hash, expires_at, request_ip) " +
                "VALUES (?, ?, ?, ?)";
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, tokenHash);
            ps.setTimestamp(3, expiresAt);
            ps.setString(4, requestIp);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public PasswordResetToken findValidByHash(String tokenHash) {
        String sql = "SELECT id, user_id, token_hash, expires_at, used_at " +
                "FROM password_reset_tokens " +
                "WHERE token_hash=? AND expires_at > NOW() AND used_at IS NULL " +
                "ORDER BY id DESC LIMIT 1";
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, tokenHash);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new PasswordResetToken(
                            rs.getInt("id"),
                            rs.getInt("user_id"),
                            rs.getString("token_hash"),
                            rs.getTimestamp("expires_at"),
                            rs.getTimestamp("used_at")
                    );
                }
                return null;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public boolean markUsed(int id) {
        String sql = "UPDATE password_reset_tokens SET used_at = NOW() WHERE id=? AND used_at IS NULL";
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
