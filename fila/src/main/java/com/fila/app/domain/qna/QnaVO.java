package com.fila.app.domain.qna;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fila.app.domain.admin.StyleImageVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class QnaVO {
    private int qnaId;
    private String productId;
    private int userNumber;
    private String name;
    private String type;
    private String question;
    private String answer;
    private String status;
    private int isSecret;
    
    // 날짜 포맷 지정 (프론트엔드에 보여질 형식)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date created_at;
    
    private String answer_email;  // 답변 받을 이메일
    private int is_email_notify;  // 이메일 수신 여부
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date answered_at; // 답변 등록일

    // 조인용
    private String user_id;
}