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

    @Override
    public int writeQna(QnaVO qna) {
        return qnaMapper.insert(qna);
    }

    @Override
    public List<QnaVO> getQnaList(String productId) {
        return qnaMapper.selectList(productId);
    }

    @Override
    public List<QnaVO> getAdminQnaList() {
        return qnaMapper.selectAdminQnaList();
    }

    @Override
    public QnaVO getQnaDetail(int qnaId) {
        return qnaMapper.selectQnaDetail(qnaId);
    }

    @Override
    public int answerQna(int qnaId, String answer) {
        // 답변 등록 시 상태 변경 로직은 XML(SQL)에 포함되어 있음
        return qnaMapper.updateAnswer(qnaId, answer);
    }

}
