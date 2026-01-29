package admin.command;

import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import command.CommandHandler;
import net.sf.json.JSONObject;
import order.domain.OrderItemDTO;
import order.persistence.OrderDAO;

public class AdminOrderUpdateHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        JSONObject json = new JSONObject();  
        Connection conn = null;
        
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작 (상태변경+재고복구)
            
            OrderDAO dao = OrderDAO.getInstance();
            
            // 1. 주문 상태 업데이트 실행
            int result = dao.updateOrderStatus(conn, orderId, newStatus);

         // AdminOrderUpdateHandler.java

            if (result > 0) {
                // 1. 상태가 '취소완료' 또는 '반품완료'로 변경될 때만 재고 복구 실행
                if ("취소완료".equals(newStatus) || "반품완료".equals(newStatus)) {

                    List<OrderItemDTO> items = dao.selectOrderItemsDetail(conn, orderId);
                    
                    for (OrderItemDTO item : items) {
                        if (item.getCombinationId() > 0) {
                            // DB의 재고를 주문 수량만큼 다시 더함
                            dao.updateIncreaseStock(conn, item.getCombinationId(), item.getQuantity());
                        }
                    }
                }
                
                conn.commit();
                json.put("status", "success");
            } else {
                conn.rollback();
                json.put("status", "error");
                json.put("message", "변경할 주문 내역이 없습니다.");
            }
        } catch (Exception e) {
            if (conn != null) JdbcUtil.rollback(conn);
            e.printStackTrace();
            json.put("status", "error");
            json.put("message", "서버 오류: " + e.getMessage());
        } finally {
            JdbcUtil.close(conn);
        }

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().print(json.toString());
        return null;
    }
}