<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/layout.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/sub.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/opt-default.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/product.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/normalize.css">

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
</head>

<body>

<!-- ✅ 헤더 -->
<jsp:include page="../common/header.jsp" />

<div id="contents" class="mbr__contents">
			<h2 class="tit__style1">회원가입</h2>

			<!-- join -->
			<section class="mbr-box">
					<!-- 카카오 간편 회원가입 -->
					<div class="join-sec_kakao">
						<p class="txt">카카오 간편 회원가입으로 보다 간편하게 회원가입이 가능합니다.</p>
						<div class="btn-box">
							<a href="javascript:snsJoin('KK');void(0);" class="join_kakao">카카오 1초 간편가입</a>
							<a href="${pageContext.request.contextPath}/member/join.htm"
   class="btn_sld__bk">
   본인인증 후 회원가입
</a>

						</div>
					</div>
					<!-- // 카카오 간편 회원가입 -->
				
					<!-- 회원가입 혜택 -->
					<div class="join-benefit-box">
						<h3 class="tit__style2">회원가입 혜택</h3>	
						<ul>
							<li>
								<span>신규 가입 시 1만원 쿠폰 지급</span>
							</li>
							<li>
								<span>최대 5% 구매 포인트 적립</span>
							</li>
							<li>
								<span>최대 2만원 기념일 쿠폰 지급 </span>
							</li>
							<li>
								<span>오늘도착 서비스 이용 가능</span>
							</li>
						</ul>
					</div>
					<!-- // 회원가입 혜택 -->
			</section>
			<!-- //join -->
		</div>



<div class="bot-fix-box" style="display: none;">
	<div class="inner">


		<!-- 2023-10-05 오늘 본 상품 추가 (오늘 본 상품이 없는 경우 나타남) -->
		<button type="button" class="today-goods__btn">
			<svg id="btn_time" xmlns="http://www.w3.org/2000/svg" width="29" height="29" viewBox="0 0 29 29">
			  <g id="icon" transform="translate(-0.025 -0.025)">
				<path id="패스_706" data-name="패스 706" d="M17.05,24.66A14,14,0,1,0,19.5,9.572l.253-3.648" transform="translate(-15.29 -4.475)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1"></path>
				<path id="패스_707" data-name="패스 707" d="M6.537,83.1a14.542,14.542,0,0,0-.3,12.37" transform="translate(-4.475 -75.062)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1" stroke-dasharray="40 40"></path>
				<path id="패스_708" data-name="패스 708" d="M114.512,80.167v6.806l-3.662,3.662" transform="translate(-99.914 -72.362)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"></path>
				<line id="선_542" data-name="선 542" x1="3.654" transform="translate(4.307 5.263)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1"></line>
			  </g>
			</svg>

		</button>
		<!-- //2023-10-05 오늘 본 상품 추가 (오늘 본 상품이 없는 경우 나타남) -->


		<button type="button" class="kakaotalk__btn" onclick="doBizmsg();void(0);">
			<svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 50 50">
				<g id="btn_kakao" transform="translate(-330)">
					<circle id="타원_73" data-name="타원 73" cx="25" cy="25" r="25" transform="translate(330)" fill="#fedc00"></circle>
					<g id="그룹_18" data-name="그룹 18" transform="translate(345 15)">
						<path id="패스_8" data-name="패스 8" d="M192.79,193.223c-5.868,0-10.625,3.782-10.625,8.447a8.127,8.127,0,0,0,4.614,6.966l-.768,4.118a.236.236,0,0,0,.362.241l4.564-3.006s1.221.128,1.853.128c5.868,0,10.625-3.782,10.625-8.447s-4.757-8.447-10.625-8.447" transform="translate(-182.165 -193.223)" fill="#3c1e1e"></path>
					</g>
				</g>
			</svg>
		</button>


		<script src="https://bizmessage.kakao.com/chat/includeScript"></script>

<script type="text/javascript">
function doBizmsg() {
var kakaoPop = window.open("about:blank","kakaoPop","width=350,height=550")
var frm = document.formbiz;
frm.submit();
//document.getElementById("form-biz").submit();

}
</script>
<form id="form-biz" name="formbiz" action="https://bizmessage.kakao.com/chat/open" method="post" target="kakaoPop">
<!--
<input type="hidden" name="uuid" value="@FILA" />
<input type="hidden" name="extra" value="FILA_M"/>
-->

<input type="hidden" name="uuid" value="@fila">
<input type="hidden" name="extra" value="TCK_M">

<input type="hidden" name="bot" value="true">
<input type="hidden" name="event" value="시작">
</form>


<button type="button" class="top__btn">top</button>	


</div>
</div>



</body>
<!-- ✅ 푸터 -->
<jsp:include page="../common/footer.jsp" />	
</html>
