package com.fila.app.mapper.mypage.qnaMapper;

import java.util.List;

import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO;

public interface MypageQnaMapper {

    // 문의 카테고리
    List<MypageQnaCategoryVO> selectCategoryList();

    // 1:1 문의 등록
    int insertQna(MypageQnaVO vo);

    // 내 문의 목록
    List<MypageQnaVO> selectMyQnaList(String memberId);
 

}
