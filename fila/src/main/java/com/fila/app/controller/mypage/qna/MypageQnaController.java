package com.fila.app.controller.mypage.qna;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

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
     * 1️⃣ 1:1 문의 작성 페이지 이동
     * (mypage.jsp에서 include 하거나 이동용)
     */
    @GetMapping("/write")
    public String writeForm() {
        return "mypage/qna_write";  
        // 실제 JSP 경로에 맞게만 나중에 조정
    }

    /**
     * 2️⃣ 1:1 문의 등록 처리
     * (form submit 기준)
     */
    @PostMapping("/write")
    public String write(@ModelAttribute MypageQnaVO vo) {

        service.writeQna(vo);

        // 등록 후 목록으로 이동
        return "redirect:/mypage/qna/list";
    }

    /**
     * 3️⃣ 문의 카테고리 목록
     * (AJAX용, 지금은 안 써도 됨)
     */
    @GetMapping("/categories")
    @ResponseBody
    public List<MypageQnaCategoryVO> categories() {
        return service.getCategories();
    }
}
