package fila.mypage.command;

import java.sql.Connection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.com.util.ConnectionProvider;
import fila.command.CommandHandler;
import fila.member.MemberDTO;
import fila.mypage.domain.AddressDTO;
import fila.mypage.persistence.AddressDAO;

public class DeliveryAddressHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1) 로그인 체크
        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) {
            return "redirect:/login.htm";
        }

        // 2) 배송지 목록 조회해서 request에 담기
        AddressDAO dao = new AddressDAO();

        try (Connection conn = ConnectionProvider.getConnection()) {
            // ✅ 기본배송지 먼저, 최신순 정렬된 리스트를 가져온다고 가정
            List<AddressDTO> list = dao.selectListByUser(conn, loginUser.getUserNumber());
            request.setAttribute("addrList", list);
        }

        // 3) 페이지 이동
        return "/view/mypage/delivery_address.jsp";
    }
}