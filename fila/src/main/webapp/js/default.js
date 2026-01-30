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
			//globalMenu();
			la.init();
			wish.init();
		}
	};
	listener = {
		start : function(){
			ssq(window).bind("resize", listener.resizePage); listener.resizePage();
			/*ssq("a[href=#]").on("click",function(e){
				e.preventDefault();
			});*/
			ssq(window).on('scroll', function() {
				la.fixBtn.scr();

				$('#header').css('left', 0 - $(this).scrollLeft() + 'px');

				la.sclUpDown.didScroll = true; 
			});
		},
		resizePage : function(e) {

		}
	};
	
	var la = {
		init: function(){
			window.onload = function(){
				la.goodsOver();
			};

			setTimeout(function(){
				la.goodsOver();
			}, 1000);

			setTimeout(function(){
				la.goodsOver();
			}, 2000);
			
			la.search();
			la.gnb();
			la.fixBtn.init();
			la.layer.init();

			la.sclUpDown.init();
			
			la.vTab();
		},
		// 2023-04-11 추가 
		layer: {
			init: function(){
				la.layer.glbLyr();
			},
			glbLyr: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/pc/layout/pop_global.asp',
						data: '',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-global--open');
							$('body').append(html);

							$('.common__layer._global .global-list-box ul li .tit').on('click', function(e){
								e.preventDefault();
								$(this).parent().find('.depth2-box').slideToggle();
								$(this).toggleClass('on');
							});
						},
						error: function(e) {
							console.log(e)
						}
					});
				};

				$('body').on('click', '#footer .select-box .language__btn', function(){
					popup();
				});

				$('body').on('click', '.common__layer._global .close__btn', function(){
					$('body').removeClass('lyr-global--open');
					$('.common__layer._global').remove();
				});
			}, 
		},
		fixBtn: {
			init: function(){
				la.mFixedBtn = $('.bot-fix-box');

				la.fixBtn.scr();
				la.fixBtn.top();
				la.fixBtn.todayGoodsLayer();
			},
			scr: function(){
				if($(window).scrollTop() > 100){
					la.mFixedBtn.fadeIn();
				}else{
					la.mFixedBtn.fadeOut();
				}
			},
			top: function(){
				$('.bot-fix-box .top__btn').on('click', function(){
					$('body, html').animate({
						scrollTop: 0
					}, 800);
						return false;
				});
			},
			todayGoodsLayer: function(){
				var popup = function(){
					$.ajax({
						type: 'GET',
						url: '/pc/main/pop_today_goods.asp',
						dataType: 'html',
						success: function(html) {
							$('body').addClass('today-goods--open');
							$('body').append(html);
						},
						error: function(e) {
							console.log('e');
						}
					});
				};

				$('.today-goods__btn').on('click', function(){
					popup();
				});

				$('body').on('click', '.today-goods__layer .close__btn, .tg-wrap', function(){
					$('body').removeClass('today-goods--open');		
					$('.today-goods__layer').remove();
				});
			}
		},
		goodsOver: function(){
			if($('.goods .after').length){
				$('.goods .after').each(function(idx){
					$(this).addClass('_g0' + idx);

					var swiper = new Swiper('._g0' + idx + ' .hover__slider', {
						spaceBetween: 1,
						slidesPerView: 'auto',
						scrollbar: {
							el: '._g0' + idx + ' .slider-scrollbar',
						},
						navigation: {
						  nextEl: '._g0' + idx + ' .next__btn',
						  prevEl: '._g0' + idx + ' .prev__btn',
						}
					});

					if($('._g0' + idx + ' .hover__slider .swiper-slide').length == 1){
						$('.slider-btn-box').hide();
					}
				});
			}		
			

			// 2024-08-05 추가
			if($('.goods .other-box').length){
				$('.goods .other-box').each(function(idx){
					$(this).addClass('_go0' + idx);

					var swiper = new Swiper('._go0' + idx + ' .other__slider', {
						spaceBetween: 5,
						freeMode: true,
						slidesPerView: 'auto'
					});
				});
			}
		},
		search: function(){
			$('.search-open__btn').on('click', function(){
				$('body').addClass('search--open');
				
				setTimeout(function(){
					$('.search__layer .head input').focus();
				}, 500);
			});

			$('.search__layer .head .close__btn').on('click', function(){
				$('.search__layer .head input').val('');
				$('.search__layer .head').removeClass('_val');
			});

			$('.search__layer .cancel__btn, .search-bg__wrap').on('click', function(){
				$('body').removeClass('search--open');
			});

			$('.search__layer .head input').on('keyup', function(){
				if($(this).val() == ''){
					$('.search__layer .head').removeClass('_val');
				}else{
					$('.search__layer .head').addClass('_val');
				}
			});
		},
		gnb: function(){
			$('body._style_main #header .gnb > ul > li').on('mouseover', function(){
				$('body').addClass('_bg_on');
			});

			$('body._style_main #header .gnb > ul > li').on('mouseleave', function(){
				$('body').removeClass('_bg_on');
			});

			// 2025-03-20 슬라이드 추가
			if($('.side-menu-box .preview__slider').length){
				$('.side-menu-box .preview__slider').each(function () {
					var totalSlide = $(this).find('.swiper-slide').length;

					var swiper = new Swiper(this, {  
						direction: 'horizontal',
						loop: true,
						loopAdditionalSlides: 1,
						slidesPerView: 1,
						parallax: true,
						speed: 500,
						pagination: {
							el: $(this).find('.preview-slider-fraction')[0], 
							type: 'fraction'
						},
						autoplay: {
							delay: 3000,
							disableOnInteraction: false
						},
					});
				});
			};	
		},
		sclUpDown: {
			didScroll: null,
			lastScrollTop: 0,
			delta: 50,
			navbarHeight: $('#header').outerHeight(),
			
			init: function(){
				la.sclUpDown.scroll(); 

				setInterval(function(){
					if(la.sclUpDown.didScroll){
						la.sclUpDown.scroll(); 
						la.sclUpDown.didScroll = false; 
					}
				}, 250);				
			},
			scroll: function(){
				var st = $(window).scrollTop(); 
				
				if(Math.abs(la.sclUpDown.lastScrollTop - st) <= la.sclUpDown.delta) return;
				
				if(st > la.sclUpDown.lastScrollTop && st > la.sclUpDown.navbarHeight){
					// Scroll Down 
					$('body').removeClass('scl-up').addClass('scl-down');
				}else{
					// Scroll Up
					if(st + $(window).height() < $(document).height()){
						$('body').removeClass('scl-down').addClass('scl-up');						
					}
				}
				
				la.sclUpDown.lastScrollTop = st;

				if(st < 100){
					$('body').addClass('_w_top');
				}else{
					$('body').removeClass('_w_top');
				}
			}
		},
		vTab: function(){
			$('.goods-bt .event_tab a').on('click', function(){
				$('.goods-bt .event_tab a').removeClass('on');
				$(this).addClass('on');

				


			});
			/*var wSt = $(window).scrollTop();
				var tabHt = $('.goods-bt .event_tab a').height();
				var tabBtns = $('.goods-bt .event_tab a');
				var evCont = $('.goods-bt .event_list_box > div');

				for(var i = 0; i < tabBtns.length; i ++) {
					if(wSt < evCont[0].offset().top){
						for (tabBtn of tabBtns)
						{
							tabBtn.removeClass('on');
						}
					}else if (wSt > evCont[i].offset().top)
					{
						for(tabBtn of tabBtns){
							tabBtn.removeClass('on');
						}
						tabBtns[i].addClass('on');
					}
				}*/
				const tabBtns = document.querySelectorAll('.goods-bt .event_tab a');
				const tabBoxs = document.querySelectorAll('.goods-bt .event_list_box > div');

				const tabScroll = ()=> {
					const wSt = document.querySelector('html').scrollTop; // 브라우저 스크롤 위치

					for(let i = 0; i < tabBtns.length; i++){			
						if(wSt < tabBoxs[0].offsetTop - 190){ // 스크롤 위치가 첫번째 박스 위치보다 낮으면
							for(tabBtn of tabBtns){
								tabBtn.classList.remove('on');
							}
						}else if(wSt > tabBoxs[i].offsetTop - 190){ // 스크롤 위치가 각 박스마다 위치해 있으면?
							for(tabBtn of tabBtns){
								tabBtn.classList.remove('on');
							}
							tabBtns[i].classList.add('on');
						}
					}
				}
				
				document.addEventListener('scroll', ()=> {
					tabScroll();		
				});                                     
				tabScroll();
		},
	};

	// 2025-04-16 메인리뉴얼 goodsOver(); 호출용
	window.MyApp = window.MyApp || {};
	MyApp.la = la;

	var wish = {
		list : null, curr:null, 
		init : function() {
			wish.list = ssq(".wish[data-wish]");
			ssq(document).on("click", ".wish[data-wish]", function(e){
				var obj = ssq(this), pno = obj.attr("data-wish");
				wish.changeWish(obj, pno);
			});
		},
		changeWish:function(obj,pno) {
			wish.curr = obj;
			var strQuery;
			var url;
			var elementname;
		
		
			strQuery = jQuery(":input", document.form2).serialize();
			url = "/product/put_wishlist.asp?rand=" + Math.random() + "&ProductNo=" + pno  + "&" + new Date().getTime(); 
		
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
						obj.addClass("on");				
						//obj.html(total_qty);
					}
					else if(type=='remove') {
						obj.removeClass("on");				
						//obj.html(total_qty);
					}
					else if(type=='nothing') {
						alert("존재하지않는제품입니다.");	
					}
					else if(type=='error') {
						alert("시스템오류입니다 [err03]");
					}	
					else if(type=='login') {
						alert("로그인 후 이용가능합니다.");
						location.href = "/login.htm"
					}	
		          }
		      }
		    }
			reqObj.send(null);
		}
	}

	/* #HJ 201704 추가 */
	/*
	function globalMenu() {
		jQuery.ajax({
			type: "POST",
			url: "/member/ajaxGlobalMenu.asp",
			dataType : "JSON",
			success: function(data) {
				var login = data.login;
				var cart = data.cart;
				var coupon = data.coupon;
				var point = data.point;
				var wishcnt = data.wishcnt;
				var joinText; 
						joinText = "<a href='https://www.fila.co.kr/member/join_intro.asp''>회원가입</a>";
						joinText = joinText + "<div class='layer_join'>";
						joinText = joinText + "<h3>지금 <span>FILA ONE</span> 회원이 되면</h3>";
						joinText = joinText + "<ul>";
						joinText = joinText + "<li><span>10,000</span>신규가입 만원 쿠폰 제공</li>";
						joinText = joinText + "<li><span>Point</span>멤버십 적립 혜택</li>";
						joinText = joinText + "<li><span>Coupon</span>기념일/ 등급별 쿠폰제공</li>";
						joinText = joinText + "</ul>";
						joinText = joinText + "<div class='btn_box'>";
						joinText = joinText + "<a href='https://www.fila.co.kr/member/join_intro.asp' class='btn_join'>회원가입</a>";
						joinText = joinText + "<a href='http://www.fila.co.kr/customer/membership2.asp' class='btn_benefit'>더 많은 혜택 보기</a>";
						joinText = joinText + "</div>";
						joinText = joinText + "</div>";
	
				if (login == 1) { 
						jQuery("#globalMenu1").html("<a href='/mypage/mypage.asp'>마이페이지</a>");
						jQuery("#globalMenu2").html("<a href='/mypage/myOrder.asp'>주문/배송</a>");
						jQuery("#globalMenu3").html("<a href='/mypage/qna.asp'>1:1문의</a>");
						jQuery("#globalMenu4").html("<a href='/mypage/coupon.asp'>쿠폰</a><strong><a href='/mypage/coupon.asp'>" + coupon + "개</a></strong>");
						jQuery("#globalMenu5").html("<a href='/mypage/point.asp'>포인트</a><strong><a href='/mypage/point.asp'>" + point + "P</a></strong>");
						jQuery("#globalMenu7").html("<a href='/mypage/wishlist.asp'>위시리스트</a><strong><a href='/mypage/wishlist.asp'>" + wishcnt + "개</a></strong>");						
						jQuery("#globalMenu8").html("<a href='/specialoffer/list.asp'>이벤트</a>");
						jQuery("#globalMenu5").show();
						jQuery("#globalMenu6").show();
						jQuery("#globalMenu7").show();
						jQuery("#globalMenu1m").html("<a href='/member/logout.asp'>로그아웃</a>");
						jQuery("#globalMenu2m").html("<a href='/mypage/mypage.asp'>마이페이지</a>");
						jQuery("#globalMenu3m").html("<a href='/mypage/myOrder.asp'>주문/배송</a>");					
						jQuery("#globalMenu4m").html("<a href='/customer/notice.asp'>고객센터</a>");
						jQuery("#cart_cnt").attr("data-num",cart);
				}
				else {
						jQuery("#globalMenu1").html("<a href='/SIST_FILA/login.htm'>로그인</a>");
						//jQuery("#globalMenu2").html(joinText);
						jQuery("#globalMenu2").html("<a href='/member/join_intro.asp' >회원가입</a>");
						jQuery("#globalMenu3").html("<a href='/member/searchIDPW.asp'>아이디 · 비밀번호 찾기</a>");
						jQuery("#globalMenu8").html("<a href='/specialoffer/list.asp'>이벤트</a>");
						//jQuery("#globalMenu4").html("<a href='/member/guest.asp'>비회원 주문조회</a>");
						jQuery("#globalMenu4").html("");
						jQuery("#globalMenu5").hide();
						jQuery("#globalMenu6").hide();
						jQuery("#globalMenu7").hide();
						jQuery("#globalMenu1m").html("<a href='/SIST_FILA/login.htm'>로그인</a>");
						jQuery("#globalMenu2m").html("<a href='https://www.fila.co.kr/member/join_intro.asp'>회원가입</a>");				
						jQuery("#globalMenu3m").html("<a href='/mypage/myOrder.asp'>주문/배송</a>");					
						jQuery("#globalMenu4m").html("<a href='/customer/notice.asp'>고객센터</a>");
						jQuery("#cart_cnt").attr("data-num",cart);
				}			
			},
			error: function(e) {
						jQuery("#globalMenu1").html("<a href='/SIST_FILA/login.htm'>로그인</a>");
						//jQuery("#globalMenu2").html(joinText);
						jQuery("#globalMenu2").html("<a href='/member/join_intro.asp' >회원가입</a>");
						jQuery("#globalMenu3").html("<a href='/member/searchIDPW.asp'>아이디 · 비밀번호 찾기</a>");
						//jQuery("#globalMenu4").html("<a href='/member/guest.asp'>비회원 주문조회</a>");
						jQuery("#globalMenu4").html("");
						jQuery("#globalMenu5").hide();
						jQuery("#globalMenu6").hide();
						jQuery("#globalMenu7").hide();
						jQuery("#globalMenu1m").html("<a href='/SIST_FILA/login.htm'>로그인</a>");
						jQuery("#globalMenu2m").html("<a href='https://www.fila.co.kr/member/join_intro.asp'>회원가입</a>");				
						jQuery("#globalMenu3m").html("<a href='/mypage/myOrder.asp'>주문/배송</a>");					
						jQuery("#globalMenu4m").html("<a href='/customer/notice.asp'>고객센터</a>");
						jQuery("#cart_cnt").attr("data-num","0");
			}
		});	
	}*/

})(jQuery);
function initXMLHttp() 
{
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
        } catch (e) {}
     }
  }
  if (!xmlHttp) {
     alert('Cannot create XMLHTTP instance');
     return false;
  }
    return xmlHttp;
}   


//AS조회용 영어 숫자만 가능
function ReturnAsVal(obj,val) {
    obj.value = obj.value.replace(/[^a-zA-Z0-9]/g, '');
    
    if (obj.value == null || obj.value == "" || obj.value == 0) {
        obj.value = val;
    }
    /*
    alert(isNaN(obj.value));
    alert($.isNumeric(obj.value));
    alert(parseInt(obj.val));
    alert(parseInt("000"));
    */
}

var doubleSubmitFlag = false;

function fncSubmit(formName) {
    if(doubleSubmitFlag){
        return false;
    }else {
    	doubleSubmitFlag = true;
			formName.submit();
    }
}
function searchRun2() {
	var gnbFormObj = document.searchForm2;
	var FormObj = document.searchFormReal;	

	if(gnbFormObj.searchItem.value=="" || gnbFormObj.searchItem.value == "검색어를 입력하세요") {
		alert("검색어를 입력하세요.");
		gnbFormObj.searchItem.value = "";
		gnbFormObj.searchItem.focus();
		return;
	}
	else {
		tempItem = escape(gnbFormObj.searchItem.value);
		if (tempItem == "검색어를 입력하세요.") { 
			tempItem = "";
			gnbFormObj.searchItem.value = "";
		}
		else { 
			doubleSubmitFlag = false;
			FormObj.sWord.value = gnbFormObj.searchItem.value;
			FormObj.searchsCateNo.value = gnbFormObj.searchsCateNo.value;
			fncSubmit(FormObj);
			//FormObj.submit();		
		}				
	}
}
function searchRun3() {
	var gnbFormObj = document.searchForm3;
	var FormObj = document.searchFormReal;	

	if(gnbFormObj.searchItem.value=="" || gnbFormObj.searchItem.value == "검색어를 입력하세요") {
		alert("검색어를 입력하세요.");
		gnbFormObj.searchItem.value = "";
		gnbFormObj.searchItem.focus();
		return;
	}
	else {
		tempItem = escape(gnbFormObj.searchItem.value);
		if (tempItem == "검색어를 입력하세요.") { 
			tempItem = "";
			gnbFormObj.searchItem.value = "";
		}
		else { 
			FormObj.sWord.value = gnbFormObj.searchItem.value;
			FormObj.searchsCateNo.value = gnbFormObj.searchsCateNo.value;
			fncSubmit(FormObj);
			//FormObj.submit();		
		}				
	}
}
function searchsCate(n){
	$(".searchCate").removeClass("on");
	$(".searchs" + n).addClass("on");
	$("#searchsCateNo").val(n);
}

function searchsCate2(n){
	$(".searchCate2").removeClass("on");
	$(".searchss" + n).addClass("on");
	$("#searchsCateNo2").val(n);
}

function snsLogin(ss){
		window.open('https://' + location.host + '/socialConnect/call.asp?channel=' + ss + '&action=LOGIN','sns','width=500,height=500');
}
function snsLogin2(ss){
		location.href='https://' + location.host + '/socialConnect/call.asp?channel=' + ss + '&action=LOGIN';
}
function snsConnect(ss){
		window.open('https://' + location.host + '/socialConnect/call.asp?channel=' + ss + '&action=CONNECT','sns','width=500,height=500');
}
function snsClear(v1,v2){
	if (v1 != "" && v2 != ""){
		if(confirm("연동을 해제하시겠습니까?")){
			dataFrame.location.href = "/member/snsClear.asp?v1=" + v1 + "&v2=" + v2;
		}
	}
}
//safe_send5()
function connectChk(ss){
	dataFrame.location.href = "/member/snsCheck.asp?v1=" + ss;
}

function snsJoin(ss){
		window.open('https://' + location.host + '/socialConnect/call.asp?channel=' + ss + '&action=JOIN','sns','width=500,height=500');
}

function wish_Cart_action(pno) {
				var btn = $('.cart__btn');
				var popup = function() {
					$.ajax({
						type: 'GET',
						url: '/pc/product/pop_wishcart.asp',
						data: 'pno=' + pno,
						dataType: 'html',
						success: function(html) {
							//$('body').append(html);
							$('#addLayerDiv').empty();
							$('#addLayerDiv').append(html);							
						},
						error: function(e) {

						}
					});
				} 
				
				popup();

				$('body').on('click', '.common__layer._option .close__btn', function(){
					$('.common__layer').remove();
				});
} 

function colorChgOpAll(obj){
	var pColorName = $(obj).attr("data-color");
	var pCode = $(obj).attr("data-code");
	document.form99.ProductNo.value = pColorName;
	document.form99.CodeProductColor.value = $(obj).attr("data-colorcode");	
	
//	alert($(obj).val());
	$(".colorName").html(pColorName);
	$(".cartVsize").empty();
	
	$(".cartVsize").html($(".colorSize" + $(obj).val()).html());
	$("input:radio[name='ProductSize_Cart']").prop("checked",false);
}

function PrintComma(srcNumber) {
	var txtNumber = '' + srcNumber;
	var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');
	var arrNumber = txtNumber.split('.');
	arrNumber[0] += '.';
	do 
	{
		arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2');
	} while (rxSplit.test(arrNumber[0]));
	
	if (arrNumber.length > 1) 
	{
		return arrNumber.join('');
	}
	else 
	{
		return arrNumber[0].split('.')[0];
    }
}

var processImg = new Image();
processImg.src = "/pc/resource/images/waiting.gif";
var lang;

function changeToProcess(){
	var imgLang = "";
	if (lang == "ja"){
	imgLang = "ja/";
	}
/*					
	if (document.all){
		document.all['checkoutbtn'].innerHTML = "<button id='loginbtn2' class='btn_bg__bk btn _style_loading'></button>";
	} else if (document.layers){
		document.layers['checkoutbtn'].innerHTML = "<button id='loginbtn2'  class='btn_bg__bk btn _style_loading'></button>";
	} else if (document.getElementById){
		document.getElementById('checkoutbtn').innerHTML = "<button id='loginbtn2'  class='btn_bg__bk btn _style_loading'></button>";
	}
*/
	if (document.all){
		document.all['checkoutbtn'].innerHTML = "<a id='loginbtn2' class='btn_bg__bk btn _style_loading'></a>";
	} else if (document.layers){
		document.layers['checkoutbtn'].innerHTML = "<a id='loginbtn2'  class='btn_bg__bk btn _style_loading'></a>";
	} else if (document.getElementById){
		document.getElementById('checkoutbtn').innerHTML = "<a id='loginbtn2'  class='btn_bg__bk btn _style_loading'></a>";
	}
}

//@해당폼전체검사용
function ReturnNumberVal(obj,val) {
    obj.value = obj.value.replace(/[^0-9]/g, '');
    
    if (obj.value == null || obj.value == "" || obj.value == 0) {
        obj.value = val;
    }
    /*
    alert(isNaN(obj.value));
    alert($.isNumeric(obj.value));
    alert(parseInt(obj.val));
    alert(parseInt("000"));
    */
}

//왼쪽에 붙은 0 제거
function pointNumberVal(obj){
	if (obj.value.length > 1){
		obj.value = obj.value.replace(/(^0+)/, "");
	}
}
function shareTo( cte ) {
	if ( cte != "" ) {
		jQuery(".ssSocial-Sharing:eq(0) ." + cte + " a").click();
	}
}

jQuery(document).on("click", ".sWordRemove", function(e){ 
	var sWord = jQuery(this).parent("li").attr("data-sword")
	jQuery(this).parent("li").remove();
	jQuery.ajax({
		type: "GET",
		url: "/ext/searchRemove.asp",
		data: "sWord=" + sWord,
		dataType : "JSON",
		success: function(data) {
			if(data.result == ""){
				$(".latest__list").empty();
				$(".latest__list").append('<li class="no_search_list">최근 검색어가 없습니다.</li>');
			}
		}
	})
	//검색어 남아있을 경우 레이어 안 닫히도록
	//if ( jQuery(".sWordRemove").length > 2 ) {
	//	e.stopPropagation();
	//}
});
function wordRemoveAll(){

	jQuery.ajax({
		type: "POST",
		url: "/ext/searchRemove.asp",
		data: "sWord=removeAll",
		dataType : "JSON",
		success: function(data) {
			$(".latest__list").empty();
			$(".latest__list").append('<li class="no_search_list">최근 검색어가 없습니다.</li>');
		}
	})

}

jQuery(document).on("click", ".toDayViewRemove", function(e){ 
	var pno = jQuery(this).parent("li").attr("data-no")
	jQuery(this).parent("li").remove();
	jQuery.ajax({
		type: "GET",
		url: "/ext/todayViewRemove.asp",
		data: "pno=" + pno,
		dataType : "JSON",
		success: function(data) {
			if(data.result == ""){
				$(".todayViewList").empty();
				$(".todayViewList").append('<div class="tg-txt-box"><p>최근 본 상품이 없습니다.</p>	</div>');
			}
		}
	})
});

function todayViewRemoveAll(){

	jQuery.ajax({
		type: "POST",
		url: "/ext/todayViewRemove.asp",
		data: "pno=removeAll",
		dataType : "JSON",
		success: function(data) {
				$(".todayViewList").empty();
				$(".todayViewList").append('<div class="tg-txt-box"><p>최근 본 상품이 없습니다.</p>	</div>');
		}
	})

}

	//'''LHS 20220121	'''오늘도착 배송할인 쿠폰
	function todayCouponDown(){
		cpnUrl = "/event/todayCoupon/coupon_down.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					todayDelivery();
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}


	//20240514 쿠폰x 알림신청
	function groobee240514(){
		if ($("#promoCheck").is(":checked")){

			cpnUrl = "/event/groobee/20240514_result.asp";

			jQuery.ajax({
				type: "POST",
				url: cpnUrl,
				data: "rand=" + Math.random(),
				dataType : "JSON",
				success: function(data) {
					var result = data.result;
					var msg = data.msg;

					if (result == 9) { 
						alert("로그인 후 이용해 주세요.");
						top.location.href=msg;
					}
					if (result == 2) { 
						alert(msg);
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html(msg);
					}			
					if (result == 3) { 
						alert(msg);
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html(msg);
					}
					if (result == 8) { 
						alert(msg);
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html(msg);
					}
					if (result == 0) { 
						alert(msg);
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html(msg);
						//top.location.href="/mypage/coupon.asp";
					}		
				},
				error: function(e) {

				}
			});	

		}else{
			alert("SMS 마케팅 수신동의에 동의해주세요.")
			//$('body').addClass('cfm--open');
			//$('.eventCmt').html("SMS 마케팅 수신동의에 동의해주세요.");
		}
	}

	//20240320 쿠폰x 두산티징 알림신청
	function doosanAlrim2024(){
		if ($("#promoCheck").is(":checked")){

			cpnUrl = "/event/groobee/20240429_result.asp";

			jQuery.ajax({
				type: "POST",
				url: cpnUrl,
				data: "rand=" + Math.random(),
				dataType : "JSON",
				success: function(data) {
					var result = data.result;
					var msg = data.msg;

					if (result == 9) { 
						alert("로그인 후 이용해 주세요.");
						top.location.href=msg;
					}
					if (result == 2) { 
						alert(msg);
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html(msg);
					}			
					if (result == 3) { 
						alert(msg);
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html(msg);
					}
					if (result == 8) { 
						alert(msg);
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html(msg);
					}
					if (result == 0) { 
						alert(msg);
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html(msg);
						//top.location.href="/mypage/coupon.asp";
					}		
				},
				error: function(e) {

				}
			});	

		}else{
			alert("SMS 마케팅 수신동의에 동의해주세요.")
			//$('body').addClass('cfm--open');
			//$('.eventCmt').html("SMS 마케팅 수신동의에 동의해주세요.");
		}
	}


	//20240604 쿠폰x 알림신청
	function ojosConfirm(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20240604_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}			
								if (result == 3) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 8) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 0) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
									//top.location.href="/mypage/coupon.asp";
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html("SMS 마케팅 수신동의에 동의해주세요.");
					}
				}
			},
			error: function(e) {

			}
		});

	}

	//20240612 쿠폰x 알림신청
	function mw2406Confirm(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20240612_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}			
								if (result == 3) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 8) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 0) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
									//top.location.href="/mypage/coupon.asp";
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html("SMS 마케팅 수신동의에 동의해주세요.");
					}
				}
			},
			error: function(e) {

			}
		});

	}


	//'''LHS 20240701	'''기획전 카카오 플친 쿠폰다운로드
	function groobee240701(){
		cpnUrl = "/event/groobee/20240701_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}


	//20240712 쿠폰x 알림신청
	function groobee240712(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20240712_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}			
								if (result == 3) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 8) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 0) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
									//top.location.href="/mypage/coupon.asp";
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html("SMS 마케팅 수신동의에 동의해주세요.");
					}
				}
			},
			error: function(e) {

			}
		});

	}

	//20240719 쿠폰x 알림신청
	function groobee240719(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20240719_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}			
								if (result == 3) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 8) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 0) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
									//top.location.href="/mypage/coupon.asp";
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html("SMS 마케팅 수신동의에 동의해주세요.");
					}
				}
			},
			error: function(e) {

			}
		});

	}

	//20240807 쿠폰x 알림신청
	function groobee240807(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20240807_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}			
								if (result == 3) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 8) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 0) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
									//top.location.href="/mypage/coupon.asp";
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html("SMS 마케팅 수신동의에 동의해주세요.");
					}
				}
			},
			error: function(e) {

			}
		});

	}

	//20240812 쿠폰x 알림신청
	function groobee240812(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20240812_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}			
								if (result == 3) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 8) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
								}
								if (result == 0) { 
									alert(msg);
									//$('body').addClass('cfm--open');
									//$('.eventCmt').html(msg);
									//top.location.href="/mypage/coupon.asp";
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
						//$('body').addClass('cfm--open');
						//$('.eventCmt').html("SMS 마케팅 수신동의에 동의해주세요.");
					}
				}
			},
			error: function(e) {

			}
		});

	}

	//'''LHS 20240813	'''기획전 쿠폰다운로드
	function groobee240813(){
		cpnUrl = "/event/groobee/20240813_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//20240906 쿠폰x 알림신청
	function groobee240906(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20240906_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
								}			
								if (result == 3) { 
									alert(msg);
								}
								if (result == 8) { 
									alert(msg);
								}
								if (result == 0) { 
									alert(msg);
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
					}
				}
			},
			error: function(e) {

			}
		});

	}

	//'''LHS 20241001	'''기획전 카카오 플친 쿠폰다운로드
	function groobee241001(){
		cpnUrl = "/event/groobee/20241001_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20241101	'''기획전 키즈 11월 쿠폰팩 쿠폰다운로드
	function groobee241101(){
		cpnUrl = "/event/groobee/20241101_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//20241118 쿠폰x 알림신청
	function groobee241121(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20241121_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
								}			
								if (result == 3) { 
									alert(msg);
								}
								if (result == 8) { 
									alert(msg);
								}
								if (result == 0) { 
									alert(msg);
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
					}
				}
			},
			error: function(e) {

			}
		});

	}

	//'''LHS 20250106	'''기획전 키워드 쿠폰다운로드 
	function groobee250106(){
		cpnUrl = "/event/groobee/20250106_result.asp";
		var keyword = $("#keywordCpn").val();
		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			data : "keyword=" + keyword,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20250101	'''기획전 카카오 플친 쿠폰다운로드
	function groobee250101(){
		cpnUrl = "/event/groobee/20250101_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20250116	'''기획전 쿠폰다운로드
	function groobee250116(){
		cpnUrl = "/event/groobee/20250116_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20250422	'''기획전 쿠폰다운로드
	function groobee250422(){
		cpnUrl = "/event/groobee/20250422_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20250512	'''기획전 쿠폰다운로드
	function groobee250512(){
		cpnUrl = "/event/groobee/20250512_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20250630	'''기획전 쿠폰다운로드
	function groobee250630(){
		cpnUrl = "/event/groobee/20250630_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}
	//'''LHS 20250721	'''기획전 쿠폰다운로드
	function groobee250721(){
		cpnUrl = "/event/groobee/20250721_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20250912	'''기획전 쿠폰다운로드
	function groobee250915(){
		cpnUrl = "/event/groobee/20250915_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20250912	'''기획전 쿠폰다운로드
	function groobee250915_2(){
		cpnUrl = "/event/groobee/20250915_2_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20250917	'''기획전 쿠폰다운로드
	function groobee250919(mode){
		cpnUrl = "/event/groobee/20250919_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			data: "mode=" + mode,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20251030	'''기획전 쿠폰다운로드
	function groobee251030(){
		cpnUrl = "/event/groobee/20251030_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//'''LHS 20251216	'''기획전 쿠폰다운로드
	function groobee251216(){
		cpnUrl = "/event/groobee/20251216_result.asp";

		jQuery.ajax({
			type: "POST",
			url: cpnUrl,
			dataType : "JSON",
			success: function(data) {
				var result = data.result;
				var msg = data.msg;

				if (result == 9) { 
					alert("로그인 후 이용해 주세요.");
					top.location.href=msg;
				}
				if (result == 2) { 
					alert(msg);
				}			
				if (result == 3) { 
					alert(msg);
				}						
				if (result == 0) { 
					alert(msg);
					//top.location.href="/mypage/coupon.asp";
				}		
			},
			error: function(e) {

			}
		});	
	}

	//20251218 쿠폰x 알림신청
	function groobee251218(){
		loginUrl = "/member/ajaxGlobalMenu.asp"
		jQuery.ajax({
			type: "POST",
			url: loginUrl,
			data: "rand=" + Math.random(),
			dataType : "JSON",
			success: function(logindata) {
				idName = logindata.idname;
				if (idName == ""){
					alert("로그인 후 이용해 주세요.");
					top.location.href="/login.htm";
				}else{
					if ($("#promoCheck").is(":checked")){

						cpnUrl = "/event/groobee/20251218_result.asp";

						jQuery.ajax({
							type: "POST",
							url: cpnUrl,
							data: "rand=" + Math.random(),
							dataType : "JSON",
							success: function(data) {
								var result = data.result;
								var msg = data.msg;

								if (result == 9) { 
									alert("로그인 후 이용해 주세요.");
									top.location.href=msg;
								}
								if (result == 2) { 
									alert(msg);
								}			
								if (result == 3) { 
									alert(msg);
								}
								if (result == 8) { 
									alert(msg);
								}
								if (result == 0) { 
									alert(msg);
								}		
							},
							error: function(e) {

							}
						});	

					}else{
						alert("SMS 마케팅 수신동의에 동의해주세요.")
					}
				}
			},
			error: function(e) {

			}
		});

	}


// 그루비 추천 상품 수신 과 노출 처리를 위한 필수 스크립트 함수
// 함수명 변경 불가
var goodspno = "";
var goodspno2 = "";
var ValgorithmCd = "";
var VcampaignKey = "";
var ValgorithmCd2 = "";
var VcampaignKey2 = "";

function setGroobeeRecommend (algorithmCd, campaignKey, goodsArray) {

goodspno = "";
goodspno2 = "";
console.log(campaignKey);
console.log(goodsArray);
	//장바구니 추천상품 , 메인 추천상품
	if (campaignKey == "RE738f096310d14a80aa0e6c99d11f9b43" ){
		//장바구니 팝업
		for(key in goodsArray) {
			for (key2 in goodsArray[key]){
				if (goodspno == ""){
					goodspno = goodsArray[key][key2];
				}else{
					goodspno += "," + goodsArray[key][key2];
				}
				
			}
		}


		ValgorithmCd = algorithmCd;
		VcampaignKey = campaignKey;

		//"RE738f096310d14a80aa0e6c99d11f9b43"
		  // 추천 상품 노출 처리
		  var groobeeObj;
		  groobeeObj = {
			  algorithmCd : algorithmCd,
			  campaignKey : campaignKey,
			  campaignTypeCd : "RE",
			  goods: goodsArray
		  }
		  groobee.send("DI", groobeeObj);
		
	}else{
		mode = "view";
		if (campaignKey == "RE7b06443a1835447885f5397a2ad35ea3"){
			//상세 상단
			tagID = "";
		}else if(campaignKey == "RE3ba0cf1effa6490f9216acae3703cba5///" || campaignKey == "REe82aabcd847a42ec827f14aebd7dacd41" || campaignKey == "REe82aabcd847a42ec827f14aebd7dacd4") {
			//상세 하단
			tagID = "recopickProduct";
			mode = "MAINDIVCART"
		}else if(campaignKey == "REc35a1dc7440342d7a61c65d4e92b2fd9///" || campaignKey == "RE63da5c31590d4fe9bb342b6d5c72c2a2" || campaignKey == "REf70e838c71bf4db080614ac8405f5fe1" || campaignKey == "REc0b801fec2a44867b7cfad920d94b778///"){
			//검색페이지,오늘 본 상품,위시리스트, 장바구니
			tagID = "recopickProduct";
			mode = "MAINDIVCART"
		}else if(campaignKey == "REd9c4a9844e4a43d6b5c5cb1cc570b743" || campaignKey == "RE9fe4a0d8b08149d2ad955d0983e89c17" || campaignKey == "RE8f31195d88214821946733f00d611266"){
			//기획전 상세,주문완료, 주문상세
			tagID = "recopickProduct";
			mode = "MAINDIV"
		}else if(campaignKey == "REae0d8912d1c34563a8f031af8b2a0181"){
			//2021-08-19 1n1상세 상단
			tagID = "recopickProduct";
		}else if(campaignKey == "REa8d64c1e7c7045cdaa9557c4ae83e07b"){
			//2021-08-19 1n1상세 하단
			tagID = "";
		}else if(campaignKey == "REa6ff915f494d46eca43851470022812f///"){
			//2021-09-16 KIDS Items you’ll like
			tagID = "recopickProduct";
			mode = "MAINDIV"
		}else if(campaignKey == "RE3ca54f07932b48b8857a8c1182dcacde"){
			//2022-05-13 /order/mafila.asp
			tagID = "recopickProduct";
			mode = "MAINDIV"
		}else if (campaignKey == "REdcc67e4f8778494eac3e99f4ee2f7a5c///"){
			//메인추천
			tagID = "recopickProduct";
			mode = "MAINDIVCART"
		}else if (campaignKey == "RE116ac5cf56024f5dbd474f9e4f8eb95a" )	{
			//상세 하단2
			tagID = "recopickProduct2";
			mode = "MAINDIVCART"
		}else{
			tagID = "";
		}

		for(key in goodsArray) {
			for (key2 in goodsArray[key]){
				if (goodspno2 == ""){
					goodspno2 = goodsArray[key][key2];
				}else{
					goodspno2 += "," + goodsArray[key][key2];
				}
				
			}
		}

		ValgorithmCd2 = algorithmCd;
		VcampaignKey2 = campaignKey;

		  // 추천 상품 노출 처리
		  var groobeeObj;
		  groobeeObj = {
			  algorithmCd : algorithmCd,
			  campaignKey : campaignKey,
			  campaignTypeCd : "RE",
			  goods: goodsArray
		  }
		  groobee.send("DI", groobeeObj);
		console.log(tagID)
		if (tagID != ""){
			GetCartGroobeView(tagID,algorithmCd, campaignKey, goodspno2,mode)
		}
	}

}
// 추천 상품 클릭 시 호출 되는 스크립트 함수
// 함수명 자유 작성
function clickGroobeeProduct (algorithmCd, campaignKey, goodsNo) {
  // 추천 상품 클릭 처리
  var groobeeObj;
  groobeeObj = {
    algorithmCd : algorithmCd,
    campaignKey : campaignKey,
    campaignTypeCd : "RE",
    goods: [
        {goodsCd: goodsNo}
    ]
  } 
  groobee.send("CL", groobeeObj);

  // 페이지 이동 처리
// [✔고객사 작성 영역 code…

}


function GetCartGroobeView(tagID,algorithmCd, campaignKey, goodsNo,mode){

	//console.log(slidesNo);
	jQuery.ajax({
		type: "POST",
		url: "/ext/groobe_cart_data.asp",
		data: { "productNo" : goodsNo, "algorithmCd" : algorithmCd, "campaignKey" : campaignKey, "mode" : mode},
		async: true,
		success: function (data) {
				if ( data == "" )	{
					jQuery("#" + tagID).hide();
				}else {
					jQuery("#" + tagID).show();
					jQuery("#" + tagID).append(data);					
				}


			}
	})
}

function GetCartInsiderView(tagID,campaignId,variationId,goodsNo,mode){

	//console.log(slidesNo);
	jQuery.ajax({
		type: "POST",
		url: "/ext/groobe_cart_data.asp",
		data: { "productNo" : goodsNo, "campaignId" : campaignId, "variationId" : variationId , "mode" : mode},
		async: true,
		success: function (data) {
				if ( data == "" )	{
					jQuery("#" + tagID).hide();
				}else {
					jQuery("#" + tagID).empty();
					jQuery("#" + tagID).addClass("ins-preview-wrapper-" + variationId);
					jQuery("#" + tagID).show();
					jQuery("#" + tagID).html(data);				
				}


			}
	})
}


function checkoutbtn_getback() {
	var str = '<a href="javascript:pay_checkout();void(0);" class="btn_bg__bk on">구매하기</a>';
	jQuery("#checkoutbtn").html(str);
}

function sWordHistory(){
	jQuery.ajax({
		type: "POST",
		url: "/main/sWordHistory.asp",
		data: "",
		dataType : "HTML",
		success: function (data) {
			$("#sWordHistory").empty().html(data);
		}
	})
}


jQuery(function(){
	// 수량 빼기
	jQuery(document).on("click",  "#vpop99 button[id^=qtyMinusW]", function() {

		var maxStock = jQuery("input:radio[name='ProductSize_Cart']:checked").attr("data-limit") != undefined ?jQuery("input:radio[name='ProductSize_Cart']:checked").attr("data-limit") : ProductStockLimitNumber ; 
		var minStock = maxStock > 0 ? 1 : 0 ;

		var obj = jQuery(this).next( "input[id^=ProductQuantityW]" )
		var qtyVal = obj.val(); 
		
		qtyVal = jQuery.isNumeric(qtyVal) ? qtyVal : minStock ;
		qtyVal--;
		qtyVal = qtyVal < minStock ? minStock : qtyVal ;
		obj.val( qtyVal );
		var val7 = document.form99.cartPrice.value;
		$("#ctoprice").html(PrintComma(val7*qtyVal)+"원");
	})
	// 수량 더하기
	jQuery(document).on("click",  "#vpop99 button[id^=qtyPlusW]", function() {
		var maxStock = jQuery("input:radio[name='ProductSize_Cart']:checked").attr("data-limit") != undefined ?jQuery("input:radio[name='ProductSize_Cart']:checked").attr("data-limit") : ProductStockLimitNumber ; 
		var minStock = maxStock > 0 ? 1 : 0 ;
		//console.log(11);
		var obj = jQuery(this).prev( "input[id^=ProductQuantityW]" ); 
		var qtyVal = obj.val(); 
		qtyVal = jQuery.isNumeric(qtyVal) ? qtyVal : minStock ;
		qtyVal++;
		if (qtyVal > maxStock) { 
			alert(maxStock + "개 까지만 주문 가능합니다");
		}
		qtyVal = qtyVal > maxStock ? maxStock : qtyVal ;
		obj.val( qtyVal );
		var val7 = document.form99.cartPrice.value;
		$("#ctoprice").html(PrintComma(val7*qtyVal)+"원");
	})
	jQuery(document).on("blur", "#vpop99 input[id^=ProductQuantityW]", function() {
		var maxStock = jQuery("input:radio[name='ProductSize_Cart']:checked").attr("data-limit") != undefined ?jQuery("input:radio[name='ProductSize_Cart']:checked").attr("data-limit") : ProductStockLimitNumber ; 
		var minStock = maxStock > 0 ? 1 : 0 ;

		var regex = /[0-9]|\./;
		var obj = jQuery(this);
		var val = obj.val();
		if (val > maxStock) { 
			alert(maxStock + "개 까지만 주문 가능합니다");
		}
		!regex.test( val ) ? obj.val( minStock ) : "" ;

		val < minStock ? obj.val( minStock ) : "" ;
		val > maxStock ? obj.val( maxStock ) : "" ;
		var val7 = document.form99.cartPrice.value;
		$("#ctoprice").html(PrintComma(val7*qtyVal)+"원");
	})

	//'''20250307 searchHistoryAjax
	sWordHistory();
})


