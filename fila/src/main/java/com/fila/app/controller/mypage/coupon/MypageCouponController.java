package com.fila.app.controller.mypage.coupon;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.mypage.coupon.MypageCouponVO;
import com.fila.app.service.mypage.coupon.MypageCouponService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage/coupon")
public class MypageCouponController {

    private final MypageCouponService mypageCouponService;

    // 레거시 CouponListHandler 대응
    @GetMapping("/list")
    public String couponList(HttpSession session, Model model) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) {
            return "redirect:/login";
        }

        List<MypageCouponVO> couponList =
                mypageCouponService.getMyCouponList(auth.getUserNumber());

        long activeCount =
                couponList.stream().filter(c -> "0".equals(c.getIsUsed())).count();

        model.addAttribute("couponList", couponList);
        model.addAttribute("activeCount", activeCount);

        // 네 프로젝트 뷰 네이밍에 맞춰서 JSP 경로로 연결
        return "mypage/mycoupon";
    }

    // 레거시 CouponProcessHandler 대응 (AJAX)
    @PostMapping("/register")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerCoupon(
            HttpSession session,
            @RequestParam("randomNo") String randomNo) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) {
            return ResponseEntity.status(401).body(
                    Map.of("status", "fail", "message", "로그인이 필요합니다.")
            );
        }

        Map<String, Object> result =
                mypageCouponService.registerCoupon(auth.getUserNumber(), randomNo);

        return ResponseEntity.ok(result);
    }
}
