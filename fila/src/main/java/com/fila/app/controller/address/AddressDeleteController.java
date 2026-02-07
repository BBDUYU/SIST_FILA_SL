
package com.fila.app.controller.address;

import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
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
public class AddressDeleteController {
	
	private final AddressMapper addressMapper;

	@PostMapping(value = "/address/delete.htm")
	@ResponseBody
	@Transactional
	public String process(HttpSession session, int addrNo) throws Exception {

	    Object auth = (session == null) ? null : session.getAttribute("auth");
	    if (auth == null) return "{\"ok\":false,\"error\":\"UNAUTHORIZED\"}";

	    int userNumber = ((MemberVO) auth).getUserNumber();

	    int isDefault = addressMapper.isDefault(addrNo, userNumber);
	    if (isDefault == 1) return "{\"ok\":false,\"error\":\"DEFAULT_CANNOT_DELETE\"}";

	    if (addressMapper.hasOrderReference(addrNo, userNumber) > 0) {
	        return "{\"ok\":false,\"error\":\"USED_IN_ORDER\"}";
	    }

	    int deleted = addressMapper.delete(addrNo, userNumber);
	    if (deleted == 0) return "{\"ok\":false,\"error\":\"NOT_FOUND\"}";

	    return "{\"ok\":true}";
	}

}
