<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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