package order.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import order.domain.OrderDTO;
import order.service.OrderService;

public class CompleteHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String orderId = request.getParameter("orderId");
        
        OrderService service = OrderService.getInstance();
        OrderDTO order = service.getOrderDetail(orderId);
        request.setAttribute("order", order);

        request.setAttribute("orderId", orderId);
        
        return "/view/order/complete.jsp"; // 완료 페이지 경로
    }
}