package fila.order.command;

import java.sql.Connection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import fila.com.util.ConnectionProvider;
import fila.command.CommandHandler;
import fila.member.MemberDTO;
import fila.order.domain.OrderDTO;
import fila.order.persistence.OrderDAO;

//MyOrderListHandler.java

public class MyOrderListHandler implements CommandHandler {
 @Override
 public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
     HttpSession session = request.getSession();
     MemberDTO auth = (MemberDTO) session.getAttribute("auth");
     
     if (auth == null) return "redirect:/member/login.htm";

     try (Connection conn = ConnectionProvider.getConnection()) {
         OrderDAO dao = OrderDAO.getInstance();
         
         List<OrderDTO> list = dao.selectUserOrderList(conn, auth.getUserNumber(), "ORDER");
         
         request.setAttribute("orderList", list);
         request.setAttribute("totalCount", list.size()); // 총 건수 표시용
     }
     
     return "/view/mypage/orders.jsp";
 }
}