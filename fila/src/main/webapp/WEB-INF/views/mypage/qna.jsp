<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>1:1 문의 | FILA</title>

<link rel="icon" type="image/x-icon" href="//filacdn.styleship.com/filacontent2/favicon.ico" />
<link href="http://localhost/SIST_FILA/css/SpoqaHanSansNeo.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/normalize.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/opt-default.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/swiper-bundle.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/product.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sub.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />

<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/TweenMax.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>
<script src="${pageContext.request.contextPath}/js/mighty.base.1.5.7.js"></script>
<script src="${pageContext.request.contextPath}/js/matiz.js"></script>
<script src="${pageContext.request.contextPath}/js/swiper-bundle.js"></script>
<script src="${pageContext.request.contextPath}/js/default.js?v=202504161631"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
    
    <!-- QnA JS -->
    <script src="${pageContext.request.contextPath}/js/inquiry.js"></script>
    <script src="${pageContext.request.contextPath}/js/mypage.js"></script>

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>


</head>

<body>

<jsp:include page="/view/common/header.jsp"/>
<jsp:include page="/view/mypage/mypage.jsp"/>

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



<script>
var contextPath = '${pageContext.request.contextPath}';

(function ($) {

	  // 1:1 문의 모달 열기
	  $(document).on('click', '.qna-write__btn', function (e) {
	    e.preventDefault();
	    openQnaModal();
	  });

	  function openQnaModal() {
		    $.ajax({
		        url: contextPath + '/mypage/qnaWriteForm.htm',
		        type: 'GET',
		        success: function (res) {
		            // 1. 데이터를 먼저 넣는다
		            $('#qnaModalContent').html(res);
		            
		            $('#qnaModalOverlay').css({
		                'display': 'block',
		                'position': 'fixed',
		                'top': '0',
		                'left': '0',
		                'width': '100%',
		                'height': '100%',
		                'background': 'rgba(0, 0, 0, 0.6)', // 👈 배경을 까맣게 만드는 핵심
		                'z-index': '9998'
		            });

		            // 3. 모달 레이어 노출
		            $('.common__layer').show().css({
		                'display': 'block',
		                'z-index': '9999'
		            });

		            $('body').css('overflow', 'hidden');
		        }
		    });
		}

	  // 닫기
	  window.closeQnaModal = function () {
	    $('#qnaModalOverlay').hide();
	    $('#qnaModalContent').empty();
	    $('body').css('overflow', 'auto');
	  };

	  // 내부 닫기 버튼
	  $(document).on('click', '#btnCloseQna, .close__btn', function () {
	    closeQnaModal();
	  });
	  $(document).on('click', '.qna-q', function () {
	        const $parentLi = $(this).closest('li');
	        const $answer = $parentLi.find('.qna-a');

	        // 1. 클릭한 질문의 답변을 토글 (열려있으면 닫고, 닫혀있으면 열기)
	        $answer.stop().slideToggle(300);

	        // 2. 답변이 열릴 때 부모 li에 'on' 클래스 추가 (화살표 방향 변경 등을 위해)
	        $parentLi.toggleClass('on');

	        // 3. (선택사항) 다른 답변은 자동으로 닫고 싶다면 아래 주석 해제
	        /*
	        $parentLi.siblings().removeClass('on').find('.qna-a').slideUp(300);
	        */
	    });
	})(jQuery);

</script>

<jsp:include page="/view/common/footer.jsp"/>
<%-- <jsp:include page="/view/mypage//qna_write.jsp"/>
 --%>
</body>
</html>
