package admin.command;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import admin.domain.UserInfoDTO;
import admin.service.AdminUserService;
import admin.service.CouponService;
import command.CommandHandler;

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
        
        order.service.OrderService orderService = order.service.OrderService.getInstance();
        List<order.domain.OrderDTO> orderList = orderService.getUserOrderList(userNum);
        user.setOrderList(orderList);
        
        request.setAttribute("user", user);
        
        return "/view/admin/admin_user_info.jsp";
    }
}