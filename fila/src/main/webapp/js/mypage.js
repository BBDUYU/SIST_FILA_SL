(function(ssq){
	var struc = {}, config = {}, listener = {};
	ssq(document).ready(function(){ struc.init() });

	function trace(a){
		var b="";
		for(var i=0;i<arguments.length;i++){
			if(i>0)b+=", ";
			b+=arguments[i];
		}
		try{console.log(b);}catch(e){}
	}

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
				mypage.layer.coupon();
				mypage.layer.modifyPw();
				mypage.layer.qna();          // ✅ qna가 "정상 위치"에서 정의/바인딩됨
				mypage.layer.chgOpt();
				mypage.layer.chgWishOpt();
				mypage.layer.exchange();
				mypage.layer.addAddr();
				mypage.layer.chgPw();
				mypage.layer.orderSearch();
				mypage.layer.chgRetire();
				mypage.layer.review();
			},

			coupon: function(){
				var popup = function(seq){
					$.ajax({
						type: 'GET',
						url: '/pc/mypage/pop_coupon_detail.asp',
						data: 'seq=' + seq,
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-coupon--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e);
						}
					});
				};

				$('body').on('click', '.coupon__btn', function(){
					var seq = $(this).attr("data-no");
					popup(seq);
				});

				$('body').on('click', '.common__layer._coupon .close__btn', function(){
					$('body').removeClass('lyr-coupon--open');
					$('.common__layer._coupon').remove();
				});
			},

			modifyPw: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/pc/mypage/pop_modify_pw.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-modify--open');
							$('body').append(html);

							// 눈
							ssq('.pwonoff__btn').click(function(){
								ssq(this).toggleClass('off');
								ssq('.sch-idpw .password-box .inp__pw').attr('type', 'text');
								if(!ssq(this).hasClass('off')){
									ssq('.sch-idpw .password-box .inp__pw').attr('type', 'password');
								}
							});
						},
						error: function(e) {
							console.log(e);
						}
					});
				};

				$('body').on('click', '.info-modify__btn', function(e){
					e.preventDefault();
					popup();
				});

				$('body').on('click', '.common__layer._modify_pw .close__btn', function(){
					$('body').removeClass('lyr-modify--open');
					$('.common__layer._modify_pw').remove();
				});
			},

			// ✅✅✅ 여기로 qna 모달 기능을 "정식으로" 빼서 고정
			qna: function(){

				// 🔹 모달 열기 (서버에서 레이어 HTML 받아오기)
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: (typeof contextPath !== 'undefined' ? contextPath : '') + '/mypage/writeLayer.htm',
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

				// 🔹 열기 버튼
				$('body').on('click', '.qna-page__writeBtn', function(){
					popup();
				});

				// 🔹 닫기
				$('body').on(
					'click',
					'.common__layer._qna_write .close__btn, .common__layer._qna_write .btn_close, .common__layer._qna_write .btn_cancel, .layer_dim',
					function(){
						$('body').removeClass('lyr-qna--open');
						$('.common__layer._qna_write').remove();
					}
				);

				// 🔹 등록
				$('body').on('click', '.common__layer._qna_write .btn_submit', function(){

					var $form = $('#qnaWriteForm');
					if ($form.length === 0) {
						alert('폼(#qnaWriteForm)을 찾을 수 없습니다.');
						return;
					}

					if (!$form.find('[name="categoryId"]').val()) {
						alert('문의유형을 선택해주세요.');
						return;
					}
					if (!$form.find('[name="title"]').val()) {
						alert('제목을 입력해주세요.');
						return;
					}
					if (!$form.find('[name="content"]').val()) {
						alert('문의 내용을 입력해주세요.');
						return;
					}

					var formData = new FormData($form[0]);

					$.ajax({
						type: 'POST',
						url: (typeof contextPath !== 'undefined' ? contextPath : '') + '/mypage/qna/write_submit.ajax',
						data: formData,
						processData: false,
						contentType: false,
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
			},

			chgOpt: function(){
				var btn = ssq('.option-change__btn');
				var popup = function(cartno) {
					ssq.ajax({
						type: 'GET',
						url: '/pc/order/pop_option.asp',
						data: 'cartno=' + cartno,
						dataType: 'html',
						success: function(html) {
							ssq('body').append(html);
						},
						error: function(e) {
							layerAlert('e');
						}
					});
				};

				btn.on('click', function() {
					var cartno = ssq(this).attr("data-no");
					popup(cartno);
				});

				ssq('body').on('click', '.common__layer._option .close__btn', function(){
					ssq('.common__layer').remove();
				});
			},

			chgWishOpt: function(){
				var btn = ssq('.Wishoption-change__btn');
				var popup = function(wishno) {
					ssq.ajax({
						type: 'GET',
						url: '/pc/mypage/pop_Wishoption.asp',
						data: 'wishno=' + wishno,
						dataType: 'html',
						success: function(html) {
							ssq('body').append(html);
						},
						error: function(e) {
							layerAlert('e');
						}
					});
				};

				btn.on('click', function() {
					var wishno = ssq(this).attr("data-no");
					popup(wishno);
				});

				ssq('body').on('click', '.common__layer._option .close__btn', function(){
					ssq('.common__layer').remove();
				});
			},

			addCart: function(){
				var btn = ssq('.cart__btn');
				btn.on('click', function() {
					var cartno = ssq(this).attr("data-no");
				});

				ssq('body').on('click', '.common__layer._option .close__btn', function(){
					ssq('.common__layer').remove();
				});
			},

			exchange: function(){
				var btn = ssq('.exchange_btn');
				var popup = function(cartno) {
					ssq.ajax({
						type: 'GET',
						url: '/pc/order/pop_exchange.asp',
						data: 'cartno=' + cartno,
						dataType: 'html',
						success: function(html) {
							ssq('body').append(html);

							var colorchipSwiper = new Swiper('.color__slider', {
								observer: true,
								observeParents: true,
								loop: false,
								mousewheel: true,
								slidesPerView: 'auto',
								freemode: true
							});
						},
						error: function(e) {
							layerAlert('e');
						}
					});
				};

				btn.on('click', function() {
					var cartno = ssq(this).attr("data-no");
					popup(cartno);
				});

				ssq('body').on('click', '.common__layer._option .close__btn', function(){
					ssq('.common__layer').remove();
				});
			},

			addAddr: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/pc/mypage/pop_address_add.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-addr--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e);
						}
					});
				};

				$('body').on('click', '.add-addr__btn', function(){
					popup();
				});

				$('body').on('click', '.common__layer._addr_add .close__btn', function(){
					$('body').removeClass('lyr-addr--open');
					$('.common__layer._addr_add').remove();
				});
			},

			chgPw: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/mypage/pop_pw.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-addr--open');
							$('body').append(html);

							ssq('.pwonoff__btn').click(function(){
								ssq(this).toggleClass('off');
								ssq('.sch-idpw .password-box .inp__pw').attr('type', 'text');
								if(!ssq(this).hasClass('off')){
									ssq('.sch-idpw .password-box .inp__pw').attr('type', 'password');
								}
							});
						},
						error: function(e) {
							console.log(e);
						}
					});
				};

				$('body').on('click', '.pw-change__btn', function(){
					popup();
				});

				$('body').on('click', '.common__layer._addr_add .close__btn', function(){
					$('body').removeClass('lyr-addr--open');
					$('.common__layer._addr_add').remove();
				});
			},

			chgRetire: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/mypage/pop_retire.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-addr--open');
							$('body').append(html);

							ssq('.pwonoff__btn').click(function(){
								ssq(this).toggleClass('off');
								ssq('.sch-idpw .password-box .inp__pw').attr('type', 'text');
								if(!ssq(this).hasClass('off')){
									ssq('.sch-idpw .password-box .inp__pw').attr('type', 'password');
								}
							});
						},
						error: function(e) {
							console.log(e);
						}
					});
				};

				$('body').on('click', '.retire-change__btn', function(){
					popup();
				});

				$('body').on('click', '.common__layer._addr_add .close__btn', function(){
					$('body').removeClass('lyr-addr--open');
					$('.common__layer._addr_add').remove();
				});
			},

			orderSearch: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/pc/mypage/pop_order_search.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-order-search--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e);
						}
					});
				};

				$('body').on('click', '.search-order-box .btn_sld__bk', function(){
					popup();
				});
				$('body').on('click', '.box2', function(){
					popup();
				});

				$('body').on('click', '.common__layer._order_search .close__btn', function(){
					$('body').removeClass('lyr-order-search--open');
					$('.common__layer._order_search').remove();
				});
			},

			review: function(){
				var popup = function(pno){
					$.ajax({
						type: 'GET',
						url: '/pc/product/pop_review.asp',
						data: 'pno=' + pno,
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-review--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e);
						}
					});
				};

				$('body').on('click', '.btn_review', function(){
					var pno = $(this).attr("data-no");
					popup(pno);
				});

				$('body').on('click', '.common__layer._review .close__btn', function(){
					$('body').removeClass('lyr-review--open');
					$('.common__layer._review').remove();
				});
			}
		},

		qnaList: function(){
			$('.qna__list li .qna-q').on('click', function(){
				var tBox = $(this).parent('li').find('.qna-a');
				if(tBox.css('display') == 'none'){
					$('.qna__list li').removeClass('open');
					$(this).parent('li').addClass('open');
				}else{
					$('.qna__list li').removeClass('open');
				}
			});
		},

		dateWrite: function(){
			$('.self-write').on('click', function(e){
				e.preventDefault();
				$(this).parents('.my-sort-wrap').toggleClass('_write');
			});
		},

		payDiscountToggle: function(){
			$('.myorder-detail-box .discount').on('click', function(){
				$(this).toggleClass('_open');
				const couponBox = $(this).closest('.myorder-detail-box').find('.pay-coupon-box');

				if ($(this).hasClass('_open')) {
					couponBox.stop(true, true).slideDown();
				} else {
					couponBox.stop(true, true).slideUp();
				}
			});
		}
	};

})(jQuery);


// 원본 남겨둔 전역 스크립트들
jQuery(document).ready(function(){
	jQuery(".period a").not(".self-write").click(function(){
		jQuery(".period a[class=on]").removeClass("on");
		jQuery(this).addClass("on");
	});
	jQuery(".period a.self-write").click(function(){
		jQuery(this).toggleClass("on");
	});
});

function searchDate(sdate, term){
	jQuery("#dateFrom").val(sdate);
	jQuery("#dateTo").val(jQuery("#nowDate").val());
	jQuery("#searchDate").val(term);
}

function passform(){
	var obj = document.myform;
	if(obj.memberPassword.value == ""){
		obj.memberPassword.focus();
		alert("암호를 입력해주세요");
		return false;
	}
	obj.submit();
}

function addrSubmit(){
	var objF = document.getElementById('addr');
	if(objF.addrname.value == ''){alert('수령인명을 입력해주세요'); objF.addrname.focus(); return; }
	if(objF.zipcode.value == ''){alert('우편번호를 입력해주세요'); objF.zipcode.focus(); return; }
	if(objF.addr1.value == ''){alert('주소를 입력해주세요'); objF.addr1.focus(); return; }
	if(objF.tel2_1.value == '' ){alert('휴대폰을 입력해주세요'); objF.tel2_1.focus(); return; }
	var pattern =/^[0-9]*$/g;
	if (!pattern.test(objF.tel2_1.value)) { alert('휴대폰은 숫자만 입력 가능합니다.'); objF.tel2_1.focus(); return; }
	objF.submit();
}

function addr_delete(addrVal){
	if (addrVal == undefined || addrVal == '') {
		alert("잘못된 시도입니다.");
	} else {
		jQuery.ajax({
			type: "POST",
			data: "addrNo=" + addrVal,
			url: "/mypage/pop_delivery_delete.asp",
			dataType : "HTML",
			success: function(data) {
				alert("삭제되었습니다.");
				location.reload();
			}
		});
	}
}

function addrDefault(addrVal){
	if (addrVal == undefined || addrVal == '') {
		alert("잘못된 시도입니다.");
	} else {
		jQuery.ajax({
			type: "POST",
			data: "addrNo=" + addrVal,
			url: "/mypage/pop_delivery_default.asp",
			dataType : "HTML",
			success: function(data) {
				alert("기본주소로 설정되었습니다.");
				location.reload();
			}
		});
	}
}

function addrAddPopup(val){
	var addrVal = val;
	if (addrVal == undefined || addrVal == '') {
		alert("잘못된 시도입니다.");
	} else {
		$.ajax({
			type: 'GET',
			url: '/pc/mypage/pop_address_add.asp',
			data: 'addrNo=' + addrVal,
			dataType: 'html',
			success: function(html) {
				$('body').addClass('lyr-addr--open');
				$('body').append(html);
			},
			error: function(e) {
				console.log(e);
			}
		});

		$('body').on('click', '.common__layer._addr_add .close__btn', function(){
			$('body').removeClass('lyr-addr--open');
			$('.common__layer._addr_add').remove();
		});
	}
}

function cjTracking(orno){
	window.open('https://trace.cjlogistics.com/web/detail.jsp?slipno='+orno,'cjTracking','toolbar=yes,location=no,directories=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=800,height=600');
}
function hyundaiTracking(orno){
	window.open('http://www.hlc.co.kr/personalService/tracking/06/tracking_goods_result.jsp?sflag=01&InvNo='+orno,'hyundaiTracking','toolbar=yes,location=no,directories=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=1024,height=800');
}
function hjTracking(orno){
	window.open('http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num='+orno,'cjTracking','toolbar=yes,location=no,directories=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=1024,height=800');
}
function todayTracking(orno){
	window.open('https://mall.todaypickup.com/front/delivery/list/'+orno,'todayTracking','toolbar=yes,location=no,directories=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=800,height=500');
}

function orderAddrPopup(val){
	var addrVal = val;
	if (addrVal == undefined || addrVal == '') {
		alert("잘못된 시도입니다.");
	} else {
		$.ajax({
			type: 'GET',
			url: '/pc/mypage/pop_address_order.asp',
			data: 'OrderNo=' + addrVal,
			dataType: 'html',
			success: function(html) {
				$('body').addClass('lyr-addr--open');
				$('body').append(html);
			},
			error: function(e) {
				console.log(e);
			}
		});

		$('body').on('click', '.common__layer._addr_add .close__btn', function(){
			$('body').removeClass('lyr-addr--open');
			$('.common__layer._addr_add').remove();
		});
	}
}

function recart(ordno){
	var val = "recart";
	jQuery.ajax({
		type: "POST",
		data: "mode="+ val + "&orderno=" + ordno + "&" + new Date().getTime(),
		url: "/product/put_cart_behind.asp",
		dataType : "JSON",
		success: function(data) {
			var codetype = data.codetype;
			var msg = data.msg;

			if (codetype == "add")  {
				var addmsg = jQuery("#boxMsg").attr("data-msg");
				if (addmsg == undefined) { addmsg = ""; }
				if (addmsg != "") { alert(addmsg); }
			}

			if (codetype == "addo2o")  {
				alert("선택하신 상품/사이즈는 매장 발송 상품입니다.\n물류센터 발송 상품과 개별 배송되오니 참고 부탁드립니다.");
			}

			if (msg !="") { alert(msg); }
			top.location.href="/order/cart.asp";
		}
	});
}
function openInquiryModal() {
  $('.qna-page__writeBtn').trigger('click');
}
