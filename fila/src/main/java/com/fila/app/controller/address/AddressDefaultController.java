package com.fila.app.controller.address;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.address.AddressMapper;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class AddressDefaultController {

    private final AddressMapper addressMapper;

    @PostMapping("/address/default.htm")
    @ResponseBody
    @Transactional
    public ResponseEntity<String> process(HttpSession session, int addrNo) throws Exception {

        Object auth = (session == null) ? null : session.getAttribute("auth");
        if (auth == null) return json("{\"ok\":false,\"error\":\"UNAUTHORIZED\"}", HttpStatus.UNAUTHORIZED);

        int userNumber = ((MemberVO) auth).getUserNumber();

        addressMapper.clearDefault(userNumber);
        addressMapper.setDefault(addrNo, userNumber);

        return json("{\"ok\":true}", HttpStatus.OK);
    }

    private ResponseEntity<String> json(String body, HttpStatus status){
        HttpHeaders h = new HttpHeaders();
        h.add("Content-Type", "application/json; charset=UTF-8");
        return new ResponseEntity<>(body, h, status);
    }
}