<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
var contextPath = '${pageContext.request.contextPath}';

(function ($) {

  /* =========================
     공통 모달 노출 함수 (CSS 강제 보정 포함)
     ========================= */
     function showModalForce(overlayId) {

    	  // 1️⃣ 열고 싶은 overlay 선택 (#AddaddressModalOverlay 등)
    	  var $ov = $(overlayId);

    	  // 2️⃣ overlay 자체를 화면에 표시 (flex 유지)
    	  $ov.css('display', 'flex').show();

    	  // 3️⃣ 🔥 이 overlay "안에 로드된" common__layer만 찾기
    	  //    (페이지 전체 common__layer ❌)
    	  var $layer = $ov.find('.common__layer');

    	  // 4️⃣ common__layer 강제 표시 (AJAX 로드 후 height 0 방지)
    	  $layer.css({
    	    display: 'block',
    	    visibility: 'visible',
    	    opacity: '1',
    	    zIndex: '9999'
    	  });

    	  // 5️⃣ 내부 컨텐츠(.inner)도 같이 강제 표시
    	  $layer.find('.inner').css({
    	    display: 'block',
    	    visibility: 'visible',
    	    zIndex: '10000'
    	  });

    	  // 6️⃣ 모달 열린 동안 배경 스크롤 막기
    	  $('body').css('overflow', 'hidden');
    	}

  /* =========================
     배송지 수정 (edit_address.jsp)
     ========================= */
     $(document).on('click', '.modify__btn', function (e) {
     	e.preventDefault();

    // addrNo 추출 로직
    var addrNo = $(this).data('addr-no');

    $('#EditaddModalContent').load(contextPath + '/mypage/edit_modal.htm?addrNo=' + addrNo, function(){
        showModalForce('#EditaddressModalOverlay');
   		});
   });

  /* =========================
     배송지 추가 (add_address.jsp)
     ========================= */
     $(document).on('click', '.add-addr__btn', function (e) {
     	e.preventDefault();

     var targetUrl = contextPath + '/mypage/add_modal.htm'; 
       
     $('#AddaddModalContent').load(targetUrl, function(response, status, xhr) {
           if (status == "error") {
               console.error("오류 발생: " + xhr.status + " " + xhr.statusText);
           } else {
               showModalForce('#AddaddressModalOverlay');
           }
       });
   });

  /* =========================
     공통 닫기
     ========================= */
  window.closeQnaModal = function () {
    $('#AddaddressModalOverlay').hide();
    $('#EditaddressModalOverlay').hide();
    $('#AddaddModalContent').empty();
    $('#EditaddModalContent').empty();
    $('body').css('overflow', 'auto');
  };

  $(document).on('click', '.close__btn, .btnCancel', function () {
    closeQnaModal();
  });

})(jQuery);

	/* =========================
	기본 배송지 설정
	========================= */
	function addrDefault(addrNo) {
		  if (!confirm('이 배송지를 기본 배송지로 설정하시겠습니까?')) return;
	
		  $.ajax({
		    url: contextPath + '/mypage/address/default.htm',
		    type: 'POST',
		    data: { addrNo: addrNo },
		    dataType: 'json',
		    success: function (res) {
		      if (res && res.ok) {
		        location.reload(); // 다시 조회해서 UI 갱신
		      } else {
		        alert('기본 배송지 설정 실패');
		      }
		    },
		    error: function (xhr) {
		      alert('오류 발생 (' + xhr.status + ')');
		    }
		  });
		}
	
	/* =========================
	삭제 버튼 (기본배송지 아닌 것만 data-addr-no로 들어옴)
	========================= */
	$(document).off('click.addrDelete', '.delete__btn[data-addr-no]')
    .on('click.addrDelete', '.delete__btn[data-addr-no]', function(e){
	e.preventDefault();
	e.stopPropagation();
	
	var addrNo = $(this).data('addr-no');
	if(!addrNo) return;
	
	if(!confirm('이 배송지를 삭제하시겠습니까?')) return;
	
	$.ajax({
	url: contextPath + '/mypage/address/delete.htm',
	type: 'POST',
	data: { addrNo: addrNo },
	dataType: 'json',
	
	success: function(res){
	if(res && res.ok){
	 location.reload();
	}else{
	 if(res && res.error === "USED_IN_ORDER"){
	   alert('주문에 사용된 배송지는 삭제할 수 없습니다.');
	 }else if(res && res.error === "DEFAULT_CANNOT_DELETE"){
	   alert('기본 배송지는 삭제할 수 없습니다.');
	 }else if(res && res.error === "NOT_FOUND"){
	   alert('삭제할 배송지를 찾을 수 없습니다.');
	 }else{
	   alert('삭제 실패');
	 }
	}
	},
	
	error: function(xhr){
	// 서버가 JSON으로 에러 내려주는 경우도 있어서 파싱 시도
	try{
	 var res = JSON.parse(xhr.responseText);
	
	 if(res && res.error === "USED_IN_ORDER"){
	   alert('주문에 사용된 배송지는 삭제할 수 없습니다.');
	   return;
	 }
	 if(res && res.error === "DEFAULT_CANNOT_DELETE"){
	   alert('기본 배송지는 삭제할 수 없습니다.');
	   return;
	 }
	 if(res && res.error === "NOT_FOUND"){
	   alert('삭제할 배송지를 찾을 수 없습니다.');
	   return;
	 }
	}catch(e){
	 // 파싱 실패 시 무시
	}
	
	alert('삭제 실패 (' + xhr.status + ')');
	}
	});
	});
</script>