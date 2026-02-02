<%@ page contentType="text/html; charset=UTF-8" %>
<div class="common__layer sch-idpw _modify_pw">
    <div class="layer-bg__wrap"></div>

    <div class="inner">
        <div class="head">
            <p class="tit">내 정보 변경</p>
            <button type="button" class="close__btn" onclick="closeModifyModal()">close</button>
        </div>

        <div class="con">
            <div class="wrap">
                <p class="txt">비밀번호 확인 후 <br>정보 변경이 가능합니다.</p>
                <form name="myform" id="confirmPwForm" method="post" class="join_form modify_form">
                    <div class="password-box">
                        <input type="password" name="memberPassword" id="confirmPassword" class="inp__pw" maxlength="16" placeholder="8 - 16자 영문, 숫자, 특수문자 조합">
                        <button type="button" class="pwonoff__btn">on/off</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="foot">
            <button type="button" class="close__btn" onclick="closeModifyModal()">취소</button>
            <button type="button" class="on" id="btnConfirmPw">확인</button>
        </div>
    </div>
</div>

<script>
// 모달 안에서 동작할 전용 스크립트
$('#btnConfirmPw').on('click', function(e) {
    // 1. 폼의 기본 제출 동작(새로고침)을 강제로 막음
    e.preventDefault(); 

    var pw = $('#confirmPassword').val();
    if(!pw) {
        alert("비밀번호를 입력하세요.");
        return;
    }

    // 2. contextPath 변수가 없다면 JSP 엘리먼트로 직접 치환
    var urlAddr = "${pageContext.request.contextPath}/mypage/confirmPassword.htm";
    var nextAddr = "${pageContext.request.contextPath}/mypage/modifyInfo.htm";

    $.ajax({
        url: urlAddr,
        type: 'POST',
        data: { memberPassword: pw },
        dataType: 'json',
        success: function(res) {
            console.log("응답 결과:", res); // 디버깅용
            if(res.ok) {
                // 성공 시 이동
                location.href = nextAddr;
            } else {
                alert(res.message || "비밀번호가 일치하지 않습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.error("에러 발생:", error);
            alert("통신 중 오류가 발생했습니다.");
        }
    });
});

// 엔터키 대응
$('#confirmPassword').on('keypress', function(e) {
    if(e.keyCode == 13) {
        e.preventDefault();
        $('#btnConfirmPw').click();
    }
});
</script>