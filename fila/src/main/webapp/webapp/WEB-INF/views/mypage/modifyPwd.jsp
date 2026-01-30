<%@ page contentType="text/html; charset=UTF-8" %>
<div class="common__layer sch-idpw _addr_add">
	<div class="layer-bg__wrap"></div>

	<div class="inner">
		<div class="head">
			<p class="tit">비밀번호 재설정</p>
			<button type="button" class="close__btn">close</button>
		</div>

		<div class="con">
			<div class="wrap">
				<form name="myform2" onsubmit="return false;" method="post" target="dataFrame" class="join_form modify_form">
				<input type="hidden" name="memberID" value="tmdwhddh">
				<div class="password-box">
					<input type="password" class="inp__pw" name="MemberPassword" id="MemberPassword" maxlength="16" placeholder="8 - 16자 영문, 숫자, 특수문자 조합">
					<button type="button" class="pwonoff__btn">on/off</button>
					<!-- 눈 감기 클래스 off -->
				</div>
				<p class="txt2">8-12자의 영문 / 숫자 / 특수문자(!@#$%^&amp;*) 조합만
				사용 가능합니다.</p>
				<p class="err-msg" id="pwResult">특수문자가 필요합니다.</p>
				</form>
			</div>
		</div>
		<div class="foot">
			<button type="button" class="btn_can">취소</button>
			<button type="button" class="on" onclick="javascript:updateform_pw();void(0);">변경 후 로그인</button>
		</div>
	</div>
</div>

