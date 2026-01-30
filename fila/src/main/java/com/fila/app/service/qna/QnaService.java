package com.fila.app.service.qna;

import java.util.List;

import com.fila.app.domain.qna.QnaVO;

public interface QnaService {
    
    // 문의 작성
    int writeQna(QnaVO qna);
    
    // 문의 목록 (상품별)
    List<QnaVO> getQnaList(String productId);
    
    // 관리자: 전체 목록
    List<QnaVO> getAdminQnaList();
    
    // 관리자: 상세 보기
    QnaVO getQnaDetail(int qnaId);
    
    // 관리자: 답변 등록
    int answerQna(int qnaId, String answer);

}
