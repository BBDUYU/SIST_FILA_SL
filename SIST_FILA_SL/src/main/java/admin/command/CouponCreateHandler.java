package admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import command.CommandHandler;
import admin.domain.CouponDTO;
import admin.service.CouponService;
import java.sql.Date;

public class CouponCreateHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getMethod().equalsIgnoreCase("GET")) {
            // 등록 폼 페이지로 이동
            return "/view/admin/create_coupon.jsp";
        } else {
            // POST: 데이터베이스 저장 처리
            String name = request.getParameter("name");
            String discountType = request.getParameter("discount_type"); // AMOUNT or PERCENT
            int discountValue = Integer.parseInt(request.getParameter("discount_value"));
            String expiresAtStr = request.getParameter("expires_at");
            String serialNumber = generateSerial();
            
            CouponDTO dto = new CouponDTO();
            dto.setName(name);
            dto.setDiscount_type(discountType);
            dto.setDiscount_value(discountValue);
            dto.setSerial_number(serialNumber);
            
            // 만료일이 입력되었을 경우에만 처리
            if (expiresAtStr != null && !expiresAtStr.isEmpty()) {
                dto.setExpires_at(Date.valueOf(expiresAtStr));
            }

            CouponService service = CouponService.getInstance();
            service.createCoupon(dto);

            // 등록 후 리스트로 리다이렉트
            String contextPath = request.getContextPath();
            response.sendRedirect(contextPath + "/admin/coupon_list.htm");
            return null;
        }
    }
    private String generateSerial() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < 16; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}