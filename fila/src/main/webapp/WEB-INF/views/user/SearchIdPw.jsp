<%@ page contentType="text/html; charset=UTF-8" %>


<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/layout.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/sub.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/opt-default.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/product.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/normalize.css">

<script src="<%=request.getContextPath()%>/resource/js/jquery-1.11.2.min.js"></script>

<script>
var contextPath = '<%=request.getContextPath()%>';

var AUTH_CODE = '';
var FOUND_ID  = '';
var FOUND_PHONE = '';
var timer = null;
var remain = 0;

$(function(){

  /* 숫자만 입력 */
  $('#phone2,#confirmNo').on('input', function(){
    this.value = this.value.replace(/[^0-9]/g,'');
  });

  /* 인증번호 요청 (프론트 임시) */
  $('#btnSend').on('click', function(){

    if(!$('#membername').val() || !$('#phone2').val()){
      alert('이름과 휴대폰 번호를 입력하세요.');
      return;
    }

    AUTH_CODE = String(Math.floor(100000 + Math.random()*900000));
    console.log('임의 인증번호:', AUTH_CODE);

    $('#confirmBox').show();
    $('#btnConfirm').show();
    $('#btnSend').hide();

    startTimer(300);
  });

  /* 인증번호 확인 + 아이디 조회 */
  $('#btnConfirm').on('click', function(){

    if($('#confirmNo').val() !== AUTH_CODE){
      alert('인증번호가 일치하지 않습니다.');
      return;
    }

    var phone = $('#phone1').val() + $('#phone2').val();

    $.ajax({
      url: contextPath + '/member/find-id.htm',
      type: 'post',
      dataType: 'text',
      data: {
        name: $('#membername').val(),
        phone: phone
      },
      success: function(id){
        id = $.trim(id || '');
        if(!id){
          alert('일치하는 회원 정보가 없습니다.');
          return;
        }

        FOUND_ID = id;
        FOUND_PHONE = phone;

        $('#resultText').html('<h3 class="txt__id">아이디 : ' + FOUND_ID + '</h3>');
        $('#pwTargetId').val(FOUND_ID);
        $('#pwTargetPhone').val(FOUND_PHONE);

        clearInterval(timer);
        $('#idLayer').fadeIn(150);
      },
      error: function(){
        alert('아이디 조회 서버 오류');
      }
    });
  });

  /* 비밀번호 재설정 모달 열기 */
  $('#btnPwOpen').on('click', function(){
    $('#idLayer').hide();
    $('#pwLayer').fadeIn(150);
  });

  /* 비밀번호 재설정 */
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
      url: contextPath + '/member/pw-reset.htm',
      type: 'post',
      dataType: 'text',
      data: {
        id: $('#pwTargetId').val(),
        phone: $('#pwTargetPhone').val(),
        newPw: pw1
      },
      success: function(res){
        if($.trim(res) === 'OK'){
          alert('비밀번호가 변경되었습니다.');
          location.href = contextPath + '/member/login.htm';
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

/* 타이머 */
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
      alert('인증시간이 만료되었습니다.');
      location.reload();
    }
  },1000);
}

function closeIdLayer(){ $('#idLayer').hide(); }
function closePwLayer(){ $('#pwLayer').hide(); }
</script>

<div id="contents" class="mbr__contents">
  <h2 class="tit__style1">아이디 / 비밀번호 찾기</h2>

  <section class="mbr-box">
    <div class="info-sec">
      <div class="inp-box">
        <input type="text" id="membername" placeholder="이름">

        <div class="phone">
          <select id="phone1" class="sel__style1 wid__style3">
            <option value="010">010</option>
            <option value="011">011</option>
            <option value="016">016</option>
            <option value="017">017</option>
            <option value="019">019</option>
          </select>
          <input type="tel" id="phone2" class="inp__phone" maxlength="8" placeholder="휴대폰 번호">
        </div>

        <div id="confirmBox" style="display:none;">
          <input type="tel" id="confirmNo" maxlength="6" placeholder="인증번호">
          <small id="countdown" class="count"></small>
        </div>
      </div>

      <div class="btn-box">
        <button type="button" class="btn_bg__gr" id="btnSend">인증번호 요청</button>
        <button type="button" class="btn_bg__bk" id="btnConfirm" style="display:none;">인증번호 확인</button>
      </div>
    </div>
  </section>
</div>

<!-- 아이디 결과 모달 -->
<div class="common__layer sch-idpw" id="idLayer" style="display:none;">
  <div class="layer-bg__wrap"></div>
  <div class="inner">
    <div class="head">
      <p class="tit">아이디 찾기</p>
      <button type="button" class="close__btn" onclick="closeIdLayer()">close</button>
    </div>
    <div class="con">
      <div class="wrap">
        <p id="resultText"></p>
        <div class="top__line2">
          <p class="txt">비밀번호가 기억나지 않으실 경우<br>재설정이 가능합니다.</p>
        </div>
      </div>
    </div>
    <div class="foot">
      <button type="button" class="btn_bg__bk" id="btnPwOpen">비밀번호 재설정</button>
      <button type="button" class="on"
              onclick="location.href='<%=request.getContextPath()%>/member/login.htm'">
        로그인
      </button>
    </div>
  </div>
</div>

<!-- 비밀번호 재설정 모달 -->
<div class="common__layer sch-idpw" id="pwLayer" style="display:none;">
  <div class="layer-bg__wrap"></div>
  <div class="inner">
    <div class="head">
      <p class="tit">비밀번호 재설정</p>
      <button type="button" class="close__btn" onclick="closePwLayer()">close</button>
    </div>
    <div class="con">
      <form class="join_form modify_form">
        <input type="hidden" id="pwTargetId">
        <input type="hidden" id="pwTargetPhone">

        <div class="wrap">
          <div class="password-box">
            <input type="password" class="inp__pw" id="newPw" placeholder="새 비밀번호">
          </div>
          <div class="password-box">
            <input type="password" class="inp__pw" id="newPw2" placeholder="비밀번호 확인">
          </div>
        </div>
      </form>
    </div>
    <div class="foot">
      <button type="button" class="btn_can" onclick="closePwLayer()">취소</button>
      <button type="button" class="on" id="btnPwSubmit">변경 후 로그인</button>
    </div>
  </div>
</div>

