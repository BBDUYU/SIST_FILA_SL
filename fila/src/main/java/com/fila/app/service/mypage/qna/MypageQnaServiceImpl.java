package com.fila.app.service.mypage.qna;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO;
import com.fila.app.mapper.mypage.qnaMapper.MypageQnaMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MypageQnaServiceImpl implements MypageQnaService {

    private final MypageQnaMapper mapper;

    /* =========================
       [공통] QnA 카테고리 목록
    ========================= */
    @Override
    @Transactional(readOnly = true)
    public List<MypageQnaCategoryVO> getQnaCategoryList() {
        return mapper.selectCategoryList();
    }

    /* =========================
       [사용자] 1:1 문의 등록
    ========================= */
    @Override
    @Transactional
    public void writeInquiry(MypageQnaVO vo) {
        mapper.insertInquiry(vo);
    }

    /* =========================
       [사용자] 개인정보 수집 동의
    ========================= */
    @Override
    @Transactional
    public void updatePrivacyAgree(long userNumber, int isAgreed) {
        mapper.updatePrivacyAgree(userNumber, isAgreed);
    }

    /* =========================
       [사용자] 내 문의 목록
    ========================= */
    @Override
    @Transactional(readOnly = true)
    public List<MypageQnaVO> getMyInquiryList(long userNumber, String status) {
        if (status == null || status.isEmpty() || "ALL".equalsIgnoreCase(status)) {
            return mapper.selectByUser(userNumber);
        }
        return mapper.selectByUserAndStatus(userNumber, status);
    }

    /* =========================
       [관리자] 전체 문의 목록
    ========================= */
    @Override
    @Transactional(readOnly = true)
    public List<MypageQnaVO> getAllInquiries() {
        return mapper.selectAllInquiries();
    }

    /* =========================
       [관리자] 답변 등록
    ========================= */
    @Override
    @Transactional
    public boolean answerInquiry(long inquiryId, String replyContent) {
        return mapper.updateReply(inquiryId, replyContent) > 0;
    }

    /* =========================
       [공통] 문의 상세
    ========================= */
    @Override
    @Transactional(readOnly = true)
    public MypageQnaVO getInquiryDetail(long inquiryId) {
        return mapper.selectInquiryDetail(inquiryId);
    }
}
