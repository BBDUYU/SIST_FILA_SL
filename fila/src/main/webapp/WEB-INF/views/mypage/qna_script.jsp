<%@ page contentType="text/html; charset=UTF-8" %>
<script>
var contextPath = '${pageContext.request.contextPath}';

$(document).ready(function () {

    // 1:1 문의 모달 열기
    $(document).on('click', '.qna-write__btn', function (e) {
        e.preventDefault();

        $.ajax({
            url: contextPath + '/mypage/qnaWriteForm.htm',
            type: 'GET',
            success: function (res) {
                $('#qnaModalContent').html(res);

                // flex로 중앙정렬 되게 표시
                $('#qnaModalOverlay').css('display', 'block');

                // 스크롤 잠금
                $('body').css('overflow', 'hidden');
            },
            error: function () {
                alert('모달 폼을 불러오는 중 오류가 발생했습니다.');
            }
        });
    });

});

// 닫기
function closeQnaModal() {
    $('#qnaModalOverlay').hide();
    $('#qnaModalContent').empty();
    $('body').css('overflow', 'auto');
}

// 등록
function fn_send() {
    if (!$('#categoryId').val()) {
        alert('유형을 선택해주세요.');
        return;
    }
    if (!$('#boardTitle').val() || !$('#boardTitle').val().trim()) {
        alert('제목을 입력해주세요.');
        return;
    }
    if (!$('#boardContents').val() || !$('#boardContents').val().trim()) {
        alert('내용을 입력해주세요.');
        return;
    }
    if ($('input[name="privacyAgree"]:checked').val() === '0') {
        alert('개인정보 동의가 필요합니다.');
        return;
    }

    $.ajax({
        url: contextPath + '/mypage/write.htm',
        type: 'POST',
        data: $('#qnaWriteForm').serialize(),
        success: function (res) {
            // 컨트롤러가 "OK" 반환
            alert('정상적으로 등록되었습니다.');
            closeQnaModal();
            location.reload();
        },
        error: function () {
            alert('등록 중 오류가 발생했습니다.');
        }
    });
}
</script>
