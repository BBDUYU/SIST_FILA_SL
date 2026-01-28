package style;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StyleDAO {
    private static StyleDAO instance = new StyleDAO();
    private StyleDAO() {}
    public static StyleDAO getInstance() { return instance; }

    public List<StyleDTO> selectStyleList(Connection conn) throws SQLException {
        List<StyleDTO> list = new ArrayList<>();
        String sql = "SELECT STYLE_ID, STYLE_NAME FROM STYLE WHERE USE_YN = 1 ORDER BY STYLE_ID DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                StyleDTO dto = new StyleDTO();
                dto.setStyleId(rs.getInt("STYLE_ID"));
                dto.setStyleName(rs.getString("STYLE_NAME"));
                list.add(dto);
            }
        }
        return list;
    }
}