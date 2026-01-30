package com.fila.app.domain.notice;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NoticeVO {
	
	private int notice_id;
	private String category_name;
	private String title;
	private String created_id;
	
	// [3] EmpVO처럼 JSON으로 나갈 때 날짜 포맷을 맞추고 싶다면 추가 (선택사항)
	// 화면에 2026-01-30 15:00:00 처럼 예쁘게 찍힘
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date created_at;
	private String updated_id;
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date updated_at;
	private String image_url;
	
}
