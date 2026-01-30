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

/* 사이드바 */
.sidebar {
	width: 240px;
	height: 100vh;
	background: var(--fila-navy);
	color: white;
	position: fixed;
}

.sidebar .logo {
	padding: 30px;
	text-align: center;
	border-bottom: 1px solid #1a3578;
	font-weight: bold;
	font-size: 24px;
	letter-spacing: 2px;
}

.nav-item {
	padding: 15px 25px;
	cursor: pointer;
	border-bottom: 1px solid #1a3578;
	transition: 0.3s;
}

.nav-item:hover, .nav-item.active {
	background: var(--fila-red);
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
}

/* 상세 페이지 전용 스타일 */
.section-title {
	font-size: 18px;
	font-weight: bold;
	color: var(--fila-navy);
	margin: 30px 0 15px 0;
	display: flex;
	align-items: center;
}

.section-title::before {
	content: '';
	display: inline-block;
	width: 4px;
	height: 18px;
	background-color: var(--fila-red);
	margin-right: 10px;
}

.info-table {
	width: 100%;
	border-top: 2px solid var(--fila-navy);
	border-collapse: collapse;
	margin-bottom: 20px;
}

.info-table th {
	background-color: #f9f9f9;
	border: 1px solid #eee;
	padding: 12px 15px;
	text-align: left;
	width: 20%;
	font-size: 14px;
	color: #333;
}

.info-table td {
	border: 1px solid #eee;
	padding: 12px 15px;
	font-size: 14px;
	color: #666;
}

.status-badge {
	padding: 3px 10px;
	font-size: 12px;
	font-weight: bold;
	color: white;
	background-color: #28a745;
}

.status-badge.blocked {
	background-color: var(--fila-red);
}

/* 버튼 스타일 */
.btn-area {
	text-align: center;
	margin-top: 40px;
	border-top: 1px solid #eee;
	padding-top: 25px;
}

.btn-fila {
	background: var(--fila-navy);
	color: white;
	border: none;
	padding: 10px 25px;
	cursor: pointer;
}

.btn-fila-red {
	background: var(--fila-red);
	color: white;
	border: none;
	padding: 10px 25px;
	cursor: pointer;
}

/* 탭 메뉴 스타일 */
.nav-tabs {
	display: flex;
	list-style: none;
	padding: 0;
	margin: 0;
	border-bottom: 2px solid var(--fila-navy);
}

.nav-item-tab {
	padding: 10px 25px;
	cursor: pointer;
	border: 1px solid #eee;
	border-bottom: none;
	margin-right: 5px;
	background: white;
	color: #666;
	transition: 0.2s;
}

.nav-item-tab.active {
	background: var(--fila-navy) !important;
	color: white !important;
	border-color: var(--fila-navy) !important;
}
</style>