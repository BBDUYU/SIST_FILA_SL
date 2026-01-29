package fila.admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.service.CouponService;
import fila.command.CommandHandler;

public class CouponDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String couponIdStr = request.getParameter("id");
        String status = request.getParameter("status"); // Y 또는 N 수신
        
        if (couponIdStr != null && status != null) {
            int couponId = Integer.parseInt(couponIdStr);
            CouponService service = CouponService.getInstance();
            
            // DAO의 delete 메서드가 이제 특정 상태로 업데이트하도록 동작함
            service.toggleCouponStatus(couponId, status);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/coupon_list.htm");
        return null;
    }
}