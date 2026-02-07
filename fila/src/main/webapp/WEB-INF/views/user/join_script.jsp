<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
$(function() {

  /* [FIX] 헤더 오버레이가 클릭 막는 케이스 방어 */
  $('body').removeClass('search--open today-goods--open');
  $('.search-bg__wrap, .gnb-bg__wrap').css({ visibility:'hidden', opacity:0, pointerEvents:'none' });

  /* 숫자만 입력 */
  $('#birthDay, #phone2, [name="childBirth"]').on('input', function(){
    this.value = this.value.replace(/[^0-9]/g,'');
  });

  /* 카카오(틀만) */
  $('.join_kakao').on('click', function(e){
    e.preventDefault();
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

  /* [FIX] 본인인증완료: join_cert = yes 세팅 + 성별 미선택 경고 */
  $('#certBtn').on('click', function(e){
    e.preventDefault();

    var ok = true;
    $('#nameErr,#birthErr,#phoneErr,#certErr').hide();

    if(!$('#memberName').val().trim()){ $('#nameErr').show(); ok=false; }
    if($('#birthDay').val().length !== 8 || !$('#MemberGender').val()){
      $('#birthErr').show(); ok=false;   // 성별 안 눌렀을 때도 여기 뜸
    }
    if(!$('#phone2').val().trim()){ $('#phoneErr').show(); ok=false; }

    if($('.certItem:checked').length !== 4){
      $('#certErr').show(); ok=false;
    }

    if(!ok) return;

    /* [FIX] 핵심: submit에서 본인인증 경고 안 뜨게 */
    $('#join_cert').val('yes');

    /* [FIX] MemberVO phone 미리 세팅(휴대폰번호 덜 적는 문제 방지: 010 + 뒤8자리) */
    $('#phone').val( ($('#phone1').val() || '') + ($('#phone2').val() || '') );

    /* 보기용 잠금(원하시면 이 줄 통째로 지우셔도 됨) */
    $('#memberName,#birthDay,#phone1,#phone2,#NationalInfo,#MemberGender').prop('disabled', true);
  });

  /* 비밀번호 보기 토글 */
  $('#pwToggle').on('click', function(){
    var $pw = $('#memberPassword');
    var isPw = $pw.attr('type') === 'password';
    $pw.attr('type', isPw ? 'text' : 'password');
    $(this).toggleClass('off', !isPw);
  });

  /* [FIX] 아이디 입력 변경 시 중복확인 다시 필요 */
  $('#memberId').on('input', function(){
    $('#id_check').val('no');
  });

  /* [FIX] 아이디 중복확인: JoinController.java 기준 GET /member/id-check.htm (param: id) */
  $('#idCheckBtn').on('click', function(){
    $('#idErr').hide();
    var id = $('#memberId').val().trim();

    if(!id){
      $('#idErr').show();
      return;
    }

    $.ajax({
      url: '<%=request.getContextPath()%>/member/id-check.htm',
      type: 'GET',
      data: { id: id },
      cache: false,
      success: function(res){
        res = (res || '').toString().trim();
        if(res === 'OK'){
          alert('사용 가능한 아이디입니다.');
          $('#id_check').val('yes');
        }else if(res === 'DUPLICATE'){
          alert('이미 사용 중인 아이디입니다.');
          $('#id_check').val('no');
        }else if(res === 'EMPTY'){
          alert('아이디를 입력해주세요.');
          $('#id_check').val('no');
        }else{
          alert('중복확인 응답이 올바르지 않습니다.');
          $('#id_check').val('no');
        }
      },
      error: function(){
        alert('중복확인 실패');
        $('#id_check').val('no');
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

  /* [FIX] 자녀정보 토글 제거: 버튼 클릭해도 아무것도 안 함 */
  $('#childToggleBtn').on('click', function(e){
    e.preventDefault();
  });

  /* 최종 제출 */
  $('#joinForm').on('submit', function(e){

    /* [FIX] disabled로 잠근 필드 제출 전에 복구(값이 서버로 안 가는 문제 방지) */
    $('#memberName,#birthDay,#phone1,#phone2,#NationalInfo,#MemberGender').prop('disabled', false);

    $('#idErr,#pwErr,#emailErr,#agreeErr').hide();

    /* [FIX] 본인인증 체크(이게 동작해야 함) */
    if($('#join_cert').val() !== 'yes'){
      alert('본인인증을 먼저 완료해주세요.');
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

    if($('.requiredAgree:checked').length !== 2){
      $('#agreeErr').show();
      e.preventDefault();
      return;
    }

    /* [FIX] phone + marketingAgree 최종 세팅(MemberVO) */
    $('#phone').val( ($('#phone1').val() || '') + ($('#phone2').val() || '') );
    $('#marketingAgree').val( $('#agree4').is(':checked') ? 1 : 0 );
  });

});
</script>