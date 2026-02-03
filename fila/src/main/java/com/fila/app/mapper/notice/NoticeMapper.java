package com.fila.app.mapper.notice;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.fila.app.domain.notice.NoticeVO;

public interface NoticeMapper {

    // 1. 공지사항 목록 조회 (카테고리, 검색어 필터링 포함)
    List<NoticeVO> selectList(@Param("category") String category, @Param("keyword") String keyword);

    // 2. 공지사항 상세 조회
    NoticeVO selectOne(int noticeId);

    // 3. 공지사항 등록 (관리자)
    int insert(NoticeVO notice);

    // 4. 공지사항 삭제 (관리자)
    int delete(int noticeId);

}