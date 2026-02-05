package com.fila.app.domain.notice;
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
public class NoticeVO {
	
	private int noticeId;
	private String categoryName;
	private String title;
	private String createdId;
	
	// [3] EmpVO처럼 JSON으로 나갈 때 날짜 포맷을 맞추고 싶다면 추가 (선택사항)
	// 화면에 2026-01-30 15:00:00 처럼 예쁘게 찍힘
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date createdAt;
	private String updatedId;
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date updatedAt;
	private String imageUrl;
	
}
