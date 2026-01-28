<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/common.css">


<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="/js/join.js"></script>

<style>
/* ===== join.js 필수 ===== */
.agree-chk-wrap,
.self-agree-wrap {
  display: none;
}
.agree-chk-wrap.open,
.self-agree-wrap.open {
  display: block;
}

/* ===== 본인인증 이후 ===== */
.after-cert {
  display: none;
}

/* ===== 자녀정보 초기 숨김 ===== */
.join-sec .children-box,
.join-sec .children-btn {
  display: none;
}

/* + / - 아이콘 */
.btn_sel .pm::after {
  content: '+';
}
.btn_sel.on .pm::after {
  content: '-';
}
</style>
</head>

<body>

<jsp:include page="../common/header.jsp" />



    <section class="mbr-box">
      <div class="join__step2">
        <h3>
          미스토코리아 의<br>
          회원이 되신 것을 축하드립니다.
        </h3>

        <p class="txt__style1">
          회원님은 미스토코리아 에서 운영하는 <br>
          브랜드 사이트 (FILA, Keds 외)에 통합가입되었습니다.<br>
          한 번의 가입으로
          <a href="javascript:;" class="txt__line">각 브랜드 사이트로의 통합 로그인이 가능</a>합니다.<br>

          FILA 통합멤버십 회원(FILA, Keds)은 해당 아이디와 패스워드로 <br>
          FILA의 모든 서비스를 이용하실 수 있습니다.
          <br><br>
          다양한 이벤트와 정보를 제공받으실 수 있으며, <br>
          회원 정보 변경은 마이페이지에서 하실 수 있습니다.<br>
          자세한 내용은 아래 통합 멤버십 혜택 버튼 클릭 후 확인하실 수 있습니다.
        </p>
      </div>

      <div class="btn-box">
<div class="btn-box">
 <a href="<%=request.getContextPath()%>/login.htm" class="btn_bg__bk">
  로그인
</a>

     



  <a href="${pageContext.request.contextPath}/customer/membership.htm"
     class="btn_sld__gr">
     멤버십 혜택 보기
  </a>
</div>

    </section>
  </div>

</div>


<jsp:include page="../common/footer.jsp" />

<script>
  $('#btnCert').on('click', function () {
    $('.after-cert').slideDown();
    $('html, body').animate({
      scrollTop: $('.after-cert').offset().top - 80
    }, 400);
  });
</script>

</body>
</html>
