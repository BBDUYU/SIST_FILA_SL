<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 상품문의 상세</title>
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
}

/* 상세 정보 테이블 스타일 */
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
	width: 15%;
	font-size: 14px;
	color: #333;
    font-weight: bold;
    vertical-align: middle;
}

.info-table td {
	border: 1px solid #eee;
	padding: 12px 15px;
	font-size: 14px;
	color: #000;
    line-height: 1.6;
}

/* 섹션 제목 */
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

/* 답변 입력창 */
.answer-textarea {
    width: 98%;
    height: 150px;
    padding: 10px;
    border: 1px solid #ddd;
    resize: none;
    font-size: 14px;
    outline: none;
}
.answer-textarea:focus {
    border-color: var(--fila-navy);
}

/* 버튼 영역 */
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
    font-size: 14px;
}

.btn-fila-red {
	background: var(--fila-red);
	color: white;
	border: none;
	padding: 10px 25px;
	cursor: pointer;
    font-size: 14px;
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
                상품문의 상세 관리
            </h2>
			<hr>

            <div class="section-title">문의 정보</div>
            <table class="info-table">
                <tr>
                    <th>문의 유형</th>
                    <td>${qna.type}</td>
                    <th>작성일</th>
                    <td><fmt:formatDate value="${qna.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td>${qna.name}</td>
                    <th>상품코드</th>
                    <td>${empty qna.product_id ? '-' : qna.product_id}</td>
                </tr>
                 <tr>
                    <th>질문 내용</th>
                    <td colspan="3" style="white-space: pre-wrap; height: 100px; vertical-align: top;">${qna.question}</td> 
                    </tr>
            </table>

            <form action="${pageContext.request.contextPath}/admin/saveProductAnswer.htm" method="post">
                <input type="hidden" name="qna_id" value="${qna.qna_id}">
                
                <div class="section-title">관리자 답변</div>
                <table class="info-table">
                    <tr>
                        <th>답변 내용</th>
                        <td>
                            <textarea name="answer_content" class="answer-textarea" placeholder="답변 내용을 입력하세요.">${qna.answer}</textarea>
                        </td>
                    </tr>
                    <c:if test="${not empty qna.answered_at}">
                        <tr>
                            <th>최종 답변일</th>
                            <td><fmt:formatDate value="${qna.answered_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                        </tr>
                    </c:if>
                </table>

                <div class="btn-area">
                    <button type="button" class="btn-fila" onclick="location.href='${pageContext.request.contextPath}/admin/productQnaList.htm'">목록으로</button>
                    <button type="submit" class="btn-fila-red" style="margin-left: 10px;">답변 등록/수정</button>
                </div>
            </form>

		</div>
	</div>
</body>
</html>