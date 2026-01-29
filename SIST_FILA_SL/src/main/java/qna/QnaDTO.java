package qna;

import java.util.Date;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class QnaDTO {
    private int qna_id;
    private String product_id;
    private int user_number;
    private String name;
    private String type;
    private String question;
    private String answer;
    private String status;
    private int is_secret;
    private Date created_at;
    private String answer_email;  // 답변 받을 이메일
    private int is_email_notify;  // 이메일 수신 여부 (체크박스 값)
    private Date answered_at; // 답변 등록일

    // 조인용
    private String user_id;
}