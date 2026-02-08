<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- [디버깅 영역] 데이터가 아예 안 오면 빨간 박스가 뜹니다. 나중에 성공하면 이 div만 지우세요 --%>
<c:if test="${empty reviewList}">
    <div style="background:#fff; padding:20px; border:2px solid red; text-align:center;">
        <h3 style="color:red;">데이터 수신 실패 혹은 0건</h3>
        <p>현재 상품 ID: <b>${param.productId}</b></p>
        <p>Controller에서 보낸 리스트 존재 여부: <b>${reviewList != null ? '객체는 있음' : '객체 자체가 없음(null)'}</b></p>
        <p style="color:blue;">SQL에는 있는데 여기가 0건이면, DB의 productId에 공백이 있는지 확인해보세요.</p>
    </div>
</c:if>

<c:choose>
    <%-- 1. 리스트가 비었을 때 --%>
    <c:when test="${empty reviewList}">
        <div class="no-review-msg" style="text-align:center; padding:80px 0; color:#999;">
            <p>작성된 리뷰가 없습니다.</p>
        </div>
    </c:when>

    <%-- 2. 리스트가 있을 때 (진짜 디자인 시작) --%>
    <c:otherwise>
        <c:forEach var="dto" items="${reviewList}">
             <div class="review-card" style="display: flex; border-bottom: 1px solid #f4f4f4; padding: 30px 0; min-height: 200px;">
                
                 <%-- 왼쪽 영역 --%>
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
    
                     <%-- 리뷰 내용 --%>
                     <div class="review-text-wrapper" style="margin-bottom: 20px;">
                        <div class="review-text-body" style="white-space: pre-wrap;">${dto.content}</div>
                     </div>
						    <%-- review_list.jsp 이미지 출력 부분 --%>
						<%-- review_list.jsp 이미지 출력 부분 수정 --%>
						<c:if test="${not empty dto.reviewImg}">
						    <div class="review-images" style="margin-bottom: 20px; display:flex; gap:5px;">
						        <c:set var="imgs" value="${fn:split(dto.reviewImg, ',')}" />
						        <c:forEach var="imgUrl" items="${imgs}">
						            <%-- 중요: trim을 사용하여 공백이나 줄바꿈 제거 --%>
						            <c:set var="cleanImgUrl" value="${fn:trim(imgUrl)}" />
										<img src="${pageContext.request.contextPath}/displayImage.do?path=${fn:trim(imgUrl)}" 
										     style="width: 100px; height: 100px; object-fit: cover; border-radius: 4px; border:1px solid #eee; cursor:pointer;" 
										     onerror="console.log('실패경로 확인용: ' + this.src)"
										     onclick="window.open(this.src)">
						        </c:forEach>
						    </div>
						</c:if>
					                     
                     <%-- 도움돼요 버튼 --%>
                     <div class="like-section" style="display: flex; align-items: center; gap: 15px; margin-top: 10px;">
                        <button type="button" class="like-btn" style="background:none; border:none; color:#666; font-size:12px;">
                           도움돼요 <b>${dto.likeCnt}</b>
                        </button>
                    </div>
                 </div>
    
                 <%-- 오른쪽 영역 (아이디, 날짜) --%>
                 <div class="review-right" style="width: 150px; border-left: 1px solid #f4f4f4; padding-left: 20px;">
                     <div class="user-id" style="font-size: 13px; font-weight: bold; margin-bottom: 8px;">
                         <c:out value="${fn:substring(dto.userId, 0, 3)}****" default="탈퇴회원" />
                     </div>
                     <div class="created-at" style="font-size: 12px; color: #999;">
                         <fmt:formatDate value="${dto.regDate}" pattern="yyyy. MM. dd." />
                     </div>
                 </div>
             </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

<script>
    // 더보기 버튼 자동 생성 로직
    $(".review-text-body").each(function() {
        if (this.scrollHeight > 110) { // 5줄 이상일 때
            $(this).after('<div class="more-btn-wrap" style="text-align:right; margin-top:5px;"><button type="button" class="more-btn" onclick="$(this).parent().prev().css(\'max-height\', \'none\'); $(this).hide();" style="font-size:13px; color:#999; text-decoration:underline; border:none; background:none; cursor:pointer;">리뷰 더보기</button></div>');
        }
    });
</script>