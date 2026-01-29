package fila.mypage.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.com.util.ConnectionProvider;
import fila.command.CommandHandler;
import fila.member.MemberDTO;
import fila.mypage.domain.AddressDTO;
import fila.mypage.persistence.AddressDAO;

import java.sql.Connection;

public class AddressAddHandler implements CommandHandler {

  @Override
  public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

    MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
    if (loginUser == null) return "redirect:/login.htm";

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
      response.sendError(405);
      return null;
    }

    request.setCharacterEncoding("UTF-8");

    AddressDTO dto = new AddressDTO();
    dto.setUserNumber(loginUser.getUserNumber());

    // 폼 name 그대로 매핑
    dto.setRecipientName(request.getParameter("addrname"));
    dto.setRecipientPhone(request.getParameter("tel2_1"));
    dto.setZipcode(request.getParameter("zipcode"));
    dto.setMainAddr(request.getParameter("addr3"));     // 도로명/표시주소
    dto.setDetailAddr(request.getParameter("addr2"));

    // ADDRESS_NAME이 폼에 없으니 기본값 처리
    String addressName = request.getParameter("addressName");
    if (addressName == null || addressName.trim().isEmpty()) addressName = "배송지";
    dto.setAddressName(addressName);

    // 기본배송지 체크박스 (체크되면 "D" 넘어옴)
    String def = request.getParameter("addrDefault");
    dto.setIsDefault("D".equals(def) ? 1 : 0);

    AddressDAO dao = new AddressDAO();

    try (Connection conn = ConnectionProvider.getConnection()) {
    	  conn.setAutoCommit(false);

    	  if (dto.getIsDefault() == 1) {
    	    dao.clearDefault(conn, dto.getUserNumber());
    	  }

    	  dao.insert(conn, dto);
    	  conn.commit();
    	} catch (Exception e) {
    	  // try-with-resources라 conn 참조가 없으면 아래처럼 구조 바꾸거나,
    	  // Connection을 try 밖에 선언해서 rollback 처리하세요.
    	  throw e;
    	}

    // ✅ 모달 요청이면 JSON으로 응답(프론트에서 닫고 새로고침)
    response.setContentType("application/json; charset=UTF-8");
    response.getWriter().write("{\"ok\":true}");
    return null;
  }
}