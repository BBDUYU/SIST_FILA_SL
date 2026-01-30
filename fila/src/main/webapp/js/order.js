var ProductStockLimitNumber = 20; //@구매제한 수량
(function(ssq){
	var	struc={}, config={}, listener={};
	ssq(document).ready(function(){ struc.init() });
	function trace(a){ var b=""; for(var i=0;i<arguments.length;i++){if(i>0)b+=", ";b+=arguments[i];} try{console.log(b);}catch(e){}}
	struc = {
		init : function() {
			struc.regist(); 
			struc.pageMethod();
			listener.start();
		},
		regist : function() {

		},
		pageMethod : function () {			
			order.init();
		}
	};
	listener = {
		start : function(){
			ssq(window).bind("resize", listener.resizePage); listener.resizePage();
			/*ssq("a[href=#]").on("click",function(e){
				e.preventDefault();
			});*/
			ssq(window).on('scroll', function() {

			});
		},
		resizePage : function(e) {

		}
	};
	
	var order = {
		init: function(){
			order.tab();
			order.barTotal();
			order.infoBox();
			order.mapBox();
			order.orderPayInput();
			order.orderPayDelivery();
			order.orderPayCoupon();
			order.orderBoxOpen();
			order.layer.init();
			order.goodsScrollSlider();
			order.cartBotBan();//2023-09-07
			order.cartTopBan();//2023-09-07
		},
		tab: function(){
			if($('.order-cart-box .tab-btn-box button').length){
				var tTabLeft = $('.order-cart-box .tab-btn-box button.on').offset().left - 15;

				$('.order-cart-box .tab-btn-box').scrollLeft(tTabLeft);
			}
		},
		barTotal: function(){
			$('.bottom-order-bar .total-box .simple').on('click', function(){
				$('.bottom-order-bar .total-box').toggleClass('open');
			});
		},
		infoBox: function(){
			$('.order-info-box .more__btn').on('click', function(){
				$('.order-info-box').toggleClass('open');
			});
		},
		mapBox: function(){
			$('.order__list li .bot .pickup-store-box .map__btn').on('click', function(){
				$(this).parents('.pickup-store-box').toggleClass('open');
			});
		},
		orderPayInput: function(){
			$('body').on('keyup', 'input', function(){
				if($(this).val() == ''){
					$(this).removeClass('_val');
				}else{
					$(this).addClass('_val');
				}
			});
		},
		orderPayDelivery: function(){
			$('.addr-info-box .msg-box select').on('change', function(){
				if($(this).val() == 'start'){
					$(this).removeClass('_start');
					$(this).removeClass('_write');
				}else if($(this).val() == 'writeMsg'){
					$(this).addClass('_write');
					$(this).addClass('_start');
				}else{
					$(this).removeClass('_write');
					$(this).addClass('_start');
				}				
			});
		},
		orderPayCoupon: function(){
			$('.my-point-box select').on('change', function(){
				if($(this).val() == 'start'){
					$(this).removeClass('_start');
				}else{
					$(this).addClass('_start');
				}				
			});

			$('.my-point-box input').on('keyup', function(){
				if($(this).val() == '0' || $(this).val() == ''){
					$('.odr-toggle-box .cn .my-point-box .inp-box').removeClass('_start');
				}else{
					$('.odr-toggle-box .cn .my-point-box .inp-box').addClass('_start');
				}				
			});
		},
		orderBoxOpen: function(){
			$('.odr-toggle-box .hd .toggle__btn').on('click', function(){
				$(this).parents('.odr-toggle-box').toggleClass('open');
			});
		},
		layer: {
			init: function(){
				order.layer.addrList();
				order.layer.addrAdd();
				order.layer.zipCode();
				order.layer.option();
				order.layer.cart();
				order.layer.payAgree();
				order.layer.review();
				order.layer.coupon();
			},
			addrList: function(){
				var addChk = 0;
				var popup = function(){
					if (addChk == 0){
						$.ajax({
							type: 'GET',
							url: '/pc/order/pop_address_list.asp',
							data: '',
							dataType: 'html',
							success: function(html) {
								$('body').addClass('lyr-addrlist--open');
								$('body').append(html);
								addChk = 0;
							},
							error: function(e) {
								console.log(e)
							}
						});
					}
				};

				$('body').on('click', '.delivery-change__btn, addrBtn', function(){
					console.log(addChk);
					popup();
					addChk = 1;
				});

				$('body').on('click', '.basic__layer._addr_list .close__btn, .cbt', function(){
					$('body').removeClass('lyr-addrlist--open');
					$('.common__layer').remove();
				});
			},
			addrAdd: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/pc/order/pop_address_add.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-addradd--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e)
						}
					});
				};

				$('body').on('click', '.addr-add__btn', function(){
					popup();
				});

				$('body').on('click', '.basic__layer._addr_add .close__btn, .cbt', function(){
					$('body').removeClass('lyr-addradd--open');
					$('.common__layer').remove();
				});
			},
			zipCode: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/pc/mypage/pop_zipcode.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-zipcode--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e)
						}
					});
				};

				$('body').on('click', '.zipcode__btn', function(){
					popup();
				});

				$('body').on('click', '.basic__layer._zipcode .close__btn', function(){
					$('body').removeClass('lyr-zipcode--open');
					$('.common__layer').remove();
				});
			},
			option: function(){
				var popup = function(cartno){
					$.ajax({
						type: 'GET',
						url: '/pc/order/pop_option.asp',
						data: 'cartno=' + cartno,
						dataType: 'html',
						success: function(html) {
							//$('body').addClass('reco-option--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e)
						}
					});
				};

				$('body').on('click', '.option-change__btn', function(){
					var cartno = ssq(this).attr("data-no");
					popup(cartno);
				});

				$('body').on('click', '.close__btn', function(){
					//$('body').removeClass('reco-option--open');
					$('.common__layer').remove();
				});
				$('body').on('click', '.cancel__btn', function(){
					//$('body').removeClass('reco-option--open');
					$('.common__layer').remove();
				});
			},
			cart: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/mo/order/pop_cart.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('cart-option--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e)
						}
					});
				};

				$('body').on('click', '.recommend-box .cart__btn', function(){
					//popup();
				});

				$('body').on('click', '.order-option__layer._opt_cart .close__btn', function(){
					$('body').removeClass('cart-option--open');
					$('.order-option__layer._opt_cart').remove();
				});
			},
			payAgree: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/pc/order/pop_pay_agree.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('cart-option--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e)
						}
					});
				};

				$('body').on('click', '.btn_agree_view', function(e){
					e.preventDefault();
					popup();
				});

				$('body').on('click', '.order-option__layer._opt_cart .close__btn', function(){
					$('body').removeClass('cart-option--open');
					$('.order-option__layer._opt_cart').remove();
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
							console.log(e)
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
			},
			coupon: function(){
				var btn = ssq('.coupon__btn');
				var cpnChk = 0;
				var popup = function(cartno) {
					if (cpnChk == 0){
						ssq.ajax({
							type: 'GET',
							url: '/pc/order/pop_coupon.asp',
							data: '',
							dataType: 'html',
							success: function(html) {
								ssq('body').append(html);
								cpnChk = 0;
							},
							error: function(e) {
								console.log(e)
							}
						});
					}
				} 
				
				btn.on('click', function() {
						popup();
						cpnChk = 1;
				});

				ssq('body').on('click', '.common__layer._coupon .close__btn', function(){
					ssq('.common__layer._coupon').remove();
				});
			}

		},
		goodsScrollSlider: function(){
			$('.goods-scroll-box').each(function(idx){
				$(this).addClass('_gs0' + idx);

				var swiper = new Swiper('._gs0' + idx + ' .goods__slider', {
					direction: 'horizontal',
					freeMode: true,
					noSwiping: false,
					allowSlidePrev: true,
					allowSlideNext: true,
					mousewheel: {
						invert: true,
						forceToAxis: true
					},
					slidesPerView: 'auto',
					slidesOffsetBefore: 0,
					slidesOffsetAfter: 0,
					scrollbar: {
						el: '._gs0' + idx + ' .goods-slider-scrollbar',
					}
				});
			});			
		},
		//2023-09-07
		cartBotBan: function(){

			var totalSlide = $('.cart-ban-box .swiper-slide').length;


			var swiper = new Swiper('.cart-ban-box', {
				direction: 'horizontal',
				loop: true,
				autoplay: true,
				loopAdditionalSlides: 1,
				slidesPerView: 1,
				pagination: {
					el: '.cart-sldr-pagination',
					clickable: true
				},
			});	
			

			$('.cart-sldr-pagination').attr('data-total-num', totalSlide);
			$('.cart-sldr-pagination').attr('data-curr-num', swiper.realIndex + 1);

			$('.cart-sldr-pagination + .pagination-curr-bar > div').css({
				'width' : (swiper.realIndex + 1 / totalSlide) * 100 + '%',
				'left' : (swiper.realIndex / totalSlide) * 100 + '%'
			});

			swiper.on('slideChange', function(){
				$('.cart-sldr-pagination').attr('data-curr-num', swiper.realIndex + 1);

				$('.cart-sldr-pagination + .pagination-curr-bar > div').css({
					'left' : (swiper.realIndex / totalSlide) * 100 + '%'
				});				
			});

			if(totalSlide == 1) {
				$('.cart-ban-box .scroll-bar-box').addClass('_hide');
				swiper.autoplay.stop();
				swiper.destroy();
			}

		},
		cartTopBan: function(){

			var swiper = new Swiper('.cart-top-ban', {
				direction: 'vertical',
				loop: true,
				autoplay: true,
				loopAdditionalSlides: 1,
				slidesPerView: 1,
				
			});	
		},
	}
	
})(jQuery);


/* 같이배송 */
var popAddDelivery;
function popAddDelivery() {
	jQuery.ajax({
		type: 'GET',
		url: '/order/pop_delivery_add.asp',
		dataType: 'html',
		success: function(html) {
			layer.source(html, 'pop_delivery_add', {
				alignX : 0.5,
				alignY : 0.5,
				background : true, 
				backgroundColor : 'black',
				backgroundOpacity : 0.7,
				closeButtonId : 'closeBtn_99'
			});
			popupToggle(); 
			customSelect();
		},
		error: function(e) {
			alert('e');
		}
	});
	
}
function popAddDelivery2() {
	var formStr = "";
	jQuery.ajax({
		type: "POST",
		url: "/order/pop_delivery_add.asp",
		dataType : "HTML",
		success: function(data) {
			formStr = data;			
			
			 myAddrPop1 = new CoverLayer(formStr, {
					bg_color : "white", 		// 백그라운드 색상 기본값:"#000"
					bg_opacity : 0.75, 		// 백그라운드 투명도. 기본값:0.75
					close_btn_id : "closeBtn_99", 	// 레이어 닫기 버튼 DOM id, 기본값:"closeBtn"
					z_index : 99998, 			// 레이어의 z-index 값 기본값:99990
					cast_speed : 500,		// 레이어 생성 트위닝 속도
					close_click : false,		// 어느곳이나 클릭시 닫힘 여부, 활성화:true, 비활성화:false(기본값)
					scroll_fix : false
					//align_x : "left",			// "center"(기본값), "left", "right"
					//align_x_value : 50,				// 정수, 0(기본값)
					//align_y : "top",			// "middle"(기본값), "left", "right"
					//align_y_value : 50				// 정수, 0(기본값)
				});			
		},
		error: function(e) {
			//alert("e");
		}
	});
}



/*  나의 배송주소록 */
var addrPop1;
function addrPopup1() {
	var formStr = "";
	 addrPop1 = new CoverLayer(formStr, {
			bg_color : "white", 		// 백그라운드 색상 기본값:"#000"
			bg_opacity : 0.75, 		// 백그라운드 투명도. 기본값:0.75
			close_btn_id : "closeBtn1", 	// 레이어 닫기 버튼 DOM id, 기본값:"closeBtn"
			z_index : 99998, 			// 레이어의 z-index 값 기본값:99990
			cast_speed : 500,		// 레이어 생성 트위닝 속도
			close_click : false,		// 어느곳이나 클릭시 닫힘 여부, 활성화:true, 비활성화:false(기본값)
			scroll_fix : false
			//align_x : "left",			// "center"(기본값), "left", "right"
			//align_x_value : 50,				// 정수, 0(기본값)
			//align_y : "top",			// "middle"(기본값), "left", "right"
			//align_y_value : 50				// 정수, 0(기본값)
		} 
	);
}
/* 배송지 등록 */
var addrAddPop;
function addrAddPopup() {
	var formStr = "";

	 addrAddPop = new CoverLayer(formStr, {
			bg_color : "white", 		// 백그라운드 색상 기본값:"#000"
			bg_opacity : 0.75, 		// 백그라운드 투명도. 기본값:0.75
			close_btn_id : "closeBtn2", 	// 레이어 닫기 버튼 DOM id, 기본값:"closeBtn"
			z_index : 99998, 			// 레이어의 z-index 값 기본값:99990
			cast_speed : 500,		// 레이어 생성 트위닝 속도
			close_click : false,		// 어느곳이나 클릭시 닫힘 여부, 활성화:true, 비활성화:false(기본값)
			scroll_fix : false
			//align_x : "left",			// "center"(기본값), "left", "right"
			//align_x_value : 50,				// 정수, 0(기본값)
			//align_y : "top",			// "middle"(기본값), "left", "right"
			//align_y_value : 50				// 정수, 0(기본값)
		} 
	);
}


/* 장바구니 프로모션 팝업 */
function cartPromotionPopup() {
	jQuery.ajax({
		type: 'GET',
		url: '/2018/pc/order/pop_cart_promotion.asp',
		dataType: 'html',
		success: function(html) {
			layer.source(html, 'cartPromotionPop', {
				alignX : 0.5,
				alignY : 0.5,
				background : true, 
				backgroundColor : 'black',
				backgroundOpacity : 0.7,
				closeButtonId : 'closeBtn'
			});
			popupToggle(); 
			customSelect();
		},
		error: function(e) {
			alert('e');
		}
	});

}



function popupToggle(){
	var button = jQuery('.sort_info_box dl dt > button');
	button.click(function(){
		jQuery(this).parents('dl').toggleClass('open');
	});
}


/* 2021-11-17 당일배송 문구 추가 */
function todayNoticeLayer(){
	$('.today__wrap .today-notice-box .today-notice__btn').on('click', function(){
		$(this).parent('div').addClass('open');
	});

	$('body').on('click', '.today__wrap .today-notice__layer .close__btn', function(){
		$('.today__wrap .today-notice-box > div > div').removeClass('open');
	});
}
/* //2021-11-17 당일배송 문구 추가 */


/*장바구니 프로모션 팝업2*/
var promotionPop1;
function PromotionPopup1() {
	var formStr = "";
		formStr +='	<div class="order_popup ">'
		formStr +='		<h2 class="popup_title">알림</h2>';
		formStr +='			<p>사이즈를 선택해 주세요.</p>';
		//formStr +='		<h2 class="popup_title">확인</h2>';
		//formStr +='			<p>프로모션을 적용하시겠습니까?</p>';
		formStr +='			<div class="btn_box1">';
		formStr +='				<a href="#" class="btn_style2">취소</a>';
		formStr +='				<a href="#" class="btn_style1">확인</a>';
		formStr +='			</div>';
		formStr +='		<div class="close"><button id="closeBtn1"><img src="/images/btn/btn_close6.png" alt="닫기" /></button></div>'
		formStr +='	</div>'
		layer.source(formStr, "promotionPop1", {
			alignX : 0.5,
			alignY : 0.5,
			background : true, 
			backgroundColor : "black",
			backgroundOpacity : 0.5,
			closeButtonId : "closeBtn1"
	});
}




jQuery(document).ready(function(){
	orderMsg();	
	todayNoticeLayer();
});



function orderMsg(){	
	if(jQuery(document).width() > 960){
		jQuery('.input_sms').val('배송 관련 요청 사항을 50자 이내로 기재해주세요. 택배 기사님께 전달할 배송 메세지를 입력해 주세요.');
	}
	else{
		jQuery('.input_sms').val('전달할 배송 메세지를 입력해 주세요.');
	}

	jQuery('.msg_area').mouseover(function(){
		jQuery('.order_msg').css('display','block');
	});
	jQuery('.msg_area').mouseleave(function(){
		jQuery('.order_msg').css('display','none');
	});
	jQuery('.order_msg li').click(function(){
		jQuery('#orderSMS').val(jQuery(this).text());
		jQuery('.order_msg').css('display','none');
	});		
}



function useCoupon_D(val) {
		xmlhttp = initXMLHttp();

		var obj = document.getElementById("mc_layer" + val);
		obj.innerHTML = "<img src=/images/waiting.gif>";
		
		randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);			
		
		xmlhttp.open("GET", "/order/pay_d_coupon.asp?facNo="+ val +"&randNo="+ randNo);
		xmlhttp.onreadystatechange = function () {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
						var returnval;
						returnval = xmlhttp.responseText;

						var index1, page;
						index1 = returnval.indexOf("|");
						TEXT1 = returnval.substring(0, index1);

						var returnWords, index2, pagecount;
						returnWords = returnval.substring(returnval.indexOf("|") + 1);
						index2 = returnWords.indexOf("|");
						TEXT2 = returnWords.substring(0, index2);

						if (TEXT1 == 0)	// success! 
						{
								document.user.transpay.value = parseInt(document.user.transpay.value,10) - parseInt(TEXT2,10);
								document.user.Delivery_coupon.value = "Y";
								document.getElementById("deli_price" + val).innerHTML = "0원";
//								document.getElementById("transprice").innerHTML = document.user.transpay.value;
								obj.innerHTML = "무료배송 쿠폰적용됨";
								recalc_aj();
						}
						else			// fail!
						{
								process(TEXT2);
								obj.innerHTML = "<a href=\"javascript:useCoupon_D('"+ val +"');void(0);\" class=\"btn_coupon\">무료배송쿠폰 사용하기</a>"
								recalc_aj();
						}
				}
		}
		xmlhttp.send(null);
}

/*2019-09-09 최근배송지추가*/
var myLateyPop;
function myLateyPop(){
	var formStr = "";
	jQuery.ajax({
		type: "POST",
		url: "/2018/pc/order/pop_delivery_lately.asp",
		dataType : "HTML",
		success: function(data) {
			formStr = data;			
			
			 myAddrPop1 = new CoverLayer(formStr, {
					bg_color : "white", 		// 백그라운드 색상 기본값:"#000"
					bg_opacity : 0.75, 		// 백그라운드 투명도. 기본값:0.75
					close_btn_id : "closeBtn", 	// 레이어 닫기 버튼 DOM id, 기본값:"closeBtn"
					z_index : 99998, 			// 레이어의 z-index 값 기본값:99990
					cast_speed : 500,		// 레이어 생성 트위닝 속도
					close_click : false,		// 어느곳이나 클릭시 닫힘 여부, 활성화:true, 비활성화:false(기본값)
					scroll_fix : false
					//align_x : "left",			// "center"(기본값), "left", "right"
					//align_x_value : 50,				// 정수, 0(기본값)
					//align_y : "top",			// "middle"(기본값), "left", "right"
					//align_y_value : 50				// 정수, 0(기본값)
				});			
		},
		error: function(e) {
			//alert("e");
		}
	});
}

/*나의 배송주소록*/
var myAddrPop1;
function myAddrPopup1() {
	var formStr = "";
	jQuery.ajax({
		type: "POST",
		url: "/order/pop_delivery.asp",
		dataType : "HTML",
		success: function(data) {
			formStr = data;			
			
			 myAddrPop1 = new CoverLayer(formStr, {
					bg_color : "white", 		// 백그라운드 색상 기본값:"#000"
					bg_opacity : 0.75, 		// 백그라운드 투명도. 기본값:0.75
					close_btn_id : "closeBtn", 	// 레이어 닫기 버튼 DOM id, 기본값:"closeBtn"
					z_index : 99998, 			// 레이어의 z-index 값 기본값:99990
					cast_speed : 500,		// 레이어 생성 트위닝 속도
					close_click : false,		// 어느곳이나 클릭시 닫힘 여부, 활성화:true, 비활성화:false(기본값)
					scroll_fix : false
					//align_x : "left",			// "center"(기본값), "left", "right"
					//align_x_value : 50,				// 정수, 0(기본값)
					//align_y : "top",			// "middle"(기본값), "left", "right"
					//align_y_value : 50				// 정수, 0(기본값)
				});			
		},
		error: function(e) {
			//alert("e");
		}
	});
}

/*배송지 추가*/
var addrAddPop1;
function addrAddPopup1(val) {
	var formStr = "";
	top.closeCoverLayer();
	jQuery.ajax({
		type: "POST",
		data: "addrNo=" + val,
		url: "/order/pop_delivery_write.asp",
		dataType : "HTML",
		success: function(data) {
			formStr = data;			
			 addrAddPop1 = new CoverLayer(formStr, {
					bg_color : "white", 		// 백그라운드 색상 기본값:"#000"
					bg_opacity : 0.2, 		// 백그라운드 투명도. 기본값:0.75
					close_btn_id : "closeBtn2", 	// 레이어 닫기 버튼 DOM id, 기본값:"closeBtn"
					z_index : 99998, 			// 레이어의 z-index 값 기본값:99990
					cast_speed : 500,		// 레이어 생성 트위닝 속도
					close_click : false,		// 어느곳이나 클릭시 닫힘 여부, 활성화:true, 비활성화:false(기본값)
					scroll_fix : false,
					//align_x : "left",			// "center"(기본값), "left", "right"
					//align_x_value : 50,				// 정수, 0(기본값)
					//align_y : "middle"		// "middle"(기본값), "left", "right"
					//align_y_value : 50				// 정수, 0(기본값)
				});			
		},
		error: function(e) {
			//alert("e");
		}
	});
}

/*배송지 수정*/
var addrAddPop2;
function addrAddPopup2(val) {
	var formStr = "";
	
	var addrVal = val;


	if (addrVal == undefined || addrVal == '') {
		alert("잘못된 시도입니다.");
	}
	else {

					$.ajax({
						type: 'GET',
						url: '/pc/order/pop_address_add.asp',
						data: 'addrNo=' + addrVal,
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-addr--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log(e)
						}
					});




				$('body').on('click', '.common__layer._addr_add .close__btn', function(){
					$('body').removeClass('lyr-addr--open');
					$('.common__layer._addr_add').remove();
				});

	}
	

}

function pay_delivery_iframe() {

	var sizeWidth2 = 645;//jQuery(window).width() * 0.90;	//가로 = 화면 넓이의 80%
	var sizeHeight2 = 590; //sizeWidth2 * 1.2;	//세로 = 가로의 60%

	if ( chkMobile() )	{	//모바일 
		sizeWidth2 = 324;
		sizeHeight2 = 590;
	}else{	//PC
		if (sizeWidth2 > 645)	{ sizeWidth2 = 645 };
		if (sizeHeight2 > 590) { sizeHeight2 = 590	};
	}
	scrollTo(0,0)
	layer.iframe("/order/pop_delivery.asp","pop_delivery", {width:sizeWidth2, height:sizeHeight2, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	/*
	var layerText='<div style="text-align:right;"><button type="button" onclick="layer.close();"><img src="/images/btn/btn_pop_close.gif"></button></div><iframe name="inneriframe" width="645" height="265" id="inneriframe" src="/order/pop_delivery.asp" style="width: 100%; height: 100%;" allowtransparency="true"></iframe>';
	layer.text(layerText,"cathpop", {width:645, height:265, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	return;
	*/
}

function pay_copyInfomation() {
	if (document.user.pDelivery.checked == true){

		document.user.OrderDName.value = document.user.OrderOName.value;	
		document.user.OrderDZip.value = document.user.OrderOZip.value;
		document.user.OrderDAddress1.value = document.user.OrderOAddress1.value;
		document.user.OrderDAddress2.value = document.user.OrderOAddress2.value;		
		document.user.OrderDRoadAddress.value = document.user.OrderORoadAddress.value;
		//document.user.OrderDEmail.value = document.user.OrderOEmail.value;
		/*
		document.user.OrderDTel11.value = document.user.OrderOTel11.value;
		document.user.OrderDTel12.value = document.user.OrderOTel12.value;
		document.user.OrderDTel13.value = document.user.OrderOTel13.value;
		*/
		document.user.OrderDTel21.value = document.user.OrderOTel21.value;
		/*
		document.user.OrderDTel22.value = document.user.OrderOTel22.value;
		document.user.OrderDTel23.value = document.user.OrderOTel23.value;
		*/
		$("#dName").html(document.user.OrderDName.value);
		if (document.user.OrderDTel21.value.length == 11){
			$("#dTel").html(document.user.OrderDTel21.value.substr(0,3) + "-" + document.user.OrderDTel21.value.substr(3,4) + "-" + document.user.OrderDTel21.value.substr(7,4));
		}else{
			$("#dTel").html(document.user.OrderDTel21.value.substr(0,3) + "-" + document.user.OrderDTel21.value.substr(3,3) + "-" + document.user.OrderDTel21.value.substr(6,4));
		}
		$("#dAddr").html("(" + document.user.OrderDZip.value + ") " + document.user.OrderDRoadAddress.value + " " + document.user.OrderDAddress2.value);
	}
}

function pay_copyDefault() {
		document.user.OrderDName.value = document.user.aOrderOName.value;	
		document.user.OrderDZip.value = document.user.aOrderOZip.value;
		document.user.OrderDAddress1.value = document.user.aOrderOAddress1.value;
		document.user.OrderDAddress2.value = document.user.aOrderOAddress2.value;		
		document.user.OrderDRoadAddress.value = document.user.aOrderORoadAddress.value;
		//document.user.OrderDEmail.value = document.user.aOrderOEmail.value;
//		document.user.OrderDTel11.value = document.user.aOrderOTel11.value;
//		document.user.OrderDTel12.value = document.user.aOrderOTel12.value;
//		document.user.OrderDTel13.value = document.user.aOrderOTel13.value;
		document.user.OrderDTel21.value = document.user.aOrderOTel21.value;
		document.user.OrderDTel22.value = document.user.aOrderOTel22.value;
		document.user.OrderDTel23.value = document.user.aOrderOTel23.value;
}

function pay_copyReset() {
		document.user.OrderDName.value = "";	
		document.user.OrderDZip.value = "";
		document.user.OrderDAddress1.value = "";
		document.user.OrderDAddress2.value = "";		
		document.user.OrderDRoadAddress.value = "";		
		
		//document.user.OrderDEmail.value = "";
		document.user.OrderDTel11.value = "";
		document.user.OrderDTel12.value = "";
		document.user.OrderDTel13.value = "";
		document.user.OrderDTel21.value = "";
		document.user.OrderDTel22.value = "";
		document.user.OrderDTel23.value = "";
}
function pay_copyLap(){
		document.user.OrderDName.value = "직접방문";	
		document.user.OrderDZip.value = "47030";
		document.user.OrderDAddress1.value = "부산광역시 사상구 낙동대로 943번길 235";
		document.user.OrderDAddress2.value = "첨단신발융합허브센터 6층";		
		document.user.OrderDRoadAddress.value = "부산광역시 사상구 낙동대로 943번길 235";
		//document.user.OrderDEmail.value = document.user.aOrderOEmail.value;
		document.user.OrderDTel11.value = document.user.aOrderOTel11.value;
		document.user.OrderDTel12.value = document.user.aOrderOTel12.value;
		document.user.OrderDTel13.value = document.user.aOrderOTel13.value;
		document.user.OrderDTel21.value = document.user.aOrderOTel21.value;
		document.user.OrderDTel22.value = document.user.aOrderOTel22.value;
		document.user.OrderDTel23.value = document.user.aOrderOTel23.value;
}

function pay_deliveryCopy(val) {
	if (val==1) {
		pay_copyDefault();		
	}
	else if (val==2) {
		pay_copyInfomation();
	}
	else if (val==3) {
		pay_copyReset();
	}	
	else if (val==4){
		pay_copyLap();
	}
	islandCheck();	
	todayDelivery();
}
 
function pay_checkout() {
	var valiMail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	var email = document.user.OrderOEmail.value;
	
	if (jQuery("select[name=giftSize]").length > 0)	{
		for (var i = 0;i < jQuery("select[name=giftSize]").length; i++)	{
			if (jQuery("select[name=giftSize]").eq(i).val() == ""){
				alert("사은품의 사이즈를 선택해주세요.");
				jQuery("select[name=giftSize]").eq(i).focus();
				var offset = $(".gift-present").offset();
				$('html, body').animate({scrollTop : offset.top}, 0);
				return false;
			}
		}
	}
	if (jQuery("select[name=giftColor]").length > 0)	{
		for (var i = 0;i < jQuery("select[name=giftColor]").length; i++)	{
			if (jQuery("select[name=giftColor]").eq(0).val() == ""){
				alert("사은품의 색상을 선택해주세요.");
				jQuery("select[name=giftColor]").eq(i).focus();
				var offset = $(".gift-present").offset();
				$('html, body').animate({scrollTop : offset.top}, 0);
				return false;
			}
		}
	}

	if (document.user.OrderOName.value=="") {
//		alert("주문자 정보에 '이름'을 입력해 주세요.") ;

		window.scrollTo({
			top: document.user.OrderOName.offsetTop - 80,
			left: 0,
			behavior: 'smooth'
		});

		document.user.OrderOName.classList.add('_type_please');
		document.user.OrderOName.classList.add('_type_vibration');

		setTimeout(function() {
			document.user.OrderOName.classList.remove('_type_vibration');
			//document.user.OrderOName.classList.remove('_type_please');
			document.user.OrderOName.focus() ;
		}, 500);

		//document.user.OrderOName.focus() ;
		return false;
	}
	else if (document.user.OrderOTel21.value=="") {
//		alert("주문자 정보에 '전화번호'를 입력해 주세요.") ;
		window.scrollTo({
			top: document.user.OrderOTel21.offsetTop - 80,
			left: 0,
			behavior: 'smooth'
		});

		document.user.OrderOTel21.classList.add('_type_please');
		document.user.OrderOTel21.classList.add('_type_vibration');

		setTimeout(function() {
			document.user.OrderOTel21.classList.remove('_type_vibration');
			//document.user.OrderOTel21.classList.remove('_type_please');
			document.user.OrderOTel21.focus() ;
		}, 500);
		//document.user.OrderOTel21.focus() ;
		return false;
	}

	else if (email == "" ) {
		//20241118 이메일 체크 비회원만 - 회원도 없는 경우가 있는데, 주문페이지에서는 입력을 노출안함
//		if (document.user.sid.value == ""){
			window.scrollTo({
				top: document.user.OrderOEmail.offsetTop - 80,
				left: 0,
				behavior: 'smooth'
			});

			document.user.OrderOEmail.classList.add('_type_please');
			document.user.OrderOEmail.classList.add('_type_vibration');

			setTimeout(function() {
				document.user.OrderOEmail.classList.remove('_type_vibration');
				//document.user.OrderOEmail.classList.remove('_type_please');
				document.user.OrderOEmail.focus() ;
			}, 500);
			//document.user.OrderOEmail.focus() ;
			return false;
//		}
	}


	else if (document.user.OrderDName.value=="") {
		if (document.user.sid.value == ""){
//			alert("배송지 정보에 '이름'을 입력해 주세요.") ;
			window.scrollTo({
				top: document.user.OrderDName.offsetTop - 80,
				left: 0,
				behavior: 'smooth'
			});

			document.user.OrderDName.classList.add('_type_please');
			document.user.OrderDName.classList.add('_type_vibration');

			setTimeout(function() {
				document.user.OrderDName.classList.remove('_type_vibration');
				//document.user.OrderDName.classList.remove('_type_please');
				document.user.OrderDName.focus() ;
			}, 500);
			//document.user.OrderDName.focus() ;
		}else{
			alert("배송지 정보 옆 '변경' 버튼을 눌러 정보를 입력해 주세요.") ;
			$(window).scrollTop(0);
			//$(".addrBtn").click();
		}
		return false;
	}
	else if (document.user.OrderDZip.value=="") {
		if (document.user.sid.value == ""){
//			alert("배송지 정보에 '주소'를 입력해 주세요.") 
			window.scrollTo({
				top: document.user.OrderDZip.offsetTop - 80,
				left: 0,
				behavior: 'smooth'
			});

			document.user.OrderDZip.classList.add('_type_please');
			document.user.OrderDZip.classList.add('_type_vibration');

			setTimeout(function() {
				document.user.OrderDZip.classList.remove('_type_vibration');
				//document.user.OrderDZip.classList.remove('_type_please');
				document.user.OrderDZip.focus() ;
			}, 500);
			//document.user.OrderDZip.focus() ;
		}else{
			alert("배송지 정보 옆 '변경' 버튼을 눌러 정보를 입력해 주세요.") 
			$(window).scrollTop(0);
			//$(".addrBtn").click();
		}
		return false;
	}
	else if (document.user.OrderDAddress1.value=="" || document.user.OrderDAddress2.value=="") {
		
		if (document.user.sid.value == ""){
			//alert("마지막 빈칸에 상세 주소를 입력해 주세요.") ;
			window.scrollTo({
				top: document.user.OrderDAddress2.offsetTop - 80,
				left: 0,
				behavior: 'smooth'
			});

			document.user.OrderDAddress2.classList.add('_type_please');
			document.user.OrderDAddress2.classList.add('_type_vibration');

			setTimeout(function() {
				document.user.OrderDAddress2.classList.remove('_type_vibration');
				//document.user.OrderDAddress2.classList.remove('_type_please');
				document.user.OrderDAddress2.focus() ;
			}, 500);
			//document.user.OrderDAddress2.focus() ;
		}else{
			alert("배송지 정보 옆 '변경' 버튼을 눌러 정보를 입력해 주세요.") ;
			$(window).scrollTop(0);
			//$(".addrBtn").click();
		}
		return false;
	}	
	else if (document.user.OrderDTel21.value=="" ) {
		
		if (document.user.sid.value == ""){
			//alert("배송지 정보에 '전화번호'를 입력해 주세요.") ;
			window.scrollTo({
				top: document.user.OrderDTel21.offsetTop - 80,
				left: 0,
				behavior: 'smooth'
			});

			document.user.OrderDTel21.classList.add('_type_please');
			document.user.OrderDTel21.classList.add('_type_vibration');

			setTimeout(function() {
				document.user.OrderDTel21.classList.remove('_type_vibration');
				//document.user.OrderDTel21.classList.remove('_type_please');
				document.user.OrderDTel21.focus() ;
			}, 500);
			//document.user.OrderDTel21.focus() ;
		}else{
			alert("배송지 정보 옆 '변경' 버튼을 눌러 정보를 입력해 주세요.") ;
			$(window).scrollTop(0);
			//$(".addrBtn").click();
		}
		return false;
	}
	/*
	if (document.user.OrderOTel22.value.length > 4 ){
		alert("주문자 휴대폰번호를 입력하세요.");
		document.user.OrderOTel22.value = "";
		document.user.OrderOTel22.focus();
		return false;
	}
	if (document.user.OrderOTel23.value.length > 4 ){
		alert("주문자 휴대폰번호를 입력하세요.");
		document.user.OrderOTel23.value = "";
		document.user.OrderOTel23.focus();
		return false;
	}
	*/

	//'''20230601 이메일이 있는데 이메일 형식이 아니면 진행 안되도록 처리
	if (email != '' && !valiMail.test(email)) {
			alert("주문자 이메일 주소를 형식에 맞게 입력해주시길 바랍니다.") ;
			$(".ordInfo").show();
			window.scrollTo({
				top: document.user.OrderOEmail.offsetTop - 80,
				left: 0,
				behavior: 'smooth'
			});

			document.user.OrderOEmail.classList.add('_type_please');
			document.user.OrderOEmail.classList.add('_type_vibration');

			setTimeout(function() {
				document.user.OrderOEmail.classList.remove('_type_vibration');
				//document.user.OrderOEmail.classList.remove('_type_please');
				document.user.OrderOEmail.value = "";
				document.user.OrderOEmail.focus() ;
			}, 500);
			//document.user.OrderOEmail.focus() ;
			return false;
		/*
		alert("올바른 이메일 주소를 입력하세요");
		document.user.OrderOEmail.focus() ;
		return false;
		*/
	}

	//전화번호가 다른데는 등록이 됐는데 지역번호 등록이 안됐을 때
	/*
	 if (document.user.OrderDTel12.value != "" || document.user.OrderDTel13.value != ""){
		if (document.user.OrderDTel11.value == "" ) {
			alert("배송지 연락처를 입력하세요") ;
			document.user.OrderDTel11.focus() ;
			return false;
		}
		if (document.user.OrderDTel12.value.length > 4 ){
			alert("배송지 연락처를 입력해주세요.");
			document.user.OrderDTel12.value = "";
			document.user.OrderDTel12.focus();
			return false;
		}
		if (document.user.OrderDTel13.value.length > 4 ){
			alert("배송지 연락처를 입력해주세요.");
			document.user.OrderDTel13.value = "";
			document.user.OrderDTel13.focus();
			return false;
		}
	}
	*/
/*
	if (parseInt(document.user.usemile.value) == parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.transpay.value) - parseInt(document.user.coup1sale.value)) ) {
		if (!document.user.gopaymethod[4].checked) {
			alert("주문금액과 사용하실 포인트가 같으므로 결제방법을 전액포인트 결제로 선택해 주세요."); 
			document.user.gopaymethod[4].focus();
		    return false;
		}	
	    if (parseInt(document.user.coup2sale.value) > 0 || parseInt(document.user.coup3sale.value) > 0)	{
				alert("전액포인트결제는 쿠폰사용이 되지 않습니다."); 
				document.user.gopaymethod[4].checked = false;
		    return false;
	    }
	}
*/

	/* 사은품 값 초기화 */
	document.user.giftEventValue.value = "";
	
	/* 이벤트 오브젝트가 있을때만 실행 #################### 2014-08-12 ######################################## */
		var giftObj = jQuery("#giftDiv");
		//alert(giftObj.css("display"));
		
		var objselectDiv = jQuery(".giftClass");
		var boolselectDiv = jQuery("input:radio[name=giftEvent]:checked");

		if(giftObj.css("display") != "none") {
				if (objselectDiv.length) {
						if (boolselectDiv.length < 1) {
							alert("사은품을 선택해주세요");
							return false;							
						}
						else {
							document.user.giftEventValue.value = boolselectDiv.val();
						}
				}
		}
	/* 이벤트 오브젝트가 있을때만 실행 #################### 2014-08-12 ######################################## */

	/*'''LHS 2020-04-13 리니어사은품 오브젝트가 있을 때만 실행	######################S####################*/
		var giftObj = jQuery("#giftBox");
		//alert(giftObj.css("display"));
		
		var objselectDiv = jQuery(".list__gift2");
		var boolselectDiv = jQuery("input:radio[name=BonusGift]:checked");

		if(giftObj.css("display") != "none") {
				if (objselectDiv.length) {
						if (boolselectDiv.length < 1) {
							alert("사은품을 선택해주세요");
							return false;							
						}
						else {
							//document.user.giftEventValue.value = boolselectDiv.val();
						}
				}
		}
	/*'''LHS 2020-04-13 리니어사은품 오브젝트가 있을 때만 실행	######################E####################*/

	if ( document.user.use_rnd1.value != "ok" ) {
		if (!document.user.use_rnd1.checked) {
			alert("개인정보 수집 및 이용에 동의하셔야 주문가능합니다.");
			$("html, body").animate({ 
    		scrollTop: $("#privacyCheck").offset().top-200
			}, 10); 
			setTimeout(function(){$("#privacyCheck").focus();},0);
			document.user.use_rnd1.focus();
			return;
		}
	}	

	/* refund체크 오브젝트가 있을때만 실행 #################### 2020-08-24 ######################################## */
	/*
		var refundObj = jQuery("#refundCheck");
		if (refundObj.length > 0) {
			if (!document.user.use_rnd2.checked) {
				alert("환불불가에 동의하셔야 주문 가능합니다.");
				$("html, body").animate({ 
	    		scrollTop: $("#refundCheck").offset().top-200
				}, 10); 
				setTimeout(function(){$("#refundCheck").focus();},0);
				return;
			}
		}
	*/
	/* refund체크 오브젝트가 있을때만 실행 #################### 2020-08-24 ######################################## */

	document.user.OrderOZip.value = document.user.OrderDZip.value;
	document.user.OrderOAddress1.value = document.user.OrderDAddress1.value;
	document.user.OrderOAddress2.value = document.user.OrderDAddress2.value;
	document.user.OrderORoadAddress.value = document.user.OrderDRoadAddress.value;  

		form = document.user;
		radioBtn = form.gopaymethod;
		var bChecked = false;

		//오늘도착관련
		dangilBtn = form.deliveryOption;
		var dChecked = false;
		if(dangilBtn) {
			if (dangilBtn.length > 1) {
				for(i=0;i<dangilBtn.length;i++) {
					if(dangilBtn[i].checked) {
						dChecked = true;
					}
				}
			}
			else {
				if(dangilBtn.checked) {
					dChecked = true;
				}
			}
		}
		if (dChecked == false){
			alert("배송방법을 선택해주세요.");
			return false;
		}


		if(radioBtn) {
			if (radioBtn.length > 1) {
				for(i=0;i<radioBtn.length;i++) {
					if(radioBtn[i].checked) {
						bChecked = true;
					}
				}
			}
			else {
				if(radioBtn.checked) {
					bChecked = true;
				}
			}
			if(bChecked) {
				
				var radioValue = jQuery("input:radio[name='gopaymethod']:checked").val();				
				
						if (radioValue == "card") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("카드결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}
					
							changeToProcess();
							
							document.user.pay_type.value="card";
							document.user.method="post";
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "iniciskakao" || radioValue == "inicistoss" || radioValue == "inicispayco") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}
					
							changeToProcess();
							
							document.user.pay_type.value = radioValue;
							document.user.method = "post";
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}								
						else if (radioValue == "iche") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("이체금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}			
							
							changeToProcess();		
							
							document.user.method="post";	
							document.user.pay_type.value="iche";	
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}	
						else if (radioValue == "icheescrow") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("이체입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="icheescrow";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}						
						else if (radioValue == "escrow") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("무통장입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="escrow";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}									
						else if (radioValue == "bank") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("무통장입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="bank";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}
						else if (radioValue == "payco") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("휴대폰소액결제액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="payco";
							document.user.method="post";
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "point" ) {
							if (parseInt(document.user.totalpay.value) < 0) {
								alert("결제금액이 마이너스가 될 수는 없습니다."); 
						    return false;
							}
							if (parseInt(user.usemile.value) == parseInt(parseInt(user.totalpaytemp.value) - parseInt(user.transpay.value) - parseInt(user.coup1sale.value) - parseInt(user.coup2sale.value) - parseInt(user.coup3sale.value) - parseInt(user.coup4sale.value) - parseInt(user.coupcartsale.value)) )  {	
								changeToProcess();		
					
								document.user.method="post";	
								document.user.pay_type.value="point";	
								document.user.action = "/order/pay_behind.asp";
								document.user.target = "pFrame";
								document.user.submit();		
							}
							else {
								alert("전액적립금결제는 주문금액과 사용하실 적립금이\n같은 경우 사용이 가능합니다.");
								return false;
							}							
						}
						else if (radioValue == "smilepay") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
							
							document.user.pay_type.value="smilepay";
							document.user.method="post";
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "naverpay") {
							if (parseInt(document.user.totalpay.value) < 100) {
								alert("결제금액이 마이너스 또는 100원미만이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
							
							document.user.pay_type.value="naverpay";
							document.user.method="post";
							document.user.action = "/order/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "sunsoo" ) {
							if (parseInt(document.user.totalpay.value) < 0) {
								alert("결제금액이 마이너스가 될 수는 없습니다."); 
						    return false;
							}
							if (parseInt(user.usemile.value) == parseInt(parseInt(user.totalpaytemp.value) - parseInt(user.coup1sale.value) - parseInt(user.coup2sale.value) - parseInt(user.coup3sale.value) - parseInt(user.coupTsale.value)) )  {	
								changeToProcess();		
					
								document.user.method="post";	
								document.user.pay_type.value="sunsoo";	
								document.user.action = "/order/pay_behind.asp";
								document.user.target = "pFrame";
								document.user.submit();		
							}
							else {
								alert("후원금사용구매는 주문금액과 사용하실 후원사용금액이\n같은 경우 사용이 가능합니다.");
								return false;
							}							
						}
			}
			else {
				//alert("결제방법을 선택해 주세요.");
				window.scrollTo({
					top: document.querySelector('.odr-toggle-box .pay-method-box ul').offsetTop - 80,
					left: 0,
					behavior: 'smooth'
				});

				document.querySelector('.odr-toggle-box .pay-method-box ul').classList.add('_type_please');
				document.querySelector('.odr-toggle-box .pay-method-box ul').classList.add('_type_vibration');

				setTimeout(function() {
					document.querySelector('.odr-toggle-box .pay-method-box ul').classList.remove('_type_please');
					document.querySelector('.odr-toggle-box .pay-method-box ul').classList.remove('_type_vibration');
				}, 500);
				return false;
			}
		}
		else {
			//alert("결제방법을 선택해 주세요.");
			window.scrollTo({
				top: document.querySelector('.odr-toggle-box .pay-method-box ul').offsetTop - 80,
				left: 0,
				behavior: 'smooth'
			});

			document.querySelector('.odr-toggle-box .pay-method-box ul').classList.add('_type_please');
			document.querySelector('.odr-toggle-box .pay-method-box ul').classList.add('_type_vibration');

			setTimeout(function() {
				document.querySelector('.odr-toggle-box .pay-method-box ul').classList.remove('_type_please');
				document.querySelector('.odr-toggle-box .pay-method-box ul').classList.remove('_type_vibration');
			}, 500);
			return false;
		}

}

function pay_checkout_set() {
	var valiMail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	var email = document.user.OrderOEmail.value;
	
	if (jQuery("select[name=giftSize]").length > 0)	{
		for (var i = 0;i < jQuery("select[name=giftSize]").length; i++)	{
			if (jQuery("select[name=giftSize]").eq(i).val() == ""){
				alert("사은품의 사이즈를 선택해주세요.");
				jQuery("select[name=giftSize]").eq(i).focus();
				var offset = $(".gift-present").offset();
				$('html, body').animate({scrollTop : offset.top}, 0);
				return false;
			}
		}
	}
	if (jQuery("select[name=giftColor]").length > 0)	{
		for (var i = 0;i < jQuery("select[name=giftColor]").length; i++)	{
			if (jQuery("select[name=giftColor]").eq(0).val() == ""){
				alert("사은품의 색상을 선택해주세요.");
				jQuery("select[name=giftColor]").eq(i).focus();
				var offset = $(".gift-present").offset();
				$('html, body').animate({scrollTop : offset.top}, 0);
				return false;
			}
		}
	}

	if (document.user.OrderOName.value=="") {
		alert("주문자 성명을 입력하세요") ;
		document.user.OrderOName.focus() ;
		return false;
	}
	else if (document.user.OrderOTel21.value=="" || document.user.OrderOTel22.value=="" || document.user.OrderOTel23.value=="") {
		alert("주문자 휴대폰번호를 입력하세요") ;
		document.user.OrderOTel21.focus() ;
		return false;
	}
	else if (email == "") {
		alert("주문자 이메일 주소를 입력하세요") ;
		document.user.OrderOEmail.focus() ;
		return false;
	}	
	else if (document.user.OrderDName.value=="") {
		alert("수취인 성명을 입력하세요") ;
		document.user.OrderDName.focus() ;
		return false;
	}
	else if (document.user.OrderDZip.value=="") {
		alert("수취인 우편번호앞자리를 입력하세요") ;
		document.user.OrderDZip.focus() ;
		return false;
	}
	else if (document.user.OrderDAddress1.value=="" || document.user.OrderDAddress2.value=="") {
		alert("수취인 주소를 입력하세요") ;
		document.user.OrderDAddress2.focus() ;
		return false;
	}	
	else if (document.user.OrderDTel21.value=="" || document.user.OrderDTel22.value=="" || document.user.OrderDTel23.value=="") {
		alert("주문자 휴대폰번호를 입력하세요") ;
		document.user.OrderDTel21.focus() ;
		return false;
	}

	if (email == '' || !valiMail.test(email)) {
		alert("올바른 이메일 주소를 입력하세요");
		return false;
	}			

/*
	if (parseInt(document.user.usemile.value) == parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.transpay.value) - parseInt(document.user.coup1sale.value)) ) {
		if (!document.user.gopaymethod[4].checked) {
			alert("주문금액과 사용하실 포인트가 같으므로 결제방법을 전액포인트 결제로 선택해 주세요."); 
			document.user.gopaymethod[4].focus();
		    return false;
		}	
	    if (parseInt(document.user.coup2sale.value) > 0 || parseInt(document.user.coup3sale.value) > 0)	{
				alert("전액포인트결제는 쿠폰사용이 되지 않습니다."); 
				document.user.gopaymethod[4].checked = false;
		    return false;
	    }
	}
*/

	/* 사은품 값 초기화 */
	document.user.giftEventValue.value = "";
	
	/* 이벤트 오브젝트가 있을때만 실행 #################### 2014-08-12 ######################################## */
		var giftObj = jQuery("#giftDiv");
		//alert(giftObj.css("display"));
		
		var objselectDiv = jQuery(".giftClass");
		var boolselectDiv = jQuery("input:radio[name=giftEvent]:checked");

		if(giftObj.css("display") != "none") {
				if (objselectDiv.length) {
						if (boolselectDiv.length < 1) {
							alert("사은품을 선택해주세요");
							return false;							
						}
						else {
							document.user.giftEventValue.value = boolselectDiv.val();
						}
				}
		}
	/* 이벤트 오브젝트가 있을때만 실행 #################### 2014-08-12 ######################################## */

	/*'''LHS 2020-04-13 리니어사은품 오브젝트가 있을 때만 실행	######################S####################*/
		var giftObj = jQuery("#giftBox");
		//alert(giftObj.css("display"));
		
		var objselectDiv = jQuery(".list__gift2");
		var boolselectDiv = jQuery("input:radio[name=BonusGift]:checked");

		if(giftObj.css("display") != "none") {
				if (objselectDiv.length) {
						if (boolselectDiv.length < 1) {
							alert("사은품을 선택해주세요");
							return false;							
						}
						else {
							//document.user.giftEventValue.value = boolselectDiv.val();
						}
				}
		}
	/*'''LHS 2020-04-13 리니어사은품 오브젝트가 있을 때만 실행	######################E####################*/

	if ( document.user.use_rnd1.value != "ok" ) {
		if (!document.user.use_rnd1.checked) {
			alert("개인정보제공에 동의하셔야 주문 가능합니다.");
			$("html, body").animate({ 
    		scrollTop: $("#privacyCheck").offset().top-200
			}, 10); 
			setTimeout(function(){$("#privacyCheck").focus();},0);
			//document.user.use_rnd1.focus();
			return;
		}
	}	

	/* refund체크 오브젝트가 있을때만 실행 #################### 2020-08-24 ######################################## */
		var refundObj = jQuery("#refundCheck");
		if (refundObj.length > 0) {
			if (!document.user.use_rnd2.checked) {
				alert("환불불가에 동의하셔야 주문 가능합니다.");
				$("html, body").animate({ 
	    		scrollTop: $("#refundCheck").offset().top-200
				}, 10); 
				setTimeout(function(){$("#refundCheck").focus();},0);
				return;
			}
		}
	/* refund체크 오브젝트가 있을때만 실행 #################### 2020-08-24 ######################################## */

	document.user.OrderOZip.value = document.user.OrderDZip.value;
	document.user.OrderOAddress1.value = document.user.OrderDAddress1.value;
	document.user.OrderOAddress2.value = document.user.OrderDAddress2.value;
	document.user.OrderORoadAddress.value = document.user.OrderDRoadAddress.value;  

		form = document.user;
		radioBtn = form.gopaymethod;
		var bChecked = false;
		
		if(radioBtn) {
			if (radioBtn.length > 1) {
				for(i=0;i<radioBtn.length;i++) {
					if(radioBtn[i].checked) {
						bChecked = true;
					}
				}
			}
			else {
				if(radioBtn.checked) {
					bChecked = true;
				}
			}
			if(bChecked) {
				
				var radioValue = jQuery("input:radio[name='gopaymethod']:checked").val();				
				
						if (radioValue == "card") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("카드결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}
					
							changeToProcess();
							
							document.user.pay_type.value="card";
							document.user.method="post";
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "iniciskakao" || radioValue == "inicistoss") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}
					
							changeToProcess();
							
							document.user.pay_type.value = radioValue;
							document.user.method = "post";
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}								
						else if (radioValue == "iche") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("이체금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}			
							
							changeToProcess();		
							
							document.user.method="post";	
							document.user.pay_type.value="iche";	
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}	
						else if (radioValue == "icheescrow") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("이체입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="icheescrow";	
							document.user.method="post";		
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}						
						else if (radioValue == "escrow") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("무통장입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="escrow";	
							document.user.method="post";		
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}									
						else if (radioValue == "bank") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("무통장입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="bank";	
							document.user.method="post";		
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}
						else if (radioValue == "payco") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("휴대폰소액결제액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="payco";
							document.user.method="post";
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "point" ) {
							if (parseInt(document.user.totalpay.value) < 0) {
								alert("결제금액이 마이너스가 될 수는 없습니다."); 
						    return false;
							}
							if (parseInt(user.usemile.value) == parseInt(parseInt(user.totalpaytemp.value) - parseInt(user.transpay.value) - parseInt(user.coup1sale.value) - parseInt(user.coup2sale.value) - parseInt(user.coup3sale.value) - parseInt(user.coup4sale.value) - parseInt(user.coupcartsale.value)) )  {	
								changeToProcess();		
					
								document.user.method="post";	
								document.user.pay_type.value="point";	
								document.user.action = "/order_set/pay_behind.asp";
								document.user.target = "pFrame";
								document.user.submit();		
							}
							else {
								alert("전액적립금결제는 주문금액과 사용하실 적립금이\n같은 경우 사용이 가능합니다.");
								return false;
							}							
						}
						else if (radioValue == "smilepay") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
							
							document.user.pay_type.value="smilepay";
							document.user.method="post";
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "naverpay") {
							if (parseInt(document.user.totalpay.value) < 100) {
								alert("결제금액이 마이너스 또는 100원미만이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
							
							document.user.pay_type.value="naverpay";
							document.user.method="post";
							document.user.action = "/order_set/pay_behind.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
			}
			else {
				alert("결제방식을 선택해 주세요!");
				return false;
			}
		}
		else {
			alert("결제방식을 선택해 주세요!");
			return false;
		}

}

function pay_checkout_test() {
	var valiMail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	var email = document.user.OrderOEmail.value;
	
	if (jQuery("select[name=giftSize]").length > 0)	{
		for (var i = 0;i < jQuery("select[name=giftSize]").length; i++)	{
			if (jQuery("select[name=giftSize]").eq(i).val() == ""){
				alert("사은품의 사이즈를 선택해주세요.");
				jQuery("select[name=giftSize]").eq(i).focus();
				var offset = $(".gift-present").offset();
				$('html, body').animate({scrollTop : offset.top}, 0);
				return false;
			}
		}
	}
	if (jQuery("select[name=giftColor]").length > 0)	{
		for (var i = 0;i < jQuery("select[name=giftColor]").length; i++)	{
			if (jQuery("select[name=giftColor]").eq(0).val() == ""){
				alert("사은품의 색상을 선택해주세요.");
				jQuery("select[name=giftColor]").eq(i).focus();
				var offset = $(".gift-present").offset();
				$('html, body').animate({scrollTop : offset.top}, 0);
				return false;
			}
		}
	}

	if (document.user.OrderOName.value=="") {
		alert("주문자 성명을 입력하세요") ;
		document.user.OrderOName.focus() ;
		return false;
	}
	else if (document.user.OrderOTel21.value=="" || document.user.OrderOTel22.value=="" || document.user.OrderOTel23.value=="") {
		alert("주문자 휴대폰번호를 입력하세요") ;
		document.user.OrderOTel21.focus() ;
		return false;
	}
	else if (email == "") {
		alert("주문자 이메일 주소를 입력하세요") ;
		document.user.OrderOEmail.focus() ;
		return false;
	}	
	else if (document.user.OrderDName.value=="") {
		alert("수취인 성명을 입력하세요") ;
		document.user.OrderDName.focus() ;
		return false;
	}
	else if (document.user.OrderDZip.value=="") {
		alert("수취인 우편번호앞자리를 입력하세요") ;
		document.user.OrderDZip.focus() ;
		return false;
	}
	else if (document.user.OrderDAddress1.value=="" || document.user.OrderDAddress2.value=="") {
		alert("수취인 주소를 입력하세요") ;
		document.user.OrderDAddress2.focus() ;
		return false;
	}	
	else if (document.user.OrderDTel21.value=="" || document.user.OrderDTel22.value=="" || document.user.OrderDTel23.value=="") {
		alert("주문자 휴대폰번호를 입력하세요") ;
		document.user.OrderDTel21.focus() ;
		return false;
	}
	if (document.user.OrderOTel22.value.length > 4 ){
		alert("주문자 휴대폰번호를 입력하세요.");
		document.user.OrderOTel22.value = "";
		document.user.OrderOTel22.focus();
		return false;
	}
	if (document.user.OrderOTel23.value.length > 4 ){
		alert("주문자 휴대폰번호를 입력하세요.");
		document.user.OrderOTel23.value = "";
		document.user.OrderOTel23.focus();
		return false;
	}
	if (document.user.OrderDTel22.value.length > 4 ){
		alert("주문자 휴대폰번호를 입력하세요.");
		document.user.OrderDTel22.value = "";
		document.user.OrderDTel22.focus();
		return false;
	}
	if (document.user.OrderDTel23.value.length > 4 ){
		alert("주문자 휴대폰번호를 입력하세요.");
		document.user.OrderDTel23.value = "";
		document.user.OrderDTel23.focus();
		return false;
	}
	if (email == '' || !valiMail.test(email)) {
		alert("올바른 이메일 주소를 입력하세요");
		return false;
	}			
	//전화번호가 다른데는 등록이 됐는데 지역번호 등록이 안됐을 때
	 if (document.user.OrderDTel12.value != "" || document.user.OrderDTel13.value != ""){
		if (document.user.OrderDTel11.value == "" ) {
			alert("배송지 연락처를 입력하세요") ;
			document.user.OrderDTel11.focus() ;
			return false;
		}
		if (document.user.OrderDTel12.value.length > 4 ){
			alert("배송지 연락처를 입력해주세요.");
			document.user.OrderDTel12.value = "";
			document.user.OrderDTel12.focus();
			return false;
		}
		if (document.user.OrderDTel13.value.length > 4 ){
			alert("배송지 연락처를 입력해주세요.");
			document.user.OrderDTel13.value = "";
			document.user.OrderDTel13.focus();
			return false;
		}
	}
/*
	if (parseInt(document.user.usemile.value) == parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.transpay.value) - parseInt(document.user.coup1sale.value)) ) {
		if (!document.user.gopaymethod[4].checked) {
			alert("주문금액과 사용하실 포인트가 같으므로 결제방법을 전액포인트 결제로 선택해 주세요."); 
			document.user.gopaymethod[4].focus();
		    return false;
		}	
	    if (parseInt(document.user.coup2sale.value) > 0 || parseInt(document.user.coup3sale.value) > 0)	{
				alert("전액포인트결제는 쿠폰사용이 되지 않습니다."); 
				document.user.gopaymethod[4].checked = false;
		    return false;
	    }
	}
*/

	/* 사은품 값 초기화 */
	document.user.giftEventValue.value = "";
	
	/* 이벤트 오브젝트가 있을때만 실행 #################### 2014-08-12 ######################################## */
		var giftObj = jQuery("#giftDiv");
		//alert(giftObj.css("display"));
		
		var objselectDiv = jQuery(".giftClass");
		var boolselectDiv = jQuery("input:radio[name=giftEvent]:checked");

		if(giftObj.css("display") != "none") {
				if (objselectDiv.length) {
						if (boolselectDiv.length < 1) {
							alert("사은품을 선택해주세요");
							return false;							
						}
						else {
							document.user.giftEventValue.value = boolselectDiv.val();
						}
				}
		}
	/* 이벤트 오브젝트가 있을때만 실행 #################### 2014-08-12 ######################################## */

	/*'''LHS 2020-04-13 리니어사은품 오브젝트가 있을 때만 실행	######################S####################*/
		var giftObj = jQuery("#giftBox");
		//alert(giftObj.css("display"));
		
		var objselectDiv = jQuery(".list__gift2");
		var boolselectDiv = jQuery("input:radio[name=BonusGift]:checked");

		if(giftObj.css("display") != "none") {
				if (objselectDiv.length) {
						if (boolselectDiv.length < 1) {
							alert("사은품을 선택해주세요");
							return false;							
						}
						else {
							//document.user.giftEventValue.value = boolselectDiv.val();
						}
				}
		}
	/*'''LHS 2020-04-13 리니어사은품 오브젝트가 있을 때만 실행	######################E####################*/

	if ( document.user.use_rnd1.value != "ok" ) {
		if (!document.user.use_rnd1.checked) {
			alert("개인정보제공에 동의하셔야 주문 가능합니다.");
			$("html, body").animate({ 
    		scrollTop: $("#privacyCheck").offset().top-200
			}, 10); 
			setTimeout(function(){$("#privacyCheck").focus();},0);
			//document.user.use_rnd1.focus();
			return;
		}
	}	

	/* refund체크 오브젝트가 있을때만 실행 #################### 2020-08-24 ######################################## */
		var refundObj = jQuery("#refundCheck");
		if (refundObj.length > 0) {
			if (!document.user.use_rnd2.checked) {
				alert("환불불가에 동의하셔야 주문 가능합니다.");
				$("html, body").animate({ 
	    		scrollTop: $("#refundCheck").offset().top-200
				}, 10); 
				setTimeout(function(){$("#refundCheck").focus();},0);
				return;
			}
		}
	/* refund체크 오브젝트가 있을때만 실행 #################### 2020-08-24 ######################################## */

	document.user.OrderOZip.value = document.user.OrderDZip.value;
	document.user.OrderOAddress1.value = document.user.OrderDAddress1.value;
	document.user.OrderOAddress2.value = document.user.OrderDAddress2.value;
	document.user.OrderORoadAddress.value = document.user.OrderDRoadAddress.value;  

		form = document.user;
		radioBtn = form.gopaymethod;
		var bChecked = false;

		//오늘도착관련
		dangilBtn = form.deliveryOption;
		var dChecked = false;
		if(dangilBtn) {
			if (dangilBtn.length > 1) {
				for(i=0;i<dangilBtn.length;i++) {
					if(dangilBtn[i].checked) {
						dChecked = true;
					}
				}
			}
			else {
				if(dangilBtn.checked) {
					dChecked = true;
				}
			}
		}
		if (dChecked == false){
			alert("배송방법을 선택해주세요.");
			return false;
		}

		if(radioBtn) {
			if (radioBtn.length > 1) {
				for(i=0;i<radioBtn.length;i++) {
					if(radioBtn[i].checked) {
						bChecked = true;
					}
				}
			}
			else {
				if(radioBtn.checked) {
					bChecked = true;
				}
			}
			if(bChecked) {
				
				var radioValue = jQuery("input:radio[name='gopaymethod']:checked").val();				
				
						if (radioValue == "card") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("카드결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}
					
							changeToProcess();
							
							document.user.pay_type.value="card";
							document.user.method="post";
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "iniciskakao" || radioValue == "inicistoss") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}
					
							changeToProcess();
							
							document.user.pay_type.value = radioValue;
							document.user.method = "post";
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}								
						else if (radioValue == "iche") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("이체금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}			
							
							changeToProcess();		
							
							document.user.method="post";	
							document.user.pay_type.value="iche";	
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}	
						else if (radioValue == "icheescrow") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("이체입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="icheescrow";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}						
						else if (radioValue == "escrow") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("무통장입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="escrow";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}									
						else if (radioValue == "bank") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("무통장입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="bank";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}
						else if (radioValue == "payco") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("휴대폰소액결제액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="payco";
							document.user.method="post";
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "point" ) {
							if (parseInt(document.user.totalpay.value) < 0) {
								alert("결제금액이 마이너스가 될 수는 없습니다."); 
						    return false;
							}
							if (parseInt(user.usemile.value) == parseInt(parseInt(user.totalpaytemp.value) - parseInt(user.transpay.value) - parseInt(user.coup1sale.value) - parseInt(user.coup2sale.value) - parseInt(user.coup3sale.value) - parseInt(user.coupTsale.value)) )  {	
								changeToProcess();		
					
								document.user.method="post";	
								document.user.pay_type.value="point";	
								document.user.action = "/order/pay_behind_test.asp";
								document.user.target = "pFrame";
								document.user.submit();		
							}
							else {
								alert("전액적립금결제는 주문금액과 사용하실 적립금이\n같은 경우 사용이 가능합니다.");
								return false;
							}							
						}
						else if (radioValue == "smilepay") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
							
							document.user.pay_type.value="smilepay";
							document.user.method="post";
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "naverpay") {
							if (parseInt(document.user.totalpay.value) < 100) {
								alert("결제금액이 마이너스 또는 100원미만이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
							
							document.user.pay_type.value="naverpay";
							document.user.method="post";
							document.user.action = "/order/pay_behind_test.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "sunsoo" ) {
							if (parseInt(document.user.totalpay.value) < 0) {
								alert("결제금액이 마이너스가 될 수는 없습니다."); 
						    return false;
							}
							if (parseInt(user.usemile.value) == parseInt(parseInt(user.totalpaytemp.value) - parseInt(user.transpay.value) - parseInt(user.coup1sale.value) - parseInt(user.coup2sale.value) - parseInt(user.coup3sale.value) - parseInt(user.coupTsale.value)) )  {	
								changeToProcess();		
					
								document.user.method="post";	
								document.user.pay_type.value="sunsoo";	
								document.user.action = "/order/pay_behind_test.asp";
								document.user.target = "pFrame";
								document.user.submit();		
							}
							else {
								alert("전액적립금결제는 주문금액과 사용하실 적립금이\n같은 경우 사용이 가능합니다.");
								return false;
							}							
						}
			}
			else {
				alert("결제방식을 선택해 주세요!");
				return false;
			}
		}
		else {
			alert("결제방식을 선택해 주세요!");
			return false;
		}

}


function pay_checkout_kit() {

	if ( document.user.use_rnd2[0].value != "ok" ) {
		if (!document.user.use_rnd2[0].checked) {
			alert("서비스 이용약관에 동의하셔야 주문 가능합니다.");
			$("html, body").animate({ 
    		scrollTop: $("#use_rnd2").offset().top-200
			}, 10); 
			setTimeout(function(){$("#use_rnd2").focus();},0);
			//document.user.use_rnd1.focus();
			return;
		}
	}

	var valiMail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	var email = document.user.OrderOEmail.value;
	
	if (jQuery("select[name=kitSize]").length > 0)	{
		for (var i = 0;i < jQuery("select[name=kitSize]").length; i++)	{
			if (jQuery("select[name=kitSize]").eq(i).val() == "" || jQuery("select[name=kitSize]").eq(i).val() == null){
				alert("사은품의 사이즈를 선택해주세요.");
				jQuery("select[name=kitSize]").eq(i).focus();
				var offset = $(".gift-present").offset();
				$('html, body').animate({scrollTop : offset.top}, 0);
				return false;
			}
		}
	}
	if (jQuery("select[name=kitColor]").length > 0)	{
		for (var i = 0;i < jQuery("select[name=kitColor]").length; i++)	{
			if (jQuery("select[name=kitColor]").eq(0).val() == "" || jQuery("select[name=kitColor]").eq(i).val() == null){
				alert("사은품의 색상을 선택해주세요.");
				jQuery("select[name=kitColor]").eq(i).focus();
				var offset = $(".gift-present").offset();
				$('html, body').animate({scrollTop : offset.top}, 0);
				return false;
			}
		}
	}

	if (document.user.OrderOName.value=="") {
		alert("주문자 성명을 입력하세요") ;
		document.user.OrderOName.focus() ;
		return false;
	}
	else if (document.user.OrderOTel21.value=="" || document.user.OrderOTel22.value=="" || document.user.OrderOTel23.value=="") {
		alert("주문자 휴대폰번호를 입력하세요") ;
		document.user.OrderOTel21.focus() ;
		return false;
	}
	else if (email == "") {
		alert("주문자 이메일 주소를 입력하세요") ;
		document.user.OrderOEmail.focus() ;
		return false;
	}	
	else if (document.user.OrderDName.value=="") {
		alert("수취인 성명을 입력하세요") ;
		document.user.OrderDName.focus() ;
		return false;
	}
	else if (document.user.OrderDZip.value=="") {
		alert("수취인 우편번호앞자리를 입력하세요") ;
		document.user.OrderDZip.focus() ;
		return false;
	}
	else if (document.user.OrderDAddress1.value=="" || document.user.OrderDAddress2.value=="") {
		alert("수취인 주소를 입력하세요") ;
		document.user.OrderDAddress2.focus() ;
		return false;
	}	
	else if (document.user.OrderDTel21.value=="" || document.user.OrderDTel22.value=="" || document.user.OrderDTel23.value=="") {
		alert("주문자 휴대폰번호를 입력하세요") ;
		document.user.OrderDTel21.focus() ;
		return false;
	}

	if (email == '' || !valiMail.test(email)) {
		alert("올바른 이메일 주소를 입력하세요");
		return false;
	}			

/*
	if (parseInt(document.user.usemile.value) == parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.transpay.value) - parseInt(document.user.coup1sale.value)) ) {
		if (!document.user.gopaymethod[4].checked) {
			alert("주문금액과 사용하실 포인트가 같으므로 결제방법을 전액포인트 결제로 선택해 주세요."); 
			document.user.gopaymethod[4].focus();
		    return false;
		}	
	    if (parseInt(document.user.coup2sale.value) > 0 || parseInt(document.user.coup3sale.value) > 0)	{
				alert("전액포인트결제는 쿠폰사용이 되지 않습니다."); 
				document.user.gopaymethod[4].checked = false;
		    return false;
	    }
	}
*/

	/* 사은품 값 초기화 */
	document.user.giftEventValue.value = "";
	
	/* 이벤트 오브젝트가 있을때만 실행 #################### 2014-08-12 ######################################## */
		var giftObj = jQuery("#giftDiv");
		//alert(giftObj.css("display"));
		
		var objselectDiv = jQuery(".giftClass");
		var boolselectDiv = jQuery("input:radio[name=giftEvent]:checked");

		if(giftObj.css("display") != "none") {
				if (objselectDiv.length) {
						if (boolselectDiv.length < 1) {
							alert("사은품을 선택해주세요");
							return false;							
						}
						else {
							document.user.giftEventValue.value = boolselectDiv.val();
						}
				}
		}
	/* 이벤트 오브젝트가 있을때만 실행 #################### 2014-08-12 ######################################## */


	if ( document.user.use_rnd1.value != "ok" ) {
		if (!document.user.use_rnd1.checked) {
			alert("개인정보제공에 동의하셔야 주문 가능합니다.");
			$("html, body").animate({ 
    		scrollTop: $("#privacyCheck").offset().top-200
			}, 10); 
			setTimeout(function(){$("#privacyCheck").focus();},0);
			//document.user.use_rnd1.focus();
			return;
		}
	}	

	document.user.OrderOZip.value = document.user.OrderDZip.value;
	document.user.OrderOAddress1.value = document.user.OrderDAddress1.value;
	document.user.OrderOAddress2.value = document.user.OrderDAddress2.value;
	document.user.OrderORoadAddress.value = document.user.OrderDRoadAddress.value;  

		form = document.user;
		radioBtn = form.gopaymethod;
		var bChecked = false;
		
		if(radioBtn) {
			if (radioBtn.length > 1) {
				for(i=0;i<radioBtn.length;i++) {
					if(radioBtn[i].checked) {
						bChecked = true;
					}
				}
			}
			else {
				if(radioBtn.checked) {
					bChecked = true;
				}
			}
			if(bChecked) {
				
				var radioValue = jQuery("input:radio[name='gopaymethod']:checked").val();				
				
						if (radioValue == "card") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("카드결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}
					
							changeToProcess();
							
							document.user.pay_type.value="card";
							document.user.method="post";
							document.user.action = "/order/pay_behind_kit.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "iche") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("이체금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}			
							
							changeToProcess();		
							
							document.user.method="post";	
							document.user.pay_type.value="iche";	
							document.user.action = "/order/pay_behind_kit.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}	
						else if (radioValue == "icheescrow") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("이체입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="icheescrow";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind_kit.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}						
						else if (radioValue == "escrow") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("무통장입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="escrow";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind_kit.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}									
						else if (radioValue == "bank") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("무통장입금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="bank";	
							document.user.method="post";		
							document.user.action = "/order/pay_behind_kit.asp";
							document.user.target = "pFrame";		
							document.user.submit();		
						}
						else if (radioValue == "payco") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("휴대폰소액결제액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
									
							document.user.pay_type.value="payco";
							document.user.method="post";
							document.user.action = "/order/pay_behind_kit.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "point" ) {
							if (parseInt(document.user.totalpay.value) < 0) {
								alert("결제금액이 마이너스가 될 수는 없습니다."); 
						    return false;
							}
							if (parseInt(user.usemile.value) == parseInt(parseInt(user.totalpaytemp.value) - parseInt(user.transpay.value) - parseInt(user.coup1sale.value) - parseInt(user.coup2sale.value) - parseInt(user.coup3sale.value) - parseInt(user.coup4sale.value) - parseInt(user.coupcartsale.value)) )  {	
								changeToProcess();		
					
								document.user.method="post";	
								document.user.pay_type.value="point";	
								document.user.action = "/order/pay_behind_kit.asp";
								document.user.target = "pFrame";
								document.user.submit();		
							}
							else {
								alert("전액적립금결제는 주문금액과 사용하실 적립금이\n같은 경우 사용이 가능합니다.");
								return false;
							}							
						}
						else if (radioValue == "smilepay") {
							if (parseInt(document.user.totalpay.value) <= 0) {
								alert("결제금액이 마이너스 또는 0원이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
							
							document.user.pay_type.value="smilepay";
							document.user.method="post";
							document.user.action = "/order/pay_behind_kit.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
						else if (radioValue == "naverpay") {
							if (parseInt(document.user.totalpay.value) < 100) {
								alert("결제금액이 마이너스 또는 100원미만이 될 수는 없습니다."); 
							    return false;
							}		
							
							changeToProcess();
							
							document.user.pay_type.value="naverpay";
							document.user.method="post";
							document.user.action = "/order/pay_behind_kit.asp";
							document.user.target = "pFrame";
							document.user.submit();		
						}
			}
			else {
				alert("결제방식을 선택해 주세요!");
				return false;
			}
		}
		else {
			alert("결제방식을 선택해 주세요!");
			return false;
		}

}


function order_check3(){
	//alert(document.iniForm.totalpay.value);
	//alert(document.iniForm.totalprice.value);
	//alert(document.iniForm.usemile.value);
	//alert(document.iniForm.transpay.value);
	
	if (confirm("전액포인트결제로 주문하시겠습니까?"))
	{
		changeToProcess();	
	
		document.iniForm.method="post";	
		document.iniForm.pay_type.value=3;				//// 1신용카드 2무통장입금 3전액포인트 4계좌이체 5에스크로 /////
		document.iniForm.action = "/order/put_db.asp";
		document.iniForm.submit();
	}	
}
function order_check13(){
	//alert(document.iniForm.totalpay.value);
	//alert(document.iniForm.totalprice.value);
	//alert(document.iniForm.usemile.value);
	//alert(document.iniForm.transpay.value);
	
	if (confirm("선수기증쿠폰으로 주문하시겠습니까?"))
	{
		changeToProcess();	
	
		document.iniForm.method="post";	
		document.iniForm.pay_type.value=13;				//// 1신용카드 2무통장입금 3전액포인트 4계좌이체 5에스크로 /////
		document.iniForm.action = "/order/put_sunsoo.asp";
		document.iniForm.submit();
	}	
}

function order_checkTEST(){
		changeToProcess();	
	
		document.iniForm.method="post";	
		document.iniForm.pay_type.value=2;				//// 1신용카드 2무통장입금 3전액포인트 4계좌이체 5에스크로 /////
		document.iniForm.action = "/order/put_test.asp";
		document.iniForm.submit();
}

function allwishCheck(checkeds) {
    var obj = document.getElementsByName('cartcheck');
    for (i = 0; i < obj.length; i++) {
        obj[i].checked = checkeds;
    }
}
function allCheckControl() {
    var obj = document.getElementById('checkCon');
    obj.checked = false;
}
function CheckedBuy() {
	form = document.form1;
	checkbox = form.checkwish;
	var nIdx = 0;
	var bChecked = false;
	var pids="";
	
	if(checkbox) {
		if (checkbox.length > 1) {
			for(i=0;i<checkbox.length;i++) {
				if(checkbox[i].checked) {
					bChecked = true;
					pids+=checkbox[i].value+"|";
				}
			}
		}
		else {
			if(checkbox.checked) {
				bChecked = true;
				pids+=checkbox.value+"|";
			}
		}
	
		if(bChecked) {
				var val = "checkedbuy";
				var strQuery;
		
				strQuery = "";
				strQuery = jQuery(":input",document.form1).serialize();
						
				jQuery.ajax({
					type: "POST",
					data: "mode="+ val + "&checkwish=" + pids + "&" + new Date().getTime(),
					url: "/product/put_cart_behind.asp",
					dataType : "JSON",
					success: function(data) {
						codetype = data.codetype;
						msg = data.msg;
						returnurl = data.returnurl;
		
						if (msg !="") { alert(msg); }
						if (returnurl !="") { 
							top.location.href=returnurl; 
						}
						else {
							top.location.reload();
						}
					},
					error: function(e) {
						//alert("e");
					}
				});
		}
		else {
			alert("상품을 선택하세요"); return;
		}
	}
	else {
		alert('상품이 없습니다.');
		return;
	}
}
//maFila용
function CheckedBuyCustom(){
		form = document.form1;
	checkbox = form.checkwish;
	var nIdx = 0;
	var bChecked = false;
	var pids="";
	
	if(checkbox) {
		if (checkbox.length > 1) {
			for(i=0;i<checkbox.length;i++) {
				if(checkbox[i].checked) {
					bChecked = true;
					pids+=checkbox[i].value+"|";
				}
			}
		}
		else {
			if(checkbox.checked) {
				bChecked = true;
				pids+=checkbox.value+"|";
			}
		}
	
		if(bChecked) {
				var val = "checkedbuyCustom";
				var strQuery;
		
				strQuery = "";
				strQuery = jQuery(":input",document.form1).serialize();
						
				jQuery.ajax({
					type: "POST",
					data: "mode="+ val + "&checkwish=" + pids + "&" + new Date().getTime(),
					url: "/product/put_cart_behind.asp",
					dataType : "JSON",
					success: function(data) {
						codetype = data.codetype;
						msg = data.msg;
						returnurl = data.returnurl;
		
						if (msg !="") { alert(msg); }
						if (returnurl !="") { 
							top.location.href=returnurl; 
						}
						else {
							top.location.reload();
						}
					},
					error: function(e) {
						//alert("e");
					}
				});
		}
		else {
			alert("상품을 선택하세요"); return;
		}
	}
	else {
		alert('상품이 없습니다.');
		return;
	}
}

function CheckedAllBuy(f){ 
//	CheckedAllClear(f);	
//	var checkItem = f.checkwish; 
//	if(checkItem) {
//		if (checkItem.length > 1) {	
//			for(i=0;i<checkItem.length;i++){ 
//				if(checkItem[i].checked) {
//					checkItem[i].checked=false; 
//				}
//				else {
//					checkItem[i].checked=true; 
//				}
//			}
//		}
//		else {
//			if(checkItem.checked) {
//				checkItem.checked=false; 
//			}
//			else {
//				checkItem.checked=true; 
//			}
//		}
//	}
	if(jQuery("#todayDeliView").is(":checked")){
		jQuery(".todaydelichk").prop("checked",true);
	}else{
		jQuery("input[name=checkwish]").prop("checked",true);
	}
	CheckedBuy();
}

function CheckedAllBuyCustom(f){
	jQuery("input[name=checkwish]").prop("checked",true);
	CheckedBuyCustom();
}

function CheckBuyOne(f,tval) {
	CheckedAllClear(f);

	var pids = tval;

	var val = "buyone";
	var strQuery;

	strQuery = "";
	strQuery = jQuery(":input",document.form1).serialize();
			
	jQuery.ajax({
		type: "POST",
		data: "mode="+ val + "&checkwish=" + pids +"|"+ "&" + new Date().getTime(),
		url: "/product/put_cart_behind.asp",
		dataType : "JSON",
		success: function(data) {
			codetype = data.codetype;
			msg = data.msg;
			returnurl = data.returnurl;

			if (msg !="") { alert(msg); }
			if (returnurl !="") { 
				top.location.href=returnurl; 
			}
			else {
				top.location.reload();
			}
		},
		error: function(e) {
			//alert("e");
		}
	});
}

function CheckBuyOneCustom(f,tval) {
	CheckedAllClear(f);

	var pids = tval;

	var val = "buyoneCustom";
	var strQuery;

	strQuery = "";
	strQuery = jQuery(":input",document.form1).serialize();
			
	jQuery.ajax({
		type: "POST",
		data: "mode="+ val + "&checkwish=" + pids +"|"+ "&" + new Date().getTime(),
		url: "/product/put_cart_behind.asp",
		dataType : "JSON",
		success: function(data) {
			codetype = data.codetype;
			msg = data.msg;
			returnurl = data.returnurl;

			if (msg !="") { alert(msg); }
			if (returnurl !="") { 
				top.location.href=returnurl; 
			}
			else {
				top.location.reload();
			}
		},
		error: function(e) {
			//alert("e");
		}
	});
}

function CheckBuyOneSet(tval){
	var val = "buyoneSet";
	var strQuery;

	var pids = "";
	//alert(tval)
	jQuery("." + tval + ":checked").each(function(){
		
		pids += this.value + "|";
	})


	jQuery.ajax({
		type: "POST",
		data: "mode="+ val + "&checkwish=" + pids + "&" + new Date().getTime(),
		url: "/product/put_cart_behind.asp",
		dataType : "JSON",
		success: function(data) {
			codetype = data.codetype;
			msg = data.msg;
			returnurl = data.returnurl;

			if (msg !="") { alert(msg); }
			if (returnurl !="") { 
				top.location.href=returnurl; 
			}
			else {
				top.location.reload();
			}
		},
		error: function(e) {
			//alert("e");
		}
	});

}

function cart_actionSet(val,val2,val3) {
		var strQuery;
		strQuery = "";
		strQuery = jQuery(":input",document.form1).serialize();
				
		jQuery.ajax({
			type: "POST",
			data: "mode="+ val + "&SetCartNo=" + val2 + "&ProductSize=" + val3 + "&" + new Date().getTime(),
			url: "/product/put_cart_behind.asp",
			dataType : "JSON",
			success: function(data) {
				codetype = data.codetype;
				msg = data.msg;
				returnurl = data.returnurl;

				if (msg !="") { alert(msg); }
				if (returnurl !="") { 
					top.location.href=returnurl; 
				}
				else {
					top.location.reload();
				}
			},
			error: function(e) {
				//alert("e");
			}
		});
}
/*
function cart_action(val,val2,val3) {
		var strQuery;
		strQuery = "";
		strQuery = jQuery(":input",document.form1).serialize();
				
		jQuery.ajax({
			type: "POST",
			data: "mode="+ val + "&ProductNo=" + val2 + "&ProductSize=" + val3 + "&" + new Date().getTime(),
			url: "/product/put_cart_behind.asp",
			dataType : "JSON",
			success: function(data) {
				codetype = data.codetype;
				msg = data.msg;
				returnurl = data.returnurl;

				if (msg !="") { alert(msg); }
				if (returnurl !="") { 
					top.location.href=returnurl; 
				}
				else {
					top.location.reload();
				}
			},
			error: function(e) {
				//alert("e");
			}
		});
}
*/
function cart_action(val,val2,val3) {
		var strQuery;
		strQuery = "";
		/* strQuery = jQuery(":input",document.form1).serialize(); 
			dataFrame.location.href = "/product/put_cart_log.asp?mode="+ val + "&ProductNo=" + val2 + "&ProductSize=" + val3 + "&" + new Date().getTime(); */
		strQuery = "mode="+ val + "&ProductNo=" + val2 + "&ProductSize=" + val3 + "&" + new Date().getTime();
		//dataFrame.location.replace("/product/put_cart_log.asp?"+ strQuery);

			jQuery.ajax({
				type: "POST",
				data: strQuery,
				url: "/product/put_cart_log.asp",
				dataType : "HTML",
				success: function(data) {
					jQuery("#cartlog").html(data);
					//jQuery("#cartlog").empty();
				},
				error: function(e) {
					//alert("e");
				}
			});	

		jQuery.ajax({
			type: "POST",
			data: "mode="+ val + "&ProductNo=" + val2 + "&ProductSize=" + val3 + "&" + new Date().getTime(),
			url: "/product/put_cart_behind.asp",
			dataType : "JSON",
			success: function(data) {
				codetype = data.codetype;
				msg = data.msg;
				returnurl = data.returnurl;

				setTimeout(function(){
					if (msg !="") { alert(msg); }
					if (returnurl !="") { 
						top.location.href=returnurl; 
					}
					else {
						top.location.reload();
					}
				},100);

			},
			error: function(e) {
				//alert("e");
			}
		});
}

function cart_recal() {
	var strQuery;
	var val = "recalculate";
	strQuery = "";
	strQuery = jQuery(":input",document.form1).serialize();
			
	jQuery.ajax({
		type: "POST",
		data: "mode="+ val + "&" + strQuery + "&" + new Date().getTime(),		
		url: "/product/put_cart_behind.asp",
		dataType : "JSON",
		success: function(data) {
			codetype = data.codetype;
			msg = data.msg;
			returnurl = data.returnurl;

			codetype = data.codetype;
			msg = data.msg;
			returnurl = data.returnurl;

			if (msg !="") { alert(msg); }
			if (returnurl !="") { 
				top.location.href=returnurl; 
			}
			else {
				top.location.reload();
			}
		},
		error: function(e) {
			//alert("e");
		}
	});	
}

function cart_resize(no) {
	var val = "resize";

	var tempVal = jQuery("#selectSize"+no).val();
	var pno = jQuery("#selectSize"+no).attr("data-pno");
	var qty = jQuery("#selectSize"+no).attr("data-qty");	
	var osize = jQuery("#selectSize"+no).attr("data-size");		
	var scNo = jQuery("#selectSize"+no).attr("data-setCartNo");		

	if (tempVal == osize) {
		alert("장바구니에 담긴 사이즈와 동일한 사이즈를 선택하셨습니다.");
		return;
	}
	
	jQuery.ajax({
		type: "POST",
		data: "mode="+ val + "&ProductNo="+ pno + "&ProductSize="+ tempVal + "&ProductQuantity="+ qty + "&SetCartNo=" + scNo + "&nowSize="+ osize + "&" + new Date().getTime(),		
		url: "/product/put_cart_behind.asp",
		dataType : "JSON",
		success: function(data) {
			codetype = data.codetype;
			msg = data.msg;
			returnurl = data.returnurl;

			codetype = data.codetype;
			msg = data.msg;
			returnurl = data.returnurl;

			if (msg !="") { alert(msg); }
			if (returnurl !="") { 
				top.location.href=returnurl; 
			}
			else {
				top.location.reload();
			}
		},
		error: function(e) {
			//alert("e");
		}
	});	
}

function CheckedAll(f){ 
	var checkItem = f.cartcheck; 
	if(checkItem)
	{
		if (checkItem.length > 1)
		{	
			for(i=0;i<checkItem.length;i++){ 
				if(checkItem[i].checked)
				{
					checkItem[i].checked=false; 
				}
				else
				{
					checkItem[i].checked=true; 
				}
			}
		}
		else
		{
			if(checkItem.checked)
			{
				checkItem.checked=false; 
			}
			else
			{
				checkItem.checked=true; 
			}
		}
	}
}

function CheckedAllClear(f){ 
	var checkItem = f.cartcheck; 
	if(checkItem) {
		if (checkItem.length > 1) {	
			for(i=0;i<checkItem.length;i++){ 
				checkItem[i].checked=false; 
			}
		}
		else {
			checkItem.checked=false; 
		}
	}
}

function CheckedCart()
{
	form = document.form1;
	checkbox = form.cartcheck;
	var nIdx = 0;
	var bChecked = false;
	var pids="";
	
	if(checkbox)
	{
		if (checkbox.length > 1)
		{
			for(i=0;i<checkbox.length;i++)
			{
				if(checkbox[i].checked)
				{
					bChecked = true;
					pids+=checkbox[i].value+"|";
				}
			}
		}
		else
		{
			if(checkbox.checked)
			{
				bChecked = true;
				pids+=checkbox.value+"|";
			}
		}
	
		if(bChecked)
		{
			form.checkwish.value = pids;			
			form.action="/product/checkwish_cart.asp";
			form.method="post";
			form.target="dataFrame";
			form.submit();
	
			return true;		
		}
		else
		{
			alert("상품을 선택하세요"); return;
		}
	}
	else
	{
		alert('상품이 없습니다.');
		return;
	}
}

function CheckedDel() {
	form = document.form1;
	checkbox = form.checkwish;
	var nIdx = 0;
	var bChecked = false;
	var pids="";
	
	if(checkbox) {
		if (checkbox.length > 1) {
			for(i=0;i<checkbox.length;i++) {
				if(checkbox[i].checked) {
					bChecked = true;
					pids+=checkbox[i].value+"|";
				}
			}
		}
		else {
			if(checkbox.checked) {
				bChecked = true;
				pids+=checkbox.value+"|";
			}
		}
	
		if(bChecked) {
				var val = "checkeddel";
				var strQuery;
		
				strQuery = "";
				//strQuery = jQuery(":input",document.form1).serialize();
				strQuery = "mode="+ val + "&checkwish=" + pids + "&" + new Date().getTime();
				//dataFrame.location.replace("/product/put_cart_log.asp?"+ strQuery);				
				jQuery.ajax({
					type: "POST",
					data: strQuery,
					url: "/product/put_cart_log.asp",
					dataType : "HTML",
					success: function(data) {
						jQuery("#cartlog").html(data);
						//jQuery("#cartlog").empty();
					},
					error: function(e) {
						//alert("e");
					}
				});					
						
				jQuery.ajax({
					type: "POST",
					data: "mode="+ val + "&checkwish=" + pids + "&" + new Date().getTime(),
					url: "/product/put_cart_behind.asp",
					dataType : "JSON",
					success: function(data) {
						codetype = data.codetype;
						msg = data.msg;
						returnurl = data.returnurl;

						setTimeout(function(){
							if (msg !="") { alert(msg); }
							if (returnurl !="") { 
								top.location.href=returnurl; 
							}
							else {
								top.location.reload();
							}
						},100);
		

					},
					error: function(e) {
						//alert("e");
					}
				});						
		}
		else {
			alert("상품을 선택하세요"); return;
		}
	}
	else {
		alert('상품이 없습니다.');
		return;
	}
}

function CheckedSoldOut(){
		var val = "soldout";
		var strQuery;

		strQuery = "";
		strQuery = jQuery(":input",document.form1).serialize();

		jQuery.ajax({
			type: "POST",
			data: "mode="+ val + "&" + strQuery + "&" + new Date().getTime(),
			url: "/product/put_cart_behind.asp",
			dataType : "JSON",
			success: function(data) {
				codetype = data.codetype;
				msg = data.msg;
				returnurl = data.returnurl;

				if (msg !="") { alert(msg); }
				if (returnurl !="") { 
					top.location.href=returnurl; 
				}
				else {
					top.location.reload();
				}
			},
			error: function(e) {
				//alert("e");
			}
		});
}

function CheckedWish() {
	form = document.form1;
	checkbox = form.checkwish;
	var nIdx = 0;
	var bChecked = false;
	var pids="";
	
	if(checkbox) {
		if (checkbox.length > 1) {
			for(i=0;i<checkbox.length;i++) {
				if(checkbox[i].checked) {
					bChecked = true;
					pids+=checkbox[i].value+"|";
				}
			}
		}
		else {
			if(checkbox.checked) {
				bChecked = true;
				pids+=checkbox.value+"|";
			}
		}
	
		if(bChecked) {
				var val = "checkedwish";
				var strQuery;
		
				strQuery = "";
				strQuery = jQuery(":input",document.form1).serialize();
						
				jQuery.ajax({
					type: "POST",
					data: "mode="+ val + "&checkwish=" + pids + "&" + new Date().getTime(),
					url: "/product/put_cart_behind.asp",
					dataType : "JSON",
					success: function(data) {
						codetype = data.codetype;
						msg = data.msg;
						returnurl = data.returnurl;
		
						if (msg !="") { alert(msg); }
						if (returnurl !="") { 
							top.location.href=returnurl; 
						}
						else {
							top.location.reload();
						}
					},
					error: function(e) {
						//alert("e");
					}
				});			
		}
		else {
			alert("상품을 선택하세요"); return;
		}
	}
	else {
		alert('상품이 없습니다.');
		return;
	}
}

function pay_result(val) {	
	document.getElementById("total_price").innerHTML = PrintComma(document.ini.totalprice.value);
	document.getElementById("total_delivery").innerHTML = PrintComma(document.ini.transpay.value);	
	if(document.ini.usemile.value=="")
	{
		document.getElementById("total_mile").innerHTML = 0;
	}
	else
	{
		document.getElementById("total_mile").innerHTML = PrintComma(document.ini.usemile.value);	
	}
	if(document.ini.OrderUseCouponPrice.value=="")
	{
		document.getElementById("total_coupon").innerHTML = 0;
	}
	else
	{
		document.getElementById("total_coupon").innerHTML = PrintComma(document.ini.OrderUseCouponPrice.value);	
	}	
	document.getElementById("total_pay").innerHTML = PrintComma(document.ini.totalpay.value);		
	if(val==2)
	{
		document.getElementById("total_pay2").innerHTML = PrintComma(document.ini.totalpay.value);			
	}
}

function is_check0(){
	if (document.user.m_usecheck.checked == true){
			user.usemile.readOnly = false; 
			user.usemile.value = ""; 
			
			if (parseInt(document.user.usemiletemp.value) != 0 ) {
				if (parseInt(document.user.usemiletemp.value) < parseInt(document.user.minPoint.value) ) {
					alert("포인트는 " + PrintComma(document.user.minPoint.value) +"원 이상부터 사용 가능합니다.");
					user.m_usecheck.checked = false;
					user.usemile.value="";
					return;
				}	
			}
			
			user.usemile.focus();
			recalc_pay();
			//recalc_gift();
			
	 }
	 else{
			user.usemile.readOnly = true; 
			user.usemile.value = ""; 
			recalc_pay();
			//recalc_gift();
	 }				
}

function PriceProcess(Price) {
	return (Math.round(Price/100-0.5))*100
}

function is_check1(radio){
	var CouponArray = radio.value.split(",");
	var CouponNo = Math.round(CouponArray[0]);
	var CouponPrice = PriceProcess(Math.round(CouponArray[1]));
	document.user.OrderUseCoupon.value = CouponNo;
	document.user.OrderUseCouponPrice.value = CouponPrice;
	recalc_pay();
	//recalc_gift();
}

function is_check0_ALL(){
	var tempMile = document.user.usemiletemp.value;
	tempMile = Math.floor(tempMile / 10) * 10;
	
	if ( parseInt(document.user.totalpay.value) < parseInt(document.user.usemiletemp.value) ) {
		// 사용 금액이 더 크면	
		document.user.usemile.value = parseInt(document.user.totalpay.value) - parseInt(document.user.transpay.value);
	} else {

		document.user.usemile.value = tempMile;

		if ( parseInt(document.user.totalpaytemp.value) < parseInt(document.user.usemile.value)  ) {

			document.user.usemile.value = parseInt(document.user.totalpaytemp.value);
		}

	}
	pay_change0();
}

function pay_change0(){

	var strpay,strcnt;
	strpay = document.user.usemile.value;
	strcnt = strpay.length

	//if (document.user.m_usecheck.checked) {	
		
			if (parseInt(document.user.usemile.value) != 0 ) {
				if (parseInt(document.user.usemile.value) < parseInt(document.user.minPoint.value) ) {
					alert("포인트는 " + PrintComma(document.user.minPoint.value) +"원 이상부터 사용 가능합니다.");
					user.usemile.value="";		
					user.usemile.focus();
				}	
			}
		
			if (parseInt(document.user.usemile.value) < 0) {
				alert("사용하실 포인트를 정상적으로 입력 해 주세요"); 
				user.usemile.value="";
				strpay = 0;
			}
			
			if (parseInt(document.user.usemile.value) > parseInt(document.user.usemiletemp.value)) {
				alert("현재 보유 포인트를 초과하였습니다.\n사용 가능한 포인트는 " + PrintComma(document.user.usemiletemp.value) + "입니다."); 
				user.usemile.value="";
				strpay = 0;
			}
			
			if (parseInt(document.user.usemile.value) > parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.OrderUseCouponPrice.value)) ) {
				alert("사용하실 포인트가 주문금액보다 많습니다.\n(배송비는 포인트 사용이 불가합니다.)"); 
				user.usemile.value="";
				strpay = 0;
			}	
			
			//if (parseInt(document.user.usemile.value) == parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.transpay.value) - parseInt(document.user.coup1sale.value)) ) {
			//'''2024-10-02 totalpaytemp는 배송비를 더한 금액이 아니기 때문에 배송비는 빼지 않는다.
			if (parseInt(document.user.usemile.value) == parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.coup1sale.value)) ) {
				if(strpay == "" || strpay == 0){
				}
				else {
					if(strpay.substring(strcnt-1) == "0"){
						alert("최소 100원은 실결제를 해 주셔야 합니다.(전액포인트결제불가)"); 
						user.usemile.value="";		
						user.usemile.focus();						
					}
					else {
						alert("포인트사용은 십원단위로 사용이 가능합니다.");
						//user.usemile.value=""
						//20220607 10자리에서 내림
						strpay = Math.floor(strpay / 10) * 10;
						user.usemile.value=strpay;
					}
				}				
			}
			else {
				if(strpay == "" || strpay == 0){
				}
				else {
					if(strpay.substring(strcnt-1) == "0"){
							//if (100 > parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.transpay.value) - parseInt(document.user.coup1sale.value)) - parseInt(document.user.usemile.value) ) {
							//'''2024-10-02 totalpaytemp는 배송비를 더한 금액이 아니기 때문에 배송비는 빼지 않는다.
							if (100 > parseInt(parseInt(document.user.totalpaytemp.value) - parseInt(document.user.coup1sale.value)) - parseInt(document.user.usemile.value) ) {
								alert("최소 100원은 실결제를 해 주셔야 합니다.(전액포인트결제불가)"); 
								user.usemile.value="";		
								user.usemile.focus();
							}
							else { 
							}
					}
					else {
						alert("포인트사용은 십원단위로 사용이 가능합니다.");
						//user.usemile.value=""
						//20220607 10자리에서 내림
						strpay = Math.floor(strpay / 10) * 10;
						user.usemile.value=strpay;
					}
				}
			}
			if (strpay == ""){
				document.user.usemile.value = 0;
			}
			var usePoint = parseInt(document.user.usemiletemp.value) - parseInt(document.user.usemile.value);
			$("#usePoint").html(PrintComma(usePoint));
	//}
	recalc_pay();
	//recalc_gift();
}

function recalc_gift() {
	if (jQuery("#giftDiv").length) {
		jQuery.ajax({
			type: "POST",
			url: "/order/GIFT_EVENT.asp",
			dataType : "HTML",
			success: function(data) {
				jQuery("#giftDiv").html(data);
			},
			error: function(e) {
				//alert("e");
			}
		});
	}
}

function recalc_pay(){
	
	if (document.user.usemile.value == ""){
		user.usemile.value = 0;
	}
	
	user.totalprice.value = parseInt(document.user.totalpaytemp.value,10) - parseInt(document.user.usemile.value,10) + parseInt(document.user.transpay.value,10) - parseInt(document.user.OrderUseCouponPrice.value,10) - parseInt(document.user.promoTotal.value,10);
	user.usemile1.value = document.user.usemile.value;
	user.usermile.value = parseInt(document.user.usemiletemp.value,10) - parseInt(document.user.usemile.value,10);
	user.totalpay.value = parseInt(document.user.totalpaytemp.value,10) - parseInt(document.user.usemile.value,10) - parseInt(document.user.OrderUseCouponPrice.value,10) + parseInt(document.user.transpay.value,10) - parseInt(document.user.promoTotal.value,10);
	user.OrderTotalPrice.value = document.user.totalpay.value;
/*	
	alert(document.user.totalprice.value);
	alert(document.user.usemile1.value);
	alert(document.user.usermile.value);
	alert(document.user.totalpay.value);			
	alert(document.user.OrderTotalPrice.value);				
*/	
	
	if (document.user.usemile.value > 0){
		// 포인트 사용시 마이너스인 경우 kish value reset 
		if (document.user.totalpay.value < 0){
			user.m_usecheck.checked = false;
			user.usemile.value="";
			recalc_pay();
		}
		
		if (parseInt(document.user.usemiletemp.value) != 0 ) {
			if (parseInt(document.user.usemile.value) < parseInt(document.user.minPoint.value) ) {
				alert("포인트는 " + PrintComma(document.user.minPoint.value) +"원 이상부터 사용 가능합니다.");
				user.usemile.value="";
				return;
			}	
		}
	}	
/*
	if (document.getElementById("kishuse1")) {
		document.getElementById("kishuse1").innerHTML = PrintComma(document.user.usemile.value);
	}
	if (document.getElementById("kishuse2")) {
		document.getElementById("kishuse2").innerHTML = PrintComma(document.user.usemile.value);
	}		
*/	
//	document.getElementById("transprice").innerHTML = PrintComma(document.user.transpay.value);	
//	document.getElementById("div_price2").innerHTML = PrintComma(document.user.totalpay.value);		
	if (parseInt(document.user.promoTotal.value,10) > 0) {
		document.getElementById("promo_sale").innerHTML = PrintComma(document.user.promoTotal.value);
	}
	///하단 가격정보 추가
	$("#transprice2").html(PrintComma(document.user.transpay.value));
	$("#div_price22").html(PrintComma(document.user.totalpay.value));		
//	document.getElementById("kish1").innerHTML = PrintComma(document.user.usermile.value);
//	document.getElementById("kish2").innerHTML = PrintComma(document.user.usermile.value);

//	document.getElementById("couponuse1").innerHTML = PrintComma(document.user.OrderUseCouponPrice.value);
//	document.getElementById("couponuse2").innerHTML = PrintComma(document.user.OrderUseCouponPrice.value);	

	//document.getElementById("div_price").innerHTML = PrintComma(document.user.totalpay.value);
	//document.getElementById("div_price3").innerHTML = PrintComma(document.user.totalpay.value);		
	// recalc_giftbox(); //#HJ 2020-08-20 쿠폰할인 금액 상관 없어서 주석
}

function orderConfirm(val){
	yorn = confirm("구매확정하시겠습니까?");
	if(yorn)
	{
		document.orderForm.oOrderNo.value = val;
		document.orderForm.target = 'oFrame';
		document.orderForm.action = '/order/order_result.asp';
		document.orderForm.submit();
	}
}

function orderCancel(val){
	yorn = confirm("주문취소하시겠습니까?");
	if(yorn)
	{
		document.orderForm.oOrderNo.value = val;
		document.orderForm.target = 'oFrame';
		document.orderForm.action = '/order/order_cancel_result.asp';
		document.orderForm.submit();
	}
}

function orderCancel2(val){
	yorn2 = confirm("주문취소접수하시겠습니까?");
	if(yorn2)
	{
		document.orderForm.oOrderNo.value = val;
		document.orderForm.target = 'oFrame';
		document.orderForm.action = '/order/order_cancelorder_result.asp';
		document.orderForm.submit();
	}
}

function childwinClose() {
	window.open("/inicis/childwin.html","childwin","width=300,height=160");		
	window.open('about:blank', 'childwin').close();
}

function addressChg() {
	SSQ("#ori").fadeOut();
}
function addressModify() {
    if (document.user.OrderOName.value == "") {
        alert("주문자 성명을 입력하세요");
        document.user.OrderOName.focus();
        return false;
    }
/*    
    else if (document.user.OrderOZip1.value == "" || document.user.OrderOZip1.value.length < 3) {
        alert("주문자 우편번호앞자리를 입력하세요");
        document.user.OrderOZip1.focus();
        return false;
    }

    else if (document.user.OrderOAddress1.value == "" || document.user.OrderOAddress2.value) {
        alert("주문자 주소를 입력하세요");
        document.user.OrderOAddress2.focus();
        return false;
    }
*/    
    else if (document.user.OrderOTel21.value == "" || document.user.OrderOTel22.value == "" || document.user.OrderOTel23.value == "") {
        alert("주문자 휴대폰번호를 입력하세요");
        document.user.OrderOTel21.focus();
        return false;
    }
    else if (document.user.OrderDName.value == "") {
        alert("수취인 성명을 입력하세요");
        document.user.OrderDName.focus();
        return false;
    }
    else if (document.user.OrderDZip.value == "" || document.user.OrderDZip.value.length < 3) {
        alert("수취인 우편번호앞자리를 입력하세요");
        document.user.OrderDZip.focus();
        return false;
    }

    else if (document.user.OrderDAddress1.value == "" || document.user.OrderDAddress2.value == "") {
        alert("수취인 주소를 입력하세요");
        document.user.OrderDAddress2.focus();
        return false;
    }
    else if (document.user.OrderDTel21.value == "" || document.user.OrderDTel22.value == "" || document.user.OrderDTel23.value == "") {
        alert("주문자 휴대폰번호를 입력하세요");
        document.user.OrderDTel21.focus();
        return false;
    }

    yorn2 = confirm("배송지를 수정하시겠습니까?");
    if (yorn2) {
        document.user.target = 'oFrame';
        document.user.action = '/order/order_address_result.asp';
        document.user.submit();
    }
}

function process(rsp) {
	setTimeout(rsp,3);
}

function useCoupon() {
	/*
    if (document.user.popupCoupon3.value == "") {
				if (confirm("선택하신 쿠폰이 없습니다. 쿠폰 사용팝업을 닫으시겠습니까?")) {
					closeCoverLayer();
					return;					
				}
				else {
        	return;
        }
    }
	*/

    coup3 = document.user.popupCoupon3.value;
		cno = document.user.cartNo.value;
		pno = document.user.pageNo.value;		

    xmlhttp = initXMLHttp();

		randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);		

//    var obj = document.getElementById("mc_layer");
//    obj.innerHTML = "<img src=/images/waiting.gif>";
    xmlhttp.open("GET", "/order/pop_coupon_r.asp?cartNo=" + cno + "&pageNo=" + pno + "&coup3=" + coup3 +"&randNo="+ randNo);
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var returnval;
            returnval = xmlhttp.responseText;

            var index1, page;
            index1 = returnval.indexOf("|");
            TEXT1 = returnval.substring(0, index1);

            var returnWords, index2, pagecount;
            returnWords = returnval.substring(returnval.indexOf("|") + 1);
            index2 = returnWords.indexOf("|");
            TEXT2 = returnWords.substring(0, index2);

            if (TEXT1 == 0)	// success!
            {
            		//#HJ 2017-04-27
            		//alert("쿠폰사용시 부분반품이 되지 않습니다.\n전체 반품 후 새로 주문하셔야 하는점 참고 바랍니다");
                //alert(TEXT2);
                recalc_aj();
                getAjaxHtml2("/order/pay_cartList_ajax.asp?randNo="+ randNo, "cartList", "");
                //closeCoverLayer();
                //jQuery("#usecpon").val(TEXT2);                
               // document.getElementById("mc_layer").innerHTML = "<a href='javascript:pay_coupon_cancel();void(0);' style='color:#df0000;' class='btn_style6 m_hidden'>쿠폰 사용 취소</a><a href='javascript:pay_coupon_cancel();void(0);' style='color:#df0000;' class='btn_style6 d_hidden t_hidden'>쿠폰 사용 취소</a>"                
				if (TEXT2.indexOf("Test") > -1){
					//$("#giftBox").show();
				}
				if (TEXT2.indexOf("코로나응원") > -1){
					//$("#giftBox").show();
				}
            }
            else			// fail!
            {
                recalc_aj();
                //document.getElementById("mc_layer").innerHTML = "<a href='javascript:pay_coupon();void(0);' class='btn_style6 m_hidden'>쿠폰 조회/사용</a><a href='javascript:pay_coupon();void(0);' class='btn_style6 d_hidden t_hidden'>쿠폰 조회/사용</a>"
				if (TEXT1 == 8)	{
                alert(TEXT2);
				}else{
                process(TEXT2.replace(/\n/g, ''));
				}

				process($('.cart_coupon').val(""));

                //self.reload();
            }
        }
    }
    xmlhttp.send(null);
}

/*쿠폰 조회 및 적용하기*/
var pay_coupon;
function pay_coupon() {
	var formStr = "";
	jQuery.ajax({
		type: "POST",
		data: "",
		url: "/order/pop_coupon.asp",
		dataType : "HTML",
		success: function(data) {
			formStr = data;			
			
			 couponPop1 = new CoverLayer(formStr, {
					bg_color : "white", 		// 백그라운드 색상 기본값:"#000"
					bg_opacity : 0.75, 		// 백그라운드 투명도. 기본값:0.75
					close_btn_id : "closeBtn1", 	// 레이어 닫기 버튼 DOM id, 기본값:"closeBtn"
					z_index : 99998, 			// 레이어의 z-index 값 기본값:99990
					cast_speed : 500,		// 레이어 생성 트위닝 속도
					close_click : false,		// 어느곳이나 클릭시 닫힘 여부, 활성화:true, 비활성화:false(기본값)
					scroll_fix : false
					//align_x : "left",			// "center"(기본값), "left", "right"
					//align_x_value : 50,				// 정수, 0(기본값)
					//align_y : "top",			// "middle"(기본값), "left", "right"
					//align_y_value : 50				// 정수, 0(기본값)
				});		
		},
		error: function(e) {
			//alert("e");
		}
	});
}

function pay_coupon_cancel() {
    xmlhttp = initXMLHttp();

		randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);		

    //var obj = document.getElementById("c_layer"+kk);
    //obj.innerHTML = "<img src=/images/waiting.gif>";
    xmlhttp.open("GET", "/order/pop_coupon_c.asp?randNo="+ randNo);
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var returnval;
            returnval = xmlhttp.responseText;

            var index1, page;
            index1 = returnval.indexOf("|");
            TEXT1 = returnval.substring(0, index1);

            var returnWords, index2, pagecount;
            returnWords = returnval.substring(returnval.indexOf("|") + 1);
            index2 = returnWords.indexOf("|");
            TEXT2 = returnWords.substring(0, index2);

            if (TEXT1 == 0)	// success!
            {
                //alert(TEXT2);
                recalc_aj();
                getAjaxHtml2("/order/pay_cartList_ajax.asp?randNo="+ randNo, "cartList", "");
                jQuery("#usecpon").val("");
                //document.getElementById("mc_layer").innerHTML = "<a href='javascript:pay_coupon();void(0);' class='btn_style6 m_hidden'>쿠폰 조회/사용</a><a href='javascript:pay_coupon();void(0);' class='btn_style6 d_hidden t_hidden'>쿠폰 조회/사용</a>"
            }
            else			// fail!
            {
                recalc_aj();            	
                //document.getElementById("mc_layer").innerHTML = "<a href='javascript:pay_coupon_cancel();void(0);' style='color:#df0000;' class='btn_style6 m_hidden'>쿠폰 사용 취소</a><a href='javascript:pay_coupon_cancel();void(0);' style='color:#df0000;' class='btn_style6 d_hidden t_hidden'>쿠폰 사용 취소</a>"                
                process(TEXT2);
                self.reload();
            }
        }
    }
    xmlhttp.send(null);
}

function pay_coupon_iframe(val,val2) {
	var tempUrl = "/order/pop_coupon.asp?cno="+val+"&no="+val2;
	//var layerText='<div style="overflow:auto;position:relative;-webkit-overflow-scrolling:touch;"><iframe name="inneriframe" width="660" height="400" id="inneriframe" src="'+ tempUrl +'" style="width: 100%; height: 100%;" allowtransparency="true"></iframe></div>';
	//layer.text(layerText,"pay_coupon", {width:640, height:400, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
  layer.iframe(tempUrl,"pay_coupon", {width:640, height:400, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
}

function useCouponLayer() {
    if ($('input:radio[name=popupCoupon3]').is(":checked") != true) {
		if (confirm("선택하신 쿠폰이 없습니다. 쿠폰 사용팝업을 닫으시겠습니까?")) {
			 $(".close__btn").click();
			 return;
		}else {
				return;
        }
    }

	$("#cpnBtn").addClass("_style_loading");
	$("#cpnBtn").attr("onclick","").unbind('click');
	$("#cpnBtn").html("");

    coup3 = $('input[name=popupCoupon3]:checked').val();

	if (coup3 == ""){
		pay_coupon_cancelLayer();
		$("#pointArea").show();
		return;
	}

	cno = document.ucoupon.cartNo.value;
	pno = document.ucoupon.pageNo.value;		
	var xmlhttp = "";
    xmlhttp = initXMLHttp();

	randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);		
		
    //var obj = document.getElementById("mc_layer");
    //obj.innerHTML = "<img src=/images/waiting.gif>";
	xmlhttp.open("GET", "/order/pop_coupon_r.asp?cartNo=" + cno + "&pageNo=" + pno + "&coup3=" + coup3 +"&randNo="+ randNo);
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var returnval;
            returnval = xmlhttp.responseText;

            var index1, page;
            index1 = returnval.indexOf("|");
            TEXT1 = returnval.substring(0, index1);

            var returnWords, index2, pagecount;
            returnWords = returnval.substring(returnval.indexOf("|") + 1);
            index2 = returnWords.indexOf("|");
            TEXT2 = returnWords.substring(0, index2);

            if (TEXT1 == 0)	// success!
            {
				if (coup3.indexOf('G25337') > -1 ){	//20240823 20240912 20240927 20250226 20250828 20250922 유니폼쿠폰 체크
					document.user.usemile.value = 0;
					$("#pointArea").hide();
				}else{
					$("#pointArea").show();
				}
                //alert(TEXT2);
                recalc_aj();
                getAjaxHtml2("/order/pay_cartList_ajax.asp?randNo="+ randNo, "cartList", "");
                $(".close__btn").click();
                //document.getElementById("mc_layer").innerHTML = "<a href='javascript:useCoupon();'><img src='/images/popup/btn_coupon.gif' alt='구폰 사용하기' /></a>"                
				setTimeout(function(){
					$('.odr-toggle-box .hd .toggle__btn').on('click', function(){
						$(this).parents('.odr-toggle-box').toggleClass('open');
					});
				},3000)
            }
            else			// fail!
            {
				$("#pointArea").show();
                recalc_aj();
                //document.getElementById("mc_layer").innerHTML = "<a href='javascript:useCoupon();' class='red mb5'>쿠폰 사용</a>"
				if (TEXT1 == 8)	{
                alert(TEXT2);
				$(".close__btn").click();
				}else{
                process(TEXT2.replace(/\n/g, ''));
				$(".close__btn").click();
				}
                //self.reload();
            }
        }
    }
    xmlhttp.send(null);
}

function pay_coupon_cancelLayer() {
    xmlhttp = initXMLHttp();

		randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);		

    //var obj = document.getElementById("c_layer"+kk);
    //obj.innerHTML = "<img src=/images/waiting.gif>";
    xmlhttp.open("GET", "/order/pop_coupon_c.asp?randNo="+ randNo);
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var returnval;
            returnval = xmlhttp.responseText;

            var index1, page;
            index1 = returnval.indexOf("|");
            TEXT1 = returnval.substring(0, index1);

            var returnWords, index2, pagecount;
            returnWords = returnval.substring(returnval.indexOf("|") + 1);
            index2 = returnWords.indexOf("|");
            TEXT2 = returnWords.substring(0, index2);

            if (TEXT1 == 0)	// success!
            {
                //alert(TEXT2);
                recalc_aj();
                getAjaxHtml2("/order/pay_cartList_ajax.asp?randNo="+ randNo, "cartList", "");
                jQuery("#usecpon").val("");
				$(".close__btn").click();
                //document.getElementById("mc_layer").innerHTML = "<a href='javascript:pay_coupon();void(0);' class='btn_style6 m_hidden'>쿠폰 조회/사용</a><a href='javascript:pay_coupon();void(0);' class='btn_style6 d_hidden t_hidden'>쿠폰 조회/사용</a>"
				setTimeout(function(){
					$('.odr-toggle-box .hd .toggle__btn').on('click', function(){
						$(this).parents('.odr-toggle-box').toggleClass('open');
					});
				},3000)

            }
            else			// fail!
            {
                recalc_aj();            	
                //document.getElementById("mc_layer").innerHTML = "<a href='javascript:pay_coupon_cancel();void(0);' style='color:#df0000;' class='btn_style6 m_hidden'>쿠폰 사용 취소</a><a href='javascript:pay_coupon_cancel();void(0);' style='color:#df0000;' class='btn_style6 d_hidden t_hidden'>쿠폰 사용 취소</a>"                

                process(TEXT2);
                self.reload();
            }
        }
    }
    xmlhttp.send(null);
}

function recalc_aj() {
	jQuery.ajax({
		type: "POST",
		url: "/order/pay_recalc.asp",
		dataType : "JSON",
		success: function(data) {
			jQuery("#sale_total").html(PrintComma(data.sale));
			jQuery("#sale_total2").html(PrintComma(data.sale));
			jQuery("#coup1price").html(PrintComma(data.coup1));
			jQuery("#coup2price").html(PrintComma(data.coup2));
			jQuery("#coup3price").html(PrintComma(data.coup3));			
			//jQuery("#salerate").html(data.salerate);			

			if (data.coupontitle != ""){
				$("#cpnName").html(data.coupontitle);
				$("#cpnName").show();
			}else{
				$("#cpnName").hide();
			}

			document.user.OrderUseCouponPrice.value = data.sale;
			document.user.totalpay.value = data.cart;
			document.user.totalprice.value = data.cart;			
			document.user.totalpaytemp.value = data.cart;			
			document.user.temptotal.value = data.cart;
			
			document.user.coup1sale.value = data.coup1;			
			document.user.coup2sale.value = data.coup2;			
			document.user.coup3sale.value = data.coup3;
			document.user.promoTotal.value = data.promo;

			recalc_pay();
			//recalc_gift();
		},
		error: function(e) {
			//alert("e");
		}
	});
}

function recalc_aj_set() {
	jQuery.ajax({
		type: "POST",
		url: "/order_set/pay_recalc.asp",
		dataType : "JSON",
		success: function(data) {
			jQuery("#sale_total").html(PrintComma(data.sale));
			jQuery("#sale_total2").html(PrintComma(data.sale));
			jQuery("#coup1price").html(PrintComma(data.coup1));
			jQuery("#coup2price").html(PrintComma(data.coup2));
			jQuery("#coup3price").html(PrintComma(data.coup3));			
			//jQuery("#salerate").html(data.salerate);			

			document.user.OrderUseCouponPrice.value = data.sale;
			document.user.totalpay.value = data.cart;
			document.user.totalprice.value = data.cart;			
			document.user.totalpaytemp.value = data.cart;			
			document.user.temptotal.value = data.cart;
			
			document.user.coup1sale.value = data.coup1;			
			document.user.coup2sale.value = data.coup2;			
			document.user.coup3sale.value = data.coup3;
			document.user.promoTotal.value = data.promo;

			recalc_pay();
			//recalc_gift();
		},
		error: function(e) {
			//alert("e");
		}
	});
}


function recalc_giftbox(){
	///금액이 5만원이상일 경우 오픈
	if (document.user.totalpay.value >= 50000){
		$("#giftBox").show();
	}else{
		$("input[name=BonusGift]").removeAttr('checked');
		$("#giftBox").hide();
	}
}

function getAjaxHtml2(url, idname, val) {
    jQuery.ajax({
        type: "GET",
        url: url,
        dataType: "html",
        data: val,
        beforeSend: function () {

        },
        error: function () {
            //alert("error");
        },
        success: function (msg) {
            jQuery("#" + idname).html(msg);
        },
        complete: function () {
            //window.scrollTo(0, 0);
        }
    });
}


function addrSubmit()
{
	var objF = document.getElementById('addr');
//	if(objF.addrtitle.value == ''){alert('배송지이름을 입력해주세요'); objF.addrtitle.focus(); return; }
	if(objF.addrname.value == ''){alert('수령인명을 입력해주세요'); objF.addrname.focus(); return; }

	if(objF.zipcode.value == ''){alert('우편번호를 입력해주세요'); objF.zipcode.focus(); return; }
	if(objF.addr1.value == ''){alert('주소를 입력해주세요'); objF.addr1.focus(); return; }
	if(objF.addr2.value == ''){alert('상세주소를 입력해주세요'); objF.addr2.focus(); return; }

	//	if(objF.tel1_1.value == '' || objF.tel1_2.value == '' || objF.tel1_3.value == ''){alert('전화번호를 입력해주세요'); objF.tel1_1.focus(); return; }
	//if(objF.tel2_1.value == '' || objF.tel2_2.value == '' || objF.tel2_3.value == ''){alert('휴대폰을 입력해주세요'); objF.tel2_1.focus(); return; }	
	if(objF.tel2_1.value == '' ){alert('휴대폰을 입력해주세요'); objF.tel2_1.focus(); return; }	
	var pattern =/^[0-9]*$/g;
	if ( !pattern.test( objF.tel2_1.value ) ) { alert('휴대폰은 숫자만 입력 가능합니다.'); objF.tel2_1.focus(); return; }

	objF.submit();
	$('body').removeClass('lyr-addradd--open');
	$('.common__layer').remove();
	//top.closeCoverLayer();
}

function addr_zipcode () {
	   winMem = window.open ("/order/zipcode_addr.asp", "zip", "width=350,height=410,menubar=no,scrollbars=no")
}

function addr_choice() {
	var addrVal = jQuery("input[name='AddressNo']:checked").val();
	var tempVal = jQuery("input[name='AddressNo']:checked").attr("ref");

/*
	if (typeof addrVal == "undefined" || addrVal == '') {
		if (document.addr.AddressNo2.value != '') {
			addrVal = jQuery("#AddressNo2 option:selected").attr("ref");			
			tempVal = addrVal; //document.addr.AddressNo2.value;		
		}
	}
*/
	if (typeof addrVal == "undefined" || addrVal == '') {
		alert("주소를 선택해 주세요");
	}
	else {
		document.user.OrderDName.value = tempVal.split('^')[0]
		document.user.OrderDZip.value = tempVal.split('^')[1]		
		document.user.OrderDRoadAddress.value = tempVal.split('^')[2]		
		document.user.OrderDAddress1.value = tempVal.split('^')[3]		
		document.user.OrderDAddress2.value = tempVal.split('^')[4]				
//		document.user.OrderDTel11.value = tempVal.split('^')[5]		
//		document.user.OrderDTel12.value = tempVal.split('^')[6]
//		document.user.OrderDTel13.value = tempVal.split('^')[7]
		document.user.OrderDTel21.value = tempVal.split('^')[8]+tempVal.split('^')[9]+tempVal.split('^')[10]
//		document.user.OrderDTel22.value = tempVal.split('^')[9]
//		document.user.OrderDTel23.value = tempVal.split('^')[10]

		$("#dName").html(tempVal.split('^')[0]);
		if (document.user.OrderDTel21.value.length == 11){
			$("#dTel").html(document.user.OrderDTel21.value.substr(0,3) + "-" + document.user.OrderDTel21.value.substr(3,4) + "-" + document.user.OrderDTel21.value.substr(7,4));
		}else{
			$("#dTel").html(document.user.OrderDTel21.value.substr(0,3) + "-" + document.user.OrderDTel21.value.substr(3,3) + "-" + document.user.OrderDTel21.value.substr(6,4));
		}
		$("#dAddr").html("("+tempVal.split('^')[1]+") "+tempVal.split('^')[2]+" "+tempVal.split('^')[4] );
		islandCheck();
		todayDelivery();
		//closeCoverLayer();
		$('body').removeClass('lyr-addrlist--open');
		$('.common__layer').remove();
	}
}

function addr_choice3(tempVal) {


	if (typeof tempVal == "undefined" || tempVal == '') {

	}
	else {
		document.user.OrderDName.value = tempVal.split('^')[0]
		document.user.OrderDZip.value = tempVal.split('^')[1]		
		document.user.OrderDRoadAddress.value = tempVal.split('^')[2]		
		document.user.OrderDAddress1.value = tempVal.split('^')[3]		
		document.user.OrderDAddress2.value = tempVal.split('^')[4]				
//		document.user.OrderDTel11.value = tempVal.split('^')[5]		
//		document.user.OrderDTel12.value = tempVal.split('^')[6]
//		document.user.OrderDTel13.value = tempVal.split('^')[7]
		document.user.OrderDTel21.value = tempVal.split('^')[8]+tempVal.split('^')[9]+tempVal.split('^')[10]
//		document.user.OrderDTel22.value = tempVal.split('^')[9]
//		document.user.OrderDTel23.value = tempVal.split('^')[10]

		$("#dName").html(tempVal.split('^')[0]);
		if (document.user.OrderDTel21.value.length == 11){
			$("#dTel").html(document.user.OrderDTel21.value.substr(0,3) + "-" + document.user.OrderDTel21.value.substr(3,4) + "-" + document.user.OrderDTel21.value.substr(7,4));
		}else{
			$("#dTel").html(document.user.OrderDTel21.value.substr(0,3) + "-" + document.user.OrderDTel21.value.substr(3,3) + "-" + document.user.OrderDTel21.value.substr(6,4));
		}
		$("#dAddr").html("("+tempVal.split('^')[1]+") "+tempVal.split('^')[2]+" "+tempVal.split('^')[4] );
		islandCheck();
		todayDelivery();
		//closeCoverLayer();
		$('body').removeClass('lyr-addrlist--open');
		$('.common__layer').remove();
	}
}

function selectAddr(val) {
	var tempVal = val;
	
	var tel2 = val.split('^')[8] + "-" + val.split('^')[9] + "-" + val.split('^')[10]
	
	jQuery("#addr1").html(val.split('^')[3]);
	jQuery("#addr2").html(val.split('^')[0]);	
	jQuery("#addr3").html(tel2);	
}


function addr_update() {
	var addrVal = jQuery("input[name='AddressNo']:checked").val();

	if (addrVal == undefined || addrVal == '') {
		if (document.addr.AddressNo2.value != '') {
			addrVal = jQuery("#AddressNo2 option:selected").val();			
		}
	}

	if (addrVal == undefined || addrVal == '') {
		alert("주소를 선택해 주세요");
	}
	else {
		location.href="pop_delivery_write.asp?addrNo="+ addrVal;
	}
}



function addr_delete(val) {
	if (val == undefined || val == '') {
		alert("잘못된 시도입니다.");
	}
	else {
		//location.href="pop_delivery_delete.asp?addrNo="+ addrVal;
		jQuery.ajax({
			type: "POST",
			data: "addrNo=" + val,
			url: "/mypage/pop_delivery_delete.asp",
			dataType : "HTML",
			success: function(data) {
				alert("삭제되었습니다.");
				$('body').removeClass('lyr-addrlist--open');
				$('.common__layer').remove();			
			},
			error: function(e) {
				//alert("e");
			}
		});
		
	}
}

function addr_choice2() {
	var addrVal = jQuery("input[name='AddressNo']:checked").val();
	var tempVal = jQuery("input[name='AddressNo']:checked").attr("ref");

	if (addrVal == undefined || addrVal == '') {
		if (document.addr.AddressNo2.value != '') {
			addrVal = document.addr.AddressNo2.value;		
			tempVal = jQuery("#AddressNo2 option:selected").attr("ref");
		}
	}
	
	if (addrVal == undefined || addrVal == '') {
		alert("주소를 선택해 주세요");
	}
	else {
		parent.document.user.OrderDName.value = tempVal.split('^')[0]
		parent.document.user.OrderDZip.value = tempVal.split('^')[1]		
		//parent.document.user.OrderDZip2.value = tempVal.split('^')[2]		
		parent.document.user.OrderDRoadAddress.value = tempVal.split('^')[3]
		parent.document.user.OrderDAddress1.value = tempVal.split('^')[4]
		parent.document.user.OrderDAddress2.value = tempVal.split('^')[5]				
		parent.document.user.OrderDTel11.value = tempVal.split('^')[6]		
		parent.document.user.OrderDTel12.value = tempVal.split('^')[7]
		parent.document.user.OrderDTel13.value = tempVal.split('^')[8]
		parent.document.user.OrderDTel21.value = tempVal.split('^')[9]
		parent.document.user.OrderDTel22.value = tempVal.split('^')[10]
		parent.document.user.OrderDTel23.value = tempVal.split('^')[11]
		parent.document.user.OrderDRoadAddress.value = tempVal.split('^')[12]
		parent.islandCheck();
		parent.todayDelivery();
		parent.layer.closeAll();
	}
}


function initXMLHttp() {
    var xmlHttp = false;

    if (window.XMLHttpRequest) { // Mozilla, Safari,...
        xmlHttp = new XMLHttpRequest();
        if (xmlHttp.overrideMimeType) {
            // set type accordingly to anticipated content type
            //xmlHttp.overrideMimeType('text/xml');
            xmlHttp.overrideMimeType('text/html');
        }
    } else if (window.ActiveXObject) { // IE
        try {
            xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) { }
        }
    }
    if (!xmlHttp) {
        alert('Cannot create XMLHTTP instance');
        return false;
    }
    return xmlHttp;
}


function islandCheck() {
	randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);			
	var island_zipcode = document.user.OrderDZip.value ;
	var p = 0;
	var finalTranspay = document.user.Delivery_price.value;
	jQuery.ajax({
		type: "POST",
		url: "/order/island_ajax.asp",
		data: "zipcode=" + island_zipcode + "&randNo=" + randNo,
		dataType : "JSON",
		async: false,		
		//contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		success: function(data) {
      if (data.status == "0")	{ // success!
      		p = data.addpay;
      		finalTranspay = parseInt(document.user.Delivery_price.value,10) + parseInt(p,10);
					if(p > 0){
						document.user.addpay.value = p;
						document.user.OrderIsisland.value = 1;
						document.user.OrderIsDangil.value = 0;
						//islandPay.innerHTML = " (도서산간지역 " + PrintComma(p) + "원 포함) ";
						islandPay2.innerHTML = " (도서산간지역 " + PrintComma(p) + "원 포함) ";
						//addDelivery.innerHTML = " (도서산간지역 " + PrintComma(p) + "원 추가 됩니다) ";

						$("#islandPay2").html(" (도서산간지역 " + PrintComma(p) + "원 추가) ");
						$("#dangilPay").html("");
						$("#dangilPay2").html("");
						$("#payWay2").removeAttr("disabled");
						$("#payWay3").removeAttr("disabled");

					}else{
						document.user.addpay.value = 0;
						document.user.OrderIsisland.value = 0;
						document.user.OrderIsDangil.value = 0;
						//islandPay.innerHTML = "";
						islandPay2.innerHTML = "";
						//addDelivery.innerHTML = "";
						$("#dangilPay").html("");
						$("#dangilPay2").html("");
						$("#payWay2").removeAttr("disabled");
						$("#payWay3").removeAttr("disabled");
					}
					document.user.transpay.value = finalTranspay;
					recalc_pay();
      }
      else {	// fail!
				document.user.transpay.value = finalTranspay;
				recalc_pay();      	
        //alert(data.msg);
      }
		},
		error: function(e) {
			document.user.transpay.value = finalTranspay;
			//alert("e");
		}
	});
}

function cartEmpty() {
	alert("장바구니에서 주문체크된 상품이 없습니다.");
 	top.location.href = "/order/cart.asp";
}

function CheckedAll2(f){ 
	if (jQuery("#todayDeliView").prop("checked")){	
		jQuery(".todaydelichk").prop("checked", jQuery("#checkAll").prop("checked"));
		changeCartPrice3();
	}else{		
		jQuery("input[id^=checkProduct]").prop("checked", jQuery("#checkAll").prop("checked"));
		
		jQuery("input[id^=checkProduct]").click(function(){
			if ( jQuery("input[id^=checkProduct]").length - jQuery("input[id^=checkProduct]:checked").length == 0  )	{
				jQuery("#checkAll").prop("checked", true);
			}else{
				jQuery("#checkAll").prop("checked", false);
			}
		})

		changeCartPrice2();
	}
}

function cartpriceWrong() {
	alert("주문하시는 장바구니금액과 결제금액의 합계가 맞지않습니다.\n\n장바구니로 이동하겠습니다");
	top.window.scrollTo(0,0);
	top.location.href = "/order/cart.asp";	
}



function customSelect() {
	var x, i, j, selElmnt, a, b, c;
	/*look for any elements with the class "custom-select":*/
	x = document.getElementsByClassName("custom-select");
	for (i = 0; i < x.length; i++) {
	  selElmnt = x[i].getElementsByTagName("select")[0];
	  /*for each element, create a new DIV that will act as the selected item:*/
	  a = document.createElement("DIV");
	  a.setAttribute("class", "select-selected");
	  a.innerHTML = selElmnt.options[selElmnt.selectedIndex].innerHTML;
	  x[i].appendChild(a);
	  /*for each element, create a new DIV that will contain the option list:*/
	  b = document.createElement("DIV");
	  b.setAttribute("class", "select-items select-hide");
	  for (j = 1; j < selElmnt.length; j++) {
		/*for each option in the original select element,
		create a new DIV that will act as an option item:*/
		c = document.createElement("DIV");
		c.innerHTML = selElmnt.options[j].innerHTML;
		c.addEventListener("click", function(e) {
			/*when an item is clicked, update the original select box,
			and the selected item:*/
			var y, i, k, s, h;
			s = this.parentNode.parentNode.getElementsByTagName("select")[0];
			h = this.parentNode.previousSibling;
			for (i = 0; i < s.length; i++) {
			  if (s.options[i].innerHTML == this.innerHTML) {
				s.selectedIndex = i;
				h.innerHTML = this.innerHTML;
				y = this.parentNode.getElementsByClassName("same-as-selected");
				for (k = 0; k < y.length; k++) {
				  y[k].removeAttribute("class");
				}
				this.setAttribute("class", "same-as-selected");
				break;
			  }
			}
			h.click();
		});
		b.appendChild(c);
	  }
	  x[i].appendChild(b);
	  a.addEventListener("click", function(e) {
		  /*when the select box is clicked, close any other select boxes,
		  and open/close the current select box:*/
		  e.stopPropagation();
		  closeAllSelect(this);
		  this.nextSibling.classList.toggle("select-hide");
		  this.classList.toggle("select-arrow-active");
	  });
	}
	function closeAllSelect(elmnt) {
	  /*a function that will close all select boxes in the document,
	  except the current select box:*/
	  var x, y, i, arrNo = [];
	  x = document.getElementsByClassName("select-items");
	  y = document.getElementsByClassName("select-selected");
	  for (i = 0; i < y.length; i++) {
		if (elmnt == y[i]) {
		  arrNo.push(i)
		} else {
		  y[i].classList.remove("select-arrow-active");
		}
	  }
	  for (i = 0; i < x.length; i++) {
		if (arrNo.indexOf(i)) {
		  x[i].classList.add("select-hide");
		}
	  }
	}
	/*if the user clicks anywhere outside the select box,
	then close all select boxes:*/
	document.addEventListener("click", closeAllSelect);
}


function addCart(n,pno,pcolor,pcolorcode,pprice){
	var obj = document.form2;

	obj.ProductNo.value = pno;
	obj.ProductColor.value = pcolor;
	obj.ProductColorCode.value = pcolorcode;
	obj.ProductPrice.value = pprice;
	obj.ProductSize.value = jQuery("#productSize" + n + " option:selected").val();

	OrderCheck = true;

	if (obj.ProductSize.value=="") {alert("\n사이즈를 선택해 주세요");OrderCheck = false;}	

	if (OrderCheck) {
		var val = "";
		var strQuery;

		strQuery = "";
		strQuery = jQuery(":input",obj).serialize();
		jQuery.ajax({
			type: "POST",
			data: strQuery,
			url: "/product/put_cart_log.asp",
			dataType : "HTML",
			success: function(data) {
				jQuery("#cartlog").html(data);
				//jQuery("#cartlog").empty();
			},
			error: function(e) {
				//alert("e");
			}
		});			
				
		jQuery.ajax({
			type: "POST",
			data: "mode="+ val + "&" + strQuery + "&" + new Date().getTime(),
			url: "/product/put_cart_behind.asp",
			dataType : "JSON",
			success: function(data) {
				codetype = data.codetype;
				msg = data.msg;
				returnurl = data.returnurl;

				/* #HJ 2019-10-23 SUZZEST 스크립트는 삭제 */
				/* dataFrame.location.href = "/product/put_cart_log.asp?" + strQuery; */
				//dataFrame.location.replace("/product/put_cart_log.asp?"+ strQuery);

				if (codetype == "add")  {
					var confirmChk = 0;
					var alertChk = 0;
								
					infoFrame.location.href = "/ext/info.asp?refresh=simple";

					setTimeout(function(){
						top.location.reload();
					},100);

				}			

				if (codetype == "addo2o")  {
					var addmsg = "선택하신 상품/사이즈는 매장발송 상품입니다\n일반배송보다 1~2일 더 소요될 수 있음을 알려드립니다";
					if (addmsg != "") { alert(addmsg); }										
					infoFrame.location.href = "/ext/info.asp?refresh=simple";
					setTimeout(function(){
						top.location.reload();
					},100);
			  }

				if (msg !="") { alert(msg); }
			},
			error: function(e) {
				//alert("e");
			}
		});
	}else
		return;



}


var NpClientId = "TRdYWOQ1nniOVCyVss2I";



function useCouponTEST() {
    if (document.ucoupon.popupCoupon3.value == "") {
				if (confirm("선택하신 쿠폰이 없습니다. 쿠폰 사용팝업을 닫으시겠습니까?")) {
					closeCoverLayer();
					return;					
				}
				else {
        	return;
        }
    }

    coup3 = document.ucoupon.popupCoupon3.value;
		cno = document.ucoupon.cartNo.value;
		pno = document.ucoupon.pageNo.value;		

    xmlhttp = initXMLHttp();

		randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);		

    var obj = document.getElementById("mc_layer");
    obj.innerHTML = "<img src=/images/waiting.gif>";
    xmlhttp.open("GET", "/test1/pop_coupon_r.asp?cartNo=" + cno + "&pageNo=" + pno + "&coup3=" + coup3 +"&randNo="+ randNo);
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var returnval;
            returnval = xmlhttp.responseText;

            var index1, page;
            index1 = returnval.indexOf("|");
            TEXT1 = returnval.substring(0, index1);

            var returnWords, index2, pagecount;
            returnWords = returnval.substring(returnval.indexOf("|") + 1);
            index2 = returnWords.indexOf("|");
            TEXT2 = returnWords.substring(0, index2);

            if (TEXT1 == 0)	// success!
            {
            		//#HJ 2017-04-27
            		//alert("쿠폰사용시 부분반품이 되지 않습니다.\n전체 반품 후 새로 주문하셔야 하는점 참고 바랍니다");
                //alert(TEXT2);
                recalc_aj();
                getAjaxHtml2("/order/pay_cartList_ajax.asp?randNo="+ randNo, "cartList", "");
                closeCoverLayer();
                jQuery("#usecpon").val(TEXT2);                
                document.getElementById("mc_layer").innerHTML = "<a href='javascript:pay_coupon_cancel();void(0);' style='color:#df0000;' class='btn_style6 m_hidden'>쿠폰 사용 취소</a><a href='javascript:pay_coupon_cancel();void(0);' style='color:#df0000;' class='btn_style6 d_hidden t_hidden'>쿠폰 사용 취소</a>"                
								if (TEXT2.indexOf("Test") > -1){
									//$("#giftBox").show();
								}
								if (TEXT2.indexOf("코로나응원") > -1){
									//$("#giftBox").show();
								}
            }
            else			// fail!
            {
                recalc_aj();
                document.getElementById("mc_layer").innerHTML = "<a href='javascript:pay_coupon();void(0);' class='btn_style6 m_hidden'>쿠폰 조회/사용</a><a href='javascript:pay_coupon();void(0);' class='btn_style6 d_hidden t_hidden'>쿠폰 조회/사용</a>"
                process(TEXT2);
                //self.reload();
            }
        }
    }
    xmlhttp.send(null);
}


var clickEvent = "";
var setEvent = "";
function giftPopCoupon(mno,pno,pColor,pPrice,setNo){
	var psize = jQuery("#giftSubSize" + pno + " option:selected").val();
	var val = "giftcoupon";
	if (mno == "" || pno == "" || psize == ""){
		if (psize=="") {alert("\n사이즈를 선택해 주세요");}	
	}else{
		if (clickEvent == ""){
				clickEvent = "ok"
				jQuery("#btn" + pno).html("<img src='/images/waiting_small.gif'>");
		//1.카트에 넣기
				strQuery = "";
				strQuery = "ProductNo=" + pno + "&ProductPrice=" + pPrice + "&ProductColorCode=" + pColor + "&ProductSize=" + psize + "&ProductQuantity=1"
						
				jQuery.ajax({
					type: "POST",
					data: "mode="+ val + "&" + strQuery + "&" + new Date().getTime(),
					url: "/ext/giftCartIn.asp",
					dataType : "JSON",
					success: function(data) {
						codetype = data.codetype;
						msg = data.msg;
						returnurl = data.returnurl;
						/*
						if (setEvent == "")	{
							if (mno == "10"){
								jQuery(".gift__list").hide();
								jQuery("#gift10").show();
								if (setNo == 1){
									jQuery(".set1").hide();
								}else{
									jQuery(".set2").hide();
								}
								clickEvent = ""
							}
							setEvent = "ok";
						}
						*/


						if (clickEvent == "ok"){

						//2.쿠폰 다운받기
							jQuery.ajax({
								type: "POST",
								data: "masterNo="+ mno + "&" + new Date().getTime(),
								url: "/ext/giftCouponDown.asp",
								dataType : "JSON",
								success: function(data) {
									couponid = data.msg;
									if (couponid == ""){
										location.href = "/order/pay.asp"
									}else{
									//3.쿠폰 적용하기
			//							dataFrame.location.href = "/order/pop_coupon_r.asp?coup3=" + couponid;
			//							location.href = "/order/pay.asp";
										xmlhttp = initXMLHttp();

										randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);	

										xmlhttp.open("GET", "/order/pop_coupon_r.asp?coup3=" + couponid +"&randNo="+ randNo);
										xmlhttp.onreadystatechange = function () {
											if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
												var returnval;
												returnval = xmlhttp.responseText;

												var index1, page;
												index1 = returnval.indexOf("|");
												TEXT1 = returnval.substring(0, index1);

												if (TEXT1 == 0)	// success!
												{
													//#HJ 2017-04-27
													//alert("쿠폰사용시 부분반품이 되지 않습니다.\n전체 반품 후 새로 주문하셔야 하는점 참고 바랍니다");
													location.href = "/order/pay.asp"
												}
												else			// fail!
												{
													location.href = "/order/pay.asp"
												}
											}
										}
										xmlhttp.send(null);

									}
								}
							});
						}

					}
				});

		}

	}
}

function giftCouponDown(mno){
				jQuery.ajax({
					type: "POST",
					data: "masterNo="+ mno + "&" + new Date().getTime(),
					url: "/ext/giftCouponDown.asp",
					dataType : "JSON",
					success: function(data) {
						var result = data.result;
						var msg = data.msg;

						if (result == 9) { 
							alert("로그인 후 이용해 주세요.");
							top.location.href=msg;
						}
						if (result == 2) { 
							alert("이미 다운 받은 쿠폰입니다.\n사은품을 선택해주세요.");
						}					
						if (result == 0) { 
							alert("쿠폰을 다운받았습니다.\n사은품을 선택해주세요.");
						}		
					}
				});
}

//2021-09-08 오늘도착 건으로 택배방식 선택 ajax
function todayDelivery(){
	randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);			
	var Dangil_zipcode = document.user.OrderDZip.value ;

	jQuery.ajax({
		type: "POST",
		url: "/order/pay_Delivery.asp",
		data : "zipcode=" + Dangil_zipcode + "&randNo=" + randNo,
		dataType : "HTML",
		success: function(data) {
			jQuery("#todayDelivery").html(data)
		}
	});

}

function todayDeliveryCheck() {
	randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);			
	var Dangil_zipcode = document.user.OrderDZip.value ;
	var p = 0;
	var pp = 0;
	var finalTranspay = document.user.Delivery_price.value;
	var deliVal = $('input[name=deliveryOption]:checked').val();
		jQuery.ajax({
			type: "POST",
			url: "/order/todaydelivery_ajax.asp",
			data: "zipcode=" + Dangil_zipcode + "&randNo=" + randNo,
			dataType : "JSON",
			async: false,		
			//contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
		  if (data.status == "0")	{ // success!
				p = data.addpay;
				pp = data.addislandPrice;
				
						if(p > 0 && deliVal == 1){
							//20240614 오늘도착일 때는 배송비 제외하고 오늘도착 배송비만
							//finalTranspay = parseInt(document.user.Delivery_price.value,10) + parseInt(p,10) + parseInt(pp,10);
							finalTranspay = parseInt(p,10) + parseInt(pp,10);
							document.user.addpay.value = p;
							document.user.OrderIsDangil.value = 1;
							$("#dangilPay").html(" (오늘도착 " + PrintComma(p) + "원 포함) ");
							$("#dangilPay2").html(" (오늘도착 " + PrintComma(p) + "원 포함) ");
							$("#addDelivery").html(" (오늘도착 " + PrintComma(p) + "원 추가 됩니다) ");

							$("#payWay2").attr("disabled","true");
							$("#payWay3").attr("disabled","true");
							$("#payWay2").prop('checked',false);
							$("#payWay3").prop('checked',false);
							$(".basic-box").hide();
							$(".today-box").show();
						}else{
							//20240614 도서산간 일 때는 배송비 + 도서산간 배송비
							finalTranspay = parseInt(document.user.Delivery_price.value,10) + parseInt(pp,10);
							document.user.addpay.value = pp;
							document.user.OrderIsDangil.value = 0;
							$("#dangilPay").html("");
							$("#dangilPay2").html("");
							$("#addDelivery").html("");
							if (deliVal == 1){	///2022-01-20 오늘도착 선택했는데 쿠폰으로 인해 배송비가 0원이 되었을 경우 여길 타게
								document.user.addpay.value = p;
								document.user.OrderIsDangil.value = 1;
								$("#payWay2").attr("disabled","true");
								$("#payWay3").attr("disabled","true");
								$("#payWay2").prop('checked',false);
								$("#payWay3").prop('checked',false);
								$(".basic-box").hide();
								$(".today-box").show();
							}else{
								$("#payWay2").removeAttr("disabled");
								$("#payWay3").removeAttr("disabled");
								$(".basic-box").show();
								$(".today-box").hide();
								//2022-01-24 일반택배 선택시 쿠폰적용 취소
								/*
								//#HJ 2024-10-30 오늘도착 쿠폰 종료되었기에 제거 
								jQuery.ajax({
									type: "POST",
									data: "mode=1"  + "&" + new Date().getTime(),
									url: "/event/todayCoupon/coupon_cancel.asp",
									dataType : "JSON",
									success: function(data) {
										resultcode = data.result;
										if (resultcode == "OK")  {
											jQuery("#useCpn").html("<a href='javascript:today_coupon();void(0);' ><img src='/images/220124_free_dt_off.png'></a>");
										}			
									},
									error: function(e) {
										//alert("e");
									}
								});
								*/
							}
						}
						document.user.transpay.value = finalTranspay;
						recalc_pay();
		  }
		  else {	// fail!
					document.user.transpay.value = finalTranspay;
					$("#dangilPay").html("");
					$("#dangilPay2").html("");
					$("#addDelivery").html("");
					$("#payWay2").removeAttr("disabled");
					$("#payWay3").removeAttr("disabled");
					$("#delivery_method1").prop("checked",true);
					$("#delivery_method2").prop("checked",false);
					islandCheck()
					recalc_pay();      	
			//alert(data.msg);
		  }
			},
			error: function(e) {
				document.user.transpay.value = finalTranspay;
				$("#payWay2").removeAttr("disabled");
				$("#payWay3").removeAttr("disabled");
				//alert("e");
			}
		});

}

//2021-10-15 오늘도착 추가 관련
function recalc_dangil(){
	randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);
	pay_coupon_cancel();
	getAjaxHtml2("/order/pay_cartList_ajax.asp?randNo="+ randNo, "cartList", "");
	jQuery.ajax({
		type: "POST",
		url: "/order/pay_recalc.asp",
		dataType : "JSON",
		success: function(data) {
			jQuery("#sale_total").html(PrintComma(data.sale));
			jQuery("#coup1price").html(PrintComma(data.coup1));
			jQuery("#coup2price").html(PrintComma(data.coup2));
			jQuery("#coup3price").html(PrintComma(data.coup3));			
			//하단가격정보 추가
			jQuery("#sale_total2").html(PrintComma(data.sale));
			//jQuery("#salerate").html(data.salerate);			

			document.user.OrderUseCouponPrice.value = data.sale;
			document.user.totalpay.value = data.cart;
			document.user.totalprice.value = data.cart;			
			document.user.totalpaytemp.value = data.cart;			
			document.user.temptotal.value = data.cart;
			
			document.user.coup1sale.value = data.coup1;			
			document.user.coup2sale.value = data.coup2;			
			document.user.coup3sale.value = data.coup3;
			document.user.promoTotal.value = data.promo;

			document.user.TotalPrice_Cart.value = document.user.totalpaytemp.value;
			$(".cartprice").html(PrintComma(document.user.TotalPrice_Cart.value));

			recalc_pay();
			//recalc_gift();
			jQuery.ajax({
				type: "POST",
				url: "/order/dangilPoint.asp",
				dataType : "JSON",
				success: function(data) {
					jQuery("#todayPoint").html(data.todayPoint);
					if (data.addProduct == "0")	{
						jQuery(".addDeli").hide();
					}
				},
				error: function(e) {
					//alert("e");
				}
			});
		},
		error: function(e) {
			//alert("e");
		}
	});
}
//20211028 장바구니 오늘도착가능상품만 보기 todaydelichk
function todayDeliViewAll(){
	/*
		jQuery("input[id^=checkProduct]").prop("checked", jQuery("#checkAll").prop("checked"));
		
		jQuery("input[id^=checkProduct]").click(function(){
			if ( jQuery("input[id^=checkProduct]").length - jQuery("input[id^=checkProduct]:checked").length == 0  )	{
				jQuery("#checkAll").prop("checked", true);
			}else{
				jQuery("#checkAll").prop("checked", false);
			}
		})
*/
	if (jQuery("#todayDeliView").prop("checked")){
		jQuery(".odr-tab a").removeClass("on");
		jQuery("#todayli").addClass("on");
		jQuery("#checkAll").prop("checked", false);
		jQuery("input[id^=checkProduct]").prop("checked", false);
		jQuery(".todaydelichk").prop("checked", true);
		jQuery(".notodaydeli").hide();
		jQuery(".todayinfo").show();
		jQuery("#todaygoalYN").html("[가능]");
		changeCartPrice3();
	}else{
		jQuery(".odr-tab a").removeClass("on");
		jQuery("#normalli").addClass("on");
		jQuery("#checkAll").prop("checked", true);
		jQuery("input[id^=checkProduct]").prop("checked", true);
		jQuery(".notodaydeli").show();
		jQuery(".todayinfo").hide();
		jQuery("#DeliveryTotal").val(0);
		jQuery("#dvPrice").html(PrintComma(jQuery("#DeliveryTotal").val()));
		jQuery("#todaygoalYN").html("[불가능]");
		changeCartPrice2();
	}
}



function changeCartPrice3(){
	var cprice = 0;
	var oprice = 0;
	var cpromo = 0;
	var dangil = 0;
	var boxcnt;
	///1+1시 가격 설정
	/*
	jQuery("input[name=checkwish]:checked").each(function(){
		if (jQuery(this).attr("data-promo") == "True" ){
			cpromo++;	
		}
		if (jQuery(this).attr("data-promo") == "True" && jQuery(this).attr("data-pq") % 2 == 0){
			cpromo++;
		}
	})
	*/
	jQuery("input[name=checkwish]:checked").each(function(){
		if (cpromo % 2 == 0 && cpromo > 0 && jQuery(this).attr("data-promo") == "True" ){
			cprice += (parseFloat(jQuery(this).attr("data-price"))/2);
		}else if (cpromo > 0 && jQuery(this).attr("data-promo") == "True" && jQuery(this).attr("data-pq") % 2 == 0 ){
			cprice += (parseFloat(jQuery(this).attr("data-price"))/2);
		}else{
			cprice += parseFloat(jQuery(this).attr("data-price"));
		}
		oprice += parseFloat(jQuery(this).attr("data-price"));
		///오늘도착 value 합산
		dangil += parseFloat(jQuery(this).attr("data-dangil"));
	})

/*
		If todayPoint > 0 And todayPoint <= 17.5 Then
			boxCnt = 1
		Else
			boxCnt = CInt(todayPoint/17.5) + 1
		End If
*/

	if (dangil > 0 && dangil <= 17.5){
		boxcnt = 1
	}else{
		///2021-12-20 나머지가 0이면 박스 + 안함
		if (dangil % 17.5 == 0){
			boxcnt = Math.floor((dangil/17.5));
		}else{
			boxcnt = Math.floor((dangil/17.5) + 1 );
		}
	}
	if (oprice == 0){
		boxcnt = 0;
	}
	
	jQuery("#DeliveryTotal").val(boxcnt*5000);
	jQuery("#dvPrice").html(PrintComma(jQuery("#DeliveryTotal").val()));

	cprice += parseFloat(jQuery("#DeliveryTotal").val());
	//oprice += parseFloat(jQuery("#DeliveryTotal").val());
	jQuery("#ctPice").empty();
	jQuery("#ctPice").html(PrintComma(oprice));
	jQuery("#pPrice").empty();
	jQuery("#pPrice").html(PrintComma(cprice));
			if ( jQuery(".todaydelichk").length - jQuery(".todaydelichk:checked").length == 0  )	{
				jQuery("#checkAll").prop("checked", true);
			}else{
				jQuery("#checkAll").prop("checked", false);
			}

	dangilYN();
}


function dangilYN(){
	var YY = 0;
	var NN = 0;
	jQuery("input[name=checkwish]:checked").each(function(){
		if (jQuery(this).attr("data-dangil") == 0 ){
			NN++;
		}else{
			YY++;
		}
	})
	if (NN > 0 || YY == 0 ){
		jQuery("#todaygoalYN").html("[불가능]");
	}else{
		jQuery("#todaygoalYN").html("[가능]");
	}
}

//'''2022-01-20 오늘도착쿠폰 적용
function today_coupon(){
	var deliVal = $('input[name=deliveryOption]:checked').val();
	if (deliVal == 1){
		jQuery.ajax({
			type: "POST",
			data: "mode=1"  + "&" + new Date().getTime(),
			url: "/event/todayCoupon/coupon_result.asp",
			dataType : "JSON",
			success: function(data) {
				resultcode = data.result;

				if (resultcode == "OK")  {
					todayDeliveryCheck();
					jQuery("#useCpn").html("<a href='javascript:today_coupon_cancel();void(0);' ><img src='/images/220124_free_dt_on.png'></a>");
				}			
			},
			error: function(e) {
				//alert("e");
			}
		});
	}else{
		//2022-01-24 오늘도착 체크시만 쿠폰 사용되도록처리
		alert("오늘도착 배송비무료이용권을 사용하기 위해서는 오늘도착을 선택하셔야합니다. ");
		return false;
	}
}
//'''2022-01-20 오늘도착쿠폰 취소
function today_coupon_cancel(){

		jQuery.ajax({
			type: "POST",
			data: "mode=1"  + "&" + new Date().getTime(),
			url: "/event/todayCoupon/coupon_cancel.asp",
			dataType : "JSON",
			success: function(data) {
				resultcode = data.result;

				if (resultcode == "OK")  {
					todayDeliveryCheck();
					jQuery("#useCpn").html("<a href='javascript:today_coupon();void(0);' ><img src='/images/220124_free_dt_off.png'></a>");
				}			
			},
			error: function(e) {
				//alert("e");
			}
		});

}



function CartWish(pno,psize,pcolor,obj) {
	OrderCheck = true;
	var strQuery;
	var pno;

		var url;
		var elementname;

		url = "/product/put_wish.asp?rand=" + Math.random() + "&mode=cartWish&ProductNo=" + pno  + "&ProductSize=" + psize + "&ProductColor=" + pcolor + "&" + new Date().getTime(); 

        var reqObj;
        reqObj=initXMLHttp();
				reqObj.open("GET",url,true);
        reqObj.onreadystatechange = function() {

          if(reqObj.readyState == 4) {
              if(reqObj.status==200) {
					eval("var response = (" + reqObj.responseText + ")");

					for(var i = 0; i < response.length;i++){				
						switch(response[i].title){
							case "type":
								type = response[i].value;
								break;
							case "total_qty":
								total_qty = response[i].value;
								break;
							default:
								break;
						}
					}

					if (type=='add') {
						//layerAlert("정상적으로 WISHLIST에 추가 되었습니다.");
						//countRefresh();
						jQuery(obj).addClass("on");
						try{


						}catch(e){
						}
					}
					else if (type=='cartWishDel'){
						jQuery(obj).removeClass("on");
					}
					else if(type=='exist') {
						layerAlert("이미 WISHLIST에 가지고 계신 제품입니다.");
						setTimeout(function(){layer.close('cmtPop');},3000);
					}
					else if(type=='nothing') {
						layerAlert("존재하지않는제품입니다.");
						setTimeout(function(){layer.close('cmtPop');},3000);
					}
					else if(type=='error') {
						layerAlert("시스템오류입니다 [err03]");
						setTimeout(function(){layer.close('cmtPop');},3000);
					}	
					else if(type=='login') {
						layerLoginAlert("로그인 후 이용 가능합니다.");
					}	
              }
          }
        }
				reqObj.send(null);

}

function colorChgOp(obj){
	var pColorName = $(obj).attr("data-color");
	var pCode = $(obj).attr("data-code");

//	alert($(obj).val());
	$(".colorName").html(pColorName);
	$(".cartVsize").empty();
	
	$(".cartVsize").html($(".colorSize" + $(obj).val()).html());
	$("input:radio[name='ProductSize_Cart']").prop("checked",false);
}

function cart_action3(){
		var val = "rechangecart";
		var val2 = $("input:radio[name='ProductNo_Color']:checked").val();
		var val3 = $("input:radio[name='ProductSize_Cart']:checked").val();
		var val4 = document.form99.cartNo.value;
		var val5 = $("input:radio[name='ProductNo_Color']:checked").attr("data-colorcode");
		var val6 = document.form99.ProductQuantity.value;
		var val7 = document.form99.cartPrice.value;

		jQuery.ajax({
			type: "POST",
			data: "mode="+ val + "&ProductNo=" + val2 + "&ProductSize=" + val3 + "&CartNo=" + val4 + "&CartColor=" + val5 + "&ProductQuantity=" + val6 + "&" + new Date().getTime(),
			url: "/product/put_cart_behind.asp",
			dataType : "JSON",
			success: function(data) {
				codetype = data.codetype;
				msg = data.msg;
				returnurl = data.returnurl;

				if (msg !="") { alert(msg); }
				if (returnurl !="") { 
					top.location.href=returnurl;
				}
				else {
					top.location.reload();
				}
			},
			error: function(e) {

			}
		});
}


function couponAction(c){
	if (c == ""){
		pay_coupon_cancel();
	}else{
		useCoupon();
	}
}

jQuery(document).on("click", "#offlineBtn", function(){
	var val1 = jQuery("#offline").val();
	jQuery("#offline").val("");
	jQuery("#offlineBtn").hide();
	jQuery("#offlineBtn2").show();
	if (val1 != "") {
		jQuery.ajax({
			type: "POST",
			data: "randomNo="+val1,
			url: "/order/pop_coupon_process.asp",
			dataType : "JSON",
			success: function(data) {
				jQuery("#offline").val("");
				setTimeout(data.msg,3);
				jQuery("#offlineBtn2").hide();
				jQuery("#offlineBtn").show();

			},
			error: function(e) {
				//alert("오류입니다.\n잠시 후 다시 이용해 주세요");
				location.reload();
			}
		});
	}
	else {
		alert("쿠폰번호를 입력해 주세요");
		jQuery("#offline").focus();
		jQuery("#offlineBtn2").hide();
		jQuery("#offlineBtn").show();
		
	}
});

$(document).ready(function() {
    $('input[type=radio][name=gopaymethod]').change(function() {
		$("#paymethod").html($(this).attr("data-method"));
    });
});