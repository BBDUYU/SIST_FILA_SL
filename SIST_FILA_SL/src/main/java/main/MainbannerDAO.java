package main;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import com.util.JdbcUtil; // JdbcUtil 클래스가 있다고 가정

public class MainbannerDAO {
    
    private static MainbannerDAO dao = null;
    private MainbannerDAO() {}
    
    public static MainbannerDAO getInstance() {
        if(dao == null) {
            dao = new MainbannerDAO();
        }
        return dao;
    }
    
    /**
     * 메인 상단 배너 리스트 조회
     */
    public ArrayList<MainbannerDTO> selectMainBannerList(Connection conn) {
        ArrayList<MainbannerDTO> list = new ArrayList<>();
        
        String sql = "SELECT BANNER_ID, BANNER_NAME, IMAGE_URL, LINK_URL " +
                     "FROM MAIN_BANNER " +
                     "WHERE IS_ACTIVE = 'Y' " +
                     "ORDER BY SORT_ORDER ASC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                MainbannerDTO dto = MainbannerDTO.builder()
                        .bannerId(rs.getInt("BANNER_ID"))       
                        .bannerName(rs.getString("BANNER_NAME")) 
                        .imageUrl(rs.getString("IMAGE_URL"))
                        .linkUrl(rs.getString("LINK_URL"))
                        .build();

                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}