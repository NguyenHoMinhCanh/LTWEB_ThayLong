package com.japansport.controller;

import com.japansport.dao.UserAddressDao;
import com.japansport.dao.UserDao;
import com.japansport.model.User;
import com.japansport.model.UserAddress;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Date;
import java.util.Base64;
import java.util.Set;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {

    private static final Set<String> ALLOWED_GENDERS = Set.of("MALE", "FEMALE", "OTHER", "");

    private static String ensureCsrf(HttpSession session) {
        Object cur = session.getAttribute("CSRF_TOKEN");
        if (cur != null) return String.valueOf(cur);

        byte[] buf = new byte[32];
        new SecureRandom().nextBytes(buf);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
        session.setAttribute("CSRF_TOKEN", token);
        return token;
    }

    private static boolean validCsrf(HttpServletRequest req) {
        HttpSession session = req.getSession();
        String s = String.valueOf(session.getAttribute("CSRF_TOKEN"));
        String r = req.getParameter("csrf");
        return r != null && r.equals(s);
    }

    private static void redirectLogin(HttpServletRequest req, HttpServletResponse resp, String backPath) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/login.jsp?back=" + backPath);
    }

    private static String trimOrEmpty(String s) {
        return s == null ? "" : s.trim();
    }

    private static boolean looksLikePhone(String phone) {
        // cho phép rỗng (user chưa nhập)
        if (phone == null || phone.isBlank()) return true;

        // bỏ khoảng trắng, dấu chấm, dấu gạch
        String p = phone.replace(" ", "").replace(".", "").replace("-", "");

        // cho phép +84 hoặc 0...
        if (p.startsWith("+")) p = p.substring(1);

        // chỉ digits
        if (!p.matches("\\d+")) return false;

        // độ dài phổ biến VN: 9-12 (tùy format +84)
        return p.length() >= 9 && p.length() <= 12;
    }

    private static void attachDefaultAddress(HttpServletRequest req, int userId) {
        try {
            UserAddress addr = new UserAddressDao().getDefaultByUserId(userId);
            req.setAttribute("defaultAddress", addr);
        } catch (Exception ignored) {
            // không để crash trang account nếu lỗi DB
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        ensureCsrf(session);

        User u = (User) session.getAttribute("currentUser");
        if (u == null) {
            redirectLogin(req, resp, "/account");
            return;
        }

        // Load địa chỉ mặc định để hiển thị ở account.jsp
        attachDefaultAddress(req, u.getId());

        req.getRequestDispatcher("/account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        ensureCsrf(session);

        User u = (User) session.getAttribute("currentUser");
        if (u == null) {
            redirectLogin(req, resp, "/account");
            return;
        }

        if (!validCsrf(req)) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "CSRF token không hợp lệ. Vui lòng tải lại trang và thử lại.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }

        String formType = trimOrEmpty(req.getParameter("formType"));
        if ("address".equalsIgnoreCase(formType)) {
            handleUpdateAddress(req, resp, session, u);
            return;
        }

        // Mặc định: update profile
        handleUpdateProfile(req, resp, session, u);
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User u) throws ServletException, IOException {
        // ====== LẤY DỮ LIỆU FORM ======
        String name = trimOrEmpty(req.getParameter("name"));
        String phone = trimOrEmpty(req.getParameter("phone"));
        String gender = trimOrEmpty(req.getParameter("gender")).toUpperCase();
        String birthdayStr = trimOrEmpty(req.getParameter("birthday"));

        // ====== VALIDATE ======
        if (name.isBlank()) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Tên hiển thị không được để trống.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }
        if (name.length() > 80) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Tên hiển thị tối đa 80 ký tự.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }

        if (!looksLikePhone(phone)) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Số điện thoại không hợp lệ (chỉ gồm số, có thể +84, độ dài 9-12).");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }

        if (!ALLOWED_GENDERS.contains(gender)) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Giới tính không hợp lệ.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }

        Date birthday = null;
        if (!birthdayStr.isBlank()) {
            try {
                // yyyy-MM-dd (input type="date")
                birthday = Date.valueOf(birthdayStr);
            } catch (IllegalArgumentException ex) {
                attachDefaultAddress(req, u.getId());
                req.setAttribute("errorMessage", "Ngày sinh không hợp lệ.");
                req.getRequestDispatcher("/account.jsp").forward(req, resp);
                return;
            }
        }

        // ====== UPDATE DB ======
        try {
            UserDao dao = new UserDao();
            boolean ok = dao.updateProfile(u.getId(), name, phone, gender.isBlank() ? null : gender, birthday);

            if (ok) {
                // cập nhật session để UI hiển thị ngay
                u.setName(name);
                u.setPhone(phone);
                u.setGender(gender.isBlank() ? null : gender);
                u.setBirthday(birthday);

                session.setAttribute("FLASH_MSG", "Cập nhật thông tin thành công.");
                session.setAttribute("FLASH_TYPE", "success");

                resp.sendRedirect(req.getContextPath() + "/account");
            } else {
                attachDefaultAddress(req, u.getId());
                req.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
                req.getRequestDispatcher("/account.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Có lỗi hệ thống. Vui lòng thử lại.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
        }
    }

    private void handleUpdateAddress(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User u) throws ServletException, IOException {
        String fullName = trimOrEmpty(req.getParameter("fullName"));
        String phone = trimOrEmpty(req.getParameter("addrPhone"));
        String addressLine = trimOrEmpty(req.getParameter("addressLine"));
        String city = trimOrEmpty(req.getParameter("city"));
        String district = trimOrEmpty(req.getParameter("district"));
        String ward = trimOrEmpty(req.getParameter("ward"));

        // ====== VALIDATE (đơn giản, dễ báo cáo) ======
        if (fullName.isBlank()) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Họ tên người nhận không được để trống.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }
        if (fullName.length() > 150) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Họ tên người nhận tối đa 150 ký tự.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }

        if (phone.isBlank() || !looksLikePhone(phone)) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Số điện thoại nhận hàng không hợp lệ.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }

        if (addressLine.isBlank()) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Địa chỉ (số nhà, tên đường) không được để trống.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }
        if (addressLine.length() > 255) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Địa chỉ tối đa 255 ký tự.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }

        if (city.length() > 100 || district.length() > 100 || ward.length() > 100) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Tỉnh/Quận/Phường tối đa 100 ký tự.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
            return;
        }

        try {
            boolean ok = new UserAddressDao().saveDefaultAddress(u.getId(), fullName, phone, addressLine, city, district, ward);
            if (ok) {
                session.setAttribute("FLASH_MSG", "Đã lưu địa chỉ giao hàng mặc định.");
                session.setAttribute("FLASH_TYPE", "success");
                resp.sendRedirect(req.getContextPath() + "/account");
            } else {
                attachDefaultAddress(req, u.getId());
                req.setAttribute("errorMessage", "Lưu địa chỉ thất bại. Vui lòng thử lại.");
                req.getRequestDispatcher("/account.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            attachDefaultAddress(req, u.getId());
            req.setAttribute("errorMessage", "Có lỗi hệ thống khi lưu địa chỉ.");
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
        }
    }
}
