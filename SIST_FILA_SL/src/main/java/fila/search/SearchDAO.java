package fila.search;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class SearchDAO implements ISearch{

    private static SearchDAO dao = null;

    private SearchDAO() { }

    public static SearchDAO getInstance() {
        if(dao == null) {
            dao = new SearchDAO();
        }
        return dao;
    }

    /**
     * 검색어 기록 추가/갱신
     * 기존에 존재하면 검색 횟수 증가, 없으면 새로 추가
     */
    public void upsertKeyword(Connection conn, String keyword) throws SQLException {
        String sql = "MERGE INTO SEARCH_KEYWORDS t " +
                     "USING (SELECT ? AS KEYWORD FROM dual) s " +
                     "ON (t.KEYWORD = s.KEYWORD) " +
                     "WHEN MATCHED THEN " +
                     "  UPDATE SET t.SEARCH_COUNT = t.SEARCH_COUNT + 1, t.LAST_SEARCH_DATE = SYSDATE " +
                     "WHEN NOT MATCHED THEN " +
                     "  INSERT (KEYWORD_ID, KEYWORD, SEARCH_COUNT, LAST_SEARCH_DATE) " +
                     "  VALUES (SEARCH_KEYWORDS_SEQ.NEXTVAL, s.KEYWORD, 1, SYSDATE)"; // 시퀀스명 수정 완료

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, keyword);
            pstmt.executeUpdate();
        }
    }
    /**
     * 상위 N개의 인기 검색어 조회
     */
    public ArrayList<SearchDTO> selectTopKeywords(Connection conn, int limit) throws SQLException {
        ArrayList<SearchDTO> list = new ArrayList<>();
        
        String sql = "SELECT * FROM ( " +
                     "  SELECT KEYWORD_ID, KEYWORD, SEARCH_COUNT, LAST_SEARCH_DATE " +
                     "  FROM SEARCH_KEYWORDS " +
                     "  ORDER BY SEARCH_COUNT DESC " +
                     ") WHERE ROWNUM <= ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SearchDTO dto = SearchDTO.builder()
                            .keyword_id(rs.getInt("KEYWORD_ID"))
                            .keyword(rs.getString("KEYWORD"))
                            .search_count(rs.getInt("SEARCH_COUNT"))
                            .last_search_date(rs.getTimestamp("LAST_SEARCH_DATE")) 
                            .build();
                    
                    list.add(dto);
                }
            }
        }
        return list;
    }
}
