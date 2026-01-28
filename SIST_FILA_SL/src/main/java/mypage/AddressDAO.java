package mypage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.util.ConnectionProvider;

public class AddressDAO {

  // 기본배송지 해제
  public void clearDefault(Connection conn, int userNumber) throws Exception {
    String sql = "UPDATE DELIVERY_ADDRESS SET IS_DEFAULT = 0 WHERE USER_NUMBER = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, userNumber);
      ps.executeUpdate();
    }
  }

  // INSERT
  public int insert(Connection conn, AddressDTO dto) throws Exception {
    String sql =
      "INSERT INTO DELIVERY_ADDRESS " +
      "(ADDRESS_ID, USER_NUMBER, ADDRESS_NAME, RECIPIENT_NAME, RECIPIENT_PHONE, ZIPCODE, MAIN_ADDR, DETAIL_ADDR, IS_DEFAULT) " +
      "VALUES (DELIVERY_ADDRESS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?)";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, dto.getUserNumber());
      ps.setString(2, dto.getAddressName());
      ps.setString(3, dto.getRecipientName());
      ps.setString(4, dto.getRecipientPhone());
      ps.setString(5, dto.getZipcode());
      ps.setString(6, dto.getMainAddr());
      ps.setString(7, dto.getDetailAddr());
      ps.setInt(8, dto.getIsDefault());
      return ps.executeUpdate();
    }
  }

  // UPDATE (본인 주소만)
  public int update(Connection conn, AddressDTO dto) throws Exception {
    String sql =
      "UPDATE DELIVERY_ADDRESS " +
      "SET ADDRESS_NAME=?, RECIPIENT_NAME=?, RECIPIENT_PHONE=?, ZIPCODE=?, MAIN_ADDR=?, DETAIL_ADDR=?, IS_DEFAULT=? " +
      "WHERE ADDRESS_ID=? AND USER_NUMBER=?";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, dto.getAddressName());
      ps.setString(2, dto.getRecipientName());
      ps.setString(3, dto.getRecipientPhone());
      ps.setString(4, dto.getZipcode());
      ps.setString(5, dto.getMainAddr());
      ps.setString(6, dto.getDetailAddr());
      ps.setInt(7, dto.getIsDefault());
      ps.setInt(8, dto.getAddressId());
      ps.setInt(9, dto.getUserNumber());
      return ps.executeUpdate();
    }
  }
  
	//내 배송지 전체 조회 (기본배송지 먼저)
	public List<AddressDTO> selectListByUser(Connection conn, int userNumber) throws Exception {
	 String sql =
	   "SELECT ADDRESS_ID, USER_NUMBER, ADDRESS_NAME, RECIPIENT_NAME, RECIPIENT_PHONE, " +
	   "       ZIPCODE, MAIN_ADDR, DETAIL_ADDR, IS_DEFAULT " +
	   "FROM DELIVERY_ADDRESS " +
	   "WHERE USER_NUMBER = ? " +
	   "ORDER BY IS_DEFAULT DESC, ADDRESS_ID DESC";
	
	 List<AddressDTO> list = new ArrayList<>();
	 try (PreparedStatement ps = conn.prepareStatement(sql)) {
	   ps.setInt(1, userNumber);
	   try (ResultSet rs = ps.executeQuery()) {
	     while (rs.next()) {
	       AddressDTO dto = new AddressDTO();
	       dto.setAddressId(rs.getInt("ADDRESS_ID"));
	       dto.setUserNumber(rs.getInt("USER_NUMBER"));
	       dto.setAddressName(rs.getString("ADDRESS_NAME"));
	       dto.setRecipientName(rs.getString("RECIPIENT_NAME"));
	       dto.setRecipientPhone(rs.getString("RECIPIENT_PHONE"));
	       dto.setZipcode(rs.getString("ZIPCODE"));
	       dto.setMainAddr(rs.getString("MAIN_ADDR"));
	       dto.setDetailAddr(rs.getString("DETAIL_ADDR"));
	       dto.setIsDefault(rs.getInt("IS_DEFAULT"));
	       list.add(dto);
	     }
	   }
	 }
	 return list;
	}
	
	// 기본 배송지
	public int setDefault(Connection conn, int addressId, int userNumber) throws Exception {
	    String sql =
	        "UPDATE DELIVERY_ADDRESS " +
	        "SET IS_DEFAULT = 1 " +
	        "WHERE ADDRESS_ID = ? AND USER_NUMBER = ?";

	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, addressId);
	        ps.setInt(2, userNumber);
	        return ps.executeUpdate();
	    }
	}
	
	// 해당 주소가 기본배송지인지 확인 (본인 것만)
	public int isDefault(Connection conn, int addressId, int userNumber) throws Exception {
	  String sql = "SELECT NVL(IS_DEFAULT,0) FROM DELIVERY_ADDRESS WHERE ADDRESS_ID=? AND USER_NUMBER=?";
	  try (PreparedStatement ps = conn.prepareStatement(sql)) {
	    ps.setInt(1, addressId);
	    ps.setInt(2, userNumber);
	    try (ResultSet rs = ps.executeQuery()) {
	      if (rs.next()) return rs.getInt(1);
	      return -1; // 없으면 -1
	    }
	  }
	}

	// DELETE (본인 주소만)
	public int delete(Connection conn, int addressId, int userNumber) throws Exception {
	  String sql = "DELETE FROM DELIVERY_ADDRESS WHERE ADDRESS_ID=? AND USER_NUMBER=?";
	  try (PreparedStatement ps = conn.prepareStatement(sql)) {
	    ps.setInt(1, addressId);
	    ps.setInt(2, userNumber);
	    return ps.executeUpdate();
	  }
	}
	
	public boolean hasOrderReference(Connection conn, int addressId, int userNumber) throws Exception {

		  // ⚠️ 아래 ORDERS / ADDRESS_ID / USER_NUMBER는
		  //    FK_ORDER_ADDRESS가 걸린 "자식 테이블/컬럼"에 맞게 바꿔야 합니다.
		  String sql =
		      "SELECT 1 " +
		      "FROM ORDERS " +
		      "WHERE USER_NUMBER = ? AND ADDRESS_ID = ? AND ROWNUM = 1";

		  try (PreparedStatement ps = conn.prepareStatement(sql)) {
		    ps.setInt(1, userNumber);
		    ps.setInt(2, addressId);
		    ResultSet rs = ps.executeQuery();
		    try {
		      return rs.next();
		    } finally {
		      if (rs != null) rs.close();
		    }
		  }
		}
	
	// ✅ 단건 조회 (본인 주소만)
	public AddressDTO selectOneById(Connection conn, int addressId, int userNumber) throws Exception {
	  String sql =
	      "SELECT ADDRESS_ID, USER_NUMBER, ADDRESS_NAME, RECIPIENT_NAME, RECIPIENT_PHONE, " +
	      "       ZIPCODE, MAIN_ADDR, DETAIL_ADDR, IS_DEFAULT " +
	      "FROM DELIVERY_ADDRESS " +
	      "WHERE ADDRESS_ID = ? AND USER_NUMBER = ?";

	  try (PreparedStatement ps = conn.prepareStatement(sql)) {
	    ps.setInt(1, addressId);
	    ps.setInt(2, userNumber);
	    try (ResultSet rs = ps.executeQuery()) {
	      if (!rs.next()) return null;

	      AddressDTO dto = new AddressDTO();
	      dto.setAddressId(rs.getInt("ADDRESS_ID"));
	      dto.setUserNumber(rs.getInt("USER_NUMBER"));
	      dto.setAddressName(rs.getString("ADDRESS_NAME"));
	      dto.setRecipientName(rs.getString("RECIPIENT_NAME"));
	      dto.setRecipientPhone(rs.getString("RECIPIENT_PHONE"));
	      dto.setZipcode(rs.getString("ZIPCODE"));
	      dto.setMainAddr(rs.getString("MAIN_ADDR"));
	      dto.setDetailAddr(rs.getString("DETAIL_ADDR"));
	      dto.setIsDefault(rs.getInt("IS_DEFAULT"));
	      return dto;
	    }
	  }
	}
	
}
