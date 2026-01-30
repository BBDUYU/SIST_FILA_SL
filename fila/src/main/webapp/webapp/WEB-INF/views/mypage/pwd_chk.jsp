<%@ page contentType="text/html; charset=UTF-8" %>
<div class="common__layer sch-idpw _modify_pw">
    <div class="layer-bg__wrap"></div>

    <div class="inner">
        <div class="head">
            <p class="tit">내 정보 변경</p>
            <button type="button" class="close__btn" onclick="closeModifyModal()">close</button>
        </div>

        <div class="con">
            <div class="wrap">
                <p class="txt">비밀번호 확인 후 <br>정보 변경이 가능합니다.</p>
                <form name="myform" id="confirmPwForm" method="post" class="join_form modify_form">
                    <div class="password-box">
                        <input type="password" name="memberPassword" id="confirmPassword" class="inp__pw" maxlength="16" placeholder="8 - 16자 영문, 숫자, 특수문자 조합">
                        <button type="button" class="pwonoff__btn">on/off</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="foot">
            <button type="button" class="close__btn" onclick="closeModifyModal()">취소</button>
            <button type="button" class="on" id="btnConfirmPw">확인</button>
        </div>
    </div>
</div>

