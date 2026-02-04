package com.fila.app.controller.qna;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.qna.QnaVO;
import com.fila.app.service.qna.QnaService;

import lombok.Setter;

@Controller
@RequestMapping("/qna/*")
public class QnaController {

    @Setter(onMethod_ = @Autowired)
    private QnaService qnaService;
    
    // ==========================================
    // [사용자(User) 기능]
    // ==========================================
    
    // [AJAX] 문의 작성 처리
    @PostMapping(value = "/write.do", produces = "text/plain; charset=UTF-8")
    @ResponseBody // 문자열 "success" or "fail"을 그대로 응답
    public String write(
            QnaVO qna, 
            HttpSession session
            ) {
        
        // 1. 로그인 체크
        MemberVO member = (MemberVO) session.getAttribute("auth");
        if (member == null) {
            return "login_required"; // 프론트에서 처리할 에러 코드
        }
        
        // 2. 작성자 정보 세팅
        qna.setUserNumber(member.getUserNumber()); // MemberVO의 필드명 확인 (getUserNumber or getNo)
        
        // 3. 서비스 호출
        int result = qnaService.writeQna(qna);
        
        return result > 0 ? "success" : "fail";
    }
    
    // [AJAX or Include] 문의 목록 가져오기
    @GetMapping("/list")
    public String list(
            @RequestParam("productId") String productId,
            Model model
            ) {
        
        // 목록 조회 서비스 호출
        List<QnaVO> list = qnaService.getQnaList(productId);
        
        model.addAttribute("qnaList", list);
        
        // JSP 조각(Fragment) 리턴 -> AJAX로 로드해서 끼워넣기용
        return "qna/qna_list_fragment"; 
    }
    
    // ==========================================
    // [관리자(Admin) 기능]
    // ==========================================
    
    // 관리자용 전체 목록 조회 (ProductQnaListHandler 대체)
    @GetMapping("/admin/list")
    public String adminList(Model model, HttpSession session) {
    	
        MemberVO member = (MemberVO) session.getAttribute("auth");
        if(member == null || !member.getId().equals("admin")) return "redirect:/login";

        // 사이드바 활성화를 위한 설정
        model.addAttribute("pageName", "productQna");

        // 전체 목록 조회
        List<QnaVO> list = qnaService.getAdminQnaList();
        model.addAttribute("qnaList", list);

        return "admin/product_qna_list"; // /WEB-INF/views/admin/product_qna_list.jsp
    }

    // 관리자용 상세 조회 (ProductQnaDetailHandler 대체)
    @GetMapping("/admin/detail")
    public String adminDetail(@RequestParam("qna_id") int qnaId, Model model) {
        
        model.addAttribute("pageName", "productQna");

        // 상세 내용 조회
        QnaVO qna = qnaService.getQnaDetail(qnaId);
        model.addAttribute("qna", qna);

        return "admin/product_qna_detail";
    }

    // 5. 관리자 답변 등록 처리 (ProductQnaAnswerHandler 대체)
    @PostMapping("/admin/answer")
    public String adminAnswer(
            @RequestParam("qna_id") int qnaId,
            @RequestParam("answer_content") String answerContent,
            Model model
            ) {
        
        // 답변 등록 및 상태 변경 서비스 호출
        int result = qnaService.answerQna(qnaId, answerContent);

        // 결과 메시지 세팅
        if (result > 0) {
            model.addAttribute("msg", "답변이 성공적으로 등록되었습니다.");
        } else {
            model.addAttribute("msg", "답변 등록에 실패하였습니다.");
        }
        
        // 확인 누르면 다시 상세 페이지로 이동하도록 설정
        model.addAttribute("loc", "/qna/admin/detail?qna_id=" + qnaId);
        
        // 공통 알림창 JSP로 이동 (아까 만든 common/message.jsp 사용 추천)
        return "common/message"; 
    }
    
}
