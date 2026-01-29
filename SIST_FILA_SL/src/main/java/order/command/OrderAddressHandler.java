package order.command;

import java.sql.Connection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import command.CommandHandler;
import member.domain.MemberDTO;
import mypage.domain.AddressDTO;
import mypage.persistence.AddressDAO;

public class OrderAddressHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 세션에서 로그인 정보 확인
        HttpSession session = request.getSession();
        MemberDTO authUser = (MemberDTO) session.getAttribute("auth");
        
        if (authUser == null) {
            return null; // 로그인이 안 되어 있으면 빈 결과 반환
        }

        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            AddressDAO addressDao = new AddressDAO();
            
            // 2. 유저의 배송지 목록 가져오기
            List<AddressDTO> addressList = addressDao.selectListByUser(conn, authUser.getUserNumber());
            
            // 3. JSP로 전달
            request.setAttribute("addressList", addressList);
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }

        // 4. 모달용 JSP로 포워딩 (경로 확인 필요)
        return "/view/order/order_address.jsp"; 
    }
}