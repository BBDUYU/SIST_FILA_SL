<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="common__layer sch-idpw _qna_write" id="qnaWriteLayer">
    <div class="inner">
        <div class="head" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid #eee;">
            <p class="tit" style="font-size: 20px; font-weight: bold;">1:1 문의하기</p>
            <button type="button" class="close__btn" onclick="closeQnaModal()" style="font-size: 24px; background: none; border: none; cursor: pointer;">&times;</button>
        </div>

        <form id="qnaWriteForm" onsubmit="return false;" style="padding: 20px;">
            <div class="con">
                <div class="qna-category-box" style="margin-bottom: 15px;">
                    <select class="sel__style1" name="categoryId" id="categoryId" style="width: 100%; padding: 10px; border: 1px solid #ddd;">
                        <option value="">문의유형 선택</option>
                        <%-- ✅ 컨트롤러 변수명 categoryList와 일치시킴 --%>
                        <c:forEach var="cat" items="${categoryList}">
                            <option value="${cat.categoryId}">${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="qna-write-box">
                    <input type="text" name="title" id="boardTitle" placeholder="제목을 입력해주세요." 
                           style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd;">
                    
                    <textarea name="content" id="boardContents" placeholder="문의 내용을 입력해주세요." 
                              style="width: 100%; height: 150px; padding: 10px; border: 1px solid #ddd; resize: none;"></textarea>
                </div>

                <div class="my-privacy-box" style="margin-top: 20px; padding: 15px; background: #f8f8f8; font-size: 12px; line-height: 1.6;">
                    <p class="tit" style="font-weight: bold; margin-bottom: 5px;">개인정보 수집 동의</p>
                    <p class="txt">1. 수집 목적 : 민원처리 답변사항 전달</p>
                    <p class="txt">2. 수집 항목 : 이메일, 성명</p>
                    <div class="chk-box" style="margin-top: 10px; display: flex; gap: 20px;">
                        <label><input type="radio" name="privacyAgree" value="1" checked> 동의합니다</label>
                        <label><input type="radio" name="privacyAgree" value="0"> 동의하지 않습니다</label>
                    </div>
                </div>
            </div>

            <div class="foot" id="writeButton" style="margin-top: 20px; display: flex; gap: 10px;">
                <button type="button" onclick="closeQnaModal()" style="flex: 1; padding: 15px; background: #eee; border: none; cursor: pointer;">취소</button>
                <button type="button" class="on" onclick="fn_send()" style="flex: 1; padding: 15px; background: #000; color: #fff; border: none; cursor: pointer;">문의하기</button>
            </div>

            <div class="foot" id="writeButton2" style="display:none; text-align: center; margin-top: 20px;">
                <p>전송 중입니다...</p>
            </div>
        </form>
    </div>
</div>

<script>
function fn_send() {
    // 유효성 검사
    if ($("#categoryId").val() === "") {
        alert("문의유형을 선택해주세요.");
        return;
    }
    if ($("#boardTitle").val().trim() === "") {
        alert("제목을 입력해주세요.");
        return;
    }
    if ($("#boardContents").val().trim() === "") {
        alert("내용을 입력해주세요.");
        return;
    }
    if ($('input[name="privacyAgree"]:checked').val() === "0") {
        alert("개인정보 수집에 동의하셔야 접수가 가능합니다.");
        return;
    }

    $("#writeButton").hide();
    $("#writeButton2").show();

    // AJAX 전송
    $.ajax({
        url: "${pageContext.request.contextPath}/mypage/write.htm",
        type: "POST",
        data: $("#qnaWriteForm").serialize(),
        success: function (res) {
            alert("문의가 정상적으로 접수되었습니다.");
            location.reload(); // 리스트 새로고침
        },
        error: function (xhr) {
            alert("오류가 발생했습니다. 다시 시도해주세요.");
            $("#writeButton").show();
            $("#writeButton2").hide();
        }
    });
}
</script>