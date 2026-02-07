package com.fila.app.controller.address;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LegacyPopupController {

    @GetMapping("/pc/mypage/pop_address_add.asp")
    public String popAddressAdd() {
        return "redirect:/mypage/add_modal.htm";
    }

    @GetMapping("/pc/mypage/pop_address_edit.asp")
    public String popAddressEdit(@RequestParam(value="addrNo", required=false) Integer addrNo) {
        if (addrNo == null) addrNo = 0;
        return "redirect:/mypage/edit_modal.htm?addrNo=" + addrNo;
    }
}