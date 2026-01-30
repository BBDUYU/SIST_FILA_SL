<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script>
function fn_send() {
    // 1. 유효성 검사
    if ($("#categoryId").val() == "") {
        alert("문의유형을 선택해주세요.");
        $("#categoryId").focus();
        return;
    }
    if ($("#boardTitle").val().trim() == "") {
        alert("제목을 입력해주세요.");
        $("#boardTitle").focus();
        return;
    }
    if ($("#boardContents").val().trim() == "") {
        alert("문의 내용을 입력해주세요.");
        $("#boardContents").focus();
        return;
    }
    
    // 라디오 버튼 체크 여부 확인
    var agree = $('input[name="privacyAgree"]:checked').val();
    if (!agree) {
        alert("개인정보 수집 동의 여부를 선택해주세요.");
        return;
    }
    if (agree == "0") {
        alert("개인정보 수집에 동의하셔야 문의 접수가 가능합니다.");
        return;
    }

    // 2. 대기 상태 표시 (버튼 교체)
    $("#writeButton").hide();
    $("#writeButton2").show();

    // 3. AJAX 전송
    // QnaWriteHandler가 .htm으로 매핑되어 있다고 가정합니다.
    $.ajax({
        url: contextPath + "/mypage/qnaWrite.htm",
        type: "POST",
        data: $("#qnaWriteForm").serialize(), // 폼 안의 모든 데이터를 자동으로 묶어줌
        success: function(res) {
            alert("문의가 정상적으로 접수되었습니다.");
            closeQnaModal(); // 모달 닫기
            location.reload(); // 리스트 새로고침
        },
        error: function(xhr) {
            alert("처리 중 오류가 발생했습니다. (에러코드: " + xhr.status + ")");
            $("#writeButton").show();
            $("#writeButton2").hide();
        }
    });
}
</script>