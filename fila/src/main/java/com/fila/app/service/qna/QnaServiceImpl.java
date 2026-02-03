package com.fila.app.service.qna;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fila.app.domain.qna.QnaVO; 
import com.fila.app.mapper.qna.QnaMapper;

import lombok.Setter;

@Service
public class QnaServiceImpl implements QnaService {

    @Setter(onMethod_ = @Autowired)
    private QnaMapper qnaMapper;

    // 1. 사용자: 문의 등록
    @Override
    public int writeQna(QnaVO qna) {
        return qnaMapper.insert(qna);
    }

    // 2. 사용자: 상품별 문의 목록 조회
    @Override
    public List<QnaVO> getQnaList(String productId) {
        return qnaMapper.selectList(productId);
    }

    // 3. 관리자: 전체 목록 조회
    @Override
    public List<QnaVO> getAdminQnaList() {
        return qnaMapper.selectAdminQnaList();
    }

    // 4. 관리자: 상세 조회
    @Override
    public QnaVO getQnaDetail(int qnaId) {
        return qnaMapper.selectQnaDetail(qnaId);
    }

    // 5. 관리자: 답변 등록 (상태 자동 변경)
    @Override
    public int answerQna(int qnaId, String answer) {
        // 답변 등록 시 상태 변경 로직(WAITING -> COMPLETE)은 Mapper XML에 포함되어 있음
        return qnaMapper.updateAnswer(qnaId, answer);
    }

}