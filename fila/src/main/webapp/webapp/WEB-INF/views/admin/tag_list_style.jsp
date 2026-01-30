<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/* 기존 스타일 변수 및 레이아웃 유지 */
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

/* 테이블 공통 디자인 */
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
}

/* 해시태그 강조 스타일 */
.tag-badge {
	color: var(--fila-navy);
	font-weight: 700;
	background-color: #eef2f9;
	padding: 4px 10px;
	border-radius: 20px;
}

/* 버튼 스타일 */
.submit-btn {
	background-color: var(--fila-navy) !important;
	color: #ffffff !important;
	border: none;
	padding: 10px 20px;
	font-weight: 700;
	cursor: pointer;
	border-radius: 2px;
	text-decoration: none;
}

.small-btn {
	background-color: var(--fila-navy) !important;
	color: #ffffff !important;
	border: 1px solid var(--fila-navy) !important;
	padding: 6px 15px;
	font-size: 12px;
	font-weight: 600;
	cursor: pointer;
	border-radius: 2px;
	transition: all 0.2s ease;
}

.small-btn:hover {
	background-color: #ffffff !important;
	color: var(--fila-navy) !important;
}

.btn-delete {
	background-color: var(--fila-red) !important;
	border: 1px solid var(--fila-red) !important;
}

.btn-delete:hover {
	background-color: #ffffff !important;
	color: var(--fila-red) !important;
}
</style>
		<style>
/* 모달 스타일 */
.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
	background-color: #fff;
	margin: 10% auto;
	padding: 30px;
	border-radius: 4px;
	width: 400px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1px solid #eee;
	padding-bottom: 15px;
}

.close {
	font-size: 28px;
	font-weight: bold;
	cursor: pointer;
	color: #aaa;
}

.close:hover {
	color: #000;
}
</style>