package search;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import search.SearchDTO;

public interface ISearch {
    // 검색어 추가 또는 카운트 업데이트
    void upsertKeyword(Connection conn, String keyword) throws SQLException;
    
    // 인기 검색어 상위 N개 조회
    ArrayList<SearchDTO> selectTopKeywords(Connection conn, int limit) throws SQLException;
}