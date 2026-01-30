<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
var contextPath = '${pageContext.request.contextPath}';

(function ($) {

  // 주소찾기(기존 그대로)
  $(document).on('click', '.zipcode__btn', function (e) {
    e.preventDefault();

    var $scope = $(this).closest('.style-modal-wrapper, .inner, #AddaddModalContent, #EditaddModalContent');
    var $mapOverlay = $scope.find('#MapModalOverlay');
    var $mapContent = $scope.find('#MapModalContent');

    if ($mapOverlay.length === 0) $mapOverlay = $('#MapModalOverlay');
    if ($mapContent.length === 0) $mapContent = $('#MapModalContent');

    $mapContent.load(contextPath + '/view/mypage/map.jsp', function () {
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
    e.stopPropagation();

    var $form = $(this).closest('.common__layer').find('form#addr');

    var addrNo = $form.find('input[name=addrNo]').val();
    if(!addrNo){
      alert('addrNo가 없습니다. (수정 대상 주소번호)');
      return;
    }

    $.ajax({
      url: contextPath + '/mypage/address/edit.htm',
      type: 'POST',
      data: $form.serialize(),
      dataType: 'json',
      success: function(res){
        if(res && res.ok){
          if (window.closeQnaModal) closeQnaModal();
          location.reload();
        }else{
          alert('수정 실패');
        }
      },
      error: function(xhr){
        alert('수정 실패 (' + xhr.status + ')');
      }
    });
  });
})(jQuery);
</script>