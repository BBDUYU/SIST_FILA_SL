package com.fila.app.controller.mypage;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.admin.UserInfoVO;
import com.fila.app.service.admin.AdminUserService;
import com.fila.app.service.mypage.coupon.MypageCouponService;

@Controller
@RequestMapping("/mypage")
public class MypageController {

    @Autowired
    private AdminUserService adminUserService;
    
    @Autowired
    private MypageCouponService mypageCouponService;

    
    
    // 1. 포인트 이용 내역 페이지
    @GetMapping("/mypoint.htm")
    public String myPoint(HttpSession session, Model model) {
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/member/login.htm";

        // AdminUserService.getUserDetail은 내부적으로 selectPointList를 호출하여 
        // UserInfoVO의 pointList 필드에 데이터를 채워줍니다.
        UserInfoVO userDetail = adminUserService.getUserDetail(auth.getUserNumber());
        model.addAttribute("user", userDetail);
        
        return "mypoint"; // Tiles definition name
    }

    // 2. 쿠폰 목록 페이지
    @GetMapping("/mycoupon.htm")
    public String myCoupon(HttpSession session, Model model) {
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/member/login.htm";

        // 관리자용 쿠폰 서비스나 마이페이지 전용 서비스를 활용하여 리스트 조회
        // UserInfoVO의 필드명(coupon_name, price 등)에 맞춰 서비스 호출
        model.addAttribute("couponList", mypageCouponService.getMyCouponList(auth.getUserNumber()));
        
        return "mycoupon"; // Tiles definition name
    }

    // 3. 쿠폰 등록 처리 (AJAX - JSON 대신 일반 String 응답 버전)
    @PostMapping(value = "/coupon_process.htm", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public String couponProcess(HttpSession session, @RequestParam("randomNo") String serialNo) {
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "login_required";

        // 쿠폰 등록 서비스 호출
        java.util.Map<String, Object> result = mypageCouponService.registerCoupon(auth.getUserNumber(), serialNo);
        
        // JSP 스크립트에서 res.status를 체크하므로, 
        // "success" 혹은 에러 메시지를 응답
        if ("success".equals(result.get("status"))) {
            return "{\"status\":\"success\", \"message\":\"쿠폰이 성공적으로 등록되었습니다.\"}";
        } else {
            return "{\"status\":\"error\", \"message\":\"" + result.get("message") + "\"}";
        }
    }
}