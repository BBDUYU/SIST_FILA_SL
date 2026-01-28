<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 쿠폰 목록</title>
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
</head>
<body>

	<jsp:include page="../common/sidebar.jsp">
		<jsp:param name="currentPage" value="coupon" />
	</jsp:include>

	<div class="content">
		<div class="page-header">
			<h1 class="page-title">쿠폰 관리</h1>
			<a href="${pageContext.request.contextPath}/admin/create_coupon.htm"
				class="btn btn-red">신규 쿠폰 등록</a>
		</div>

		<div class="table-card">
    <table>
        <thead>
            <tr>
                <th style="width: 80px;">번호</th>
                <th>쿠폰명</th>
                <th style="width: 150px;">시리얼 번호</th>
                <th style="width: 120px;">할인 유형</th>
                <th style="width: 150px;">할인 혜택</th>
                <th style="width: 120px;">만료일</th>
                <th style="width: 120px;">생성일</th>
                <th style="width: 80px; text-align: center;">상태</th>
                <th style="width: 120px; text-align: center;">상태 변경</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty couponList}">
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 60px; color: #999;">
                            등록된 쿠폰 데이터가 없습니다.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="dto" items="${couponList}">
                        <tr style="${dto.status eq 'N' ? 'background-color: #f9f9f9; color: #bbb;' : ''}">
                            <td>${dto.coupon_id}</td>
                            <td><strong>${dto.name}</strong></td>
                            <td style="font-family: 'Courier New', monospace; color: #666; font-weight: bold;">
                                ${not empty dto.serial_number ? dto.serial_number : '-'}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${dto.discount_type eq 'AMOUNT'}">
                                        <span class="type-badge type-fixed">정액할인</span>
                                    </c:when>
                                    <c:when test="${dto.discount_type eq 'PERCENT'}">
                                        <span class="type-badge type-percent">정율할인</span>
                                    </c:when>
                                    <c:when test="${dto.discount_type eq 'DELIVERY'}">
                                        <span class="type-badge" style="background: #e8eaf6; color: #3f51b5;">무료배송</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${dto.discount_type eq 'AMOUNT'}">
                                        <fmt:formatNumber value="${dto.discount_value}" pattern="#,###" />원
                                    </c:when>
                                    <c:when test="${dto.discount_type eq 'PERCENT'}">${dto.discount_value}%</c:when>
                                    <c:when test="${dto.discount_type eq 'DELIVERY'}">배송비무료</c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty dto.expires_at}">
                                        <fmt:formatDate value="${dto.expires_at}" pattern="yy/MM/dd" />
                                    </c:when>
                                    <c:otherwise><span style="color: #ccc;">제한없음</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${dto.created_at}" pattern="yy/MM/dd" /></td>
                            
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${dto.status eq 'Y'}">
                                        <span style="color: #2e7d32; font-weight: bold;">● 활성</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #c62828; font-weight: bold;">○ 중지</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${dto.status eq 'Y'}">
                                        <button class="btn btn-outline"
                                            style="padding: 5px 8px; font-size: 11px; border-color: #e21836; color: #e21836;"
                                            onclick="if(confirm('이 쿠폰 사용을 중지하시겠습니까?')) location.href='${pageContext.request.contextPath}/admin/delete_coupon.htm?id=${dto.coupon_id}&status=N'">
                                            중지하기</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-outline"
                                            style="padding: 5px 8px; font-size: 11px; border-color: #2e7d32; color: #2e7d32;"
                                            onclick="if(confirm('이 쿠폰을 다시 활성화하시겠습니까?')) location.href='${pageContext.request.contextPath}/admin/delete_coupon.htm?id=${dto.coupon_id}&status=Y'">
                                            복구하기</button>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>
	</div>

</body>
</html>