package com.japansport.controller;

import com.japansport.dao.VoucherDao;
import com.japansport.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/voucher")
public class AdminVoucherServlet extends HttpServlet {
    private VoucherDao voucherDao = new VoucherDao();
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idParam = req.getParameter("id");

        try {
            if ("add".equals(action)) {
                req.setAttribute("action", "add");
                req.getRequestDispatcher("/admin/voucher-form.jsp").forward(req, resp);

            } else if ("edit".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                Voucher voucher = voucherDao.getVoucherById(id);
                if (voucher != null) {
                    req.setAttribute("voucher", voucher);
                    req.setAttribute("action", "edit");
                    req.getRequestDispatcher("/admin/voucher-form.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect("voucher");
                }

            } else {
                // Danh sách voucher
                List<Voucher> vouchers = voucherDao.getAllVouchers();
                req.setAttribute("vouchers", vouchers);
                req.getRequestDispatcher("/admin/voucher-list.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("voucher");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        Voucher voucher = new Voucher();

        voucher.setCode(req.getParameter("code"));
        voucher.setName(req.getParameter("name"));
        voucher.setDiscountType(req.getParameter("discountType"));
        voucher.setDiscountValue(new BigDecimal(req.getParameter("discountValue")));
        voucher.setMinOrderValue(new BigDecimal(req.getParameter("minOrderValue")));

        String maxDiscountStr = req.getParameter("maxDiscount");
        if (maxDiscountStr != null && !maxDiscountStr.isEmpty()) {
            voucher.setMaxDiscount(new BigDecimal(maxDiscountStr));
        }

        // Xử lý ngày
        String startStr = req.getParameter("startDate");
        String endStr = req.getParameter("endDate");
        if (startStr != null && !startStr.isEmpty()) {
            voucher.setStartDate(LocalDateTime.parse(startStr, formatter));
        }
        if (endStr != null && !endStr.isEmpty()) {
            voucher.setEndDate(LocalDateTime.parse(endStr, formatter));
        }

        String usageLimitStr = req.getParameter("usageLimit");
        if (usageLimitStr != null && !usageLimitStr.isEmpty()) {
            voucher.setUsageLimit(Integer.parseInt(usageLimitStr));
        }

        voucher.setActive("1".equals(req.getParameter("isActive")));

        if ("add".equals(action)) {
            voucherDao.addVoucher(voucher);
        } else if ("update".equals(action)) {
            voucher.setId(Integer.parseInt(req.getParameter("id")));
            voucherDao.updateVoucher(voucher);
        }

        resp.sendRedirect("voucher");
    }
}
