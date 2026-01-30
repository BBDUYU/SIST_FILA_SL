<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/* 기존 상품 관리 스타일 변수 및 기본 레이아웃 유지 */
:root {
	--fila-navy: #00205b;
	--fila-red: #e31837;
	--bg-gray: #f4f4f4;
}

body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: var(--bg-gray);
	margin: 0;
}

.admin-section {
	margin-left: 240px;
	padding: 50px 40px;
	min-height: 100vh;
}

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
	padding: 15px 10px;
	border-bottom: 1px solid #f1f1f1;
	text-align: center;
	font-size: 14px;
	color: #555;
	vertical-align: middle;
}

/* 버튼 디자인 */
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
	text-decoration: none;
}

.small-btn:hover {
	background-color: #ffffff !important;
	color: var(--fila-navy) !important;
}

/* 스타일 화보 전용 썸네일 (세로형) */
.style-thumb {
	width: 70px;
	height: 90px;
	object-fit: cover;
	border: 1px solid #eee;
	border-radius: 2px;
}

/* 노출 여부 뱃지 */
.badge-use {
	padding: 4px 8px;
	border-radius: 20px;
	font-size: 11px;
	font-weight: bold;
}
.bg-live { background-color: #e8f8f0; color: #2ecc71; }
.bg-stop { background-color: #fff0f0; color: var(--fila-red); }
</style>