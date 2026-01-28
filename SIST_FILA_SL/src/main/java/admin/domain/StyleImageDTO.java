package admin.domain;

import lombok.Data;

@Data
public class StyleImageDTO {
    private int style_image_id;
    private int style_id;
    private String image_url;
    private int is_main;      // 1: 메인, 0: 일반
    private int sort_order;
    private String alt_text;
}
