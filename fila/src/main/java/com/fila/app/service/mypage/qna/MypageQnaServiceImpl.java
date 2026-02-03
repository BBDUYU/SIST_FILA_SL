package com.fila.app.service.mypage.qna;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.mypage.qna.MypageQnaVO;
import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.mapper.mypage.qnaMapper.MypageQnaMapper; // 매퍼 경로 확인

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MypageQnaServiceImpl implements MypageQnaService {

    private final MypageQnaMapper mapper;

    @Override
    @Transactional(readOnly = true)
    public List<MypageQnaCategoryVO> getCategories() {
        return mapper.selectCategoryList();
    }

    @Override
    @Transactional
    public void writeInquiry(MypageQnaVO vo) {
        mapper.insertInquiry(vo);
    }

    @Override
    @Transactional
    public void updatePrivacyAgree(long userNumber, int isAgreed) {
        mapper.updatePrivacyAgree(userNumber, isAgreed);
    }

    @Override
    @Transactional(readOnly = true)
    public List<MypageQnaVO> getMyInquiryList(long userNumber, String status) {
        if (status == null || status.isEmpty() || "ALL".equalsIgnoreCase(status)) {
            return mapper.selectByUser(userNumber);
        }
        return mapper.selectByUserAndStatus(userNumber, status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<MypageQnaVO> getAllInquiries() {
        return mapper.selectAllInquiries();
    }

    @Override
    @Transactional
    public boolean answerInquiry(long inquiryId, String replyContent) {
        return mapper.updateReply(inquiryId, replyContent) > 0;
    }

    @Override
    @Transactional(readOnly = true)
    public MypageQnaVO getInquiryDetail(long inquiryId) {
        return mapper.selectInquiryDetail(inquiryId);
    }
}