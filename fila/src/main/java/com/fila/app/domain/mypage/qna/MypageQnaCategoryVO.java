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

	private int categoryId;      // category_id (PK)
    private String categoryName; // category_name

    private Integer parentId;    // parent_id (상위 카테고리 ID, null 허용을 위해 Integer)
    private int depth;           // depth (카테고리 레벨)
    private int useYn;           // use_yn (1: 사용, 0: 미사용)

    private Date createdAt;      // created_at
    private Date updatedAt;      // updated_at
}
