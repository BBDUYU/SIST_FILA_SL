package com.fila.app.controller.mypage.qna;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO;
import com.fila.app.service.mypage.qna.MypageQnaService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MypageQnaController {

    private final MypageQnaService service;

    /**
     * 1. 1:1 문의 작성 페이지 이동 (.htm 규칙 적용) 
     */
    @RequestMapping(value = "/qnaWriteForm.htm", method = RequestMethod.GET)
    public String writeForm(Model model) {

        System.out.println("### qnaWriteForm 컨트롤러 진입 ###");

        List<MypageQnaCategoryVO> categoryList = service.getCategories();

        System.out.println("### category size = " + categoryList.size());

        model.addAttribute("categoryList", categoryList);

        return "mypage/qna_write";
    }


    /**
     * 2. 1:1 문의 등록 처리 (.htm 규칙 적용)
     */
    @RequestMapping(value = "/write.htm", method = RequestMethod.POST)
    public String write(@ModelAttribute MypageQnaVO vo) {
        // 서비스 구현체의 실제 메서드명인 writeInquiry 호출
        service.writeInquiry(vo);

        // 등록 후 목록으로 이동
        return "redirect:/mypage/qna/list.htm";
    }

    @RequestMapping(value = "/qna.htm", method = RequestMethod.GET)
    public String list(
            @RequestParam(value = "status", required = false, defaultValue = "ALL") String status,
            HttpSession session,
            Model model
    ) {
        MemberVO auth = (MemberVO) session.getAttribute("auth");

        if (auth == null) {
            model.addAttribute("qnaList", List.of());
            model.addAttribute("currentStatus", status);
            return "qna";
        }

        long userNumber = auth.getUserNumber();

        List<MypageQnaVO> list =
                service.getMyInquiryList(userNumber, status); // 🔥 시그니처 일치

        model.addAttribute("qnaList", list);
        model.addAttribute("currentStatus", status);

        return "qna";
    }



    /**
     * 4. 문의 카테고리 목록 (AJAX용)
     */
    @RequestMapping(value = "/categories.htm", method = RequestMethod.GET)
    @ResponseBody
    public List<MypageQnaCategoryVO> categories() {
        return service.getCategories();
    }
    
    @RequestMapping(value = "/qnaWrite.htm", method = RequestMethod.POST)
    @ResponseBody
    public String writeQna(
            @ModelAttribute MypageQnaVO vo,
            HttpSession session
    ) {
        try {
            MemberVO auth = (MemberVO) session.getAttribute("auth");
            vo.setUserNumber(auth.getUserNumber());

            service.writeInquiry(vo);

            return "OK";
        } catch (Exception e) {
            e.printStackTrace();
            return "FAIL";
        }
    }


}