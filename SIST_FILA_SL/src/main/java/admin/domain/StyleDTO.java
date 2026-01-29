package admin.domain;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StyleDTO {
    // 1. STYLE 테이블 컬럼
    private int style_id;           // STYLE_ID (NUMBER(5))
    private String style_name;      // STYLE_NAME (VARCHAR2(100))
    private String description;     // DESCRIPTION (VARCHAR2(500))
    private int use_yn;             // USE_YN (NUMBER(1))

    // 2. 목록 조회 및 편의를 위한 추가 필드
    private String main_image_url;  // 목록 페이지에서 보여줄 대표 이미지 (IS_MAIN = 1인 것)
    
    // 3. 스타일 상세 조회 시 포함될 리스트들
    private List<StyleImageDTO> images;   // 해당 스타일에 포함된 화보 이미지들
    private List<StyleProductDTO> products; // 해당 스타일에 매칭된 상품들
}