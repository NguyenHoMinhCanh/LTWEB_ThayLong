package com.japansport.controller;

import com.google.gson.Gson;
import com.japansport.dao.UserDao;
import com.japansport.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ManageUserAdminServlet", urlPatterns = {"/admin/users"})
@MultipartConfig
public class ManageUserAdminServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            return;
        }
        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "get":
                getUser(request, response);
                break;
            default:
                sendErrorResponse(response, "Invalid action: " + action);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            sendErrorResponse(response, "Missing action parameter");
            return;
        }
        switch (action) {
            case "toggle-status":
                toggleUserStatus(request,response);
                break;
            case "update-role":
                updateUserRole(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                sendErrorResponse(response, "Invalid action: " + action);
        }
    }
    /**
     * Lay ds tat ca user
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
        throws  IOException {

        List<User> users = userDao.getAll();
        for (User user : users) {
            user.setPassword("");
        }
        sendJsonResponse(response, users);
    }
    /**
     * Lay thong tin user theo ID
     */
    private void getUser(HttpServletRequest request, HttpServletResponse response)
        throws  IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDao.getById(id);

            if (user != null) {
                user.setPassword("");
                sendJsonResponse(response, user);
            } else {
                sendErrorResponse(response, "User not found");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid user ID");
        }
    }
    /**
     * Khoa/Mo khoa tai khoan (toogle active status)
     */
    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDao.getById(id);

            if (user == null) {
                sendErrorResponse(response, "User not found");
                return;
            }

            // Khong khoa tai khoan chinh minh
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser != null && currentUser.getId() == id) {
                sendErrorResponse(response, "Không thể khóa tài khoản của chính bạn");
                return;
            }
            //toggle active status
            int currentStatus = user.getActive();
            int newStatus = (currentStatus == 1) ? 0 : 1;
            user.setActive(newStatus);

            int affectedRows = userDao.update(user);
            boolean success = (affectedRows > 0);

            if (success) {
                String message = newStatus == 1 ? "Đã mở khóa tài khoản" : "Đã khóa tài khoản";
                sendSuccessResponse(response, message, user);
            } else {
                sendErrorResponse(response, "Failed to update user status");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid user ID");
        }
    }
    /**
     * cap nhat role user (admin/customer)
     */
    private void updateUserRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String newRole = request.getParameter("role"); // UI đang gửi "admin" hoặc "customer" (theo file bạn)

            if (newRole == null) {
                sendErrorResponse(response, "Invalid role");
                return;
            }

            // ✅ MAP role từ UI -> roles.code trong DB
            newRole = newRole.trim();
            if ("customer".equalsIgnoreCase(newRole)) newRole = "USER";
            else if ("admin".equalsIgnoreCase(newRole)) newRole = "ADMIN";
            else if ("staff".equalsIgnoreCase(newRole)) newRole = "STAFF";
            else if ("user".equalsIgnoreCase(newRole)) newRole = "USER";

            // ✅ Validate role cuối cùng (DB LTWEB nên có ADMIN/STAFF/USER)
            if (!"ADMIN".equalsIgnoreCase(newRole)
                    && !"STAFF".equalsIgnoreCase(newRole)
                    && !"USER".equalsIgnoreCase(newRole)) {
                sendErrorResponse(response, "Invalid role");
                return;
            }

            User user = userDao.getById(id);
            if (user == null) {
                sendErrorResponse(response, "User not found");
                return;
            }

            // ✅ Không cho tự hạ quyền chính mình (ADMIN -> USER/STAFF)
            HttpSession session = request.getSession(false);
            if (session != null) {
                User currentUser = (User) session.getAttribute("currentUser");
                if (currentUser != null
                        && currentUser.getId() == id
                        && currentUser.isAdmin()
                        && !"ADMIN".equalsIgnoreCase(newRole)) {
                    sendErrorResponse(response, "Khong the ha quyen chinh minh");
                    return;
                }
            }

            // ✅ Update theo bảng user_roles (đúng schema LTWEB)
            boolean success = userDao.setUserRole(user.getId(), newRole);

            // set roleCode để trả JSON về UI
            user.setRoleCode(newRole);

            if (success) {
                sendSuccessResponse(response, "Da cap nhat quyen", user);
            } else {
                sendErrorResponse(response, "Failed to update user role");
            }

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid user ID");
        } catch (SQLException e) {
            e.printStackTrace();
            sendErrorResponse(response, "Database error");
        }
    }

    /**
     * Xoa user
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            //Khong tu xoa chinh minh
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser != null && currentUser.getId() == id) {
                sendErrorResponse(response, "Khong the xoa tai khoan chinh ban");
                return;
            }
            User user = userDao.getById(id);
            if (user != null) {
                userDao.delete(user);
                sendSuccessResponse(response, "Da xoa tai khoan", null);
            } else {
                sendErrorResponse(response, "Uset not found");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid user ID");
        }
    }
    //============================== Response Helper===========================

    private void sendJsonResponse(HttpServletResponse response, Object data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
    private void sendSuccessResponse(HttpServletResponse response, String message, Object data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String json = String.format(
                "{\"success\": true, \"message\": \"%s\", \"data\": %s}",
                message,
                data != null ? gson.toJson(data) : "null"
        );
        out.print(json);
        out.flush();
    }
    private void sendErrorResponse(HttpServletResponse response, String message)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        PrintWriter out = response.getWriter();

        String json = String.format("{\"success\": false, \"message\": \"%s\"}", message);
        out.print(json);
        out.flush();
    }

}
