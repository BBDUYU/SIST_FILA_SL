package com.fila.app.service.mypage.qna;

import java.util.List;

import org.springframework.stereotype.Service;

import com.fila.app.domain.mypage.qna.MypageQnaCategoryVO;
import com.fila.app.domain.mypage.qna.MypageQnaVO;
import com.fila.app.mapper.mypage.qnaMapper.MypageQnaMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MypageQnaService {

    private final MypageQnaMapper mapper;

    // 1:1 문의 등록
    public void writeQna(MypageQnaVO vo) {
        mapper.insertQna(vo);
    }

    // 내 1:1 문의 목록
    public List<MypageQnaVO> getMyQnaList(String memberId) {
        return mapper.selectMyQnaList(memberId);
    }

    // 문의 카테고리 목록 (AJAX 대비)
    public List<MypageQnaCategoryVO> getCategories() {
        return mapper.selectCategoryList();
    }
}
