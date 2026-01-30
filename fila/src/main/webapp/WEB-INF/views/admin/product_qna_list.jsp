<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 상품문의 관리</title>
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
</head>
<body>
    
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="currentPage" value="productQna" />
    </jsp:include>

	<div class="main-content">
		<div class="card">
			<h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">
                상품문의 관리
            </h2>
            <p style="color: #666; font-size: 14px;">고객님들이 남겨주신 상품 문의 내역입니다.</p>
			<hr>

			<table class="list-table">
                <thead>
                    <tr>
                        <th style="width: 5%;">번호</th>
                        <th style="width: 10%;">문의유형</th>
                        <th style="width: 13%;">상품정보</th> <th style="width: auto;">제목</th>
                        <th style="width: 10%;">이름</th>
                        <th style="width: 10%;">회원번호</th>
                        <th style="width: 10%;">작성일</th>
                        <th style="width: 10%;">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty qnaList}">
                            <c:forEach var="dto" items="${qnaList}">
                                <tr>
                                    <td>${dto.qna_id}</td>
                                    <td>${dto.type}</td>
                                    
                                    <td style="font-size: 13px; color: #888;">
                                        ${not empty dto.product_id ? dto.product_id : '-'}
                                    </td>
                                    
                                    <td class="td-subject">
									    <c:if test="${dto.is_secret == 1}">
									        <img src="//image.fila.co.kr/fila/kr/images/common/ico_lock.png" alt="잠금" style="width: 12px; opacity: 0.6; margin-right: 3px;">
									    </c:if>
									    <a href="${pageContext.request.contextPath}/admin/productQnaDetail.htm?qna_id=${dto.qna_id}" class="link-title">
									        ${dto.question}
									    </a>
									</td>
                                    
                                    <td>${dto.name}</td>
                                    <td>${dto.user_number}</td>
                                    
                                    <td>
                                        <fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    
                                    <td>
									    <c:choose>
									        <c:when test="${not empty dto.answer and dto.answer ne ''}">
									            <span class="status-badge">답변완료</span>
									        </c:when>
									        <c:otherwise>
									            <span class="status-badge pending">답변대기</span>
									        </c:otherwise>
									    </c:choose>
									</td>
									                                </tr>
                            </c:forEach>
                        </c:when>
                        
                        <c:otherwise>
                            <tr>
                                <td colspan="7" style="padding: 50px 0; color: #999;">
                                    등록된 문의 내역이 없습니다.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div style="text-align: center; margin-top: 30px;">
                </div>

		</div>
	</div>
</body>
</html>