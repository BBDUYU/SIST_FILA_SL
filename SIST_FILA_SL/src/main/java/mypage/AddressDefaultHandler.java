package mypage;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.MemberDTO;

import com.util.ConnectionProvider;

public class AddressDefaultHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1. 로그인 체크
        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) {
            return "redirect:/login.htm";
        }

        // 2. POST만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(405);
            return null;
        }

        int addrNo = Integer.parseInt(request.getParameter("addrNo"));
        int userNumber = loginUser.getUserNumber();

        AddressDAO dao = new AddressDAO();

        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);

            // 3. 기존 기본 배송지 해제
            dao.clearDefault(conn, userNumber);

            // 4. 선택한 주소를 기본 배송지로 설정
            dao.setDefault(conn, addrNo, userNumber);

            conn.commit();
        }

        // 5. JSON 응답
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"ok\":true}");
        return null;
    }
}