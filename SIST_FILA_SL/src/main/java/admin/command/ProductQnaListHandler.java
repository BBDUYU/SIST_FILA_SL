package admin.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import qna.QnaDAO;
import qna.QnaDAOImpl; // [추가] 이게 있어야 QnaDAOImpl.getInstance()를 쓸 수 있습니다!
import qna.QnaDTO; 

public class ProductQnaListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 사이드바 활성화를 위한 설정
        request.setAttribute("pageName", "productQna");

        // 2. 인터페이스 타입(QnaDAO)으로 변수를 선언하고, 실제 객체는 구현체(QnaDAOImpl)에서 가져옵니다.
        QnaDAO dao = QnaDAOImpl.getInstance();
        
        // 3. 관리자용 전체 목록 조회 메서드 호출
        List<QnaDTO> list = dao.selectAdminQnaList(); 
        request.setAttribute("qnaList", list);

        // 4. JSP 경로 리턴 (조장님 규칙 준수)
        return "/view/admin/product_qna_list.jsp"; 
    }
}