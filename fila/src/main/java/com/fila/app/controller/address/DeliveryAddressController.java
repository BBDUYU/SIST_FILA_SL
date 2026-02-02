package com.fila.app.controller.address;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.fila.app.domain.MemberVO;
import com.fila.app.domain.address.AddressVO;
import com.fila.app.mapper.address.AddressMapper; 

@Controller
public class DeliveryAddressController {

	@Autowired
    private AddressMapper addressMapper;

    @GetMapping("/deliveryAddress.htm")
    public String deliveryAddress(HttpServletRequest request, HttpSession session) throws Exception {

        // 1) 로그인 체크
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) {
            return "redirect:/login.htm";
        }

        // 2) 배송지 목록 조회 (기본배송지 먼저)
        List<AddressVO> list = addressMapper.selectListByUser(loginUser.getUserNumber());
        request.setAttribute("addrList", list);

        return "mypage.delivery_address";
    }
}
