<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="common__layer _addr_add sch-idpw">
  <div class="layer-bg__wrap"></div>

  <div class="inner">
    <div class="head">
      <p class="tit">배송지 수정</p>
      <button type="button" class="close__btn">close</button>
    </div>

    <div class="con">
      <c:if test="${not empty error}">
        <p style="padding:20px;color:red;">주소 정보를 불러올 수 없습니다.</p>
      </c:if>

      <form name="addr" id="addr" method="post">
        <input type="hidden" name="addrNo" value="${address.addressId}">

        <div class="addr-add-box">
          <div>
            <input type="text" placeholder="배송지 이름" name="addressName" maxlength="25"
                   value="${address.addressName}">
          </div>

          <div>
            <input type="text" placeholder="수령인" name="addrname" maxlength="25"
                   value="${address.recipientName}">
          </div>

          <div>
            <input type="text" name="tel2_1" id="addrPhone"
                   placeholder="휴대폰 번호를 '-' 제외하고 숫자만 입력해주세요"
                   maxlength="11"
                   value="${address.recipientPhone}"
                   onkeyup="this.value=this.value.replace(/[^0-9]/g,'');">
          </div>

          <div class="_addr">
            <div>
              <input type="text" name="zipcode" readonly id="addrZip"
                     value="${address.zipcode}">
              <button type="button" class="zipcode__btn">주소찾기</button>
            </div>

            <div>
              <input type="text" name="addr3" maxlength="200" readonly id="addrNum1"
                     value="${address.mainAddr}">
            </div>

            <div>
              <input type="text" name="addr2" maxlength="100" id="addrNum3" autocomplete="off"
                     value="${address.detailAddr}">
            </div>
          </div>

          <div class="chk">
            <input type="checkbox" name="addrDefault" value="D" id="addrCheck" class="cb__style1"
       				${address.isDefault == 1 ? 'checked="checked"' : ''}>
            <label for="addrCheck">기본 배송지로 저장</label>
          </div>
        </div>

        <div id="MapModalOverlay"
             class="style-modal-overlay"
             onclick="if(event.target === this) closeQnaModal();"
             style="display:none;">
          <div id="MapModalContent" class="style-modal-wrapper"></div>
        </div>
      </form>
    </div>

    <div class="foot">
      <button type="button" onclick="$('.close__btn').click();">취소</button>
      <button type="button" class="on" id="btnSaveEdit">저장하기</button>
    </div>
  </div>
</div>

<script>
var contextPath = '${pageContext.request.contextPath}';

(function ($) {
  $(document).on('click', '.zipcode__btn', function (e) {
    e.preventDefault();

    var $scope = $(this).closest('.style-modal-wrapper, .inner, #AddaddModalContent, #EditaddModalContent');
    var $mapOverlay = $scope.find('#MapModalOverlay');
    var $mapContent = $scope.find('#MapModalContent');

    if ($mapOverlay.length === 0) $mapOverlay = $('#MapModalOverlay');
    if ($mapContent.length === 0) $mapContent = $('#MapModalContent');

    $mapContent.load(contextPath + '/mypage/map_modal.htm', function () {
        $mapOverlay.css('display', 'flex').show();
    });
  });

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
	  $(document).off('click.addrEdit', '#btnSaveEdit')
	             .on('click.addrEdit', '#btnSaveEdit', function(e){
	    e.preventDefault();

	    // 1. 현재 모달 안의 form을 정확히 타겟팅
	    var $container = $(this).closest('.common__layer');
	    var $form = $container.find('form'); 

	    // 2. name="addrNo"로 수정했으므로 이제 값을 잘 가져옵니다.
	    var addrNo = $form.find('input[name=addrNo]').val();
	    if(!addrNo){
	      alert('주소 번호(addrNo)를 찾을 수 없습니다.');
	      return;
	    }

	    $.ajax({
	      url: contextPath + '/mypage/edit.htm',
	      type: 'POST',
	      data: $form.serialize(),
	      // 406 에러 방지를 위해 text로 받아서 JSON으로 파싱하거나 아래처럼 설정
	      success: function(res){
	        // 만약 res가 문자열로 오면 JSON.parse(res)가 필요할 수 있음
	        var data = (typeof res === 'string') ? JSON.parse(res) : res;
	        if(data.ok){
	           alert("수정되었습니다.");
	           location.reload();
	        } else {
	           alert('수정 실패: ' + (data.error || '관리자에게 문의하세요.'));
	        }
	      },
	      error: function(xhr){
	        // 여기서 406 에러가 찍힌다면 서버 응답 형식이 문제인 것임
	        alert('서버 오류 (' + xhr.status + ')');
	      }
	    });
	  });
	})(jQuery);
</script>
