package com.fila.app.controller.wishlist;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.wishlist.WishListService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class WishToggleController {

    private final WishListService wishListService;

    @PostMapping(value="/wishlist/toggle.htm", produces=MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggle(HttpSession session,
                                                     String productId,
                                                     String sizeText) {

        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        boolean wished = wishListService.toggleWished(loginUser.getUserNumber(), productId, sizeText);

        Map<String, Object> res = new HashMap<>();
        res.put("wished", wished);
        return ResponseEntity.ok(res);
    }
}