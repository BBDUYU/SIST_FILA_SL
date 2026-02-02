<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function resetPwForm(){
	  document.pwForm.reset();   // 폼 리셋
	}





var contextPath = '<%=request.getContextPath()%>';

var AUTH_CODE = '';
var FOUND_ID  = '';
var timer = null;
var remain = 0;

$(function(){

  $('#phone2,#confirmNo').on('input', function(){
    this.value = this.value.replace(/[^0-9]/g,'');
  });

  /* ===== 인증번호 요청 (임의 생성) ===== */
  $('#btnSend').on('click', function(){

    if(!$('#membername').val() || !$('#phone2').val()){
      alert('이름과 휴대폰 번호를 입력하세요.');
      return;
    }

    AUTH_CODE = String(Math.floor(100000 + Math.random()*900000));
    console.log('임의 인증번호 =', AUTH_CODE);

    $('#confirmBox').show();
    $('#btnConfirm').show();
    $('#btnSend').hide();

    startTimer(300);
  });

  /* ===== 인증번호 확인 + DB에서 아이디 조회 ===== */
  $('#btnConfirm').on('click', function(){

    if($('#confirmNo').val() !== AUTH_CODE){
      alert('인증번호가 일치하지 않습니다.');
      return;
    }

    $.ajax({
      url: contextPath + '/member/find_id_pw.htm',
      type: 'post',
      dataType: 'text',
      data: {
        name: $('#membername').val(),
        phone: $('#phone1').val() + $('#phone2').val()
      },
      success: function(id){
        id = $.trim(id || '');
        if(!id){
          alert('일치하는 회원 정보가 없습니다.');
          return;
        }

        FOUND_ID = id;
        $('#resultText').html('<h3 class="txt__id" id="resultId"> 아이디 : '  + FOUND_ID + '</h3>');
        $('#pwTargetId').text(FOUND_ID);

        clearInterval(timer);
        $('#idLayer').fadeIn(150);
      },
      error: function(){
        alert('아이디 조회 서버 오류');
      }
    });
  });

  /* 비밀번호 재설정 열기 */
  $('#btnPwOpen').on('click', function(){
    $('#idLayer').hide();
    $('#pwLayer').fadeIn(150);
  });

  /* ===== 실제 DB 비밀번호 변경 ===== */
  $('#btnPwSubmit').on('click', function(){

    var pw1 = $('#newPw').val();
    var pw2 = $('#newPw2').val();

    if(!pw1 || pw1.length < 4){
      alert('비밀번호는 4자 이상');
      return;
    }
    if(pw1 !== pw2){
      alert('비밀번호가 일치하지 않습니다.');
      return;
    }

    $.ajax({
      url: contextPath + '/member/pw_reset.htm',
      type: 'post',
      dataType: 'text',
      data: {
        id: FOUND_ID,
        newPw: pw1
      },
      success: function(res){
        if($.trim(res) === 'OK'){
          alert('비밀번호가 변경되었습니다.');
          location.href = contextPath + '/login.htm';
        } else {
          alert('비밀번호 변경 실패');
        }
      },
      error: function(){
        alert('비밀번호 변경 서버 오류');
      }
    });
  });

});

/* ===== 타이머 ===== */
function startTimer(sec){
  clearInterval(timer);
  remain = sec;
  timer = setInterval(function(){
    remain--;
    $('#countdown').text(
      String(Math.floor(remain/60)).padStart(2,'0') + ':' +
      String(remain%60).padStart(2,'0')
    );
    if(remain <= 0){
      clearInterval(timer);
      alert('인증시간 만료');
      location.reload();
    }
  },1000);
}

function closeIdLayer(){ $('#idLayer').hide(); }
function closePwLayer(){ $('#pwLayer').hide(); }
</script>