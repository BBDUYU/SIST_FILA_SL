package mypage.qna;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class QNACategoriesDTO {

    private int category_id;
    private String category_name;

    private int parent_id;
    private int depth;
    private int use_yn;

    private Date created_at;
    private Date updated_at;
    
}
