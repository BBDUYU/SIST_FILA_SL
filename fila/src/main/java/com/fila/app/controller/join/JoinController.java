package com.fila.app.controller.join;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.join.JoinService;
import com.fila.app.service.member.MemberService;

@Controller
@RequestMapping("/member")
public class JoinController {

    @Autowired
    private JoinService joinService;

    @Autowired
    private MemberService memberService;

    /**
     * 회원가입 메인 선택 화면
     */
    @GetMapping("/joinMain.htm")
    public String joinMain() {
        return "joinMain";
    }

    /**
     * 회원가입 폼 화면
     */
    @GetMapping("/join.htm")
    public String joinForm() {
        return "join";
    }

    @PostMapping("/join.htm")
    public String joinProcess(MemberVO dto) {

        if (dto.getId() == null || dto.getPassword() == null) {
            return "redirect:/member/join.htm";
        }

        joinService.join(dto);

        // ✅ 무조건 여기로 이동
        return "redirect:/member/joinend.htm";
    }



    /**
     * 회원가입 완료 화면
     */
    @GetMapping("/joinend.htm")
    public String joinEnd() {
        return "user/joinend";   // ❗❗ 절대 /member/joinend 아님
    }




    /**
     * 아이디 중복 체크 (AJAX)
     * 반환값:
     *  - OK        : 사용 가능
     *  - DUPLICATE : 이미 사용 중
     *  - EMPTY     : 값 없음
     */
    @GetMapping("/id-check.htm")
    @ResponseBody
    public String idCheck(@RequestParam("id") String id) {

        if (id == null || id.trim().isEmpty()) {
            return "EMPTY";
        }

        boolean duplicate = memberService.isDuplicateId(id);
        return duplicate ? "DUPLICATE" : "OK";
    }

    
}
