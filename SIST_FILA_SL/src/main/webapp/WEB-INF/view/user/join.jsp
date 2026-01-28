<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<!-- ✅ 프로젝트 공통 CSS (너가 말한 경로 기준) -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/layout.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/sub.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/opt-default.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/product.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/normalize.css">

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>


</head>

<body>

<!-- HEADER -->
<jsp:include page="../common/header.jsp" />

<div id="contents" class="mbr__contents">
  <h2 class="tit__style1">회원가입</h2>

  <section class="mbr-box certWrap">

<div class="join-sec">
    <p class="txt">
        카카오 간편 회원가입으로 보다 간편하게 회원가입이 가능합니다.
    </p>

    <div class="btn-box">
        <a href="javascript:void(0);" class="join_kakao">
            <span class="ico"></span>
            <span class="txt">카카오 1초 간편가입</span>
        </a>
    </div>
</div>

    <!-- 실제 가입 폼 -->
<form id="joinForm"method="post"action="<%=request.getContextPath()%>/member/join_submit.htm">

      <!-- 상태값 -->
      <input type="hidden" name="join_cert" id="join_cert" value="no">
      <input type="hidden" name="id_check" id="id_check" value="no">

      <!-- ================= 본인인증 ================= -->
      <div class="join-sec">
        <div class="title-box">
          <h3 class="tit__style2">본인인증</h3>
        </div>

        <div class="inp-box _bf">
          <!-- 이름 -->
          <div class="name">
            <input type="text" name="memberName" id="memberName" placeholder="이름" maxlength="50">
            <select name="NationalInfo" id="NationalInfo" class="sel__style1 wid__style1">
              <option value="0">내국인</option>
              <option value="1">외국인</option>
            </select>
          </div>
          <p class="err-msg" id="nameErr" style="display:none;">이름을 입력해주세요.</p>

          <!-- 생년월일/성별 -->
          <div class="birthday">
            <input type="text" name="birthDay" id="birthDay" placeholder="생년월일 8자리 Ex.20260110" maxlength="8">
            <select name="MemberGender" id="MemberGender" class="sel__style1 wid__style1">
              <option value="">성별</option>
              <option value="M">남자</option>
              <option value="F">여자</option>
            </select>
          </div>
          <p class="err-msg" id="birthErr" style="display:none;">생년월일/성별을 선택해주세요.</p>

          <!-- 통신사/번호 -->
          <div class="phone">
           
            <select id="phone1" name="phone1" class="sel__style1 wid__style3">
              <option value="010">010</option>
              <option value="011">011</option>
              <option value="017">017</option>
              <option value="018">018</option>
              <option value="019">019</option>
            </select>
            <input type="text" maxlength="8" class="inp__phone" id="phone2" name="phone2" placeholder="휴대폰 번호">
          </div>
          <p class="err-msg" id="phoneErr" style="display:none;">휴대폰 번호를 입력해주세요.</p>
        </div>

        <!-- 본인인증 약관 -->
        <div class="self-verification">
          <div class="all-agree-box hbox">
            <input type="checkbox" class="cb__style1" id="Certall1">
            <label for="Certall1">본인 인증을 위한 약관 모두 동의</label>
            <a href="javascript:;" class="arr-down-btn on" id="certToggle"></a>
          </div>

          <div class="agree-chk-box self-agree-wrap cbox open" id="certAgreeBox">
            <ul>
              <li><input type="checkbox" class="cb__style1 certItem" id="Certagree1"><label for="Certagree1">개인정보이용 동의</label></li>
              <li><input type="checkbox" class="cb__style1 certItem" id="Certagree2"><label for="Certagree2">고유식별정보처리 동의</label></li>
              <li><input type="checkbox" class="cb__style1 certItem" id="Certagree3"><label for="Certagree3">서비스 이용약관 동의</label></li>
              <li><input type="checkbox" class="cb__style1 certItem" id="Certagree4"><label for="Certagree4">통신사 이용약관 동의</label></li>
            </ul>
          </div>

          <div class="btn-box">
            <a href="javascript:;" class="btn_sld__bk" id="certBtn">본인인증완료</a>
          </div>

          <p class="err-msg" id="certErr" style="display:none;">본인인증 약관에 모두 동의해주세요.</p>
        </div>
      </div>

      <!-- ================= 필수정보 ================= -->
      <div class="title-box certView">
        <h3 class="tit__style2">필수정보</h3>
      </div>

      <div class="inp-box m0 certView">
        <div class="inp_id">
          <input type="text" name="memberId" id="memberId" placeholder="아이디 (대소문자를 반드시 확인해주세요)" maxlength="16">
          <button type="button" class="btn__chk_id btn_sld__bk" id="idCheckBtn">중복확인</button>
        </div>
        <p class="err-msg" id="idErr" style="display:none;">아이디를 입력해주세요.</p>

        <div>
          <input type="password" class="inp__pw" name="memberPassword" id="memberPassword" placeholder="8-16자:영문,숫자,특수문자 조합" maxlength="16">
          <button type="button" class="pwonoff__btn off" id="pwToggle">on/off</button>
        </div>
        <p class="err-msg" id="pwErr" style="display:none;">비밀번호를 입력해주세요.</p>

        <div class="inp_eml">
          <!-- ✅ type=email: @ 입력 막히는 문제 방어 -->
          <input type="email" name="email" id="email" placeholder="이메일 주소">
        </div>
        <p class="err-msg" id="emailErr" style="display:none;">이메일 주소를 입력해주세요.</p>
      </div>

      <!-- ================= 자녀정보 ================= -->
      <div class="join-sec certView">
        <div class="title-box">
          <h3 class="tit__style2">자녀정보</h3>
          <button type="button" class="btn_sel" id="childToggleBtn">
            추가시 생일 쿠폰 증정<span class="pm"></span>
          </button>
        </div>

        <div class="children-box" id="childBox" style="display:none;">
          <div class="inp-box">
            <input type="text" name="childName" placeholder="자녀명">
            <div class="birthday">
              <input type="text" name="childBirth" placeholder="생년월일 8자리" maxlength="8">
              <select name="childGender" class="sel__style1 wid__style1">
                <option value="">성별</option>
                <option value="M">남성</option>
                <option value="F">여성</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <!-- ================= 이용약관 ================= -->
      <div class="join-sec certView">
        <div class="title-box">
          <h3 class="tit__style2">이용약관 및 마케팅 정보 수신 동의</h3>
        </div>

        <div class="all-agree-box">
          <input type="checkbox" class="cb__style1" id="all1">
          <label for="all1">약관 전체 동의합니다.</label>
          <a href="javascript:;" class="arr-down-btn" id="agreeToggle"></a>
        </div>

        <div class="agree-chk-wrap" id="agreeWrap" style="display:none;">
          <ul class="agree-chk-box">
            <li><input type="checkbox" class="cb__style1 agreeItem requiredAgree" id="agree1"><label for="agree1">이용약관 <span class="red">(필수)</span></label></li>
            <li><input type="checkbox" class="cb__style1 agreeItem requiredAgree" id="agree2"><label for="agree2">개인정보 수집 및 이용 동의 <span class="red">(필수)</span></label></li>
            <li><input type="checkbox" class="cb__style1 agreeItem" id="agree4"><label for="agree4">혜택 알림 수신 동의 <span>(선택)</span></label></li>
          </ul>
        </div>

        <p class="err-msg" id="agreeErr" style="display:none;">필수 약관(2개)에 동의해주세요.</p>
      </div>

      <!-- ================= 가입 버튼 ================= -->
      <div class="join-wt certView">
        <div class="title-box">
          <span class="txt__style1">
            * 필수항목에 동의하지 않으실 경우 회원가입이 불가합니다.<br>
            * 선택항목은 동의하지 않으셔도 서비스 이용이 가능합니다.
          </span>
        </div>
      </div>

      <div class="btn-box certView" id="loginButton">
        <button type="submit" class="btn_bg__bk" id="submitBtn">동의하고 가입하기</button>
      </div>

    </form>
  </section>
</div>

<!-- FOOTER -->
<jsp:include page="../common/footer.jsp" />

<script>
$(function() {

  /* ✅ 헤더에서 search--open 같은 클래스가 남아있으면 전체 클릭 막힘 → join 페이지에서 강제 제거 */
  $('body').removeClass('search--open today-goods--open');
  $('.search-bg__wrap, .gnb-bg__wrap').css({ visibility:'hidden', opacity:0, pointerEvents:'none' });

  /* 숫자만 입력(생년월일/폰) */
  $('#birthDay, #phone2').on('input', function(){
    this.value = this.value.replace(/[^0-9]/g,'');
  });

  /* 본인인증 약관 토글 */
  $('#certToggle').on('click', function(e){
    e.preventDefault();
    $(this).toggleClass('on');
    $('#certAgreeBox').toggleClass('open').stop(true,true).slideToggle(200);
  });

  /* 본인인증 전체동의 */
  $('#Certall1').on('change', function(){
    $('.certItem').prop('checked', this.checked);
  });
  $('.certItem').on('change', function(){
    $('#Certall1').prop('checked', $('.certItem:checked').length === $('.certItem').length);
  });

  /* 본인인증완료 */
  $('#certBtn').on('click', function(e){
    e.preventDefault();

    // 입력값 체크
    var ok = true;
    $('#nameErr,#birthErr,#phoneErr,#certErr').hide();

    if(!$('#memberName').val().trim()){ $('#nameErr').show(); ok=false; }
    if($('#birthDay').val().length !== 8 || !$('#MemberGender').val()){ $('#birthErr').show(); ok=false; }
    if(!$('#phone2').val().trim()){ $('#phoneErr').show(); ok=false; }

    if($('.certItem:checked').length !== 4){
      $('#certErr').show(); ok=false;
    }

    if(!ok) return;

    // ✅ 인증 완료 처리
    $('#join_cert').val('yes');

    // 입력 잠금(“완료된 느낌”)
    $('#memberName,#birthDay,#phone2,#NationalInfo,#MemberGender,#cellphone,#phone1').prop('disabled', true);

    // 아래 영역 오픈
    $('.certView').stop(true,true).slideDown(250);

    // 스크롤 이동
    $('html, body').animate({
      scrollTop: $('.certView').first().offset().top - 40
    }, 250);
  });

  /* 비밀번호 보기 토글 */
  $('#pwToggle').on('click', function(){
    var $pw = $('#memberPassword');
    var isPw = $pw.attr('type') === 'password';
    $pw.attr('type', isPw ? 'text' : 'password');
    $(this).toggleClass('off', !isPw);
  });

  /* 아이디 중복확인(지금은 더미: 값 있으면 통과 처리) */
$('#idCheckBtn').on('click', function(){

  $('#idErr').hide();
  var memberId = $('#memberId').val().trim();

  if(!memberId){
    $('#idErr').show();
    return;
  }

  $.ajax({
	  url: '<%=request.getContextPath()%>/member/idCheck.htm',
	  type: 'post',
	  data: { id: memberId },   // 🔥 여기!
	  success: function(res){
	    if(res === 'OK'){
	      alert('사용 가능한 아이디입니다.');
	      $('#id_check').val('yes');
	    } else if(res === 'DUPLICATE'){
	      alert('이미 사용 중인 아이디입니다.');
	      $('#id_check').val('no');
	    } else {
	      alert('아이디를 입력해주세요.');
	    }
	  }
	});

});


  /* 이용약관 토글 */
  $('#agreeToggle').on('click', function(e){
    e.preventDefault();
    $(this).toggleClass('on');
    $('#agreeWrap').stop(true,true).slideToggle(200);
  });

  /* 이용약관 전체동의 */
  $('#all1').on('change', function(){
    $('.agreeItem').prop('checked', this.checked);
  });
  $('.agreeItem').on('change', function(){
    $('#all1').prop('checked', $('.agreeItem:checked').length === $('.agreeItem').length);
  });

  /* 자녀정보 토글 */
  $('#childToggleBtn').on('click', function(){
    $('#childBox').stop(true,true).slideToggle(200);
    $(this).toggleClass('on');
  });

  /* 최종 제출 */
 /* 최종 제출 */
$('#joinForm').on('submit', function(e){

  // 🔥 disabled 된 필드들 제출 직전에 반드시 복구
  $('#memberName, #birthDay, #phone2, #NationalInfo, #MemberGender, #phone1')
    .prop('disabled', false);

  $('#idErr,#pwErr,#emailErr,#agreeErr').hide();

  // 본인인증 확인
  if($('#join_cert').val() !== 'yes'){
    alert('본인인증을 먼저 완료해주세요.');
    e.preventDefault();
    return;
  }

  // 아이디/비번/이메일
  if(!$('#memberId').val().trim()){
    $('#idErr').show();
    e.preventDefault();
    return;
  }

  if($('#id_check').val() !== 'yes'){
    alert('아이디 중복확인을 먼저 해주세요.');
    e.preventDefault();
    return;
  }

  if(!$('#memberPassword').val().trim()){
    $('#pwErr').show();
    e.preventDefault();
    return;
  }

  if(!$('#email').val().trim()){
    $('#emailErr').show();
    e.preventDefault();
    return;
  }

  // 필수 약관
  if($('.requiredAgree:checked').length !== 2){
    $('#agreeErr').show();
    e.preventDefault();
    return;
  }

  // ✅ 여기까지 오면 submit 정상 진행됨
});



});

</script>

</body>
</html>
