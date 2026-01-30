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

import com.fila.app.domain.MemberVO;
import com.fila.app.domain.qna.QnaVO;
import com.fila.app.service.qna.QnaService;

import lombok.Setter;

@Controller
@RequestMapping("/qna/*")
public class QnaController {

    @Setter(onMethod_ = @Autowired)
    private QnaService qnaService;
    
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
        qna.setUser_number(member.getUserNumber()); // MemberVO의 필드명 확인 (getUserNumber or getNo)
        
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
    
    // [관리자] 기능은 AdminController를 따로 만들거나 여기서 권한 체크 후 처리
}
