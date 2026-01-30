<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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