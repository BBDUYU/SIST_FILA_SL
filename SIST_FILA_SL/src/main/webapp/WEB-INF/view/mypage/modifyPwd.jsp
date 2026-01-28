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

<script>
//엔터키 감지 로직 추가
$(document).off('keypress', '#MemberPassword').on('keypress', '#MemberPassword', function(e) {
    if (e.keyCode == 13) { // 13은 엔터키의 키코드입니다.
        e.preventDefault(); // 기본 제출 동작 방지
        updateform_pw();    // 변경 함수 실행
    }
});
// 1. 비밀번호 변경 실행 함수
function updateform_pw() {
    var newPw = $('#MemberPassword').val(); 
    var $resultMsg = $('#pwResult');
    var regExp = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+|~={}\[\]:";'<>?,.\/]).{8,16}$/;

    if(newPw.length < 8 || newPw.length > 16) {
        $resultMsg.text("8 - 16자 사이로 입력해주세요.").show();
        return;
    }
    
    if(!regExp.test(newPw)) {
        alert("비밀번호 형식이 올바르지 않습니다.");
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/mypage/changePassword.htm",
        type: "POST",
        data: { newPassword: newPw },
        success: function(res) {
            alert("비밀번호가 변경되었습니다. 다시 로그인해주세요.");
            location.href = "${pageContext.request.contextPath}/login.htm";
        },
        error: function(xhr) {
            alert("변경 오류 (상태코드: " + xhr.status + ")");
        }
    });
}

// 2. 실시간 체크 및 눈 모양 버튼 (이벤트 위임 방식)
// 모달이 동적으로 로드되어도 document가 이벤트를 감시하므로 안전합니다.
$(document).off('keyup', '#MemberPassword').on('keyup', '#MemberPassword', function() {
    var pw = $(this).val();
    var regExp = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+|~={}\[\]:";'<>?,.\/]).{8,16}$/;
    var $msg = $('#pwResult');

    if(regExp.test(pw)) {
        $msg.text("사용 가능한 비밀번호입니다.").css("color", "blue");
    } else {
        $msg.text("영문, 숫자, 특수문자 조합이 필요합니다 (8~16자).").css("color", "red");
    }
});

$(document).off('click', '.pwonoff__btn').on('click', '.pwonoff__btn', function() {
    var $input = $('#MemberPassword');
    if ($input.attr('type') === 'password') {
        $input.attr('type', 'text');
        $(this).addClass('off');
    } else {
        $input.attr('type', 'password');
        $(this).removeClass('off');
    }
});
</script>