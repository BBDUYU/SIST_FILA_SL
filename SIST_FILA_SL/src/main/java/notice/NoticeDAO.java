package notice;

import java.util.List;
import notice.NoticeDTO;

public interface NoticeDAO {
    // 목록 조회 (카테고리, 검색어 포함)
    List<NoticeDTO> selectList(String category, String keyword) throws Exception;
    
    // 상세 조회 (이미지 보기용)
    NoticeDTO selectOne(int noticeId) throws Exception;

    // 공지사항 등록/삭제 (관리자용)
    int insert(NoticeDTO dto) throws Exception;
    int delete(int noticeId) throws Exception;
}