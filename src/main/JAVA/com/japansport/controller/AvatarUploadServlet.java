package com.japansport.controller;

import com.japansport.dao.UserDao;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/account/avatar")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class AvatarUploadServlet extends HttpServlet {

    private static boolean validCsrf(HttpServletRequest req) {
        HttpSession session = req.getSession();
        String s = String.valueOf(session.getAttribute("CSRF_TOKEN"));
        String r = req.getParameter("csrf");
        return r != null && r.equals(s);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User u = (User) session.getAttribute("currentUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?back=/account");
            return;
        }

        if (!validCsrf(req)) {
            session.setAttribute("FLASH_MSG", "CSRF token không hợp lệ. Vui lòng tải lại trang và thử lại.");
            session.setAttribute("FLASH_TYPE", "danger");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        Part filePart = req.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            session.setAttribute("FLASH_MSG", "Bạn chưa chọn ảnh.");
            session.setAttribute("FLASH_TYPE", "warning");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            session.setAttribute("FLASH_MSG", "File không hợp lệ. Chỉ chấp nhận ảnh.");
            session.setAttribute("FLASH_TYPE", "danger");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        // tạo folder uploads/avatars trong thư mục deploy
        String uploadDirReal = req.getServletContext().getRealPath("/uploads/avatars");
        Files.createDirectories(Paths.get(uploadDirReal));

        String submitted = filePart.getSubmittedFileName();
        String ext = ".png";
        if (submitted != null && submitted.contains(".")) {
            ext = submitted.substring(submitted.lastIndexOf(".")).toLowerCase();
            if (!(ext.equals(".png") || ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".webp"))) {
                ext = ".png";
            }
        }

        String fileName = "u" + u.getId() + "_" + UUID.randomUUID() + ext;
        File dest = new File(uploadDirReal, fileName);
        filePart.write(dest.getAbsolutePath());

        String avatarPath = "uploads/avatars/" + fileName;

        boolean ok;
        try {
            ok = new UserDao().updateAvatar(u.getId(), avatarPath);
        } catch (RuntimeException ex) {
            // fallback nếu DB chưa có cột avatar
            ok = false;
        }

        if (ok) {
            u.setAvatar(avatarPath);
            session.setAttribute("FLASH_MSG", "Cập nhật avatar thành công.");
            session.setAttribute("FLASH_TYPE", "success");
        } else {
            session.setAttribute("FLASH_MSG", "Cập nhật avatar thất bại (kiểm tra DB đã có cột avatar chưa).");
            session.setAttribute("FLASH_TYPE", "danger");
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }
}
