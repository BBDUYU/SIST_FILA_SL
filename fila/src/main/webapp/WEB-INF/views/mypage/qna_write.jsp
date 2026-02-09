<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="common__layer sch-idpw _qna_write">
<div class="inner">

    <!-- header -->
    <div class="head">
        <p class="tit">문의하기</p>
        <button type="button" class="close__btn">close</button>
    </div>
 <form id="qnaWriteForm" onsubmit="return false;">
    <!-- content -->
    <div class="con">

        <!-- 상단 영역 -->
        <div>
            <!-- 문의유형 -->
            <div class="qna-category-box">
                <div>
                   <select class="sel__style1" name="categoryId" id="categoryId">
    <option value="">문의유형 선택</option>
    <c:forEach var="cat" items="${categoryList}">
        <option value="${cat.categoryId}">
            ${cat.categoryName}
        </option>
    </c:forEach>
</select>

                </div>
            </div>

         
        </div>

        <!-- 하단 영역 -->
        <div>
            <div>
                <!-- 제목 / 내용 -->
                <div class="qna-write-box">
                    <input type="text"
                           name="title"
                           id="boardTitle"
                           placeholder="제목을 입력해주세요.">

                    <textarea name="content"
                              id="boardContents"
                              placeholder="문의 내용을 입력해주세요.
휴대폰 번호, 주민등록번호와 같은 개인정보의
입력은 삼가해 주시기 바랍니다."></textarea>
                </div>

                
            </div>

            <div>
                

                <!-- 개인정보 동의 -->
                <div class="my-privacy-box">
                    <p class="tit">개인정보 수집 동의</p>

                    <p class="txt">
                        1. 개인정보 수집 및 이용목적 : 이용자의 민원처리 답변사항 전달
                    </p>
                    <p class="txt">
                        2. 개인정보 수집 항목 : 이메일
                    </p>
                    <p class="txt">
                        <strong>
                            3. 개인정보 보유 이용 기간 :
                            전자상거래 등에서의 소비자 보호에 관한 법률 등에서
                            정한 보존기간 동안 고객님의 개인 정보를 보유합니다.<br>
                            소비자의 불만 또는 분쟁처리에 관한 기록 : 3년
                        </strong>
                    </p>

                    <p class="txt2">
                        개인정보 수집 및 이용에 대한 동의를 거부할 수 있으나,
                        동의를 거부하실 경우 1:1 문의에 대한 이메일 답변이
                        불가할 수 있습니다.
                    </p>

                    <div class="chk-box">
                        <div class="chk">
                            <input type="radio" id="privacy1"
                                   name="privacyAgree" value="1">
                            <label for="privacy1">동의합니다</label>
                        </div>

                        <div class="chk">
                            <input type="radio" id="privacy2"
                                   name="privacyAgree" value="0">
                            <label for="privacy2">동의하지 않습니다</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
      </form>

    <!-- footer -->
   <div class="foot" id="writeButton">
			<button type="button" onclick="location.href='/mypage/qna.asp'">취소</button>
			<button type="button" class="on" onclick="javascript:fn_send();void(0);">문의하기</button>
		</div>

    <div class="foot" id="writeButton2" style="display:none;">
        <img src="${pageContext.request.contextPath}/images/waiting.gif">
    </div>

</div>
</div>
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