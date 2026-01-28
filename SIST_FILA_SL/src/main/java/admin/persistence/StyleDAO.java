package admin.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import admin.domain.StyleDTO;
import admin.domain.StyleImageDTO;
import admin.domain.StyleProductDTO;

import com.util.ConnectionProvider;
import com.util.JdbcUtil; // 본인의 DB 연결 종료 유틸리티 확인

public class StyleDAO {
    private static StyleDAO instance = new StyleDAO();
    private StyleDAO() {}
    public static StyleDAO getInstance() { return instance; }


    public List<StyleDTO> selectStyleList(Connection conn) throws SQLException {
        String sql = "SELECT s.STYLE_ID, s.STYLE_NAME, s.USE_YN, s.DESCRIPTION, si.IMAGE_URL AS main_image_url " +
                     "FROM STYLE s " +
                     "LEFT JOIN STYLE_IMAGE si ON s.STYLE_ID = si.STYLE_ID AND si.IS_MAIN = 1 " +
                     "ORDER BY s.STYLE_ID DESC";
        
        List<StyleDTO> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                StyleDTO dto = StyleDTO.builder()
                        .style_id(rs.getInt("STYLE_ID"))
                        .style_name(rs.getString("STYLE_NAME"))
                        .description(rs.getString("DESCRIPTION")) 
                        .use_yn(rs.getInt("USE_YN"))
                        .main_image_url(rs.getString("main_image_url"))
                        .build();
                list.add(dto);
            }
        }
        return list;
    }

    // 2. 새로운 스타일 마스터 등록 (시퀀스 사용)
 // StyleDAO.java
    public int insertStyle(Connection conn, StyleDTO dto) throws SQLException {
        // STYLE_ID를 반환받기 위해 두 번째 인자로 컬럼명을 명시합니다.
        String sql = "INSERT INTO STYLE (STYLE_ID, STYLE_NAME, DESCRIPTION, USE_YN) VALUES (SEQ_STYLE.NEXTVAL, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[]{"STYLE_ID"})) {
            pstmt.setString(1, dto.getStyle_name());
            pstmt.setString(2, dto.getDescription());
            pstmt.setInt(3, dto.getUse_yn());
            pstmt.executeUpdate();
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1); // 생성된 시퀀스 ID 리턴
            }
        }
        return 0;
    }

    // 3. 스타일 화보 이미지 등록
    public int insertStyleImage(Connection conn, StyleImageDTO imgDto) throws SQLException {
        String sql = "INSERT INTO STYLE_IMAGE (STYLE_IMAGE_ID, STYLE_ID, IMAGE_URL, IS_MAIN, SORT_ORDER, ALT_TEXT) " +
                     "VALUES (SEQ_STYLE_IMAGE.NEXTVAL, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, imgDto.getStyle_id());
            pstmt.setString(2, imgDto.getImage_url());
            pstmt.setInt(3, imgDto.getIs_main());
            pstmt.setInt(4, imgDto.getSort_order());
            pstmt.setString(5, imgDto.getAlt_text());
            return pstmt.executeUpdate();
        }
    }

    // 4. 스타일-상품 매칭 정보 등록
    public int insertStyleProduct(Connection conn, StyleProductDTO prodDto) throws SQLException {
        String sql = "INSERT INTO STYLE_PRODUCT (PRODUCT_ID, STYLE_ID, SORT_ORDER) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, prodDto.getProduct_id());
            pstmt.setInt(2, prodDto.getStyle_id());
            pstmt.setInt(3, prodDto.getSort_order());
            return pstmt.executeUpdate();
        }
    }

 // StyleDAO.java 에 추가

 // 1. 특정 스타일 상세 정보 조회
 public StyleDTO selectStyleDetail(Connection conn, int styleId) throws SQLException {
     String sql = "SELECT * FROM STYLE WHERE STYLE_ID = ?";
     StyleDTO dto = null;
     try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
         pstmt.setInt(1, styleId);
         try (ResultSet rs = pstmt.executeQuery()) {
             if (rs.next()) {
                 dto = StyleDTO.builder()
                         .style_id(rs.getInt("STYLE_ID"))
                         .style_name(rs.getString("STYLE_NAME"))
                         .description(rs.getString("DESCRIPTION"))
                         .use_yn(rs.getInt("USE_YN"))
                         .build();
             }
         }
     }
     return dto;
 }

 // 2. 특정 스타일의 모든 이미지 조회
 public List<StyleImageDTO> selectStyleImages(Connection conn, int styleId) throws SQLException {
     String sql = "SELECT * FROM STYLE_IMAGE WHERE STYLE_ID = ? ORDER BY SORT_ORDER";
     List<StyleImageDTO> list = new ArrayList<>();
     try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
         pstmt.setInt(1, styleId);
         try (ResultSet rs = pstmt.executeQuery()) {
             while (rs.next()) {
                 StyleImageDTO img = new StyleImageDTO();
                 img.setStyle_image_id(rs.getInt("STYLE_IMAGE_ID"));
                 img.setStyle_id(rs.getInt("STYLE_ID"));
                 img.setImage_url(rs.getString("IMAGE_URL"));
                 img.setIs_main(rs.getInt("IS_MAIN"));
                 img.setSort_order(rs.getInt("SORT_ORDER"));
                 list.add(img);
             }
         }
     }
     return list;
 }
//특정 스타일의 매칭된 상품 ID 목록 조회
public List<String> selectMatchedProductIds(Connection conn, int styleId) throws SQLException {
  String sql = "SELECT PRODUCT_ID FROM STYLE_PRODUCT WHERE STYLE_ID = ?";
  List<String> list = new ArrayList<>();
  try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setInt(1, styleId);
      try (ResultSet rs = pstmt.executeQuery()) {
          while (rs.next()) {
              list.add(rs.getString("PRODUCT_ID"));
          }
      }
  }
  return list;
}

//특정 스타일의 이미지 데이터만 삭제 (수정 시 사용)
public void deleteStyleImages(Connection conn, int styleId) throws SQLException {
  String sql = "DELETE FROM STYLE_IMAGE WHERE STYLE_ID = ?";
  try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setInt(1, styleId);
      pstmt.executeUpdate();
  }
}

//특정 스타일의 상품 매칭 데이터만 삭제 (수정 시 사용)
public void deleteStyleProducts(Connection conn, int styleId) throws SQLException {
  String sql = "DELETE FROM STYLE_PRODUCT WHERE STYLE_ID = ?";
  try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setInt(1, styleId);
      pstmt.executeUpdate();
  }
}
 // 3. 스타일 기본 정보 업데이트
 public int updateStyle(Connection conn, StyleDTO dto) throws SQLException {
     String sql = "UPDATE STYLE SET STYLE_NAME = ?, DESCRIPTION = ?, USE_YN = ? WHERE STYLE_ID = ?";
     try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
         pstmt.setString(1, dto.getStyle_name());
         pstmt.setString(2, dto.getDescription());
         pstmt.setInt(3, dto.getUse_yn());
         pstmt.setInt(4, dto.getStyle_id());
         return pstmt.executeUpdate();
     }
 }
 public int updateStyleStatus(Connection conn, int id, int status) throws SQLException {
	    String sql = "UPDATE STYLE SET USE_YN = ? WHERE STYLE_ID = ?"; 
	    PreparedStatement pstmt = null;
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, status);
	        pstmt.setInt(2, id);
	        return pstmt.executeUpdate();
	    } finally {
	        JdbcUtil.close(pstmt);
	    }
	}
//5. 메인 화면용 활성 스타일 리스트 조회
public List<StyleDTO> selectActiveStyleList(Connection conn) throws SQLException {
  String sql = "SELECT s.STYLE_ID, s.STYLE_NAME, si.IMAGE_URL AS main_image_url " +
               "FROM STYLE s " +
               "LEFT JOIN STYLE_IMAGE si ON s.STYLE_ID = si.STYLE_ID AND si.IS_MAIN = 1 " +
               "WHERE s.USE_YN = 1 " + // 활성화된 것만!
               "ORDER BY s.STYLE_ID DESC";
  
  List<StyleDTO> list = new ArrayList<>();
  try (PreparedStatement pstmt = conn.prepareStatement(sql);
       ResultSet rs = pstmt.executeQuery()) {
      while (rs.next()) {
          StyleDTO dto = StyleDTO.builder()
                  .style_id(rs.getInt("STYLE_ID"))
                  .style_name(rs.getString("STYLE_NAME"))
                  .main_image_url(rs.getString("main_image_url"))
                  .build();
          list.add(dto);
      }
  }
  return list;
}
public List<StyleProductDTO> selectStyleProductDetails(Connection conn, int styleId) throws SQLException {
    // PRODUCTS(p)와 PRODUCT_IMAGE(pi)를 조인합니다.
    // IS_MAIN = 1인 이미지만 가져와서 중복을 방지합니다.
    String sql = "SELECT sp.PRODUCT_ID, sp.STYLE_ID, sp.SORT_ORDER, " +
                 "       p.NAME AS product_name, p.PRICE, " +
                 "       pi.IMAGE_URL AS product_image " + 
                 "FROM STYLE_PRODUCT sp " + 
                 "JOIN PRODUCTS p ON sp.PRODUCT_ID = p.PRODUCT_ID " + 
                 "LEFT JOIN PRODUCT_IMAGE pi ON p.PRODUCT_ID = pi.PRODUCT_ID AND pi.IS_MAIN = 1 " +
                 "WHERE sp.STYLE_ID = ? " +
                 "ORDER BY sp.SORT_ORDER ASC";
    
    List<StyleProductDTO> list = new ArrayList<>();
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, styleId);
        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                StyleProductDTO dto = new StyleProductDTO();
                dto.setProduct_id(rs.getString("PRODUCT_ID"));
                dto.setStyle_id(rs.getInt("STYLE_ID"));
                dto.setSort_order(rs.getInt("SORT_ORDER"));
                dto.setProduct_name(rs.getString("product_name"));
                dto.setPrice(rs.getInt("PRICE"));
                
                // 조회된 이미지 경로 세팅
                dto.setProduct_image(rs.getString("product_image"));
                
                list.add(dto);
            }
        }
    }
    return list;
}
//StyleDAO 내부에 상품별 사이즈를 가져오는 메서드 예시
public List<String> getProductSizes(Connection conn, String productId) throws SQLException {
 List<String> sizes = new ArrayList<>();
 String sql = "SELECT VALUE_NAME FROM PRODUCT_OPTION_VALUES v " +
              "JOIN PRODUCT_OPTION_GROUPS g ON v.OPTION_GROUP_ID = g.OPTION_GROUP_ID " +
              "WHERE g.PRODUCT_ID = ? AND g.MASTER_ID IN (4,5,6,7,8)"; // 사이즈 마스터 ID들

 try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
     pstmt.setString(1, productId);
     try (ResultSet rs = pstmt.executeQuery()) {
         while (rs.next()) {
             sizes.add(rs.getString("VALUE_NAME"));
         }
     }
 }
 return sizes;
}
}