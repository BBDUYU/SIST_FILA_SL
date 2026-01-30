package com.fila.app.controller.join;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.MemberVO;
import com.fila.app.service.member.MemberService;

@Controller
@RequestMapping("/member")
public class JoinController {

    @Autowired
    private MemberService memberService;

    /**
     * 회원가입 화면
     * (지금은 JSP 없어도 OK)
     */
    @GetMapping("/join.do")
    public String joinForm() {
        return "join"; // 나중에 join.jsp
    }

    /**
     * 회원가입 처리
     */
    @PostMapping("/join.do")
    public String joinProcess(MemberVO dto) {

        // 핵심: Service → Mapper → DB
        memberService.join(dto);

        return "redirect:/member/joinEnd.do";
    }

    /**
     * 회원가입 완료
     */
    @GetMapping("/joinEnd.do")
    public String joinEnd() {
        return "joinend"; // 나중에 joinend.jsp
    }

    /**
     * 아이디 중복 체크 (ajax / 테스트용)
     */
    @GetMapping("/id-check.do")
    @ResponseBody
    public boolean idCheck(@RequestParam("id") String id) {
        return memberService.isDuplicateId(id);
    }
}
