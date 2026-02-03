package com.fila.app.controller.order;

import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.MemberVO;
import com.fila.app.domain.admin.UserInfoVO;
import com.fila.app.service.admin.CouponService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CouponAjaxController {

	@Autowired
	private CouponService couponService;

    @GetMapping(value = "/order/coupons.ajax", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<UserInfoVO> coupons(HttpSession session) {

        MemberVO member = (MemberVO) session.getAttribute("auth");

        if (member == null) {
            return Collections.emptyList(); // "[]" 동일
        }

        int userNum = member.getUserNumber();
        return couponService.getUserCouponList(userNum);
    }
}
