<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
</head>
<body>
	<jsp:include page="../common/sidebar.jsp">
		<jsp:param name="currentPage" value="product" />
	</jsp:include>

	<div class="admin-section">
		<div class="section-header"
			style="display: flex; justify-content: space-between; align-items: center;">
			<h3 class="section-title">상품 관리 리스트</h3>
			<button onclick="location.href='createProduct.htm'"
				class="submit-btn" style="width: 150px; margin: 0;">+ 신규 상품
				등록</button>
		</div>

		<table class="info-table" style="margin-top: 20px; background: white;">
			<thead>
				<tr style="background: #f9f9f9;">
					<th>이미지</th>
					<th>상품코드</th>
					<th>카테고리</th>
					<th>상품명</th>
					<th>판매가</th>
					<th>재고</th>
					<th>상태</th>
					<th>관리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="p" items="${productList}">
					<tr>
						<td><img
							src="${pageContext.request.contextPath}/displayImage.do?path=${p.mainImageUrl}"
							width="50" height="50" style="object-fit: cover;"></td>
						<td>${p.productid}</td>
						<td>${p.categoryName}</td>
						<td style="text-align: left; font-weight: bold;">${p.name}</td>
						<td><fmt:formatNumber value="${p.price}" pattern="#,###" />원</td>
						<td><span class="${p.totalStock < 10 ? 'stock-low' : ''}">${p.totalStock}</span>
						</td>
						<td><c:choose>
								<c:when test="${p.status eq '판매중'}">
									<span style="color: #2ecc71; font-weight: bold;">●
										${p.status}</span>
								</c:when>
								<c:when test="${p.status eq '품절'}">
									<span style="color: var(--fila-red); font-weight: bold;">●
										${p.status}</span>
								</c:when>
								<c:otherwise>
									<span>${p.status}</span>
								</c:otherwise>
							</c:choose></td>
						<td>
							<button class="small-btn"
								onclick="location.href='${pageContext.request.contextPath}/admin/editProduct.htm?id=${p.productid}'">수정</button>
							<button class="small-btn"
							    style="background-color: #e31837; color: white; border: none;"
							    onclick="if(confirm('정말 삭제하시겠습니까?')) { location.href='${pageContext.request.contextPath}/admin/deleteProduct.htm?id=${p.productid}'; }">
							    삭제
							</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>