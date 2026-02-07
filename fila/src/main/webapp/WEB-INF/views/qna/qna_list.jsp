<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${empty qnaList}">
    <div style="text-align: center; padding: 80px 0;">
        <p style="font-size: 20px; color: #000; margin: 0;">작성된 상품 문의글이 없습니다.</p>
    </div>
</c:if>

<c:if test="${not empty qnaList}">
    <ul style="list-style: none; padding: 0; margin: 0;">
        <c:forEach var="dto" items="${qnaList}">
            <li style="border-bottom: 1px solid #eee;">
                
                <div onclick="toggleAnswer('${dto.qnaId}')" style="padding: 20px 10px; cursor: pointer; position: relative; margin-bottom: 20px; margin-top: 20px;">
                    <div style="font-size: 18px; color: #000; margin-bottom: 8px; display: flex; justify-content: space-between;">
                        <div>
                            <c:choose>
                                <c:when test="${dto.status eq 'COMPLETE'}">
                                    <span style="color: #000; font-weight: bold;">답변완료</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #000;">답변대기</span>
                                </c:otherwise>
                            </c:choose>
                            <span style="margin: 0 5px; color: #ddd;">|</span>
                            ${dto.type}
                        </div>
                        <div>
                            <fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd"/>
                        </div>
                    </div>

                    <div style="font-size: 20px; font-weight: bold; color: #000; line-height: 1.5; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 820px;">
                        <c:choose>
                            <c:when test="${dto.isSecret == 1 && sessionScope.auth.userNumber != dto.userNumber}">
                                <img src="//image.fila.co.kr/fila/kr/images/common/ico_lock.png" alt="잠금" style="width: 13px; vertical-align: middle; margin-top: -3px;">
                                비밀글입니다.
                            </c:when>
                            <c:otherwise>
                                <c:if test="${dto.isSecret == 1}">
                                    <img src="//image.fila.co.kr/fila/kr/images/common/ico_lock.png" alt="잠금" style="width: 13px; vertical-align: middle; margin-top: -3px;">
                                </c:if>
                                <span style="vertical-align: middle;">${dto.question}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div id="answer_area_${dto.qnaId}" style="display: none; background: #f0f0f0; padding: 30px 20px;">
                    <c:choose>
                        <c:when test="${dto.isSecret == 1 && sessionScope.auth.userNumber != dto.userNumber}">
                             <p style="font-size: 13px; color: #666; margin: 0; text-align:center;">비밀글은 작성자만 볼 수 있습니다.</p>
                        </c:when>
                        
                        <c:otherwise>
                            <div style="display: flex; gap: 15px; margin-bottom: 30px;">
                                <div style="width: 28px; height: 28px; background: #fff; border: 1px solid #ddd; border-radius: 50%; text-align: center; line-height: 26px; font-size: 15px; color: #999; font-weight: bold; flex-shrink: 0; box-sizing: border-box;">Q</div>
                                <div style="font-size: 18px; color: #000; line-height: 1.6; padding-top: 2px; white-space: pre-wrap;">${dto.question}</div>
                            </div>

                            <div style="height: 1px; background: #e5e5e5; margin-bottom: 30px;"></div>

                            <div style="display: flex; gap: 15px;">
                                <div style="width: 28px; height: 28px; background: #002053; border-radius: 50%; text-align: center; line-height: 28px; font-size: 15px; color: #fff; font-weight: bold; flex-shrink: 0;">A</div>
                                
                                <div style="flex: 1;">
                                    <c:if test="${not empty dto.answer}">
                                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                            <div style="font-size: 18px; color: #333; line-height: 1.6; white-space: pre-wrap; margin-right: 15px;">${dto.answer}</div>
                                            <div style="font-size: 18px; color: #888; white-space: nowrap; flex-shrink: 0;">
                                                <fmt:formatDate value="${dto.answeredAt}" pattern="yyyy-MM-dd HH:mm"/>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${empty dto.answer}">
                                        <div style="font-size: 18px; color: #999; padding-top: 2px;">
                                            아직 답변이 등록되지 않았습니다.
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
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