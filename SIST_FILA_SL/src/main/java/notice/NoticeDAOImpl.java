package notice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.util.DBConn;
import com.util.JdbcUtil;

public class NoticeDAOImpl implements NoticeDAO {
    
    private static NoticeDAOImpl instance = new NoticeDAOImpl();
    private NoticeDAOImpl() {}
    public static NoticeDAOImpl getInstance() {
        return instance;
    }

    // 1. 공지사항 목록 조회 (전체/필터링 완벽 대응)
    @Override
    public List<NoticeDTO> selectList(String category, String keyword) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<NoticeDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append(" SELECT notice_id, category_name, title, created_id, created_at, image_url ");
        sql.append(" FROM notice ");
        sql.append(" WHERE 1=1 ");

        // 카테고리가 '전체'일 때는 ""이 넘어오므로 trim().isEmpty()로 걸러내야 함
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category_name = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND title LIKE ? ");
        }
        
        sql.append(" ORDER BY notice_id DESC ");

        try {
            conn = DBConn.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            int idx = 1;
            if (category != null && !category.trim().isEmpty()) {
                pstmt.setString(idx++, category);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                pstmt.setString(idx++, "%" + keyword + "%");
            }

            rs = pstmt.executeQuery();

            // [핵심] 여기서 if가 아니라 while을 써야 리스트 전체가 담깁니다!
            while (rs.next()) {
                NoticeDTO dto = new NoticeDTO();
                dto.setNotice_id(rs.getInt("notice_id"));
                dto.setCategory_name(rs.getString("category_name"));
                dto.setTitle(rs.getString("title"));
                dto.setCreated_id(rs.getString("created_id"));
                dto.setCreated_at(rs.getTimestamp("created_at"));
                dto.setImage_url(rs.getString("image_url"));
                list.add(dto);
            }
            
            // 콘솔에서 실제 몇 개 가져왔는지 확인용
            System.out.println("DEBUG: 조회된 목록 개수 = " + list.size());

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }

    @Override
    public int insert(NoticeDTO dto) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = " INSERT INTO notice (notice_id, category_name, title, created_id, created_at, image_url) VALUES (SEQ_NOTICE_ID.NEXTVAL, ?, ?, ?, SYSDATE, ?) ";
        try {
            conn = DBConn.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getCategory_name());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getCreated_id());
            pstmt.setString(4, dto.getImage_url());
            result = pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
        return result;
    }

    @Override
    public int delete(int noticeId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = " DELETE FROM notice WHERE notice_id = ? ";
        try {
            conn = DBConn.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId);
            result = pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
        return result;
    }
    
    // 4. 상세 조회 (한 개만 리턴)
    @Override
    public NoticeDTO selectOne(int noticeId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        NoticeDTO dto = null;
        String sql = " SELECT * FROM notice WHERE notice_id = ? ";
        try {
            conn = DBConn.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new NoticeDTO();
                dto.setNotice_id(rs.getInt("notice_id"));
                dto.setCategory_name(rs.getString("category_name"));
                dto.setTitle(rs.getString("title"));
                dto.setCreated_id(rs.getString("created_id"));
                dto.setCreated_at(rs.getTimestamp("created_at"));
                dto.setImage_url(rs.getString("image_url"));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return dto;
    }
}