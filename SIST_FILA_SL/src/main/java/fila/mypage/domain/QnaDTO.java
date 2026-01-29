package fila.mypage.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class QnaDTO {

    // ===== INQUIRY =====
    private long inquiry_id;
    private long user_number;
    private int category_id;

    private String title;
    private String content;
    private String image_url;

    private String status;          // WAIT / DONE
    private String reply_content;
    private Date reply_at;

    private Date created_at;
    private Date updated_at;

    // ===== JOIN (INQUIRY_CATEGORY) =====
    private String category_name;
    private String user_name;
}
