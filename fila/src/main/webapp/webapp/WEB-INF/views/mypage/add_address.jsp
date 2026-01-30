<%@ page contentType="text/html; charset=UTF-8" %>

<div class="common__layer _addr_add sch-idpw">
   <div class="layer-bg__wrap"></div>

   <div class="inner">
      <div class="head">
         <p class="tit">배송지 추가</p>
         <button type="button" class="close__btn">close</button>
      </div>

      <div class="con">
         <form name="addr" id="addr" action="/mypage/pop_delivery_result.asp" target="dataFrame" method="post">   
         <input type="hidden" name="addrNo" value="${param.addrNo}">
         <div class="addr-add-box">
            <div>
               <input type="text" placeholder="배송지 이름" name="addressName" value="" maxlength="25" id="addrRecipient ">
            </div>
            <div>
               <input type="text" placeholder="수령인" name="addrname" value="" maxlength="25" id="addrRecipient ">
            </div>

            <div>
               <input type="text" name="tel2_1" id="addrPhone" placeholder="휴대폰 번호를 '-' 제외하고 숫자만 입력해주세요" maxlength="11" value="" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');">
            </div>

            <div class="_addr">
               <div>
                  <input type="text" name="zipcode" readonly value="" id="addrZip">
                  <button type="button" class="zipcode__btn">주소찾기</button>
               </div>

               <div>
                  <input type="text" name="addr3" maxlength="200" value="" readonly="" id="addrNum1">
               </div>

               <div>
                  <input type="text" name="addr2" value="" maxlength="100" id="addrNum3" autocomplete="off">
               </div>
            </div>

            <div class="chk">
            
               <input type="checkbox" name="addrDefault" value="D" id="addrCheck" class="cb__style1">
               <label for="addrCheck">기본 배송지로 저장</label>
            
            </div>
         </div>
         <div id="MapModalOverlay"
                       class="style-modal-overlay"
                       onclick="if(event.target === this) closeQnaModal();"
                       style="display:none;">
                  
                      <div id="MapModalContent" class="style-modal-wrapper">
                          <!-- AJAX로 qna_modal.jsp 들어올 자리 -->
                      </div>
                  </div>
         </form>
      </div>

      <div class="foot">
         <button type="button" onclick="$('.close__btn').click();">취소</button>
         <button type="button" class="on" id="btnSaveAdd">저장하기</button>
      </div>
   </div>
</div>

