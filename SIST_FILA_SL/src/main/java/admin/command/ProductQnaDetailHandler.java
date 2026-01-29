package admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import command.CommandHandler;
import productsqna.QnaDAO;
import productsqna.QnaDAOImpl;
import productsqna.QnaDTO;

public class ProductQnaDetailHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String qnaIdStr = request.getParameter("qna_id");
        if (qnaIdStr == null || qnaIdStr.isEmpty()) {
            return "redirect:/admin/productQnaList.htm";
        }
        
        int qnaId = Integer.parseInt(qnaIdStr);
        request.setAttribute("pageName", "productQna");

        // [수정] Impl에서 인스턴스를 가져옵니다.
        QnaDAO dao = QnaDAOImpl.getInstance();
        QnaDTO dto = dao.selectQnaDetail(qnaId); 
        request.setAttribute("qna", dto); 

        // [수정] 리턴 경로 확인 (view 폴더 포함)
        return "/view/admin/product_qna_detail.jsp";
    }
}