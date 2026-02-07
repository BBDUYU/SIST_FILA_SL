package com.fila.app.controller.mypage.qna;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.mypage.qna.MypageQnaService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MypageQnaController {

    private final MypageQnaService service;

    // 1:1 문의 작성 폼 (모달용 HTML 반환)
    @GetMapping("/qnaWriteForm.htm")
    public String qnaWriteForm(Model model) {
        List<MypageQnaCategoryVO> categories = service.getQnaCategoryList();
        model.addAttribute("categoryList", categories); // 변수명 확인
        return "mypage/qna_add"; 
    }

    @PostMapping("/write.htm")
    @ResponseBody
    public String write(
            @ModelAttribute MypageQnaVO vo,
            HttpSession session) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) {
            return "NO_AUTH";
        }

        // ✅ 작성자 세션에서 주입
        vo.setUserNumber(auth.getUserNumber());

        // ✅ 기본 상태 세팅 (DB default가 없을 경우 대비)
        vo.setStatus("WAIT");

        service.writeInquiry(vo);
        return "OK";
    }


    // 1:1 문의 목록 페이지
    @GetMapping("/qna.htm")
    public String qnaPage(
            @RequestParam(value = "status", required = false, defaultValue = "ALL") String status,
            HttpSession session, 
            Model model) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/member/login.htm";

        List<MypageQnaVO> list = service.getMyInquiryList(auth.getUserNumber(), status);
        model.addAttribute("qnaList", list);
        return "qna"; 
    }
    
    
}