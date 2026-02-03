package com.fila.app.domain.admin;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StyleVO {
    // 1. STYLE 테이블 컬럼
    private int styleId;           // STYLE_ID (NUMBER(5))
    private String styleName;      // STYLE_NAME (VARCHAR2(100))
    private String description;     // DESCRIPTION (VARCHAR2(500))
    private int useYn;             // USE_YN (NUMBER(1))

    // 2. 목록 조회 및 편의를 위한 추가 필드
    private String mainImageUrl;  // 목록 페이지에서 보여줄 대표 이미지 (IS_MAIN = 1인 것)
    
    // 3. 스타일 상세 조회 시 포함될 리스트들
    private List<StyleImageVO> images;   // 해당 스타일에 포함된 화보 이미지들
    private List<StyleProductVO> products; // 해당 스타일에 매칭된 상품들
}