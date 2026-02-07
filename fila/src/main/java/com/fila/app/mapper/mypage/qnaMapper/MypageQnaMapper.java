package com.fila.app.mapper.mypage.qnaMapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO;

@Mapper
public interface MypageQnaMapper {

    /* =========================
       [공통] QnA 카테고리
    ========================= */
    List<MypageQnaCategoryVO> selectCategoryList();

    /* =========================
       [사용자] 1:1 문의
    ========================= */
    int insertInquiry(MypageQnaVO vo);

    void updatePrivacyAgree(
        @Param("userNumber") long userNumber,
        @Param("isAgreed") int isAgreed
    );

    List<MypageQnaVO> selectByUser(
        @Param("userNumber") long userNumber
    );

    List<MypageQnaVO> selectByUserAndStatus(
        @Param("userNumber") long userNumber,
        @Param("status") String status
    );

    /* =========================
       [관리자] 문의 관리
    ========================= */
    List<MypageQnaVO> selectAllInquiries();

    int updateReply(
        @Param("inquiryId") long inquiryId,
        @Param("replyContent") String replyContent
    );

    MypageQnaVO selectInquiryDetail(
        @Param("inquiryId") long inquiryId
    );
}
