<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${empty qnaList}">
    <div style="text-align: center; padding: 80px 0;">
        <p style="font-size: 15px; color: #999; margin: 0;">등록된 상품 문의가 없습니다.</p>
    </div>
</c:if>

<c:if test="${not empty qnaList}">
    <ul style="list-style: none; padding: 0; margin: 0;">
        <c:forEach var="dto" items="${qnaList}">
            <li style="border-bottom: 1px solid #eee;">
                
                <%-- 질문 영역 (클릭 시 답변 토글) --%>
                <div onclick="toggleAnswer('${dto.qnaId}')" style="padding: 20px 10px; cursor: pointer;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                        <div>
                            <c:choose>
                                <c:when test="${dto.status eq 'COMPLETE'}">
                                    <span style="font-weight: bold; color: #000;">답변완료</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #999;">답변대기</span>
                                </c:otherwise>
                            </c:choose>
                            <span style="margin: 0 5px; color: #ddd;">|</span>
                            <span style="color:#555;">${dto.type}</span>
                        </div>
                        <div style="color:#999; font-size:13px;">
                            <fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd"/>
                        </div>
                    </div>

                    <%-- [수정] 비밀글 로직 및 이미지 태그 싹 제거! 무조건 내용만 출력 --%>
                    <div style="font-size: 16px; color: #333; line-height: 1.5; word-break: break-all;">
                        ${dto.question}
                    </div>
                </div>

                <%-- 답변 상세 영역 (기본 숨김) --%>
                <div id="answer_area_${dto.qnaId}" style="display: none; background: #f9f9f9; padding: 20px; margin-top:10px; border-radius: 4px;">
                    
                    <%-- [수정] 여기도 비밀글 체크 로직 제거 --%>
                    
                    <%-- 질문 내용 다시 보여주기 --%>
                    <div style="display:flex; gap:10px; margin-bottom:15px;">
                        <div style="width: 24px; height: 24px; background: #fff; border: 1px solid #ddd; border-radius: 50%; text-align: center; line-height: 22px; font-size: 13px; color: #999; font-weight: bold; flex-shrink: 0;">Q</div>
                        <div style="color:#333; line-height:1.6;">${dto.question}</div>
                    </div>
                    
                    <div style="height:1px; background:#eee; margin-bottom:15px;"></div>

                    <%-- 답변 내용 --%>
                    <div style="display:flex; gap:10px;">
                        <div style="width: 24px; height: 24px; background: #002053; border-radius: 50%; text-align: center; line-height: 24px; font-size: 13px; color: #fff; font-weight: bold; flex-shrink: 0;">A</div>
                        <div style="flex:1;">
                            <c:if test="${not empty dto.answer}">
                                <div style="color:#333; white-space:pre-wrap; line-height:1.6;">${dto.answer}</div>
                                <div style="color:#999; font-size:12px; margin-top:8px;">
                                    <fmt:formatDate value="${dto.answeredAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </div>
                            </c:if>
                            <c:if test="${empty dto.answer}">
                                <span style="color:#999;">아직 답변이 등록되지 않았습니다.</span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </li>
        </c:forEach>
    </ul>
</c:if>

<script>
function toggleAnswer(id) {
    var area = $("#answer_area_" + id);
    $("div[id^='answer_area_']").not(area).slideUp(200); 
    area.slideToggle(200);
}
</script>