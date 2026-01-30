<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/* 어드민 레이아웃 */ 
body {
	display: flex;
	margin: 0;
	background-color: #f4f6f9;
	font-family: 'Noto Sans KR', sans-serif;
}

.content {
	margin-left: 240px;
	padding: 40px;
	width: calc(100% - 240px);
}

.page-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
}

.page-title {
	font-size: 24px;
	font-weight: bold;
	color: #00205b;
}

/* 테이블 카드 */
.table-card {
	background: white;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	overflow: hidden;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	background: #f8f9fa;
	color: #00205b;
	padding: 15px;
	text-align: left;
	border-bottom: 2px solid #00205b;
	font-size: 14px;
}

td {
	padding: 15px;
	border-bottom: 1px solid #eee;
	font-size: 13px;
	color: #333;
}

tr:hover {
	background-color: #fdfdfd;
}

/* 할인 타입 뱃지 */
.type-badge {
	padding: 4px 8px;
	border-radius: 4px;
	font-size: 11px;
	font-weight: bold;
}

.type-fixed {
	background: #e3f2fd;
	color: #1976d2;
} /* 정액 */
.type-percent {
	background: #fff3e0;
	color: #ef6c00;
} /* 정율 */

/* 버튼 */
.btn {
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
	border: none;
	font-weight: bold;
	font-size: 13px;
	text-decoration: none;
	display: inline-block;
}

.btn-red {
	background: #e21836;
	color: white;
}

.btn-outline {
	border: 1px solid #ddd;
	color: #666;
	background: white;
}

.btn-outline:hover {
	background: #f5f5f5;
}
</style>