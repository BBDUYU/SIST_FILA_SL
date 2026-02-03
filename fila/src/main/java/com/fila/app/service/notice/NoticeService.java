package com.fila.app.service.notice;

import java.util.List;
import com.fila.app.domain.notice.NoticeVO;

public interface NoticeService {
    
    // 목록 조회
    List<NoticeVO> getNoticeList(String category, String keyword);
    
    // 상세 조회
    NoticeVO getNoticeDetail(int noticeId);
    
    // 등록
    int writeNotice(NoticeVO notice);
    
    // 삭제
    int removeNotice(int noticeId);
}