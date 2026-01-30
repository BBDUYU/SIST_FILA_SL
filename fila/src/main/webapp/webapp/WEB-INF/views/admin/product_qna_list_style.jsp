<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
:root {
	--fila-navy: #001E62;
	--fila-red: #E2001A;
	--fila-gray: #F4F4F4;
}

body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: var(--fila-gray);
	margin: 0;
	display: flex;
}

/* 컨텐츠 영역 */
.main-content {
	margin-left: 240px;
	padding: 40px;
	width: calc(100% - 240px);
}

.card {
	background: white;
	border: 1px solid #ddd;
	padding: 25px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	min-height: 600px; /* 리스트라 조금 길게 잡음 */
}

/* 리스트 테이블 스타일 */
.list-table {
	width: 100%;
	border-top: 2px solid var(--fila-navy);
	border-collapse: collapse;
	margin-top: 20px;
    text-align: center;
}

.list-table th {
	background-color: #f9f9f9;
	border-bottom: 1px solid #ddd;
	padding: 15px 10px;
	font-size: 14px;
	color: #333;
    font-weight: bold;
}

.list-table td {
	border-bottom: 1px solid #eee;
	padding: 15px 10px;
	font-size: 14px;
	color: #666;
}

/* 리스트 행 호버 효과 */
.list-table tbody tr:hover {
    background-color: #f0f4ff;
}

/* 링크 스타일 (제목) */
.link-title {
    color: #333;
    text-decoration: none;
    font-weight: 500;
    cursor: pointer;
}
.link-title:hover {
    color: var(--fila-navy);
    text-decoration: underline;
}

/* 상태 배지 */
.status-badge {
	padding: 4px 12px;
	font-size: 12px;
	font-weight: bold;
	color: white;
	border-radius: 20px;
	background-color: #28a745; /* 완료: 초록 */
}

.status-badge.pending {
	background-color: #999; /* 대기: 회색 */
}
/* 제목 칸 전용 스타일 */
.td-subject {
    max-width: 400px;         /* 제목 칸의 최대 너비 (적절히 조절 가능) */
    white-space: nowrap;      /* 줄바꿈 금지 */
    overflow: hidden;         /* 넘치는 부분 숨김 */
    text-overflow: ellipsis;  /* 말줄임표(...) 표시 */
    text-align: left;
    padding-left: 20px;
}
</style>