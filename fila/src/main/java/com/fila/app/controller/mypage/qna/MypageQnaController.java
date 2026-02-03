package com.fila.app.controller.mypage.qna;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.mypage.qna.MypageQnaVO;
import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.service.mypage.qna.MypageQnaService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/mypage/qna")
@RequiredArgsConstructor
public class MypageQnaController {

    private final MypageQnaService service;

    /**
     * 1. 1:1 문의 작성 페이지 이동 (.htm 규칙 적용)
     */
    @RequestMapping(value = "/write.htm", method = RequestMethod.GET)
    public String writeForm(Model model) {
        // 카테고리 목록을 미리 넘겨주어 JSP에서 Select 박스를 구성하게 합니다.
        List<MypageQnaCategoryVO> categories = service.getCategories();
        model.addAttribute("categories", categories);
        
        return "mypage/qna_write";  // /WEB-INF/views/mypage/qna_write.jsp
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

    /**
     * 3. 내 문의 목록 조회
     */
    @RequestMapping(value = "/list.htm", method = RequestMethod.GET)
    public String list(@RequestParam(value = "status", required = false, defaultValue = "ALL") String status, 
                       Model model) {
        
        // 실제 프로젝트에서는 세션에서 userNumber를 가져와야 합니다.
        // 현재는 예시로 1L을 사용하거나, 로그인 정보 객체에서 추출하세요.
        long userNumber = 1L; 
        
        List<MypageQnaVO> list = service.getMyInquiryList(userNumber, status);
        model.addAttribute("qnaList", list);
        model.addAttribute("currentStatus", status);
        
        return "mypage/qna_list";
    }

    /**
     * 4. 문의 카테고리 목록 (AJAX용)
     */
    @RequestMapping(value = "/categories.htm", method = RequestMethod.GET)
    @ResponseBody
    public List<MypageQnaCategoryVO> categories() {
        return service.getCategories();
    }
}