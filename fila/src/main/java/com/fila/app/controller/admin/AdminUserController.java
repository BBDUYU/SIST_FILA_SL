package com.fila.app.controller.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.admin.UserInfoVO;
import com.fila.app.domain.order.OrderItemVO;
import com.fila.app.domain.order.OrderVO;
import com.fila.app.service.admin.AdminUserService;
import com.fila.app.service.admin.CouponService;
import com.fila.app.service.order.OderService;

@Controller
@RequestMapping("/admin")
public class AdminUserController {

    @Autowired
    private AdminUserService adminUserService;
    
    @Autowired
    private CouponService couponService;
    
    @Autowired
    private OderService oderService;

    /**
     * 1. 회원 목록 조회
     */
    @RequestMapping(value = "/userList", method = RequestMethod.GET)
    public String userList(Model model) throws Exception {
        // 싱글톤(getInstance) 대신 주입된 서비스 사용
        List<UserInfoVO> userList = adminUserService.getUserList();
        model.addAttribute("userList", userList);
        return "admin/admin_user";
    }

    /**
     * 2. 회원 상세 정보 조회
     */
    @RequestMapping(value = "/userDetail", method = RequestMethod.GET)
    public String userDetail(@RequestParam(value="userNum", required=false) Integer userNum, Model model) throws Exception {
        if (userNum == null) {
            return "redirect:/admin/userList";
        }
        
        // 서비스에서 이미 자녀리스트, 포인트 등을 담아서 가져옴
        UserInfoVO user = adminUserService.getUserDetail(userNum);
        
        // 추가 정보(쿠폰, 주문내역) 매핑
        user.setCouponList(couponService.getUserCouponList(userNum));
        user.setOrderList(oderService.getUserOrderList(userNum));
        
        model.addAttribute("user", user);
        return "admin/admin_user_info";
    }

    /**
     * 3. 주문 상세 내역 조회 (AJAX)
     * @ResponseBody와 List 리턴을 사용하면 스프링이 자동으로 JSON 배열([])로 변환합니다.
     */
    @RequestMapping(value = "/orderDetail", method = RequestMethod.GET)
    @ResponseBody
    public List<OrderItemVO> orderDetail(@RequestParam("orderId") String orderId) {
        // OderService에 이미 상세 정보 가져오는 로직이 구현되어 있음
        OrderVO order = oderService.getOrderDetail(orderId);
        return order.getOrderItems();
    }

    /**
     * 4 & 5. 주문 상태 업데이트 및 재고 복구 (AJAX)
     * Map을 리턴하면 JSON 객체({})로 변환됩니다.
     */
    @RequestMapping(value = "/orderUpdate", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> orderUpdate(@RequestParam("orderId") String orderId, @RequestParam("status") String status) {
        Map<String, Object> response = new HashMap<String, Object>();
        
        // OderServiceImpl.cancelOrder 내부에 상태 업데이트 + 재고복구 로직이 포함되어 있음
        boolean isSuccess = oderService.cancelOrder(orderId, status);
        
        if (isSuccess) {
            response.put("status", "success");
            response.put("message", "[" + status + "] 처리가 완료되었습니다.");
        } else {
            response.put("status", "error");
            response.put("message", "처리 중 오류가 발생했습니다.");
        }
        
        return response;
    }
}