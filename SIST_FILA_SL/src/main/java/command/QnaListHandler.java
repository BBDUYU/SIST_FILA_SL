package command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import productsqna.QnaDAO;
import productsqna.QnaDAOImpl;
import productsqna.QnaDTO;

public class QnaListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String productId = request.getParameter("product_id");
        
        // [수정된 부분] new QnaDAOImpl() 대신 getInstance() 사용
        QnaDAO dao = QnaDAOImpl.getInstance(); 
        
        List<QnaDTO> list = dao.selectList(productId); // DB에서 목록 조회
        
        request.setAttribute("qnaList", list);
        
        // 리스트용 JSP 조각 파일 경로 (본인 프로젝트 경로에 맞게 확인!)
        return "/view/qna/qna_list.jsp"; 
    }
}