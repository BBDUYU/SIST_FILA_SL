package command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.util.DBConn;

import member.domain.MemberDTO;
import review.ReviewDAO;
import review.ReviewDAOImpl;

public class ReviewLikeHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. JSON 말고 일반 텍스트로 보낸다고 선언
        response.setContentType("text/plain; charset=utf-8"); 
        
        HttpSession session = request.getSession();
        MemberDTO auth = (MemberDTO) session.getAttribute("auth");
        
        // 2. 로그인 안 했으면 "login" 글자 리턴
        if (auth == null) {
            response.getWriter().print("login");
            return null;
        }

        int userNumber = auth.getUserNumber(); 
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        int type = Integer.parseInt(request.getParameter("type"));

        java.sql.Connection conn = DBConn.getConnection();
        ReviewDAO dao = new ReviewDAOImpl(conn);
        
        // 3. DAO 결과 받기
        int result = dao.insertReviewLike(reviewId, userNumber, type);
        DBConn.close();

        // 4. 결과값 숫자 그대로 보내기 (1, -1, 0)
        response.getWriter().print(result);
        return null;
    }
}