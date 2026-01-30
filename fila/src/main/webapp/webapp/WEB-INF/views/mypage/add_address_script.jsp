<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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