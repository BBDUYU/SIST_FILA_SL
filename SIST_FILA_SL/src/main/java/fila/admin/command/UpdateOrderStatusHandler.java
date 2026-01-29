package fila.admin.command;

import java.io.PrintWriter;
import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.com.util.ConnectionProvider;
import fila.com.util.JdbcUtil;
import fila.command.CommandHandler;
import fila.order.persistence.OrderDAO;
import net.sf.json.JSONObject;

public class UpdateOrderStatusHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // POST 방식만 허용
        if (!request.getMethod().equalsIgnoreCase("POST")) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();

        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            OrderDAO dao = OrderDAO.getInstance();

            // 주문 상태 업데이트 실행
            int result = dao.updateOrderStatus(conn, orderId, status);

            if (result > 0) {
                json.put("status", "success");
                json.put("message", "[" + status + "] 처리가 완료되었습니다.");
            } else {
                json.put("status", "error");
                json.put("message", "상태 변경에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.put("status", "error");
            json.put("message", "서버 오류: " + e.getMessage());
        } finally {
            JdbcUtil.close(conn);
        }

        out.print(json.toString());
        return null;
    }
}