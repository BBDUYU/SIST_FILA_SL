<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="contents" class="mbr__contents">
  <h2 class="tit__style1">회원가입</h2>

  <section class="mbr-box certWrap">

    <!-- ================= 카카오 간편가입(틀만) ================= -->
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

    <!-- ================= 실제 가입 폼 ================= -->
    <!-- [FIX] 스프링 JoinController.java 기준: POST /member/join.htm -->
    <form id="joinForm" method="post" action="<%=request.getContextPath()%>/member/join.htm">

      <!-- [FIX] 본인인증 완료 플래그(이게 없어서 submit 때 "본인인증" 경고만 뜨던 케이스 해결) -->
      <input type="hidden" name="join_cert" id="join_cert" value="no">

      <!-- [FIX] 중복확인 플래그 -->
      <input type="hidden" name="id_check" id="id_check" value="no">

      <!-- [FIX] MemberVO 바인딩용(JoinController는 MemberVO로 받음) -->
      <input type="hidden" name="phone" id="phone" value="">
      <input type="hidden" name="marketingAgree" id="marketingAgree" value="0">
      <input type="hidden" name="role" id="role" value="USER">
      <input type="hidden" name="status" id="status" value="ACTIVE">
      <input type="hidden" name="grade" id="grade" value="BASIC">

      <!-- ================= 본인인증 ================= -->
      <div class="join-sec">
        <div class="title-box">
          <h3 class="tit__style2">본인인증</h3>
        </div>

        <div class="inp-box _bf">

          <div class="name">
            <!-- [FIX] MemberVO 필드명: name -->
            <input type="text" name="name" id="memberName" placeholder="이름" maxlength="50">
            <select name="NationalInfo" id="NationalInfo" class="sel__style1 wid__style1">
              <option value="0">내국인</option>
              <option value="1">외국인</option>
            </select>
          </div>
          <p class="err-msg" id="nameErr" style="display:none;">이름을 입력해주세요.</p>

          <div class="birthday">
            <!-- [FIX] MemberVO 필드명: birthday -->
            <input type="text" name="birthday" id="birthDay" placeholder="생년월일 8자리 Ex.20260110" maxlength="8">
            <!-- [FIX] MemberVO 필드명: gender -->
            <select name="gender" id="MemberGender" class="sel__style1 wid__style1">
              <option value="">성별</option>
              <option value="M">남자</option>
              <option value="F">여자</option>
            </select>
          </div>
          <p class="err-msg" id="birthErr" style="display:none;">생년월일/성별을 선택해주세요.</p>

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
          <!-- [FIX] MemberVO 필드명: id -->
          <input type="text" name="id" id="memberId" placeholder="아이디 (대소문자를 반드시 확인해주세요)" maxlength="16">
          <button type="button" class="btn__chk_id btn_sld__bk" id="idCheckBtn">중복확인</button>
        </div>
        <p class="err-msg" id="idErr" style="display:none;">아이디를 입력해주세요.</p>

        <div>
          <!-- [FIX] MemberVO 필드명: password -->
          <input type="password" class="inp__pw" name="password" id="memberPassword" placeholder="8-16자:영문,숫자,특수문자 조합" maxlength="16">
          <button type="button" class="pwonoff__btn off" id="pwToggle">on/off</button>
        </div>
        <p class="err-msg" id="pwErr" style="display:none;">비밀번호를 입력해주세요.</p>

        <div class="inp_eml">
          <!-- [FIX] MemberVO 필드명: email -->
          <input type="email" name="email" id="email" placeholder="이메일 주소">
        </div>
        <p class="err-msg" id="emailErr" style="display:none;">이메일 주소를 입력해주세요.</p>

      </div>

      <!-- ================= 자녀정보(토글 없음: 항상 표시) ================= -->
      <div class="join-sec certView">
        <div class="title-box">
          <h3 class="tit__style2">자녀정보</h3>
          <button type="button" class="btn_sel" id="childToggleBtn">
            추가시 생일 쿠폰 증정<span class="pm"></span>
          </button>
        </div>

        <!-- [FIX] 토글 제거: 항상 보이게 -->
        <div class="children-box" id="childBox" style="display:block;">
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