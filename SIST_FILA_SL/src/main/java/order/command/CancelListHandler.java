package order.command;

import java.sql.Connection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.util.ConnectionProvider;

import command.CommandHandler;
import member.MemberDTO;

import order.domain.OrderDTO;
import order.persistence.OrderDAO;

public class CancelListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        MemberDTO auth = (MemberDTO) session.getAttribute("auth");
        
        if (auth == null) return "redirect:/login.htm";

        try (Connection conn = ConnectionProvider.getConnection()) {
            OrderDAO dao = OrderDAO.getInstance();
            // "CANCEL" 타입을 인자로 전달하여 취소/반품 관련 주문만 조회
            List<OrderDTO> list = dao.selectUserOrderList(conn, auth.getUserNumber(), "CANCEL");
            request.setAttribute("orderList", list);
            request.setAttribute("totalCount", list.size());
        }

        return "/view/mypage/inquiry.jsp"; // 교환/취소/반품 전용 JSP
    }
}
