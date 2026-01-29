package fila.search;

import java.sql.Connection;
import java.util.ArrayList;

import fila.com.util.ConnectionProvider;
import fila.com.util.JdbcUtil;

public class SearchService {
    
    private SearchService() {}
    private static SearchService instance = new SearchService();
    public static SearchService getInstance() { return instance; }

    public void recordSearchKeyword(String keyword) {
        Connection conn = null;
        try {
            // ConnectionProvider를 사용하여 커넥션 확보
            conn = ConnectionProvider.getConnection();
            
            // DAO를 통한 검색어 upsert 실행
            SearchDAO sDao = SearchDAO.getInstance();
            if (keyword != null && !keyword.trim().isEmpty()) {
                sDao.upsertKeyword(conn, keyword.trim());
            }

        } catch (Exception e) {
            // 예외 발생 시 런타임 예외로 던져서 서비스 레이어의 오류를 알림
            throw new RuntimeException("검색어 기록 중 오류 발생", e);
        } finally {
            // 커넥션 반환
            JdbcUtil.close(conn);
        }
    }
    public ArrayList<SearchDTO> getPopularKeywords(int limit) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            return SearchDAO.getInstance().selectTopKeywords(conn, limit);
        } catch (Exception e) {
            throw new RuntimeException("인기 검색어 조회 중 오류 발생", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
}