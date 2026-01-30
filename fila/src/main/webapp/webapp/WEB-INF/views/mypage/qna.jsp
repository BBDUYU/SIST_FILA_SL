<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="my-con" style="user-select: auto !important;">
           			<h2 class="tit__style4" style="user-select: auto !important;">1:1 문의</h2>
					<a href="#" class="btn_sld__bk btn_rt qna-write__btn" style="user-select: auto !important;">1:1 문의하기</a>

					<ul class="qna__list" style="user-select: auto !important;">
    <c:choose>
        <c:when test="${not empty qnaList}">
            <c:forEach var="dto" items="${qnaList}">
                <li style="user-select: auto !important;">
                    <div class="qna-q" style="user-select: auto !important; cursor: pointer;">
                        <div class="info" style="user-select: auto !important;">
                            <div style="user-select: auto !important;">
                                <p class="status ${dto.status == 'DONE' ? 'on' : ''}" style="user-select: auto !important;">
                                    ${dto.status == 'WAIT' ? '답변대기' : '답변완료'}
                                </p>
                                <p class="category" style="user-select: auto !important;">${dto.category_name}</p>
                            </div>
                            <p class="date" style="user-select: auto !important;">
                                <fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd"/>
                            </p>
                        </div>

                        <div class="qna-tit" style="user-select: auto !important;">
                            <p style="user-select: auto !important;">${dto.title}</p>
                        </div>
                    </div>
                    <div class="qna-a" style="user-select: auto !important; display: none;">
                        <div class="q-txt-box" style="user-select: auto !important;">
                            <div>
                                <p style="user-select: auto !important;">${dto.content}</p>
                            </div>
                        </div>

                        <c:if test="${dto.status == 'DONE'}">
                            <div class="a-txt-box" style="user-select: auto !important;">
                                <div>
                                    <p style="user-select: auto !important;">${dto.reply_content}</p>
                                </div>
                                <p class="date" style="user-select: auto !important;">
                                    <fmt:formatDate value="${dto.reply_at}" pattern="yyyy-MM-dd HH:mm"/>
                                </p>
                            </div>
                        </c:if>
                    </div>
                </li>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <li class="no-data" style="text-align:center; padding:50px 0;">
                등록된 문의 내역이 없습니다.
            </li>
        </c:otherwise>
    </c:choose>
</ul>
					<!-- //1:1문의 -->
					<div id="qnaModalOverlay" style="display:none;">
						    <div id="qnaModalContent"></div>
						</div>
				</section>

</div>
</div>

