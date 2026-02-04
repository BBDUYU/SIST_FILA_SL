package com.fila.app.controller.order;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fila.app.domain.address.AddressVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.address.AddressMapper;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class OrderAddressController {

	@Autowired
	private AddressMapper addressMapper;

	@GetMapping("/order/order_address.htm")
    public String orderAddress(HttpSession session, Model model) {

        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        
        if (authUser == null) return null;

        try {
            List<AddressVO> addressList =
                    addressMapper.selectListByUser(authUser.getUserNumber());

            model.addAttribute("addressList", addressList);
            return "/order/order_address";

        } catch (SQLException e) {
            throw new RuntimeException("배송지 조회 실패", e);
        }

    }
}
