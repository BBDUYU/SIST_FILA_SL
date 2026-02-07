package com.fila.app.controller.mypage.member;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.mypage.member.MypageMemberService;

@Controller
@RequestMapping("/mypage/member")
public class MemberModifyController {

    private final MypageMemberService mypageMemberService;

    @Autowired
    public MemberModifyController(MypageMemberService mypageMemberService) {
        this.mypageMemberService = mypageMemberService;
    }

    // 내정보 변경 화면
    @GetMapping("/modify.htm")
    public String modifyPage(HttpSession session, Model model) {
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/member/login.htm";

        int memberNo = auth.getUserNumber();
        model.addAttribute("childList", mypageMemberService.getChildList(memberNo));
        model.addAttribute("mktMap", mypageMemberService.getMarketingStatus(memberNo));

        return "mypage/modifyInfo";
    }

    // 🔥 여기 추가하는 메서드 (비밀번호 변경)
    @PostMapping("/password-change")
    public String changePassword(
            HttpSession session,
            String currentPw,
            String newPw,
            String confirmPw,
            Model model) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) {
            return "redirect:/member/login.htm";
        }

        // 새 비밀번호 확인
        if (!newPw.equals(confirmPw)) {
            model.addAttribute("pwError", "새 비밀번호가 일치하지 않습니다.");
            return "mypage/modifyInfo";
        }

        boolean success = mypageMemberService.changePassword(
        	    auth.getUserNumber(),  // ✔ int memberNo
        	    currentPw,
        	    newPw
        	);


        if (!success) {
            model.addAttribute("pwError", "현재 비밀번호가 올바르지 않습니다.");
            return "mypage/modifyInfo";
        }

        model.addAttribute("pwSuccess", "비밀번호가 변경되었습니다.");
        return "mypage/modifyInfo";
    }
}
