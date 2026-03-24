package com.japansport.util;

import java.io.InputStream;
import java.util.Properties;

public final class AppConfig {
    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = AppConfig.class.getClassLoader().getResourceAsStream("app.properties")) {
            if (in != null) PROPS.load(in);
        } catch (Exception ignored) {}
    }

    private AppConfig() {}

    public static String get(String key, String def) {
        // 1) ENV (setenv.bat / system env)
        String v = System.getenv(key);
        if (v != null && !v.isBlank()) return v.trim();

        // 2) JVM -D (nếu bạn có dùng, tùy chọn)
        v = System.getProperty(key);
        if (v != null && !v.isBlank()) return v.trim();

        // 3) app.properties (fallback)
        v = PROPS.getProperty(key);
        if (v != null && !v.isBlank()) return v.trim();

        return def;
    }

    public static boolean getBool(String key, boolean def) {
        String v = get(key, "");
        if (v.isBlank()) return def;
        return "true".equalsIgnoreCase(v) || "1".equals(v) || "yes".equalsIgnoreCase(v);
    }

    public static int getInt(String key, int def) {
        String v = get(key, "");
        if (v.isBlank()) return def;
        try { return Integer.parseInt(v.trim()); } catch (Exception e) { return def; }
    }
}
