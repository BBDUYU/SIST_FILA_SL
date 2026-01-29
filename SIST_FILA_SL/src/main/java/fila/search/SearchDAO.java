package fila.search;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SearchDAO implements ISearch {

    @Autowired
    private DataSource dataSource;

    /**
     * 검색어 기록 추가/갱신
     */
    @Override
    public void upsertKeyword(String keyword) {
        String sql =
            "MERGE INTO SEARCH_KEYWORDS t " +
            "USING (SELECT ? AS KEYWORD FROM dual) s " +
            "ON (t.KEYWORD = s.KEYWORD) " +
            "WHEN MATCHED THEN " +
            "  UPDATE SET t.SEARCH_COUNT = t.SEARCH_COUNT + 1, t.LAST_SEARCH_DATE = SYSDATE " +
            "WHEN NOT MATCHED THEN " +
            "  INSERT (KEYWORD_ID, KEYWORD, SEARCH_COUNT, LAST_SEARCH_DATE) " +
            "  VALUES (SEARCH_KEYWORDS_SEQ.NEXTVAL, s.KEYWORD, 1, SYSDATE)";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, keyword);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("검색어 저장 실패", e);
        }
    }

    /**
     * 상위 N개의 인기 검색어 조회
     */
    @Override
    public ArrayList<SearchDTO> selectTopKeywords(int limit) {
        ArrayList<SearchDTO> list = new ArrayList<>();

        String sql =
            "SELECT * FROM ( " +
            "  SELECT KEYWORD_ID, KEYWORD, SEARCH_COUNT, LAST_SEARCH_DATE " +
            "  FROM SEARCH_KEYWORDS " +
            "  ORDER BY SEARCH_COUNT DESC " +
            ") WHERE ROWNUM <= ?";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
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
        } catch (SQLException e) {
            throw new RuntimeException("인기 검색어 조회 실패", e);
        }

        return list;
    }
}
