<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	  url: '<%=request.getContextPath()%>/member/id-check.do',
	  type: 'get',
	  data: { id: memberId },
	  success: function(res){

	    // res === true  → 이미 존재 (중복)
	    // res === false → 사용 가능
	    if(res === true){
	      alert('이미 사용 중인 아이디입니다.');
	      $('#id_check').val('no');
	    } else {
	      alert('사용 가능한 아이디입니다.');
	      $('#id_check').val('yes');
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