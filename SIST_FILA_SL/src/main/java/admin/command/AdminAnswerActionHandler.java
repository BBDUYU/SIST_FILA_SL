package admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import command.CommandHandler;
import mypage.qna.QnaService;

public class AdminAnswerActionHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 파라미터 받기 (JSP의 AJAX data 속성 이름과 일치해야 함)
        String inquiryIdStr = request.getParameter("inquiryId");
        String replyContent = request.getParameter("content");

        if (inquiryIdStr == null || replyContent == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        long inquiryId = Long.parseLong(inquiryIdStr);

        // 2. 서비스 호출하여 답변 저장
        QnaService service = QnaService.getInstance();
        service.answerInquiry(inquiryId, replyContent);

        // 3. AJAX 응답 (성공 시 메시지나 빈 값 반환)
        response.getWriter().write("success");
        return null;
    }
}