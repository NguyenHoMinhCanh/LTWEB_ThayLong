package com.japansport.model;

import java.sql.Timestamp;

public class PasswordResetToken {
    private int id;
    private int userId;
    private String tokenHash;
    private Timestamp expiresAt;
    private Timestamp usedAt;

    public PasswordResetToken(int id, int userId, String tokenHash, Timestamp expiresAt, Timestamp usedAt) {
        this.id = id;
        this.userId = userId;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
        this.usedAt = usedAt;
    }

    public int getId() {
        return id;
    }

    public int getUserId() {
        return userId;
    }

    public String getTokenHash() {
        return tokenHash;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public Timestamp getUsedAt() {
        return usedAt;
    }
}
