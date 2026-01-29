package admin.command;

import java.sql.Connection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.util.ConnectionProvider;
import command.CommandHandler;
import net.sf.json.JSONArray;
import order.domain.OrderItemDTO;
import order.persistence.OrderDAO;

public class AdminOrderDetailHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String orderId = request.getParameter("orderId");
        
        try (Connection conn = ConnectionProvider.getConnection()) {
            OrderDAO dao = OrderDAO.getInstance();
            // 아까 만든 조인 쿼리 메서드 호출
            List<OrderItemDTO> items = dao.selectOrderItemsDetail(conn, orderId);

            // 리스트를 JSON 배열로 변환
            JSONArray jsonArray = JSONArray.fromObject(items);
            
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().print(jsonArray.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        return null; // AJAX 응답이므로 뷰 페이지로 이동하지 않음
    }
}