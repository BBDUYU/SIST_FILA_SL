<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/layout.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/sub.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/opt-default.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/product.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/normalize.css">

<script src="<%=request.getContextPath()%>/resource/js/jquery-1.11.2.min.js"></script>

<div id="contents" class="mbr__contents">
  <h2 class="tit__style1">아이디 / 비밀번호 찾기</h2>

  <section class="mbr-box">
    <div class="info-sec">

      <div class="inp-box">
        <input type="text" id="membername" placeholder="이름">

        <div class="phone">
          <select id="phone1" class="sel__style1 wid__style3">
            <option value="010">010</option>
            <option value="011">011</option>
            <option value="016">016</option>
            <option value="017">017</option>
            <option value="019">019</option>
          </select>

          <input type="tel"
                 id="phone2"
                 class="inp__phone"
                 maxlength="8"
                 inputmode="numeric"
                 placeholder="휴대폰 번호">
        </div>

        <!-- 인증번호 -->
        <div id="confirmBox" style="display:none;">
          <input type="tel"
                 id="confirmNo"
                 maxlength="6"
                 inputmode="numeric"
                 placeholder="인증번호">
          <small id="countdown" class="count"></small>
        </div>
      </div>

      <div class="btn-box">
        <button type="button" class="btn_bg__gr" id="btnSend">인증번호 요청</button>
        <button type="button" class="btn_bg__bk" id="btnConfirm" style="display:none;">인증번호 확인</button>
      </div>

    </div>
  </section>
</div>

<!-- ===== 아이디 결과 ===== -->
<div class="common__layer sch-idpw" id="idLayer" style="display:none;">
	<div class="layer-bg__wrap"></div>

	<div class="inner">
		<div class="head">
			<p class="tit">아이디 찾기</p>
			<button type="button" class="close__btn" onclick="closeIdLayer()">close</button>
		</div>

		<div class="con">
			<div class="wrap">
				<p id="resultText">
					
				</p>
				

				<div class="top__line2">
					<p class="txt">
						비밀번호가 기억나지 않으실 경우<br>
						재설정이 가능합니다.
					</p>
				</div>
			</div>
		</div>

		<div class="foot">
			<button type="button" class="btn_bg__bk" id="btnPwOpen" onclick="openPwLayer()">비밀번호 재설정</button>
			<button type="button" class="on" onclick="location.href='/member/login.do'">로그인</button>
		</div>
	</div>
</div>


<!-- ===== 비밀번호 재설정 ===== -->
<div class="common__layer sch-idpw" id="pwLayer" style="display:none;">
	<div class="layer-bg__wrap"></div>

	<div class="inner">
		<div class="head">
			<p class="tit">비밀번호 재설정</p>
			<button type="button" class="close__btn" onclick="closePwLayer()">close</button>
		</div>

		<div class="con">
			<form name="pwForm" method="post" class="join_form modify_form">
				<input type="hidden" name="id" id="pwTargetId">

				<div class="wrap">
					<div class="password-box">
						<input type="password"
							   class="inp__pw"
							   name="MemberPassword"
							   id="newPw"
							   placeholder="8 - 16자 영문, 숫자, 특수문자 조합"
							   maxlength="16">
					</div>

					<div class="password-box">
						<input type="password"
							   class="inp__pw"
							   name="MemberPassword"
							   id="newPw2"
							   placeholder="비밀번호 확인"
							   maxlength="16">
					</div>
					<p id="pwResult"
					   style="color:#cc3333; font-style:normal; font-family:dotum; font-size:12px;"></p>&nbsp;

					<p class="txt2">
						8-12자의 영문 / 숫자 / 특수문자(!@#$%^&amp;*) 조합만 사용 가능합니다.
					</p>

					<p class="err-msg"></p>
				</div>
			</form>
		</div>

		<div class="foot">
			<button type="reset" class="btn_can" onclick="resetPwForm()">취소</button>
			<button type="button" class="on" id="btnPwSubmit">변경 후 로그인</button>
		</div>
	</div>
</div>
