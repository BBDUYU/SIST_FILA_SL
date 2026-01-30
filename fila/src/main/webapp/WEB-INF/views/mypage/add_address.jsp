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

<script>
var contextPath = '${pageContext.request.contextPath}';

(function ($) {

  /* =========================
     주소 검색 (map.jsp) - 이중 모달 대응
     ========================= */
  $(document).on('click', '.zipcode__btn', function (e) {
    e.preventDefault();

    // 🔥 현재 버튼이 속한 add/edit 모달 "안"에서만 map 모달 찾기
    var $scope = $(this).closest(
      '.style-modal-wrapper, .inner, #AddaddModalContent, #EditaddModalContent'
    );

    var $mapOverlay = $scope.find('#MapModalOverlay');
    var $mapContent = $scope.find('#MapModalContent');

    // 안전장치 (scope 못 찾았을 때)
    if ($mapOverlay.length === 0) $mapOverlay = $('#MapModalOverlay');
    if ($mapContent.length === 0) $mapContent = $('#MapModalContent');

    $mapContent.load(
      contextPath + '/view/mypage/map.jsp',
      function () {
        $mapOverlay.css('display', 'flex').show();
      }
    );
  });

  /* =========================
     map 모달 닫기
     ========================= */
  $(document).on('click', '#MapModalOverlay, #MapModalOverlay .close__btn', function (e) {
    if (e.target !== this && !$(e.target).hasClass('close__btn')) return;

    var $overlay = $(this).closest('#MapModalOverlay');
    $overlay.hide();
    $overlay.find('#MapModalContent').empty();
  });

})(jQuery);
</script>

<script>
(function($){
  $(document).off('click.addrAdd', '#btnSaveAdd')
             .on('click.addrAdd', '#btnSaveAdd', function(e){
    e.preventDefault();

    var $form = $('#addr');
    $.ajax({
      url: contextPath + '/mypage/address/add.htm',
      type: 'POST',
      data: $form.serialize(),
      dataType: 'json',
      // ✅ success는 반드시 이 '$.ajax' 중괄호 안에 있어야 합니다!
      success: function(res){
        if(res && res.ok){
          alert("배송지가 추가되었습니다.");
          if (location.pathname.indexOf("order") > -1) {
            // 주문 페이지면 목록 로드
            $("#AddrModalContent").load(contextPath + "/order/address_list.htm");
          } else {
            // 마이페이지면 새로고침
            location.reload();
          }
        } else {
          alert('저장 실패');
        }
      },
      error: function(xhr){
        alert('저장 실패 (' + xhr.status + ')');
      }
    });
  });
})(jQuery);
// ❌ 이 아래에는 아무것도 없어야 합니다.
</script>