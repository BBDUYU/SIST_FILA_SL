package com.fila.app.controller.address;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.address.AddressVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.address.AddressMapper;

@Controller
@RequestMapping("/mypage")
public class DeliveryAddressController {

    @Autowired
    private AddressMapper addressMapper;

    @GetMapping("/delivery_address.htm")
    public String deliveryAddress(HttpServletRequest request, HttpSession session) throws Exception {
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        List<AddressVO> list = addressMapper.selectListByUser(loginUser.getUserNumber());
        request.setAttribute("addrList", list);

        return "delivery_address";
    }

    // 신규 배송지 모달
    @GetMapping("/add_modal.htm")
    public String addModal(HttpSession session){
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";
        
        return "forward:/WEB-INF/views/mypage/add_address.jsp";
    }
    // 배송지 수정 모달
    @GetMapping("/edit_modal.htm")
    public String editModal(HttpSession session,
                            @RequestParam("addrNo") int addrNo,
                            HttpServletRequest request) throws Exception {
        
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        AddressVO address = addressMapper.selectOneById(addrNo, loginUser.getUserNumber());
        
        if (address == null) {
            request.setAttribute("error", "NOT_FOUND");
        } else {
            request.setAttribute("address", address);
        }

        return "forward:/WEB-INF/views/mypage/edit_address.jsp";
    }
    
    @GetMapping("/map_modal.htm") 
    public String mapModal() {
    	
        return "forward:/WEB-INF/views/mypage/map.jsp"; 
    }

}