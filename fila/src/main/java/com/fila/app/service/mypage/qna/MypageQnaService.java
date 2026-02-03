package com.fila.app.service.mypage.qna;

import java.util.List;

import org.springframework.stereotype.Service;

import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO;
import com.fila.app.domain.qna.QnaVO;


@Service
public interface MypageQnaService {

	// [공통] 카테고리 목록 조회
    List<MypageQnaCategoryVO> getCategories();

    // [사용자] 1:1 문의 등록
    void writeInquiry(MypageQnaVO vo);

    // [사용자] 개인정보 수집 동의 업데이트
    void updatePrivacyAgree(long userNumber, int isAgreed);

    // [사용자] 내 문의 목록 조회 (전체 또는 상태별)
    List<MypageQnaVO> getMyInquiryList(long userNumber, String status);

    // [관리자] 전체 문의 목록 조회
    List<MypageQnaVO> getAllInquiries();

    // [관리자] 답변 등록
    boolean answerInquiry(long inquiryId, String replyContent);

    // [공통] 문의 상세 조회
    MypageQnaVO getInquiryDetail(long inquiryId);
}
