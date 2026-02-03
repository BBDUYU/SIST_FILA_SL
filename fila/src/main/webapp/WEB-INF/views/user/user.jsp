<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인 | FILA</title>

<!-- 로그인 전용 CSS -->
<link rel="stylesheet" href="/SIST_FILA/resources/login.css">
</head>

<body>

<main class="login-container">
  <section class="login-box">

    <h2 class="login-title">로그인</h2>

    <!-- 아이디 / 비밀번호 -->
    <form class="login-form" method="post" action="${pageContext.request.contextPath}/member/login.do">
      <div class="input-wrap">
        <input type="text" name="id" placeholder="아이디" required>
      </div>

      <div class="input-wrap password">
        <input type="password" name="password" placeholder="비밀번호" required>
        <span class="eye"></span>
      </div>

      <div class="login-option">
        <label>
          <input type="checkbox" name="rememberId"> 아이디 저장
        </label>
       <a href="${pageContext.request.contextPath}/member/find-id-pw.do">
  아이디 / 비밀번호 찾기
</a>

      </div>

      <button type="submit" class="btn-login">로그인</button>
    </form>

    <!-- SNS 로그인 -->
    <div class="sns-login">
      <button type="button" class="btn-kakao" onclick="kakaoLogin()">
        카카오로 로그인하기
      </button>
    </div>

    <hr class="login-divider">

    <!-- 회원가입 -->
   <button type="button" class="btn-join"
        onclick="location.href='${pageContext.request.contextPath}/member/join.do'">

      회원가입
    </button>

    <div class="guest-order">
      <a href="${pageContext.request.contextPath}/order/guest.do">비회원 주문조회</a>

    </div>

  </section>
</main>

<!-- 로그인 관련 JS -->
<script src="/js/login.js"></script>

</body>
</html>
