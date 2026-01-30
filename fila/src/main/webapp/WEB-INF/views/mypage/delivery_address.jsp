<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>배송지 관리 | FILA</title>

<link rel="icon" type="image/x-icon"
	href="//filacdn.styleship.com/filacontent2/favicon.ico" />
<link href="http://localhost/SIST_FILA/css/SpoqaHanSansNeo.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/normalize.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/opt-default.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/swiper-bundle.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/layout.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/product.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/sub.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />

<!-- ✅ jQuery는 무조건 가장 먼저 -->
<script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>

<!-- 그 다음 플러그인/라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/TweenMax.js"></script>
<script src="${pageContext.request.contextPath}/js/mighty.base.1.5.7.js"></script>
<script src="${pageContext.request.contextPath}/js/matiz.js"></script>

<!-- ✅ 마지막에 내 코드(배송지/마이페이지 관련) -->
<script src="${pageContext.request.contextPath}/js/mypage.js"></script>
<script src="${pageContext.request.contextPath}/js/searchZip.js"></script>

<!-- 다음 우편번호 -->
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


</head>

<body>

	<jsp:include page="/view/common/header.jsp" />
	<jsp:include page="/view/mypage/mypage.jsp" />

	<section class="my-con">
		<h2 class="tit__style4">배송지 관리</h2>
		<a href="#" class="btn_sld__bk btn_rt add-addr__btn">신규 배송지 추가</a>


		<!-- 배송지 관리 -->
		<div class="my-address-box">

			<ul class="addr__list">
				<c:forEach var="a" items="${addrList}" varStatus="st">
					<li class="${a.isDefault == 1 ? '_default_addr' : ''}"><input
						type="radio" id="myAddr${st.index}" name="myAddrList"
						class="addr-chk" ${a.isDefault == 1 ? 'checked' : ''}> <label
						for="myAddr${st.index}"></label>

						<div class="addr-info">
							<div class="name-tel">
								<c:if test="${a.isDefault == 1}">
									<p class="tag">기본</p>
								</c:if>
								<p class="name">${a.recipientName}</p>
								<p class="tel">${a.recipientPhone}</p>
							</div>

							<div class="addr-detail">
								<p>
									(${a.zipcode}) ${a.mainAddr}<br>
									<c:out value="${a.detailAddr}" />
								</p>
							</div>
						</div>

						<div class="btn-box">
							<button type="button" class="modify__btn"
								data-addr-no="${a.addressId}">modify</button>
							<c:choose>
								<c:when test="${a.isDefault == 1}">
									<button type="button" class="delete__btn"
										onclick="alert('기본 배송지는 삭제하실 수 없습니다.');">delete</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="delete__btn"
										data-addr-no="${a.addressId}">delete</button>
								</c:otherwise>
							</c:choose>
						</div> <c:if test="${a.isDefault == 0}">
							<button type="button" class="default-addr__btn"
								onclick="addrDefault('${a.addressId}');">기본으로 설정</button>
						</c:if></li>
				</c:forEach>

				<c:if test="${empty addrList}">
					<li style="padding: 20px;">등록된 배송지가 없습니다.</li>
				</c:if>
			</ul>



		</div>
		<!-- //배송지 추가 -->
		<div id="AddaddressModalOverlay" class="style-modal-overlay"
			onclick="if(event.target === this) closeQnaModal();"
			style="display: none;">

			<div id="AddaddModalContent" class="style-modal-wrapper">
				<!-- AJAX로 qna_modal.jsp 들어올 자리 -->
			</div>
		</div>
		<!-- //배송지 수정 -->
		<div id="EditaddressModalOverlay" class="style-modal-overlay"
			onclick="if(event.target === this) closeQnaModal();"
			style="display: none;">

			<div id="EditaddModalContent" class="style-modal-wrapper">
				<!-- AJAX로 qna_modal.jsp 들어올 자리 -->
			</div>
		</div>
		<!-- 주소 -->

	</section>

	</div>
	</div>



	<script>
var contextPath = '${pageContext.request.contextPath}';

(function ($) {

  /* =========================
     공통 모달 노출 함수 (CSS 강제 보정 포함)
     ========================= */
     function showModalForce(overlayId) {

    	  // 1️⃣ 열고 싶은 overlay 선택 (#AddaddressModalOverlay 등)
    	  var $ov = $(overlayId);

    	  // 2️⃣ overlay 자체를 화면에 표시 (flex 유지)
    	  $ov.css('display', 'flex').show();

    	  // 3️⃣ 🔥 이 overlay "안에 로드된" common__layer만 찾기
    	  //    (페이지 전체 common__layer ❌)
    	  var $layer = $ov.find('.common__layer');

    	  // 4️⃣ common__layer 강제 표시 (AJAX 로드 후 height 0 방지)
    	  $layer.css({
    	    display: 'block',
    	    visibility: 'visible',
    	    opacity: '1',
    	    zIndex: '9999'
    	  });

    	  // 5️⃣ 내부 컨텐츠(.inner)도 같이 강제 표시
    	  $layer.find('.inner').css({
    	    display: 'block',
    	    visibility: 'visible',
    	    zIndex: '10000'
    	  });

    	  // 6️⃣ 모달 열린 동안 배경 스크롤 막기
    	  $('body').css('overflow', 'hidden');
    	}

  /* =========================
     배송지 수정 (edit_address.jsp)
     ========================= */
  $(document).on('click', '.modify__btn', function (e) {
    e.preventDefault();

    // addrNo 추출 로직
    var addrNo = $(this).data('addr-no');

    $('#EditaddModalContent').load(
      contextPath + '/view/mypage/edit_address.jsp?addrNo=' + addrNo,
      function () {
        showModalForce('#EditaddressModalOverlay');
      }
    );
  });

  /* =========================
     배송지 추가 (add_address.jsp)
     ========================= */
  $(document).on('click', '.add-addr__btn', function (e) {
    e.preventDefault();

    $('#AddaddModalContent').load(
      contextPath + '/view/mypage/add_address.jsp',
      function () {
        showModalForce('#AddaddressModalOverlay');
      }
    );
  });

  /* =========================
     공통 닫기
     ========================= */
  window.closeQnaModal = function () {
    $('#AddaddressModalOverlay').hide();
    $('#EditaddressModalOverlay').hide();
    $('#AddaddModalContent').empty();
    $('#EditaddModalContent').empty();
    $('body').css('overflow', 'auto');
  };

  $(document).on('click', '.close__btn, .btnCancel', function () {
    closeQnaModal();
  });

})(jQuery);

	/* =========================
	기본 배송지 설정
	========================= */
	function addrDefault(addrNo) {
		  if (!confirm('이 배송지를 기본 배송지로 설정하시겠습니까?')) return;
	
		  $.ajax({
		    url: contextPath + '/mypage/address/default.htm',
		    type: 'POST',
		    data: { addrNo: addrNo },
		    dataType: 'json',
		    success: function (res) {
		      if (res && res.ok) {
		        location.reload(); // 다시 조회해서 UI 갱신
		      } else {
		        alert('기본 배송지 설정 실패');
		      }
		    },
		    error: function (xhr) {
		      alert('오류 발생 (' + xhr.status + ')');
		    }
		  });
		}
	
	/* =========================
	삭제 버튼 (기본배송지 아닌 것만 data-addr-no로 들어옴)
	========================= */
	$(document).off('click.addrDelete', '.delete__btn[data-addr-no]')
    .on('click.addrDelete', '.delete__btn[data-addr-no]', function(e){
	e.preventDefault();
	e.stopPropagation();
	
	var addrNo = $(this).data('addr-no');
	if(!addrNo) return;
	
	if(!confirm('이 배송지를 삭제하시겠습니까?')) return;
	
	$.ajax({
	url: contextPath + '/mypage/address/delete.htm',
	type: 'POST',
	data: { addrNo: addrNo },
	dataType: 'json',
	
	success: function(res){
	if(res && res.ok){
	 location.reload();
	}else{
	 if(res && res.error === "USED_IN_ORDER"){
	   alert('주문에 사용된 배송지는 삭제할 수 없습니다.');
	 }else if(res && res.error === "DEFAULT_CANNOT_DELETE"){
	   alert('기본 배송지는 삭제할 수 없습니다.');
	 }else if(res && res.error === "NOT_FOUND"){
	   alert('삭제할 배송지를 찾을 수 없습니다.');
	 }else{
	   alert('삭제 실패');
	 }
	}
	},
	
	error: function(xhr){
	// 서버가 JSON으로 에러 내려주는 경우도 있어서 파싱 시도
	try{
	 var res = JSON.parse(xhr.responseText);
	
	 if(res && res.error === "USED_IN_ORDER"){
	   alert('주문에 사용된 배송지는 삭제할 수 없습니다.');
	   return;
	 }
	 if(res && res.error === "DEFAULT_CANNOT_DELETE"){
	   alert('기본 배송지는 삭제할 수 없습니다.');
	   return;
	 }
	 if(res && res.error === "NOT_FOUND"){
	   alert('삭제할 배송지를 찾을 수 없습니다.');
	   return;
	 }
	}catch(e){
	 // 파싱 실패 시 무시
	}
	
	alert('삭제 실패 (' + xhr.status + ')');
	}
	});
	});
</script>

	<jsp:include page="/view/common/footer.jsp" />
</body>
</html>
