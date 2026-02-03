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
public class MypageQnaCategoryVO {

    private int categoryId;
    private String categoryName;

    // getter / setter
}
