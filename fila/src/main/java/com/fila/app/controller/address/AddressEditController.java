package com.fila.app.controller.address;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.address.AddressVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.address.AddressMapper;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class AddressEditController {

    private final AddressMapper addressMapper;

    @PostMapping(value = "/edit.htm")
    @ResponseBody
    @Transactional
    public String process(HttpSession session,
                          int addrNo,
                          String addrname,
                          String tel2_1,
                          String zipcode,
                          String addr3,
                          String addr2,
                          String addressName,
                          String addrDefault) throws Exception {

        Object auth = (session == null) ? null : session.getAttribute("auth");
        if (auth == null) return "{\"ok\":false,\"error\":\"UNAUTHORIZED\"}";

        int userNumber = ((MemberVO) auth).getUserNumber();

        AddressVO dto = new AddressVO();
        dto.setAddressId(addrNo);
        dto.setUserNumber(userNumber);
        dto.setRecipientName(addrname);
        dto.setRecipientPhone(tel2_1);
        dto.setZipcode(zipcode);
        dto.setMainAddr(addr3);
        dto.setDetailAddr(addr2);

        if (addressName == null || addressName.trim().isEmpty()) addressName = "배송지";
        dto.setAddressName(addressName);

        dto.setIsDefault("D".equals(addrDefault) ? 1 : 0);

        if (dto.getIsDefault() == 1) {
            addressMapper.clearDefault(userNumber);
        }

        int updated = addressMapper.update(dto);
        if (updated == 0) return "{\"ok\":false,\"error\":\"NOT_FOUND\"}";

        return "{\"ok\":true}";
    }
}