package com.fila.app.mapper.mypage.qnaMapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO; // 반드시 이 VO를 임포트

@Mapper
public interface MypageQnaMapper {
    // 1. 카테고리
    List<MypageQnaCategoryVO> selectCategoryList();

    // 2. 사용자 기능
    int insertInquiry(MypageQnaVO vo); 
    void updatePrivacyAgree(@Param("userNumber") long userNumber, @Param("isAgreed") int isAgreed);
    List<MypageQnaVO> selectByUser(@Param("userNumber") long userNumber);
    List<MypageQnaVO> selectByUserAndStatus(@Param("userNumber") long userNumber, @Param("status") String status);

    // 3. 관리자 기능
    List<MypageQnaVO> selectAllInquiries();
    int updateReply(@Param("inquiryId") long inquiryId, @Param("replyContent") String replyContent);
    MypageQnaVO selectInquiryDetail(long inquiryId);
}