<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 🔥 로그인 페이지 전용 오버레이 제거 (CSS 수정 없이) -->
<style>
  /* header 가상 레이어 차단 */
  #header::before { display: none !important; }
  .gnb-bg__wrap,
  .search-bg__wrap {
    display: none !important;
    pointer-events: none !important;
  }

  /* 로그인 영역 클릭 가능 보장 */
  #contents,
  #contents * {
    pointer-events: auto !important;
  }

  /* header가 덮는 현상 방지 */
  #header {
    position: relative !important;
    z-index: 10 !important;
  }
  #contents {
    position: relative;
    z-index: 20;
  }
</style>

<!-- header는 layout에서 include된 상태라고 가정 -->

<!-- start of :: contents -->
<div id="contents" class="mbr__contents">
  <h2 class="tit__style1">로그인</h2>

  <section class="mbr-box">

    <form id="loginForm"
          name="loginForm"
          action="${pageContext.request.contextPath}/member/login.do"
          method="post"
          autocomplete="off">

      <input type="hidden" name="rtnUrl" value="index.htm">
      <input type="hidden" name="lgc" value="0">
      <input type="hidden" name="returnUrl" value="${param.returnUrl}">

      <div class="inp-box">
        <div>
          <input type="text"
                 id="memberId1"
                 name="id"
                 placeholder="아이디"
                 autocomplete="username">
        </div>

        <div>
          <input type="password"
                 id="memberPwd"
                 name="password"
                 placeholder="비밀번호"
                 autocomplete="current-password">
          <button type="button" class="pwonoff__btn">on/off</button>
        </div>
      </div>

      <div class="id-box">
        <div class="id-save">
          <input type="checkbox" id="idCheck" name="idsave" value="1" class="cb__style1">
          <label for="idCheck">아이디 저장</label>
        </div>

        <div class="id-srh">
          <a href="${pageContext.request.contextPath}/member/search-idpw">
            아이디 / 비밀번호 찾기
          </a>
        </div>
      </div>

      <div class="btn-box">
        <button type="submit" class="btn_bg__bk">로그인</button>
      </div>
    </form>

    <div class="login_sns">
      <a href="#" class="btn_naver">네이버로 로그인하기</a>
      <a href="#" class="btn_kakao">카카오로 로그인하기</a>
    </div>

    <div class="btn-box">
      <a href="${pageContext.request.contextPath}/member/join"
         class="btn_sld__bk">
        회원가입
      </a>
      <a href="#" class="txt__btn">비회원 주문조회</a>
    </div>

  </section>
</div>

<c:if test="${param.error == 'fail'}">
<script>
  alert('아이디 또는 비밀번호가 틀렸습니다.');
</script>
</c:if>

<!-- 하단 고정 버튼 -->
<div class="bot-fix-box">
  <div class="inner">
    <button type="button" class="top__btn">top</button>
  </div>
</div>
