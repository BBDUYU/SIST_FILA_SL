(function(ssq){
	var struc = {}, config = {}, listener = {};
	ssq(document).ready(function(){ struc.init() });

	struc = {
		init : function() {
			struc.regist();
			struc.pageMethod();
			listener.start();
		},
		regist : function() {},
		pageMethod : function () {
			mypage.init();
		}
	};

	listener = {
		start : function(){
			ssq(window).bind("resize", listener.resizePage);
			listener.resizePage();
			ssq(window).on('scroll', function(){});
		},
		resizePage : function(e) {}
	};

	var mypage = {
		init: function(){
			mypage.layer.init();
			mypage.qnaList();
			mypage.dateWrite();
			mypage.payDiscountToggle();
		},

		layer: {
			init: function(){
				mypage.layer.qna();   // ✅ 1:1 문의 모달
			},

			/* ===============================
			   1:1 문의 모달 (Tiles + AJAX)
			=============================== */
			qna: function(){

				// 🔹 모달 열기 (서버에서 qna_write.jsp 받아오기)
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: contextPath + '/mypage/qnaWriteForm.htm',
						dataType: 'html',
						success: function(html){
							$('body').addClass('lyr-qna--open');
							$('body').append(html);
						},
						error: function(e){
							console.error(e);
						}
					});
				};

				// 🔹 열기 버튼 (qna.jsp)
				$('body').on('click', '.qna-write__btn', function(e){
					e.preventDefault();
					popup();
				});

				// 🔹 닫기 버튼
				$('body').on(
					'click',
					'.common__layer._qna_write .close__btn, .layer_dim',
					function(){
						$('body').removeClass('lyr-qna--open');
						$('.common__layer._qna_write').remove();
					}
				);

				// 🔹 문의 등록
				$('body').on('click', '.common__layer._qna_write .btn-submit', function(){

					var $form = $('#qnaWriteForm');

					if ($form.length === 0) {
						alert('문의 폼을 찾을 수 없습니다.');
						return;
					}

					if (!$form.find('[name="categoryId"]').val()) {
						alert('문의유형을 선택해주세요.');
						return;
					}

					if (!$form.find('[name="title"]').val().trim()) {
						alert('제목을 입력해주세요.');
						return;
					}

					if (!$form.find('[name="content"]').val().trim()) {
						alert('문의 내용을 입력해주세요.');
						return;
					}

					var agree = $form.find('input[name="privacyAgree"]:checked').val();
					if (!agree || agree === '0') {
						alert('개인정보 수집에 동의하셔야 문의 접수가 가능합니다.');
						return;
					}

					$.ajax({
						type: 'POST',
						url: contextPath + '/mypage/qnaWrite.htm',
						data: $form.serialize(),
						success: function(){
							alert('문의가 접수되었습니다.');
							$('body').removeClass('lyr-qna--open');
							$('.common__layer._qna_write').remove();
							location.reload();
						},
						error: function(){
							alert('문의 등록 중 오류가 발생했습니다.');
						}
					});
				});
			}
		},

		/* ===============================
		   QnA 목록 토글
		=============================== */
		qnaList: function(){
			$('.qna__list').on('click', '.qna-q', function(){
				var $li = $(this).closest('li');
				var $answer = $li.find('.qna-a');

				$answer.stop().slideToggle(300);
				$li.toggleClass('open');
				$li.siblings().removeClass('open').find('.qna-a').slideUp(300);
			});
		},

		dateWrite: function(){},
		payDiscountToggle: function(){}
	};

})(jQuery);
