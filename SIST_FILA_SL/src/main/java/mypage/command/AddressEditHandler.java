package mypage.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.MemberDTO;

import java.sql.Connection;

import com.util.ConnectionProvider;

import mypage.domain.AddressDTO;
import mypage.persistence.AddressDAO;

public class AddressEditHandler implements CommandHandler {

  @Override
  public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

    MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
    if (loginUser == null) return "redirect:/login.htm";

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
      response.sendError(405);
      return null;
    }

    request.setCharacterEncoding("UTF-8");

    int addrNo = Integer.parseInt(request.getParameter("addrNo"));

    AddressDTO dto = new AddressDTO();
    dto.setAddressId(addrNo);
    dto.setUserNumber(loginUser.getUserNumber());

    dto.setRecipientName(request.getParameter("addrname"));
    dto.setRecipientPhone(request.getParameter("tel2_1"));
    dto.setZipcode(request.getParameter("zipcode"));
    dto.setMainAddr(request.getParameter("addr3"));
    dto.setDetailAddr(request.getParameter("addr2"));

    String addressName = request.getParameter("addressName");
    if (addressName == null || addressName.trim().isEmpty()) addressName = "배송지";
    dto.setAddressName(addressName);

    String def = request.getParameter("addrDefault");
    dto.setIsDefault("D".equals(def) ? 1 : 0);

    AddressDAO dao = new AddressDAO();

    try (Connection conn = ConnectionProvider.getConnection()) {
    	  conn.setAutoCommit(false);

    	  if (dto.getIsDefault() == 1) {
    	    dao.clearDefault(conn, dto.getUserNumber());
    	  }

    	  int updated = dao.update(conn, dto);
    	  if (updated == 0) {
    	    conn.rollback();
    	    response.setStatus(404);
    	    response.setContentType("application/json; charset=UTF-8");
    	    response.getWriter().write("{\"ok\":false,\"error\":\"NOT_FOUND\"}");
    	    return null;
    	  }

    	  conn.commit();
    	}

    response.setContentType("application/json; charset=UTF-8");
    response.getWriter().write("{\"ok\":true}");
    return null;
  }
}