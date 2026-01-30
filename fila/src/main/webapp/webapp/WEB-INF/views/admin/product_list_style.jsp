<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/* FILA 브랜드 컬러 변수 설정 */
:root {
	--fila-navy: #00205b;
	--fila-red: #e31837;
	--bg-gray: #f4f4f4;
}

/* 기본 레이아웃 및 폰트 */
body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: var(--bg-gray);
	margin: 0;
}

/* 관리자 섹션 보정 */
.admin-section {
	margin-left: 240px; /* 사이드바 너비 대응 */
	padding: 50px 40px;
	min-height: 100vh;
}

/* 섹션 타이틀 스타일 */
.section-title {
	font-size: 22px;
	font-weight: 800;
	color: var(--fila-navy);
	letter-spacing: -0.5px;
	position: relative;
	padding-left: 15px;
	margin: 0;
}

.section-title::before {
	content: '';
	position: absolute;
	left: 0;
	top: 50%;
	transform: translateY(-50%);
	width: 4px;
	height: 20px;
	background-color: var(--fila-red);
}

/* 테이블 디자인 */
.info-table {
	width: 100%;
	border-collapse: collapse;
	border-top: 2px solid var(--fila-navy);
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	background-color: #fff;
}

.info-table th {
	background-color: #f9f9f9;
	color: #333;
	font-weight: 700;
	font-size: 13px;
	padding: 15px 10px;
	border-bottom: 1px solid #eee;
}

.info-table td {
	padding: 12px 10px;
	border-bottom: 1px solid #f1f1f1;
	text-align: center;
	font-size: 14px;
	color: #555;
	vertical-align: middle;
}

/* 신규 상품 등록 버튼 (배경 네이비, 글씨 화이트 고정) */
.submit-btn {
	background-color: var(--fila-navy) !important;
	color: #ffffff !important;
	border: none;
	padding: 10px 20px;
	font-weight: 700;
	cursor: pointer;
	transition: all 0.3s ease;
	font-size: 13px;
	border-radius: 2px;
	text-decoration: none;
	display: inline-block;
}

.submit-btn:hover {
	background-color: #001640 !important;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

/* 수정 버튼 (기본 네이비 -> 호버 시 화이트 반전) */
.small-btn {
	background-color: var(--fila-navy) !important;
	color: #ffffff !important;
	border: 1px solid var(--fila-navy) !important;
	padding: 6px 15px;
	font-size: 12px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
	border-radius: 2px;
}

.small-btn:hover {
	background-color: #ffffff !important;
	color: var(--fila-navy) !important;
	border: 1px solid var(--fila-navy) !important;
}

/* 썸네일 이미지 */
.info-table img {
	border: 1px solid #eee;
	border-radius: 4px;
	object-fit: cover;
}

/* 재고 및 상태 표시 */
.stock-low {
	color: var(--fila-red);
	font-weight: 800;
	background-color: #fff0f0;
	padding: 2px 6px;
	border-radius: 3px;
}

.status-live {
	color: #2ecc71;
	font-weight: bold;
}

.status-soldout {
	color: var(--fila-red);
	font-weight: bold;
}
</style>