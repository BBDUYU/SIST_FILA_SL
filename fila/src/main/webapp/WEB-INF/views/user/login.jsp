<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
/* 🔴 헤더가 로그인 영역을 덮는 문제 해결 */

/* header의 가상 레이어 제거 */
#header::before,
.gnb-bg__wrap,
.search-bg__wrap {
    display: none !important;
    pointer-events: none !important;
}

/* header를 뒤로 보냄 */
#header {
    position: relative !important;
    z-index: 10 !important;
}

/* 로그인 contents를 앞으로 */
#contents {
    position: relative;
    z-index: 50;
}

/* contents 내부 클릭 보장 */
#contents,
#contents * {
    pointer-events: auto !important;
}
</style>

	
	<!-- // end of :: header -->

	<form name="searchFormReal" method="get"
      action="${pageContext.request.contextPath}/search">

		<input type="hidden" name="sWord" value />
		<input type="hidden" name="searchsCateNo" value />
	</form>

	<!-- start of :: contents -->
	<div id="contents" class="mbr__contents">
		<h2 class="tit__style1">로그인</h2>

		<!-- login -->
		<section class="mbr-box">
			<!-- 입력 폼 - 이메일, 비밀번호 -->
	<form id="loginForm" name="loginForm"
      action="${pageContext.request.contextPath}/member/login.do"
      method="post" class="on">



				<input type="hidden" name="rtnUrl" value="index.htm">
				<input type="hidden" name="lgc" id="lgc" value="0">
				
				<input type="hidden" name="returnUrl" value="${param.returnUrl}">

				<div class="inp-box">
					<div>
					<input type="text" id="memberId1" name="id" placeholder="아이디">

					</div>

					<div>
						<input type="password" id="memberPwd" class="inp__pw login_pw"
							   name="password" placeholder="비밀번호" value="" tabindex="52" />
						<button type="button" class="pwonoff__btn">on/off</button>
					</div>
				</div>

				<!-- 아이디 저장, 아이디비밀번호 찾기 -->
				<div class="id-box">
					<div class="id-save">
						<input type="checkbox" id="idCheck" name="idsave" value="1" class="cb__style1" tabindex="54" />
						<label for="idCheck">아이디 저장</label>
					</div>

					<div class="id-srh"><a href="${pageContext.request.contextPath}/member/pw-find.do"
   tabindex="55">
   아이디 / 비밀번호 찾기
</a>
</div>
				</div>

				<!-- 로그인 버튼 -->
				<div class="btn-box">
					<button type="submit" class="btn_bg__bk" id="loginbtn">로그인</button>

					<a id="loginbtn2" style="display:none;" class="btn_bg__bk _style_loading"></a>
				</div>
			</form>

			<!-- sns 로그인 -->
			<div class="login_sns">
				<a href="#" class="btn_naver">네이버로 로그인하기</a>
                <a href="#" class="btn_kakao">카카오로 로그인하기</a>

			</div>

			<p class="txt" style="display:none">휠라코리아 통합멤버십 회원(FILA, KEDS, ZOO YORK)은<br>
			하나의 통합아이디로 FILA의 모든 서비스를 이용하실 수 있습니다.</p>

			<div class="btn-box">
				<div class="btn-box">
  <a href="${pageContext.request.contextPath}/member/join.do"
   class="btn_sld__bk" tabindex="59">
   회원가입
</a>

				<a href="${pageContext.request.contextPath}/order/order_address.htm"
   class="txt__btn" tabindex="60">
   비회원 주문조회
</a>

			</div>
		</section>
		<!-- //login -->
	</div>
	<!-- // end of :: contents -->

	<!-- 로그인 실패 alert -->
	<c:if test="${param.error == 'fail'}">
	<script>
		alert('아이디 또는 비밀번호가 틀렸습니다.');
	</script>
	</c:if>

	<!-- 하단 고정 버튼 (top, sns) -->
	<div class="bot-fix-box">
		<div class="inner">

			<button type="button" class="today-goods__btn">
				<svg id="btn_time" xmlns="http://www.w3.org/2000/svg" width="29" height="29" viewBox="0 0 29 29">
					<g id="icon" transform="translate(-0.025 -0.025)">
						<path id="패스_706" data-name="패스 706" d="M17.05,24.66A14,14,0,1,0,19.5,9.572l.253-3.648" transform="translate(-15.29 -4.475)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1"/>
						<path id="패스_707" data-name="패스 707" d="M6.537,83.1a14.542,14.542,0,0,0-.3,12.37" transform="translate(-4.475 -75.062)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1" stroke-dasharray="40 40"/>
						<path id="패스_708" data-name="패스 708" d="M114.512,80.167v6.806l-3.662,3.662" transform="translate(-99.914 -72.362)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
						<line id="선_542" data-name="선 542" x1="3.654" transform="translate(4.307 5.263)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1"/>
					</g>
				</svg>
			</button>

			<button type="button" class="kakaotalk__btn" onclick="doBizmsg();void(0);">
				<svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 50 50">
					<g id="btn_kakao" transform="translate(-330)">
						<circle id="타원_73" data-name="타원 73" cx="25" cy="25" r="25" transform="translate(330)" fill="#fedc00"/>
						<g id="그룹_18" data-name="그룹_18" transform="translate(345 15)">
							<path id="패스_8" data-name="패스_8" d="M192.79,193.223c-5.868,0-10.625,3.782-10.625,8.447a8.127,8.127,0,0,0,4.614,6.966l-.768,4.118a.236.236,0,0,0,.362.241l4.564-3.006s1.221.128,1.853.128c5.868,0,10.625-3.782,10.625-8.447s-4.757-8.447-10.625-8.447" transform="translate(-182.165 -193.223)" fill="#3c1e1e"/>
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
			}
			
	

			</script>
			
	

			<form id="form-biz" name="formbiz" action="https://bizmessage.kakao.com/chat/open" method="post" target="kakaoPop">
				<input type="hidden" name="uuid" value="@fila" />
				<input type="hidden" name="extra" value="TCK_M"/>
				<input type="hidden" name="bot" value="true" />
				<input type="hidden" name="event" value="시작" />
			</form>

			<button type="button" class="top__btn">top</button>
		</div>
	</div>




