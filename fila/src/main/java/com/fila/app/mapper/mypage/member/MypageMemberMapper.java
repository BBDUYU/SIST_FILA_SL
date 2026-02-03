package com.fila.app.mapper.mypage.member;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.member.ChildVO;
import com.fila.app.domain.member.MemberVO;


public interface MypageMemberMapper {

    // ===== modify =====
    MemberVO selectMemberByUserNumber(
            @Param("userNumber") int userNumber);

    // ===== security =====
    int checkPassword(
            @Param("memberId") String memberId,
            @Param("password") String password);

    void updatePassword(
            @Param("memberNo") int memberNo,
            @Param("password") String password);

    void retireMember(
            @Param("memberNo") int memberNo);

    // ===== additional =====
    Map<String, Integer> selectMarketingStatus(
            @Param("memberNo") int memberNo);

    List<ChildVO> selectChildList(
            @Param("memberNo") int memberNo);
}
