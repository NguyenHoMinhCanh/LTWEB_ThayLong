package com.japansport.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public final class PasswordUtil {
    private PasswordUtil() {}

    private static final SecureRandom RNG = new SecureRandom();
    private static final int ITERATIONS = 120_000;
    private static final int SALT_LEN = 16;        // bytes
    private static final int KEY_LEN = 256;        // bits

    // Lưu dạng: pbkdf2$120000$saltB64$hashB64
    public static String hash(String rawPassword) {
        if (rawPassword == null) throw new IllegalArgumentException("password is null");
        byte[] salt = new byte[SALT_LEN];
        RNG.nextBytes(salt);

        byte[] dk = pbkdf2(rawPassword.toCharArray(), salt, ITERATIONS, KEY_LEN);
        return "pbkdf2$" + ITERATIONS + "$"
                + Base64.getUrlEncoder().withoutPadding().encodeToString(salt) + "$"
                + Base64.getUrlEncoder().withoutPadding().encodeToString(dk);
    }

    // Hỗ trợ luôn plaintext để không phá DB hiện tại (admin123, user123...)
    public static boolean verify(String rawPassword, String stored) {
        if (rawPassword == null || stored == null) return false;

        // Backward compatible: nếu DB còn lưu plaintext
        if (!stored.startsWith("pbkdf2$")) {
            return rawPassword.equals(stored);
        }

        String[] parts = stored.split("\\$");
        if (parts.length != 4) return false;

        int it = Integer.parseInt(parts[1]);
        byte[] salt = Base64.getUrlDecoder().decode(parts[2]);
        byte[] expected = Base64.getUrlDecoder().decode(parts[3]);

        byte[] actual = pbkdf2(rawPassword.toCharArray(), salt, it, expected.length * 8);
        return constantTimeEquals(actual, expected);
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int it, int keyLenBits) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, it, keyLenBits);
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            return skf.generateSecret(spec).getEncoded();
        } catch (Exception e) {
            throw new RuntimeException("PBKDF2 error", e);
        }
    }

    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a == null || b == null || a.length != b.length) return false;
        int r = 0;
        for (int i = 0; i < a.length; i++) r |= (a[i] ^ b[i]);
        return r == 0;
    }
}
