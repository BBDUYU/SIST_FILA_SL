package com.fila.app.domain.mypage.qna;

import java.util.Date;

import com.fila.app.domain.categories.CategoriesVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MypageQnaVO {

    private int qnaId;
    private String memberId;
    private int categoryId;
    private String title;
    private String content;
    private Date regDate;
    private String status;

    // getter / setter
}
