package com.fila.app.controller.admin;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fila.app.domain.qna.QnaVO;
import com.fila.app.service.qna.QnaService;

@Controller
@RequestMapping("/admin")
public class AdminQnaController {

    @Autowired
    private QnaService qnaService;

    /**
     * 1. 상품 문의 목록 조회 (getAdminQnaList 호출)
     */
    @RequestMapping("/productQnaList.htm")
    public String productQnaList(Model model) {
        model.addAttribute("pageName", "productQna");
        // 서비스 구현체의 메서드명으로 변경
        List<QnaVO> list = qnaService.getAdminQnaList(); 
        model.addAttribute("qnaList", list);
        return "admin/product_qna_list";
    }

    /**
     * 2. 상품 문의 상세 조회 (getQnaDetail 호출)
     */
    @RequestMapping("/productQnaDetail.htm")
    public String productQnaDetail(@RequestParam("qna_id") int qnaId, Model model) {
        model.addAttribute("pageName", "productQna");
        // 서비스 구현체의 메서드명으로 변경
        QnaVO vo = qnaService.getQnaDetail(qnaId);
        model.addAttribute("qna", vo);
        return "admin/product_qna_detail";
    }

    /**
     * 3. 상품 문의 답변 등록 (answerQna 호출)
     */
    @RequestMapping(value = "/productQnaAnswer.htm", method = RequestMethod.POST)
    public String productQnaAnswer(@RequestParam("qna_id") int qnaId,
                                   @RequestParam("answer_content") String answerContent,
                                   RedirectAttributes rttr) {
        
        // 서비스 구현체의 메서드명으로 변경
        int result = qnaService.answerQna(qnaId, answerContent);

        if (result > 0) {
            rttr.addFlashAttribute("msg", "답변이 성공적으로 등록되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "답변 등록에 실패하였습니다.");
        }

        return "redirect:/admin/productQnaDetail.htm?qna_id=" + qnaId;
    }

    /**
     * 4. 1:1 문의 답변 등록 (AJAX 방식)
     * 만약 1:1 문의도 동일한 로직을 사용한다면 answerQna를 재사용합니다.
     */
    @RequestMapping(value = "/answerInquiry.htm", method = RequestMethod.POST)
    @ResponseBody
    public String answerInquiry(@RequestParam("inquiryId") int inquiryId,
                                @RequestParam("content") String content) {
        try {
            qnaService.answerQna(inquiryId, content);
            return "success";
        } catch (Exception e) {
            return "fail";
        }
    }
}