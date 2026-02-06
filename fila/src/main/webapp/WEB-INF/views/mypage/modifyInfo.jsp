<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<section class="my-con">
<h2 class="tit__style4">내 정보 변경</h2>

<a href="javascript:void(0);"
   class="btn_sld__bk btn_rt pw-change__btn"
   onclick="openPwLayer();">
비밀번호 변경
</a>

<form name="myform" method="post"
      action="${pageContext.request.contextPath}/mypage/modifyInfo.htm"
      target="dataFrame"
      class="join_form  modify_form">

<input type="hidden" name="MemberTel" value="01038140096">
<input type="hidden" name="joinMode" id="joinMode" value="">
<input type="hidden" name="birthY" id="birthY" value="2000">
<input type="hidden" name="birthM" id="birthM" value="05">
<input type="hidden" name="birthD" id="birthD" value="25">
<input type="hidden" name="MemberGender" id="MemberGender" value="M">
<input type="hidden" name="srlrSeCd" id="srlrSeCd" value="S">

<div class="modify-detail-box">

<!-- ================= 필수정보 ================= -->
<div>
<p class="tit__style2">필수정보</p>

<div class="mdfy_info-box">
<div class="inp-box">
<input type="text" value="${auth.id}" disabled="">
<input type="text" value="${auth.name}" disabled="">
</div>

<div class="inp-box">
<div class="btn_number_2504">
<input type="text" value="${auth.phone}" disabled="">
<a href="javascript:void(0);" class="btn_number_edit_2504">변경</a>
</div>

<input type="text" value="${auth.email}" name="userEmail" placeholder="이메일주소">
<p class="err-msg" id="emailCheckText">이메일 주소를 입력해주세요.</p>
</div>
</div>
</div>

<!-- ================= 추가정보 ================= -->
<div>
<p class="tit__style2">추가정보</p>

<div class="mdfy_info-box">
<div>
<div class="chk">
<input type="hidden" name="birthCert" id="birthCert" value="Y">
<input type="hidden" class="_val" name="birthdaySex" id="birthdaySex" value="1">
</div>

<div class="inp-box birthdaySex">
<input type="text" id="chkBirth" value="${auth.birthday}" disabled="">
<input type="text" class="mGender"
       value="${auth.gender == 'M' ? '남자' : '여자'}" disabled="">
</div>

<p class="txt__style1">
생년월일/성별 정보 제공에 동의해주시면<br>
기념일 쿠폰 등 캠페인 쿠폰이 제공됩니다.
</p>
</div>

<div>
<div class="chk">
<input type="checkbox" name="agree4" id="agree4" value="Y"
       onclick="receptionAll();"
       ${mktMap['6'] == 1 && mktMap['7'] == 1 ? 'checked' : ''}>
<label for="agree4">마케팅 정보 수신에 동의합니다.</label>
</div>

<div class="sms-email-chk">
<div>
<input type="checkbox" name="MemberIsSMS" id="MemberIsSMS" value="Y"
       onclick="reception();" class="cb__style1"
       ${mktMap['6'] == 1 ? 'checked' : ''}>
<label for="MemberIsSMS">SMS 수신동의</label>
</div>

<div>
<input type="checkbox" name="MemberIsMaillinglist"
       id="MemberIsMaillinglist" value="Y"
       onclick="reception();" class="cb__style1"
       ${mktMap['7'] == 1 ? 'checked' : ''}>
<label for="MemberIsMaillinglist">E-MAIL 수신동의</label>
</div>
</div>
</div>
</div>
</div>

<!-- ================= 자녀정보 ================= -->
<div>
<p class="tit__style2">자녀정보</p>

<div class="inp-box" id="Children">
<c:choose>
<c:when test="${not empty childList}">
<c:forEach var="child" items="${childList}" varStatus="status">

<div class="child-group">
<div class="name">
<input type="hidden" name="custChSqor" value="">
<input type="text" name="ChildName"
       value="${child.childName}" maxlength="20" placeholder="자녀명">
</div>

<div class="info">
<div>
<input type="text" name="birthch"
       value="${child.childBirth}"
       placeholder="생년월일 8자리" maxlength="8">
</div>

<div>
<select class="sel__style1" name="MemberGender1">
<option value="">성별</option>
<option value="M" ${child.childGender eq 'M' ? 'selected' : ''}>남성</option>
<option value="F" ${child.childGender eq 'F' ? 'selected' : ''}>여성</option>
</select>
</div>
</div>

<cc>
<c:if test="${status.first}">
<button type="button" class="child-add__btn btn_sld__gr plus"
        onclick="fn_append('Children');">자녀 추가</button>
<button type="button" class="child-add__btn btn_sld__gr reset"
        onclick="fn_reset('Children');">초기화</button>
</c:if>

<c:if test="${!status.first}">
<button type="button" class="child-add__btn btn_sld__gr minus"
        onclick="fn_remove(this);">삭제</button>
</c:if>
</cc>
</div>

</c:forEach>
</c:when>

<c:otherwise>
<div class="child-group">
<div class="name">
<input type="hidden" name="custChSqor" value="">
<input type="text" name="ChildName" maxlength="20" placeholder="자녀명">
</div>

<div class="info">
<div>
<input type="text" name="birthch" placeholder="생년월일 8자리" maxlength="8">
</div>
<div>
<select class="sel__style1" name="MemberGender1">
<option value="">성별</option>
<option value="M">남성</option>
<option value="F">여성</option>
</select>
</div>
</div>

<cc>
<button type="button" class="child-add__btn btn_sld__gr plus"
        onclick="fn_append('Children');">자녀 추가</button>
<button type="button" class="child-add__btn btn_sld__gr reset"
        onclick="fn_reset('Children');">초기화</button>
</cc>
</div>
</c:otherwise>
</c:choose>
</div>
</div>

<div class="btn__flex my-btn-box modify-btn-box">
<a href="javascript:;" class="btn_quit retire-change__btn">회원탈퇴</a>
<button type="button" class="btn_sld__gr"
        onclick="location.href='/mypage/mypage.asp'">취소</button>
<button type="button" class="btn_bg__bk"
        onclick="javascript:updateform_simple2();">수정완료</button>
</div>

</form>
</section>

<!-- ================= 비밀번호 변경 모달 ================= -->
<div class="common__layer sch-idpw" id="pwLayer" style="display:none;">
<div class="layer-bg__wrap"></div>

<div class="inner">
<div class="head">
<p class="tit">비밀번호 재설정</p>
<button type="button" class="close__btn" onclick="closePwLayer()">close</button>
</div>

<div class="con">
<div class="password-box">
<input type="password" class="inp__pw" id="newPw"
       placeholder="새 비밀번호 (8자 이상)">
</div>

<div class="password-box">
<input type="password" class="inp__pw" id="newPw2"
       placeholder="비밀번호 확인">
</div>
</div>

<div class="foot">
<button type="button" class="btn_can" onclick="closePwLayer()">취소</button>
<button type="button" class="on" id="btnPwSubmit">변경</button>
</div>
</div>
</div>

<script>
function openPwLayer(){
  $('#pwLayer').fadeIn(150);
}

function closePwLayer(){
  $('#pwLayer').hide();
}

$('#btnPwSubmit').on('click', function(){

  var pw1 = $('#newPw').val();
  var pw2 = $('#newPw2').val();

  if(!pw1 || pw1.length < 8){
    alert('비밀번호는 8자 이상 입력하세요.');
    return;
  }

  if(pw1 !== pw2){
    alert('비밀번호가 일치하지 않습니다.');
    return;
  }

  $.ajax({
    // 🔥 여기만 변경됨
    url: '<%=request.getContextPath()%>/mypage/member/password-change.htm',
    type: 'post',
    dataType: 'text',
    data: { newPw: pw1 },
    success: function(res){
      if($.trim(res) === 'OK'){
        alert('비밀번호가 변경되었습니다.');
        closePwLayer();
      } else {
        alert('비밀번호 변경 실패');
      }
    },
    error: function(){
      alert('비밀번호 변경 서버 오류');
    }
  });
});
</script>
