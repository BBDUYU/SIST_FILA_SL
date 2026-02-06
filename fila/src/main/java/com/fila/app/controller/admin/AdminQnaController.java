package com.fila.app.controller.admin;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fila.app.domain.mypage.qna.MypageQnaVO;
import com.fila.app.domain.qna.QnaVO;
import com.fila.app.service.mypage.qna.MypageQnaService;
import com.fila.app.service.qna.QnaService;

@Controller
@RequestMapping("/admin")
public class AdminQnaController {

    @Autowired
    private QnaService qnaService;
    
    @Autowired
    private MypageQnaService myPageqnaService;

    /**
     * 1. 상품 문의 목록 조회 (getAdminQnaList 호출)
     */
    @RequestMapping("/productQnaList.htm")
    public String productQnaList(Model model) {
        model.addAttribute("pageName", "productQna");
        // 서비스 구현체의 메서드명으로 변경
        List<QnaVO> list = qnaService.getAdminQnaList(); 
        model.addAttribute("qnaList", list);
        return "product_qna_list";
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
        return "product_qna_detail";
    }

    /**
     * 3. 상품 문의 답변 등록 (answerQna 호출)
     */
    @RequestMapping(value = "/saveProductAnswer.htm", method = RequestMethod.POST)
    public void productQnaAnswer(@RequestParam("qna_id") int qnaId,
                                 @RequestParam("answer_content") String answerContent,
                                 HttpServletResponse response) throws Exception {
        
        int result = qnaService.answerQna(qnaId, answerContent);

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (result > 0) {
            out.println("<script>");
            out.println("alert('답변이 성공적으로 등록되었습니다.');");
            // 상세 페이지로 다시 이동
            out.println("location.href='productQnaDetail.htm?qna_id=" + qnaId + "';");
            out.println("</script>");
        } else {
            out.println("<script>");
            out.println("alert('답변 등록에 실패하였습니다.');");
            out.println("history.back();"); // 실패 시 이전 입력창으로
            out.println("</script>");
        }
        out.flush();
    }

	    /**
	     * 4. 1:1 문의 답변 등록 (AJAX 방식)
	     * 만약 1:1 문의도 동일한 로직을 사용한다면 answerQna를 재사용합니다.
	     */
    @RequestMapping(value = "/answerAction.htm", method = RequestMethod.POST)
    @ResponseBody
    public String answerInquiry(@RequestParam("inquiryId") int inquiryId,
                                @RequestParam("content") String content) {
        try {
            // qnaService 대신 myPageqnaService의 1:1 문의 전용 메서드 호출
            boolean isSuccess = myPageqnaService.answerInquiry(inquiryId, content);
            return isSuccess ? "success" : "fail";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/admin/inquiryList.htm";
    }
    
    @RequestMapping("/inquiryList.htm")
    public String inquiryList(Model model) {
        // 1. 페이지 제목이나 메뉴 활성화를 위한 속성 (선택사항)
        model.addAttribute("pageName", "inquiryList");

        // 2. 서비스 호출 (기존 핸들러의 service.getAllInquiryList() 로직)
        // QnaService 인터페이스에 getAllInquiryList() 메서드가 정의되어 있어야 합니다.
        List<MypageQnaVO> list = myPageqnaService.getAllInquiries(); 
        
        // 3. JSP로 데이터 전달
        model.addAttribute("adminQnaList", list);
        
        // 4. View 경로 리턴 (기존 /view/admin/inquiryList.jsp 에 대응)
        // ViewResolver 설정에 따라 "admin/inquiryList" 등으로 바뀔 수 있습니다.
        return "inquiryList"; 
    }
    
}