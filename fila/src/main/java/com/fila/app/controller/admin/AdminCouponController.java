package com.fila.app.controller.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.admin.CouponVO;
import com.fila.app.service.admin.CouponService;

@Controller
@RequestMapping("/admin")
public class AdminCouponController {

    @Autowired
    private CouponService couponService;

    /**
     * 1. 쿠폰 목록 조회 (CouponListHandler)
     */
    @RequestMapping(value = "/coupon_list.htm", method = RequestMethod.GET)
    public String couponList(Model model) throws Exception {
        List<CouponVO> list = couponService.getCouponList();
        model.addAttribute("couponList", list);
        return "coupon_list"; // view/admin/coupon_list.jsp
    }

    /**
     * 2. 쿠폰 등록 페이지 이동 (CouponCreateHandler GET)
     */
    @RequestMapping(value = "/create_coupon.htm", method = RequestMethod.GET)
    public String createCouponForm() {
        return "create_coupon"; // view/admin/create_coupon.jsp
    }

    /**
     * 3. 쿠폰 저장 처리 (CouponCreateHandler POST)
     */
    @RequestMapping(value = "/create_coupon.htm", method = RequestMethod.POST)
    public String createCoupon(CouponVO couponVO) throws Exception {
        
        // 시리얼 번호 생성 로직은 Service 내부에서 처리하는 것이 더 깔끔하지만, 
        // 기존 로직 유지를 위해 필요한 경우 여기서 세팅합니다.
        if (couponVO.getSerialNumber() == null || couponVO.getSerialNumber().isEmpty()) {
            couponVO.setSerialNumber(generateSerial());
        }
        
        couponService.createCoupon(couponVO);
        
        return "redirect:/admin/coupon_list.htm";
    }

    /**
     * 4. 쿠폰 상태 변경/삭제 (CouponDeleteHandler)
     * 기존 핸들러가 id와 status를 받아 활성/비활성을 토글하므로 그대로 구현합니다.
     */
    @RequestMapping(value = "/delete_coupon.htm", method = RequestMethod.GET)
    public String toggleCouponStatus(@RequestParam("id") int couponId, 
                                     @RequestParam("status") String status) throws Exception {
        
        couponService.toggleCouponStatus(couponId, status);
        
        return "redirect:/admin/coupon_list.htm";
    }

    /**
     * 시리얼 번호 생성 유틸리티
     */
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