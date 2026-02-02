package com.fila.app.controller.address;

import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.MemberVO;
import com.fila.app.mapper.address.AddressMapper;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class AddressDefaultController {

	private final AddressMapper addressMapper;

    @PostMapping(value = "/address/default", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    @Transactional
    public String process(HttpSession session, int addrNo) throws Exception {

        Object auth = (session == null) ? null : session.getAttribute("auth");
        if (auth == null) return "redirect:/login.htm"; // 핸들러 스타일 유지

        int userNumber = ((MemberVO) auth).getUserNumber();

        addressMapper.clearDefault(userNumber);
        addressMapper.setDefault(addrNo, userNumber);

        return "{\"ok\":true}";
    }
}
