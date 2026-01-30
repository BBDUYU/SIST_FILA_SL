<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
    <c:when test="${empty reviewList}">
        <div class="no-review-msg" style="text-align:center; padding:80px 0; color:#999;">
            <p>리뷰가 없습니다.</p>
        </div>
    </c:when>
    <c:otherwise>
        <c:forEach var="dto" items="${reviewList}">
             <div class="review-card" style="display: flex; border-bottom: 1px solid #f4f4f4; padding: 30px 0; min-height: 200px;">
                
                 <%-- 1. 왼쪽 영역 --%>
                 <div class="review-left" style="flex: 1; padding-right: 40px;">
                     
                     <%-- 별점 --%>
                     <div class="rating-stars" style="display: flex; gap: 2px; margin-bottom: 15px;">
                         <c:forEach begin="1" end="${dto.rating}">
                             <svg viewBox="0 0 24 24" style="width: 16px; height: 16px; fill: #003F96;"><path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.828 1.48 8.279-7.416-3.967-7.417 3.967 1.481-8.279-6.064-5.828 8.332-1.151z"/></svg>
                         </c:forEach>
                         <c:forEach begin="1" end="${5 - dto.rating}">
                             <svg viewBox="0 0 24 24" style="width: 16px; height: 16px; fill: #ddd;"><path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.828 1.48 8.279-7.416-3.967-7.417 3.967 1.481-8.279-6.064-5.828 8.332-1.151z"/></svg>
                         </c:forEach>
                     </div>
    
                     <%-- [핵심] 리뷰 텍스트 + 더보기 버튼 --%>
                     <div class="review-text-wrapper" style="margin-bottom: 20px;">
                        <%-- 본문 (공백 없이 한 줄로!) --%>
                        <div class="review-text-body">${dto.content}</div>
                        
                        <%-- 더보기 버튼 (기본 숨김) --%>
                        <div class="more-btn-wrap" style="display:none; text-align: right; margin-top: 5px;">
                            <button type="button" class="more-btn" onclick="toggleReviewText(this)" 
                                    style="font-size:13px; color:#999; text-decoration:underline; background:none; border:none; cursor:pointer; padding:0;">
                                리뷰 더보기
                            </button>
                        </div>
                     </div>
    
                     <%-- 이미지 --%>
                     <c:if test="${not empty dto.review_img}">
                        <div class="review-images" style="margin-bottom: 20px; display:flex; gap:5px;">
                            <c:set var="imgs" value="${fn:split(dto.review_img, ',')}" />
                            <c:forEach var="imgUrl" items="${imgs}">
                                <c:set var="fileName" value="${fn:substringAfter(imgUrl, '/review/')}" />
                                <img src="${pageContext.request.contextPath}/review/image.htm?file=${fileName}" style="width: 150px; height: 150px; object-fit: cover; border-radius: 4px;">
                            </c:forEach>
                        </div>
                     </c:if>
    
                     <%-- 도움 버튼 --%>
                     <div class="like-section" style="display: flex; align-items: center; gap: 15px; margin-top: 10px;">
                       <button type="button" onclick="handleLike(this, ${dto.review_id}, 1)" style="background: none; border: none; cursor: pointer; display: flex; align-items: center; font-size: 12px; padding: 0; ${dto.myLike == 1 ? 'color:#003F96;' : 'color:#666;'}">
                           <svg viewBox="0 0 24 24" style="width: 16px; height: 16px; margin-right: 4px; fill: ${dto.myLike == 1 ? '#003F96' : '#999'};"><path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z"/></svg>
                           도움돼요 <span style="margin-left: 4px; font-weight: bold;">${dto.like_cnt}</span>
                       </button>
                       <button type="button" onclick="handleLike(this, ${dto.review_id}, 0)" style="background: none; border: none; cursor: pointer; display: flex; align-items: center; font-size: 12px; padding: 0; ${dto.myLike == 0 ? 'color:#003F96;' : 'color:#666;'}">
                           <svg viewBox="0 0 24 24" style="width: 16px; height: 16px; margin-right: 4px; transform: rotate(180deg); fill: ${dto.myLike == 0 ? '#003F96' : '#999'};"><path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z"/></svg>
                           도움안돼요 <span style="margin-left: 4px; font-weight: bold;">${dto.dislike_cnt}</span>
                        </button>
                    </div>
                  </div>
    
                  <%-- 2. 오른쪽 영역 (ID, 날짜) --%>
                 <div class="review-right" style="width: 150px; border-left: 1px solid #f4f4f4; padding-left: 20px; display: flex; flex-direction: column; justify-content: flex-start;">
                     <div class="user-id" style="font-size: 13px; font-weight: bold; color: #333; margin-bottom: 8px;">
                         <c:set var="maskId" value="${dto.user_id}" />
                         ${fn:substring(maskId, 0, 3)}****
                     </div>
                     <div class="created-at" style="font-size: 12px; color: #999; margin-top: auto;">
                         <fmt:formatDate value="${dto.regdate}" pattern="yyyy. MM. dd." />
                     </div>
                 </div>
    
             </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

<%-- 이 리스트가 로드되자마자 높이를 계산 --%>
<script>
// 이 파일 안에서 바로 정의해버립니다. (외부 의존성 X)
function checkReviewHeightLocal() {
    console.log("높이 체크 함수 실행됨!"); // 확인용 로그
    $(".review-text-body").each(function() {
        var scrollHeight = this.scrollHeight; // 실제 전체 높이
        var clientHeight = this.clientHeight; // 눈에 보이는 높이(110px)
        
        // 실제 내용이 더 길면 버튼 보이기
        if (scrollHeight > clientHeight) {
            $(this).next(".more-btn-wrap").show();
        } else {
            $(this).next(".more-btn-wrap").hide();
        }
    });
}

// 0.1초 뒤에 무조건 실행!
setTimeout(checkReviewHeightLocal, 100);
</script>