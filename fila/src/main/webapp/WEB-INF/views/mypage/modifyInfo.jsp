<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<section class="my-con">
           			<h2 class="tit__style4">내 정보 변경</h2>
					<a href="javascript:;" class="btn_sld__bk btn_rt pw-change__btn">비밀번호 변경</a>
					<form name="myform" method="post" action="${pageContext.request.contextPath}/mypage/modifyInfo.htm" target="dataFrame" class="join_form  modify_form   ">
						<input type="hidden" name="MemberTel" value="01038140096">
						<input type="hidden" name="joinMode" id="joinMode" value="">
						<input type="hidden" name="birthY" id="birthY" value="2000">
						<input type="hidden" name="birthM" id="birthM" value="05">
						<input type="hidden" name="birthD" id="birthD" value="25">
						<input type="hidden" name="MemberGender" id="MemberGender" value="M">
						<input type="hidden" name="srlrSeCd" id="srlrSeCd" value="S">
					<!-- 내 정보 변경 (기본정보, 선택정보, 자녀정보) -->
					<div class="modify-detail-box">
						<div class="">
							<p class="tit__style2">필수정보</p> 
							<!-- 기본정보 (아이디, 이름, 전화번호) -->
							<div class="mdfy_info-box">
								<div class="inp-box">
								    <input type="text" value="${auth.id}" disabled="">
								    <input type="text" value="${auth.name}" disabled="">
								</div>
								<div class="inp-box">
									<div class="btn_number_2504">
										<input type="text" value="${auth.phone}" disabled="">
        								<a href="javascript:void(0);" class="btn_number_edit_2504">변경</a>
										<style>
											.modify-detail-box .inp-box .btn_number_2504{
												display: flex;
												align-items: center;
											}
											.modify-detail-box .inp-box .btn_number_2504>input{
												flex-grow: 1;
												width: auto;
											}
											.btn_number_edit_2504{
												display: flex;
												width: 80px;
												height: 40px;
												border-radius: 20px;
												border: 1px solid rgb(0, 0, 0);
												justify-content: center;
												align-items: center;
												font-size: 16px;
												margin-left: 10px;
												box-sizing: border-box;
												transition: all 0.3s;
											}
											.btn_number_edit_2504:hover{
												background-color: rgb(0,32,83);
												border-color: rgb(0,32,83);
												color: rgb(255,255,255);
											}
										</style>
									</div>
									<input type="text" value="${auth.email}" name="userEmail" placeholder="이메일주소">
    								<p class="err-msg" id="emailCheckText">이메일 주소를 입력해주세요.</p>
								</div>
							</div>
							<!-- //기본정보 (아이디, 이름, 전화번호) -->
						</div>

						<div class="">
							<p class="tit__style2">추가정보</p> 

							<!-- 선택정보 (생년월일, 성별) -->
							<div class="mdfy_info-box">
								<div>
									<div class="chk">
										<input type="hidden" name="birthCert" id="birthCert" value="Y">
										
										<input type="hidden" class="_val" name="birthdaySex" id="birthdaySex" value="1">
										

									</div>									
									<div class="inp-box birthdaySex ">
										<input type="text" id="chkBirth" value="${auth.birthday}" disabled="">
   										<input type="text" class="mGender" value="${auth.gender == 'M' ? '남자' : '여자'}" disabled="">
									</div>
									<p class="txt__style1">
										생년월일/성별 정보 제공에 동의해주시면<br>기념일 쿠폰 등 캠페인 쿠폰이 제공됩니다.
									</p>

									
								</div>

								<div>
								    <div class="chk">
								        <%-- 전체 동의: '6'과 '7'이 모두 1일 때 --%>
								        <input type="checkbox" name="agree4" id="agree4" value="Y" onclick="receptionAll();"
								               ${mktMap['6'] == 1 && mktMap['7'] == 1 ? 'checked' : ''}>
								        <label for="agree4">마케팅 정보 수신에 동의합니다.</label>
								    </div>
								    <div class="sms-email-chk">
								        <div>
								            <%-- SMS (ID: '6') --%>
								            <input type="checkbox" name="MemberIsSMS" id="MemberIsSMS" value="Y" onclick="reception();" class="cb__style1"
								                   ${mktMap['6'] == 1 ? 'checked' : ''}>
								            <label for="MemberIsSMS">SMS 수신동의</label>
								        </div>
								
								        <div>
								            <%-- E-MAIL (ID: '7') --%>
								            <input type="checkbox" name="MemberIsMaillinglist" id="MemberIsMaillinglist" value="Y" onclick="reception();" class="cb__style1"
								                   ${mktMap['7'] == 1 ? 'checked' : ''}>
								            <label for="MemberIsMaillinglist">E-MAIL 수신동의</label>
								        </div>
								    </div>
								</div>
							</div>
							<!-- //선택정보 (생년월일, 성별) -->
						</div>

						<div class="">
    <p class="tit__style2" style="display: flex; justify-content: space-between; align-items: center;">
        자녀정보 
    </p> 

    <div class="inp-box" id="Children">
    <c:choose>
        <c:when test="${not empty childList}">
            <c:forEach var="child" items="${childList}" varStatus="status">
                <div class="child-group">
                    <div class="name">
                        <input type="hidden" name="custChSqor" value="">
                        <input type="text" name="ChildName" value="${child.childName}" maxlength="20" placeholder="자녀명">
                    </div>

                    <div class="info">
                        <div>
                            <input type="text" name="birthch" value="${child.childBirth}" placeholder="생년월일 8자리" maxlength="8">
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
                            <button type="button" class="child-add__btn btn_sld__gr plus" onclick="fn_append('Children');">자녀 추가</button>
                            <button type="button" class="child-add__btn btn_sld__gr reset" onclick="fn_reset('Children');">초기화</button>
                        </c:if>
                        <c:if test="${!status.first}">
                            <button type="button" class="child-add__btn btn_sld__gr minus" onclick="fn_remove(this);">삭제</button>
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
                    <div><input type="text" name="birthch" placeholder="생년월일 8자리" maxlength="8"></div>
                    <div>
                        <select class="sel__style1" name="MemberGender1">
                            <option value="">성별</option>
                            <option value="M">남성</option>
                            <option value="F">여성</option>
                        </select>
                    </div>
                </div>
                <cc>
                    <button type="button" class="child-add__btn btn_sld__gr plus" onclick="fn_append('Children');">자녀 추가</button>
                    <button type="button" class="child-add__btn btn_sld__gr reset" onclick="fn_reset('Children');">초기화</button>
                </cc>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</div>

					</div>

					<div class="btn__flex my-btn-box modify-btn-box" id="loginButton">
						<a href="javascript:;" class="btn_quit retire-change__btn">회원탈퇴</a>

						<button type="button" class="btn_sld__gr" onclick="location.href='/mypage/mypage.asp'">취소</button>
						<button type="button" class="btn_bg__bk" onclick="javascript:updateform_simple2();void(0);">수정완료</button>
					</div>
					<div class="btn__flex my-btn-box" id="loginButton2" style="display:none;">
						<img src="/pc/resource/images/waiting.gif">
					</div>
					
				</form>
				</section>
				<div id="PwdModifyModalOverlay" class="style-modal-overlay" style="display: none;">
    <div id="PwdModifyModalContent" class="style-modal-wrapper"></div>
</div>
<%-- 하단 안내 및 JS는 기존과 동일 --%>

</div>
</div>