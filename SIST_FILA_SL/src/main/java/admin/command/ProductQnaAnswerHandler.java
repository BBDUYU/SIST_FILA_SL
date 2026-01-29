package admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import command.CommandHandler;
import qna.QnaDAO;
import qna.QnaDAOImpl;

public class ProductQnaAnswerHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    request.setCharacterEncoding("UTF-8");
	    
	    String qnaIdStr = request.getParameter("qna_id");
	    String answerContent = request.getParameter("answer_content");
	    
	    int qnaId = Integer.parseInt(qnaIdStr);
	    QnaDAO dao = QnaDAOImpl.getInstance();
	    int result = dao.updateAnswer(qnaId, answerContent);

	    // 경고창 띄우기
	    if (result > 0) {
	        request.setAttribute("msg", "답변이 성공적으로 등록되었습니다.");
	    } else {
	        request.setAttribute("msg", "답변 등록에 실패하였습니다.");
	    }
	    
	    // 상세 페이지로 다시 보내기 (수정된 내용을 바로 확인하기 위함)
	    request.setAttribute("loc", request.getContextPath() + "/admin/productQnaDetail.htm?qna_id=" + qnaId);
	    
	    // alert를 띄워줄 전용 JSP 페이지로 포워딩
	    return "/view/admin/message.jsp"; 
	}
}