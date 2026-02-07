<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
$(document).ready(function() {
    // 비밀번호 변경 버튼 클릭 시
    $('.pw-change__btn').on('click', function(e) {
        e.preventDefault();
        
        // 1. modifyPwd.jsp의 내용을 AJAX로 가져옴
        $.ajax({
            url: "${pageContext.request.contextPath}/view/mypage/modifyPwd.jsp", // 실제 파일 경로 확인
            type: "GET",
            success: function(data) {
                // 2. 모달 컨텐츠 영역에 HTML 주입
                $('#PwdModifyModalContent').html(data);
                // 3. 모달 레이어 표시
                $('#PwdModifyModalOverlay').fadeIn(200);
            },
            error: function() {
                alert("비밀번호 변경 창을 불러오는데 실패했습니다.");
            }
        });
    });

    // 모달 닫기 (취소 버튼 또는 X 버튼 클릭 시)
    $(document).on('click', '.close__btn, .btn_can', function() {
        $('#PwdModifyModalOverlay').fadeOut(200);
        $('#PwdModifyModalContent').empty(); // 내용 비우기
    });
});
function fn_append(id) {
    const html = `
        <div class="child-group" style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
            <div class="name" style="display:flex; gap:10px;">
                <input type="text" name="ChildName" placeholder="자녀명" style="flex:1;">
                <button type="button" class="btn_sld__gr" onclick="$(this).closest('.child-group').remove()" style="background:#666;">삭제</button>
            </div>
            <div class="info" style="display:flex; gap:10px; margin-top:5px;">
                <input type="text" name="birthch" placeholder="생년월일 8자리" maxlength="8" style="flex:1;">
                <select class="sel__style1" name="MemberGender1" style="flex:1;">
                    <option value="">성별</option>
                    <option value="M">남성</option>
                    <option value="F">여성</option>
                </select>
            </div>
        </div>`;
    $('#' + id).append(html);
}

function updateform_simple2() {
    if(confirm("수정하시겠습니까?")) {
        document.myform.submit();
    }
}
$(document).ready(function() {
    // 페이지 로드 시 개별 체크박스 상태에 따라 전체 동의 체크박스 업데이트
    reception(); 
});

function reception() {
    // SMS와 EMAIL이 모두 체크되어 있으면 전체동의 체크, 아니면 해제
    if($("#MemberIsSMS").is(":checked") && $("#MemberIsMaillinglist").is(":checked")) {
        $("#agree4").prop("checked", true);
    } else {
        $("#agree4").prop("checked", false);
    }
}
//1. 자녀 추가 (삭제 버튼이 포함된 새 그룹 추가)
function fn_append(id) {
    const html = `
        <div class="child-group">
            <div class="name">
                <input type="hidden" name="custChSqor" value="">
                <input type="text" name="ChildName" maxlength="20" placeholder="자녀명">
            </div>
            <div class="info">
                <div><input type="text" name="birthch" placeholder="생년월일 8자리" maxlength="8"></div>
                <div>
                    <select class="sel__style1" name="MemberGender1">
                        <option value="">성별</option>
                        <option value="M">남성</option>
                        <option value="F">여성</option>
                    </select>
                </div>
            </div>
            <cc><button type="button" class="child-add__btn btn_sld__gr minus" onclick="fn_remove(this);">삭제</button></cc>
        </div>`;
    $('#' + id).append(html);
}

// 2. 개별 삭제
function fn_remove(obj) {
    $(obj).closest('.child-group').remove();
}

// 3. 전체 초기화 (첫 번째 그룹만 남기고 내용 비우기)
function fn_reset(id) {
    if(confirm("입력하신 자녀 정보를 모두 초기화하시겠습니까?")) {
        const $container = $('#' + id);
        // 첫 번째 그룹 외에 모두 삭제
        $container.find('.child-group:not(:first)').remove();
        // 첫 번째 그룹의 입력값 비우기
        const $first = $container.find('.child-group:first');
        $first.find('input[type="text"]').val('');
        $first.find('select').val('');
    }
}
//회원탈퇴 버튼 클릭 시
$('.retire-change__btn').on('click', function(e) {
    e.preventDefault();
    
    if (confirm("정말로 탈퇴하시겠습니까?\n탈퇴 시 동일 아이디로 재가입이 불가능할 수 있으며, 모든 혜택이 소멸됩니다.")) {
        // 탈퇴 핸들러로 이동
        location.href = "${pageContext.request.contextPath}/mypage/retireMember.htm";
    }
});
</script>