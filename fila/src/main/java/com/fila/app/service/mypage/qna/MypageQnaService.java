package com.fila.app.service.mypage.qna;

import java.util.List;

import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO;

public interface MypageQnaService {

    /* =========================
       [공통] QnA 카테고리 목록
       - qna_write 모달에서 사용
    ========================= */
    List<MypageQnaCategoryVO> getQnaCategoryList();

    /* =========================
       [사용자] 1:1 문의 등록
    ========================= */
    void writeInquiry(MypageQnaVO vo);

    /* =========================
       [사용자] 개인정보 수집 동의
    ========================= */
    void updatePrivacyAgree(long userNumber, int isAgreed);

    /* =========================
       [사용자] 내 문의 목록
    ========================= */
    List<MypageQnaVO> getMyInquiryList(long userNumber, String status);

    /* =========================
       [관리자] 전체 문의 목록
    ========================= */
    List<MypageQnaVO> getAllInquiries();

    /* =========================
       [관리자] 답변 등록
    ========================= */
    boolean answerInquiry(long inquiryId, String replyContent);

    /* =========================
       [공통] 문의 상세
    ========================= */
    MypageQnaVO getInquiryDetail(long inquiryId);
}
