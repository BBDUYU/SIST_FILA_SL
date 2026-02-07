<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="my-con">
    <h2 class="tit__style4">1:1 문의</h2>

    <!-- 1:1 문의하기 버튼 -->
    <a href="#" class="btn_sld__bk btn_rt qna-write__btn">1:1 문의하기</a>

    <!-- 문의 리스트 -->
    <ul class="qna__list">
        <c:choose>
            <c:when test="${not empty qnaList}">
                <c:forEach var="dto" items="${qnaList}">
                    <li>
                        <div class="qna-q" style="cursor:pointer;">
                            <div class="info">
                                <div>
                                    <p class="status ${dto.status == 'DONE' ? 'on' : ''}">
                                        <c:choose>
                                            <c:when test="${dto.status == 'DONE'}">답변완료</c:when>
                                            <c:otherwise>답변대기</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p class="tit">${dto.title}</p>
                                </div>
                                <p class="date">${dto.createdAt}</p>
                            </div>
                        </div>
                    </li>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <li class="nodata">
                    등록된 문의가 없습니다.
                </li>
            </c:otherwise>
        </c:choose>
    </ul>

    <!-- 모달 오버레이/컨텐츠 -->
    <div id="qnaModalOverlay" class="common__layer _qna_write" style="display:none;">
        <div class="layer-bg__wrap" onclick="closeQnaModal()"></div>
        <div class="inner">
            <div id="qnaModalContent"></div>
        </div>
    </div>

    <%-- 스크립트 include (프로젝트에서 쓰는 방식대로 include 하시면 됩니다) --%>
    <jsp:include page="/WEB-INF/views/mypage/qna_script.jsp" />
</section>
