package mypage.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import command.CommandHandler;
import mypage.domain.QNACategoriesDTO;
import mypage.service.QnaService;

public class QnaWriteFormHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        // 여기서 데이터를 담아줘야 JSP의 c:forEach가 작동합니다!
        QnaService service = QnaService.getInstance();
        List<QNACategoriesDTO> categoryList = service.getCategoryList();
        request.setAttribute("categoryList", categoryList);
        
        // 실제 JSP 파일 경로 리턴
        return "/view/mypage/qna_write.jsp"; 
    }
}