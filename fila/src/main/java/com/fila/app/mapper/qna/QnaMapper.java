package com.fila.app.mapper.qna;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.qna.QnaVO;

public interface QnaMapper {

    // 1. 상품 문의 등록
    int insert(QnaVO qna);

    // 2. 상품 문의 목록 조회 (상품별)
    List<QnaVO> selectList(String productId);

    // 3. 관리자용 전체 목록 조회
    List<QnaVO> selectAdminQnaList();

    // 4. 관리자용 상세 조회
    QnaVO selectQnaDetail(int qnaId);
    
    // 5. 관리자 답변 저장 & 상태 변경
    int updateAnswer(@Param("qnaId") int qnaId, @Param("answer") String answer);

}