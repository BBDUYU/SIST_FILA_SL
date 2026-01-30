<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
    <div class="main-content">
        <div class="card">
            <h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">1:1 문의 관리</h2>
            <p style="color: #666; font-size: 14px;">고객의 문의사항을 확인하고 답변을 등록합니다.</p>
            <hr>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>카테고리</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="qna" items="${adminQnaList}">
                        <tr>
                            <td>${qna.inquiry_id}</td>
                            <td><span style="color: #888;">${qna.category_name}</span></td>
                            <td style="text-align: left;"><strong>${qna.title}</strong></td>
                            <td>${qna.user_name}</td>
                            <td><fmt:formatDate value="${qna.created_at}" pattern="yyyy-MM-dd" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${qna.status eq 'WAIT'}">
                                        <span class="status-badge status-wait">답변대기</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-done">답변완료</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button class="btn-toggle" onclick="toggleReply('${qna.inquiry_id}')">보기/답변</button>
                            </td>
                        </tr>
                       <tr id="replyRow_${qna.inquiry_id}" class="reply-row">
    <td colspan="7" class="reply-box">
        <div class="qa-split-container">
            
            <div class="qa-part">
                <div class="qa-header header-q">CUSTOMER QUESTION</div>
                <div class="qa-body">
                    ${qna.content}
                </div>
            </div>

            <div class="qa-part">
                <div class="qa-header header-a">
                    ADMIN ANSWER
                    <c:if test="${qna.status ne 'WAIT'}">
                        <span style="float:right; font-weight:normal; font-size:11px; color:#888;">
                            답변완료: <fmt:formatDate value="${qna.reply_at}" pattern="yyyy-MM-dd HH:mm" />
                        </span>
                    </c:if>
                </div>
                <div class="qa-body">
                    <c:choose>
                        <c:when test="${qna.status eq 'WAIT'}">
                            <textarea id="text_${qna.inquiry_id}" class="reply-textarea" 
                                      placeholder="고객 문의에 대한 답변을 입력하세요."></textarea>
                            <div style="overflow: hidden;">
                                <button class="btn-submit" onclick="submitReply('${qna.inquiry_id}')">답변 완료</button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            ${qna.reply_content}
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
        </div>
    </td>
</tr>
                    </c:forEach>

                    <c:if test="${empty adminQnaList}">
                        <tr>
                            <td style="padding: 100px 0; color: #999;">새로운 문의 사항이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
