<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
var contextPath = '${pageContext.request.contextPath}';

(function ($) {

	  // 1:1 문의 모달 열기
	  $(document).on('click', '.qna-write__btn', function (e) {
	    e.preventDefault();
	    openQnaModal();
	  });

	  function openQnaModal() {
		    $.ajax({
		        url: contextPath + '/mypage/qnaWriteForm.htm',
		        type: 'GET',
		        success: function (res) {
		            // 1. 데이터를 먼저 넣는다
		            $('#qnaModalContent').html(res);
		            
		            $('#qnaModalOverlay').css({
		                'display': 'block',
		                'position': 'fixed',
		                'top': '0',
		                'left': '0',
		                'width': '100%',
		                'height': '100%',
		                'background': 'rgba(0, 0, 0, 0.6)', // 👈 배경을 까맣게 만드는 핵심
		                'z-index': '9998'
		            });

		            // 3. 모달 레이어 노출
		            $('.common__layer').show().css({
		                'display': 'block',
		                'z-index': '9999'
		            });

		            $('body').css('overflow', 'hidden');
		        }
		    });
		}

	  // 닫기
	  window.closeQnaModal = function () {
	    $('#qnaModalOverlay').hide();
	    $('#qnaModalContent').empty();
	    $('body').css('overflow', 'auto');
	  };

	  // 내부 닫기 버튼
	  $(document).on('click', '#btnCloseQna, .close__btn', function () {
	    closeQnaModal();
	  });
	  $(document).on('click', '.qna-q', function () {
	        const $parentLi = $(this).closest('li');
	        const $answer = $parentLi.find('.qna-a');

	        // 1. 클릭한 질문의 답변을 토글 (열려있으면 닫고, 닫혀있으면 열기)
	        $answer.stop().slideToggle(300);

	        // 2. 답변이 열릴 때 부모 li에 'on' 클래스 추가 (화살표 방향 변경 등을 위해)
	        $parentLi.toggleClass('on');

	        // 3. (선택사항) 다른 답변은 자동으로 닫고 싶다면 아래 주석 해제
	        /*
	        $parentLi.siblings().removeClass('on').find('.qna-a').slideUp(300);
	        */
	    });
	})(jQuery);

</script>