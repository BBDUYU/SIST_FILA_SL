package admin.service;

import java.sql.Connection;
import java.util.ArrayList;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import categories.CategoriesDAO;
import categories.CategoriesDTO;

public class TagService {
    // 싱글톤
    private TagService() {}
    private static TagService instance = new TagService();
    public static TagService getInstance() { return instance; }

    // 태그 리스트 조회 로직
    public ArrayList<CategoriesDTO> getTagList() {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            CategoriesDAO cDao = CategoriesDAO.getInstance();
            
            // DAO에 태그만 가져오는 메서드를 추가해야 합니다.
            return cDao.selectTagList(conn); 
        } catch (Exception e) {
            throw new RuntimeException("태그 목록 로드 실패", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
    public int createTag(String tagName) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 관리 시작
            
            CategoriesDAO dao = CategoriesDAO.getInstance();
            
            // 1. 기존 최대값 조회 후 +1 (자동 번호 생성)
            int newId = dao.getMaxTagId(conn) + 1;
            
            // 2. DTO 객체 생성
            CategoriesDTO dto = CategoriesDTO.builder()
                                .category_id(newId)
                                .name(tagName)
                                .build();
            
            // 3. DB 저장
            int result = dao.insertTag(conn, dto);
            
            conn.commit(); // 모든 작업 성공 시 확정
            return result;
        } catch (Exception e) {
            JdbcUtil.rollback(conn); // 에러 발생 시 취소
            throw new RuntimeException("태그 생성 실패: " + e.getMessage(), e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
}