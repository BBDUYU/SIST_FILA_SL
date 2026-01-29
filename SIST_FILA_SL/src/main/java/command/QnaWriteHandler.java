package command; // ★ 패키지명 확인! (com.fila.qna.handler 면 그걸로 수정)

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import command.CommandHandler;
import member.domain.MemberDTO;
import productsqna.QnaDAOImpl;
import productsqna.QnaDTO;

public class QnaWriteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 인코딩
        request.setCharacterEncoding("UTF-8");
        
        // 2. 로그인 체크 & 회원번호 가져오기
        HttpSession session = request.getSession();
        
        // ★ 세션에 저장된 건 "MemberDTO" 입니다.
        MemberDTO member = (MemberDTO) session.getAttribute("auth");
        
        // 로그인이 안 되어 있다면 401 에러 리턴
        if (member == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
            return null;
        }

        // 3. 파라미터 받기
        String productId = request.getParameter("productId");
        String qnaType = request.getParameter("qnaType");
        String qnaContent = request.getParameter("qnaContent");
        String memberEmail = request.getParameter("memberEmail");
        String emailChk = request.getParameter("emailChk");
        
        // 4. DTO에 담기
        QnaDTO dto = new QnaDTO();
        dto.setProduct_id(productId); 
        dto.setType(qnaType);
        dto.setQuestion(qnaContent);
        dto.setAnswer_email(memberEmail);
        dto.setUser_number(member.getUserNumber()); 
        
        // 이메일 수신 여부
        if ("on".equals(emailChk)) {
            dto.setIs_email_notify(1);
        } else {
            dto.setIs_email_notify(0);
        }

        dto.setIs_secret(0); // 비밀글 아님(공개)
        
        // 5. DB 저장
        QnaDAOImpl dao = QnaDAOImpl.getInstance();
        int result = dao.insert(dto); 
        
        // 6. 응답
        response.setContentType("text/plain; charset=UTF-8");
        if (result > 0) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("fail");
        }
        
        return null;
    }
}