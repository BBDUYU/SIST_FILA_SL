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
    e.preventDefault(); 

    var pw = $('#confirmPassword').val();
    if(!pw) {
        alert("비밀번호를 입력하세요.");
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/mypage/confirmPassword.htm",
        type: 'POST',
        data: { memberPassword: pw },
        // dataType: 'json'을 삭제하거나 주석 처리하세요. 
        // 삭제하면 브라우저가 Accept 헤더를 까다롭게 따지지 않습니다.
        success: function(data) {
            // 응답이 문자열로 올 경우를 대비해 파싱 처리
            var res = (typeof data === 'string') ? JSON.parse(data) : data;
            
            if(res.ok) {
                location.href = "${pageContext.request.contextPath}/mypage/modifyInfo.htm";
            } else {
                alert(res.message);
            }
        },
        error: function(xhr) {
            // 406 에러가 난다면 여기서 xhr.status를 찍어볼 수 있습니다.
            console.log("Error Status: " + xhr.status);
            alert("통신 에러가 발생했습니다. 다시 시도해주세요.");
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