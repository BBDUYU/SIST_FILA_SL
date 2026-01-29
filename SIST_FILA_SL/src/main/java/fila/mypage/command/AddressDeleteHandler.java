package fila.mypage.command;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.com.util.ConnectionProvider;
import fila.command.CommandHandler;
import fila.member.MemberDTO;
import fila.mypage.persistence.AddressDAO;

public class AddressDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1) 로그인 체크
        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        // 2) POST만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(405);
            return null;
        }

        request.setCharacterEncoding("UTF-8");

        int addrNo = Integer.parseInt(request.getParameter("addrNo"));
        int userNumber = loginUser.getUserNumber();

        AddressDAO dao = new AddressDAO();
        Connection conn = null;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            // ✅ (A) 기본배송지 삭제 방지 - DB에서도 막기
            int isDefault = dao.isDefault(conn, addrNo, userNumber);
            if (isDefault == 1) {
                conn.rollback();
                response.setStatus(400);
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"ok\":false,\"error\":\"DEFAULT_CANNOT_DELETE\"}");
                return null;
            }

            // ✅ (B) 주문에 사용된 배송지 삭제 방지 (FK_ORDER_ADDRESS 때문에)
            // ※ dao.hasOrderReference() 안 SQL은 너희 스키마(자식테이블/컬럼)에 맞춰야 함
            boolean usedInOrder = dao.hasOrderReference(conn, addrNo, userNumber);
            if (usedInOrder) {
                conn.rollback();
                response.setStatus(400);
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"ok\":false,\"error\":\"USED_IN_ORDER\"}");
                return null;
            }

            // ✅ (C) 실제 삭제 (본인 것만)
            int deleted = dao.delete(conn, addrNo, userNumber);
            if (deleted == 0) {
                conn.rollback();
                response.setStatus(404);
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"ok\":false,\"error\":\"NOT_FOUND\"}");
                return null;
            }

            conn.commit();

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"ok\":true}");
            return null;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignore) {}
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception ignore) {}
            }
        }
    }
}