package fila.admin.command;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.domain.UserInfoDTO;
import fila.admin.service.AdminUserService;
import fila.admin.service.CouponService;
import fila.command.CommandHandler;

public class AdminUserDetailHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String strUserNum = request.getParameter("userNum");
        if (strUserNum == null || strUserNum.isEmpty()) {
            return "redirect:/admin/userList.htm"; 
        }
        
        int userNum = Integer.parseInt(strUserNum);
        
        AdminUserService service = AdminUserService.getInstance();
        
        UserInfoDTO user = service.getUserDetail(userNum);
        
        CouponService couponService = CouponService.getInstance();
        List<UserInfoDTO> couponList = couponService.getUserCouponList(userNum);        
        user.setCouponList(couponList);
        
        fila.order.service.OrderService orderService = fila.order.service.OrderService.getInstance();
        List<fila.order.domain.OrderDTO> orderList = orderService.getUserOrderList(userNum);
        user.setOrderList(orderList);
        
        request.setAttribute("user", user);
        
        return "/view/admin/admin_user_info.jsp";
    }
}