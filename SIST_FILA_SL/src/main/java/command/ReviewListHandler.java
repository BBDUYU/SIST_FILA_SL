package command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.util.DBConn;
import member.MemberDTO;
import review.ReviewDAO;
import review.ReviewDAOImpl;
import review.ReviewDTO;

public class ReviewListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 파라미터 받기
        String productId = request.getParameter("product_id");
        String sort = request.getParameter("sort"); // "photo" 또는 null
        String keyword = request.getParameter("keyword");
        
        // 2. 로그인 유저 확인
        HttpSession session = request.getSession();
        MemberDTO auth = (MemberDTO) session.getAttribute("auth");
        int userNumber = (auth != null) ? auth.getUserNumber() : 0;
        
        // 3. DB에서 리스트 다시 조회
        ReviewDAO dao = new ReviewDAOImpl(DBConn.getConnection());
        
        // Rating 필터는 일단 null 처리 (나중에 필요하면 추가)
        List<ReviewDTO> list = dao.selectListByFilter(productId, null, userNumber, sort, keyword);
        DBConn.close();
        
        // 4. 결과 저장
        request.setAttribute("reviewList", list);
        
        return "/view/review/review_list.jsp";
    }
}