(function(ssq){
	var	struc={}, config={}, listener={};
	ssq(document).ready(function(){ struc.init(); });
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
			list.init();
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
	
	var list = {
		init: function(){
			list.filterOpenClose();
			list.filterOption();
			list.filterMoreBtn();
			list.thumbChnage();
			//list.setUpCartLayer();
			list.goodsScrollSlider();
			list.addCartLayer();
			list.layer.init();
			list.comparisonBtn();
			list.styleGoodsSlider();
			list.priceRenge();
		},
		filterOpenClose: function(){
			/*
			if($('body').hasClass('list')){
				setTimeout(function(){
					$('body').toggleClass('filter--open');
				}, 2000);
			}
			*/

			$('.filter__btn').on('click', function(){
				$('body').toggleClass('filter--open');
			});

		},
		filterOption: function(){
			$('.toggle__btn').on('click', function(){
				$(this).parent('div').toggleClass('open');
			});
		},
		filterMoreBtn: function(){
			$('body').on('click', '.filter-box .option-box .more__btn', function(){
				$(this).parent('.inp-box').find('ul').toggleClass('hide__list');
			});
		},
		thumbChnage: function(){
			$('.col-box button').on('click', function(){
				if($(this).hasClass('col3__btn')){
					$('.goods-list-box').removeClass('_thumb04');
					$('.goods-list-box').addClass('_thumb03');
					dataFrame.location.href = "/product/thumlist.asp?thumNo=3";
				}else{
					$('.goods-list-box').removeClass('_thumb03');
					$('.goods-list-box').addClass('_thumb04');
					dataFrame.location.href = "/product/thumlist.asp?thumNo=4";
				}
			});
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
		addCartLayer: function(){
			var btn = ssq('.goods-scroll-box .cart__btn');
			var popup = function(cartno) {
				ssq.ajax({
					type: 'GET',
					url: '/pc/order/pop_cart.asp',
					data: 'cartno=' + cartno,
					dataType: 'html',
					success: function(html) {
						ssq('body').append(html);
					},
					error: function(e) {
						layerAlert('e');
					}
				});
			} 
			
			btn.on('click', function() {
				var cartno = ssq(this).attr("data-no");
				popup(cartno);
			});

			ssq('body').on('click', '.common__layer._option .close__btn', function(){
				ssq('.common__layer').remove();
			});
		},
		layer: {
			init: function(){
				list.layer.comparison();
			},
			comparison: function(){
				var popup = function(){
					var pnoArr = [];
					$('.comparison-chk:checked').each(function(){
						pnoArr.push($(this).val());
					})
//					console.log(pnoArr);

					$.ajax({
						type: 'GET',
						url: '/pc/product/pop_comparison.asp',
						data: 'ProductNo=' + pnoArr,
						dataType: 'html',
						success: function(html) {
							$('body').addClass('lyr-comparison--open');
							$('body').append(html);


						},
						error: function(e) {
							console.log(e)
						}
					});
				};

				$('body').on('click', '.lyr-comparison__btn', function(){
					popup();
				});

				$('body').on('click', '.common__layer._comparison .close__btn', function(){
					$('body').removeClass('lyr-comparison--open');
					$('.common__layer._comparison').remove();
				});
			}
		},
		comparisonBtn: function(){
			$('.comparison__btn').on('click', function(){
				$('.goods-list-box').toggleClass('_on_comparison');
			});

			$('body').on('click', '.comparison-close__btn', function(){
				$('.comparison-chk').prop('checked', false);
				$('.goods-list-box').removeClass('_goods_chk');
				$('.goods-list-box').removeClass('_on_comparison');
			});						

			$('body').on('click', '.comparison-chk + label', function(){
					var comno = $(this).attr("data-no");
				setTimeout(function(){			
					var totalChk = totalChk = $('.comparison-chk:checked').length;					
					if(totalChk > 1 && totalChk <= 3){
						$('.goods-list-box').addClass('_goods_chk');
					}else if (totalChk > 3){
						alert("비교상품은 3개만 가능합니다.");
						$(".comparisonchk" + comno).click();
						$('.goods-list-box').addClass('_goods_chk');
					}else{
						$('.goods-list-box').removeClass('_goods_chk');
					}
					if (totalChk < 4){
						$('.lyr-comparison__btn span').text(totalChk);
					}
				}, 200);				
			});
		},
		styleGoodsSlider: function(){
			if($('.style-goods .after').length){
				$('.style-goods').each(function(idx){
					$(this).addClass('_sg0' + idx);
					
					if($('._sg0' + idx + ' .hover__slider .swiper-slide').length != 1){

					var swiper = new Swiper('._sg0' + idx + ' .hover__slider', {
						//spaceBetween: 5,
						loop: true,
					    pagination: {
							el: '._sg0' + idx + ' .sg-swiper-pagination',
							clickable: true,
						},
						//scrollbar: {
						//	el: '._sg0' + idx + ' .slider-scrollbar',
						//},
						navigation: {
						  nextEl: '._sg0' + idx + ' .next__btn',
						  prevEl: '._sg0' + idx + ' .prev__btn',
						}
					});

					}

					//setTimeout(function(){
						if($('._sg0' + idx + ' .hover__slider .swiper-slide').length != 1){
							$('._sg0' + idx + ' .bot__layer').addClass('_show');
						}
					//}, 1000)
				});
			}
		},
		priceRenge: function(){
			const inputLeft = document.getElementById("input-left");
			const inputRight = document.getElementById("input-right");

			const thumbLeft = document.querySelector(".slider > .thumb.left");
			const thumbRight = document.querySelector(".slider > .thumb.right");
			const range = document.querySelector(".slider > .range");

			const setLeftValue = () => {
			  const _this = inputLeft;
			  const [min, max] = [parseInt(_this.min), parseInt(_this.max)];
			  
			  _this.value = Math.min(parseInt(_this.value), parseInt(inputRight.value) - 1);
			  _this.value = Math.floor(_this.value/1000) * 1000;
			  
			  const percent = ((_this.value - min) / (max - min)) * 100;
			  ssq("#pricestart").val(_this.value);
			  ssq("#priceRange_MinText").html(PrintComma(_this.value));
			  thumbLeft.style.left = percent + "%";
			  range.style.left = percent + "%";
			};

			const setRightValue = () => {
			  const _this = inputRight;
			  const [min, max] = [parseInt(_this.min), parseInt(_this.max)];
			  
			  _this.value = Math.max(parseInt(_this.value), parseInt(inputLeft.value) + 1);
			  _this.value = Math.floor(_this.value/1000) * 1000;
			  
			  const percent = ((_this.value - min) / (max - min)) * 100;
			  ssq("#priceend").val(_this.value);
			  ssq("#priceRange_MaxText").html(PrintComma(_this.value));
			  thumbRight.style.right = 100 - percent + "%";
			  range.style.right = 100 - percent + "%";
			};
			try{
			inputLeft.addEventListener("input", setLeftValue);
			inputRight.addEventListener("input", setRightValue);
			}catch(e){
			}
		}
	}

	
})(jQuery);

function goPage(page){
	document.sFrm.page.value = page;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);
	document.sFrm.submit();
}

function searchKeyword(){
	document.sFrm.page.value = 1;		
	document.sFrm.submit();		
}
function searchKeyword2(){
	document.sFrm2.page.value = 1;		
	document.sFrm2.submit();		
}
function changeValue(val1,val2){
	jQuery("input[name='"+val2+"']").val(val1);
}

function choiceColor(){
	var colors;
	colors = jQuery("#colorTemp").val();		
	document.sFrm.colorVal.value = colors;
	document.sFrm.page.value = 1;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);
	$("#product_list").empty();
	listAppend();
}
/*
function choicePrice(){
	var price1, price2;
	price1 = jQuery("#price1").val();	
	price2 = jQuery("#price2").val();		
	document.sFrm.page.value = 1;
	document.sFrm.priceS.value = price1;
	document.sFrm.priceE.value = price2;	
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);	
	document.sFrm.submit();
}
*/
function changePrice(val){
	document.sFrm.page.value = 1;
	document.sFrm.priceVal.value = val;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);	
	$("#product_list").empty();
	listAppend();
}
function changePrice2(){
	document.sFrm.page.value = 1;
	document.sFrm.pricestart.value = $("#pricestart").val();
	document.sFrm.priceend.value = $("#priceend").val();
	$("#product_list").empty();
	listAppend();
}

function changeSort(val){
	document.sFrm.page.value = 1;
	document.sFrm.sortVal.value = val;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);	
	//document.sFrm.submit();
	$("#product_list").empty();
	listAppend();
}

function changeDepth(val){
	document.sFrm.page.value = 1;
	document.sFrm.depthVal.value = val;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);	
	document.sFrm.submit();
}

function changeCount(val){
	document.sFrm.page.value = 1;
	document.sFrm.countVal.value = val;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);	
	document.sFrm.submit();
}

function changeViewAll(val){
	document.sFrm.page.value = 1;
	document.sFrm.viewAll.value = val;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);	
	document.sFrm.submit();
}

function choiceColorPrice(){
	var price11, price22;
	price11 = jQuery("#price11").val();	
	price22 = jQuery("#price22").val();		
	document.sFrm.priceS.value = price11;
	document.sFrm.priceE.value = price22;
	var colors;
	colors = jQuery("#colorTemp2").val();		
	document.sFrm.colorVal.value = colors;
	document.sFrm.page.value = 1;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);
	document.sFrm.submit();
}

$(function(){
		$("div.search_form input[type=checkbox]").on("click", function(){
			
			var o = $(this);
			var op = o.parent().parent().parent();
			var targetLayer = $("div#" + op.attr("id") + "Select");
			var targetLayer2 = $("div#" + op.attr("class") + "Select2");
			var targetName = op.attr("id") + "Choice";

			if (o.val() == 0 ){
				jQuery("." + targetName).prop('checked',this.checked)
			}else{
				jQuery("#" + op.attr("id") + "CheckAll").prop('checked',false)
			}

			selectValue(targetLayer, targetName, op.attr("id"));
			
		})


		function selectValue(targetLayer, targetName, targetId){
			var sizeValArr = new Array();
			var printData = "";

			jQuery("input[name=" + targetName + "]:checked").each(
				function(n,o){
					sizeValArr.push(jQuery(o).val());
				}
			);

			//jQuery(".selected_area").show();
			//console.log(printData);
			var targetLayer2 = $("div#" + targetId + "Select2");
			$("span",targetLayer2).remove();
			targetLayer.append(printData);
			targetLayer2.append(printData);
			jQuery("input[id=" + targetId + "Val]").val(sizeValArr.toString());
			if (jQuery("input[id=" + targetId + "Val]").val() == ""){
				jQuery("input[id=" + targetId + "Val]").val(0);
			}
			document.sFrm.page.value = 1;
			pageNo = 1;
			$("#product_list").empty();
			listAppend();	
		}
})

function filterReset(){
	$('input').prop('checked',false);
	document.sFrm.page.value = 1;
	document.sFrm.colorVal.value = "0";
	document.sFrm.priceVal.value = "0";
	document.sFrm.sizeVal.value = "0";
	document.sFrm.filterOpVal.value = "0";
	document.sFrm.sportsVal.value = "0";
	document.sFrm.fitVal.value = "0";
	document.sFrm.sexVal.value = "0";
	document.sFrm.wireVal.value = "0";
	$("#product_list").empty();
	listAppend();
}

function codiCart(codiNo){
				//$('body').removeClass('lyr-setup--open');
				//setTimeout(function(){
				//	$('form[name="setupForm"]:first-of-type').remove();
				//}, 1500);

				$.ajax({
					type: 'GET',
					url: '/pc/product/pop_style_cart.asp',
					data: 'codiNo=' + codiNo,
					dataType: 'html', 
					success: function(html) {
						$('body').addClass('lyr-setup--open');
						$('body').append(html);
https://assetscdn.styleship.com/assets/filaweb1/data/codi/03_2212%20copy_23.jpg
						$('.option-select-box select').on('change', function(){
							$(this).addClass('_start');
						});

						$('body').on('click', '.common__layer._setup_cart .close__btn, .lyr-setup__bg', function(){
							$('body').removeClass('lyr-setup--open');
							$('.common__layer._setup_cart').remove();

							//console.log('aaa');
						});

						 var swiper = new Swiper(".common__layer._setup_cart .photo__slider", { 
							loop: true,
							pagination: {
								el: ".swiper-pagination",
								clickable: true,
							},
							  navigation: {
								nextEl: ".swiper-button-next",
								prevEl: ".swiper-button-prev",
							  },
						});

						$('.layer-button-prev, .layer-button-next').on('click', function(){
							setTimeout(function(){
								$('form[name="setupForm"]:first-of-type').remove();
							}, 200);
						});
					},
					error: function(e) {
						console.log(e)
					}
				});


				$('body').on('click', '.common__layer._setup_cart .close__btn, .lyr-setup__bg', function(){
					$('body').removeClass('lyr-setup--open');
					$('.common__layer._setup_cart').remove();
				});
}

function cate1Chg(cate,cateTitle){
	document.sFrm.no.value = cate;
	document.sFrm.page.value = 1;
	//document.sFrm.sWord.value = unescape(document.sFrm.sWord.value);
	$(".ccc").removeClass("on");
	$(".cate" + cate).addClass("on");
	$("#cateTitle2").html(cateTitle);
	$("#product_list").empty();
	listAppend();
}



function GetProductList(){
		

}