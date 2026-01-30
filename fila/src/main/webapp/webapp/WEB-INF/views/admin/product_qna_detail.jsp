<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
