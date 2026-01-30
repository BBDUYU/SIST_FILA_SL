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
			main.init();
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
	
	var main = {
		init: function(){
			main.goodsScrollSlider();
			main.selectChange();
			main.mainSlider();
			main.subSlider();
			main.brandSlider();
			main.bannerSlider();
			main.scrollTop();
		},
		goodsScrollSlider: function(){
			$('.goods-scroll-box').each(function(idx){
				$(this).addClass('_gs0' + idx);

				var swiper = new Swiper('._gs0' + idx + ' .goods__slider', {
					observer: true,
					observeParents: true,
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
					},
					initialSlide: 1
				});

				swiper.slideTo(0, 0, false);

				/*$('.goods-scroll-box .category-btn-box button').on('click', function(){
					setTimeout(function(){
						swiper.slideTo(0, 0, false);
					}, 500);
				});*/
			});		
			
			// 2024-06-11 추천 스타일 영상 추가
			/*$('body').on('click', '.main__contents .goods-scroll-box._type_thumb_vdo .slider-box .goods a', function(e){
				e.preventDefault();
				
				$('.main__contents .goods-scroll-box._type_thumb_vdo .slider-box .goods').removeClass('_vdo_open');
				$(this).parents('.swiper-slide').addClass('_vdo_open');

				if($(this).parents('.swiper-slide').hasClass('_vdo_open')){
					for(var i = 0; i < $('._type_thumb_vdo video').length; i++){
						$('.swiper-slide .thumb-vdo-box video').get(i).pause();
					}	
					$('._vdo_open .thumb-vdo-box video').get(0).play();
				}else{
					for(var i = 0; i < $('._type_thumb_vdo video').length; i++){
						$('.swiper-slide .thumb-vdo-box video').get(i).pause();
					}	
				}
			});

			if($('.main__contents .goods-scroll-box._type_thumb_vdo .slider-box .goods').hasClass('_vdo_open')){
				$('._vdo_open .thumb-vdo-box video').get(0).play();
			}else{
				for(var i = 0; i < $('._type_thumb_vdo video').length; i++){
					$('.swiper-slide .thumb-vdo-box video').get(i).pause();
				}	
			}*/
		
			if($('.goods-scroll-box._type_thumb_vdo').length){
				var thumbSwiper = document.querySelector('.goods-scroll-box._type_thumb_vdo .goods__slider').swiper;				
				thumbSwiper.slideTo(0, 0, false);
			}
			
			$('body').on('click', '.main__contents .goods-scroll-box._type_thumb_vdo .slider-box .goods a', function(e){
				e.preventDefault();

				var vdoSrc = $(this).attr('data-vdo-src');
				
				$('.main__contents .goods-scroll-box._type_thumb_vdo .slider-box .goods').removeClass('_vdo_open');
				$(this).parents('.swiper-slide').addClass('_vdo_open');

				$('.goods-scroll-box._type_thumb_vdo .slider-box .goods .thumb-vdo-box video').remove();
				$(this).parents('.photo').find('.thumb-vdo-box').html('<video muted playsinline loop autoplay>											<source src="' + vdoSrc + '">										</video>');
			});		
		},
		selectChange: function(){
			$('.goods-search-box select').on('change', function(){
				if($(this).val() == 'selectOption'){
					$(this).removeClass('_selected');
				}else{
					$(this).addClass('_selected');
				}
			});
		},
		mainSlider: function(){
			var totalSlide = $('._main_slider .swiper-slide').length;

			var swiper = new Swiper('._main_slider .main__slider', {
				direction: 'horizontal',
				loop: true,
				loopAdditionalSlides: 1,
				slidesPerView: 1,
				navigation: {
					nextEl: '._main_slider .next__btn',
					prevEl: '._main_slider .prev__btn',
				},
				pagination: {
					el: '.main-slider-pagination',
					clickable: true
				},
				on: {
					transitionStart: function(){
						if($('.swiper-slide-active').hasClass('_type_vdo')){
							for(var i = 0; i < $('._type_vdo video').length; i++){
								$('.swiper-slide .vdo-box video').get(i).pause();
							}	

							$('.swiper-slide-active .vdo-box video').get(0).play();							
						}else{
							for(var i = 0; i < $('._type_vdo video').length; i++){
								$('.swiper-slide .vdo-box video').get(i).pause();
							}							
						}
					}
				}
			});
	
			if($('.swiper-slide-active').hasClass('_type_vdo')){
				$('.swiper-slide-active .vdo-box video').get(0).play();
			}

			if(totalSlide == 1){
				$('.main-slider-pagination').addClass('_hide');
			}
			
			$('.main-slider-pagination').attr('data-total-num', totalSlide);
			$('.main-slider-pagination').attr('data-curr-num', swiper.realIndex + 1);
			$('.main-slider-pagination + .pagination-curr-bar > div').css({
				'width' : ((swiper.realIndex + 1) / totalSlide) * 100 + '%',
				'left' : (swiper.realIndex / totalSlide) * 100 + '%'
			});
			
			if($('.swiper-slide-active').hasClass('_type_vdo')){
				swiper.autoplay.stop();
			}else{
				swiper.autoplay.start();
			}

			swiper.on('slideChange', function(){
				$('.main-slider-pagination').attr('data-curr-num', swiper.realIndex + 1);

				$('.main-slider-pagination + .pagination-curr-bar > div').css({
					'left' : (swiper.realIndex / totalSlide) * 100 + '%'
				});				
			});

			swiper.on('slideChangeTransitionStart', function(){
				if($('.swiper-slide-active').hasClass('_type_vdo')){
					swiper.autoplay.stop();
				}else{
					swiper.autoplay.start();
				}
			});

			setInterval(function(){
				if($('.swiper-slide-active').hasClass('_type_vdo')){
					if($('.main-slider-box .swiper-slide-active .vdo-box video').prop('ended')){
						swiper.slideNext();
					}
				}
			}, 200);
		},
		subSlider: function(){
			/*var swiper = new Swiper('._sub_slider .main__slider', {
				effect: 'fade',
				direction: 'horizontal',
				slidesPerView: 1,
				scrollbar: {
					el: '.main-slider-scrollbar',
				},
				on: {
					transitionStart: function(){
						if($('.swiper-slide-active').hasClass('_type_vdo')){
							for(var i = 0; i < $('._type_vdo video').length; i++){
								$('.swiper-slide .vdo-box video').get(i).pause();
							}	

							$('.swiper-slide-active .vdo-box video').get(0).play();
						}else{
							for(var i = 0; i < $('._type_vdo video').length; i++){
								$('.swiper-slide .vdo-box video').get(i).pause();
							}							
						}						
					}
				}
			});	
			
			
	
			if($('.swiper-slide-active').hasClass('_type_vdo')){
				$('.swiper-slide-active .vdo-box video').get(0).play();
			}*/


			var totalSlide = $('._sub_slider .swiper-slide').length;

			var swiper = new Swiper('._sub_slider .main__slider', {
				effect: 'fade',
				direction: 'horizontal',
				loop: totalSlide > 1,
				loopAdditionalSlides: 1,
				slidesPerView: 1,
				navigation: {
					nextEl: '._sub_slider .next__btn',
					prevEl: '._sub_slider .prev__btn',
				},
				pagination: {
					el: '.main-slider-pagination',
					clickable: true
				},
				on: {
					transitionStart: function(){
						if($('.swiper-slide-active').hasClass('_type_vdo')){
							for(var i = 0; i < $('._type_vdo video').length; i++){
								$('.swiper-slide .vdo-box video').get(i).pause();
							}	

							$('.swiper-slide-active .vdo-box video').get(0).play();							
						}else{
							for(var i = 0; i < $('._type_vdo video').length; i++){
								$('.swiper-slide .vdo-box video').get(i).pause();
							}							
						}
					}
				}
			});
	
			if($('.swiper-slide-active').hasClass('_type_vdo')){
				$('.swiper-slide-active .vdo-box video').get(0).play();
			}

			if(totalSlide == 1){
				$('.main-slider-pagination').addClass('_hide');
			}
			
			$('.main-slider-pagination').attr('data-total-num', totalSlide);
			$('.main-slider-pagination').attr('data-curr-num', swiper.realIndex + 1);
			$('.main-slider-pagination + .pagination-curr-bar > div').css({
				'width' : ((swiper.realIndex + 1) / totalSlide) * 100 + '%',
				'left' : (swiper.realIndex / totalSlide) * 100 + '%'
			});
			
			if($('.swiper-slide-active').hasClass('_type_vdo')){
				swiper.autoplay.stop();
			}else{
				swiper.autoplay.start();
			}

			swiper.on('slideChange', function(){
				$('.main-slider-pagination').attr('data-curr-num', swiper.realIndex + 1);

				$('.main-slider-pagination + .pagination-curr-bar > div').css({
					'left' : (swiper.realIndex / totalSlide) * 100 + '%'
				});				
			});

			swiper.on('slideChangeTransitionStart', function(){
				if($('.swiper-slide-active').hasClass('_type_vdo')){
					swiper.autoplay.stop();
				}else{
					swiper.autoplay.start();
				}
			});

			setInterval(function(){
				if($('.swiper-slide-active').hasClass('_type_vdo')){
					if($('.main-slider-box .swiper-slide-active .vdo-box video').prop('ended')){
						swiper.slideNext();
					}
				}
			}, 200);

		},
		brandSlider: function(){
			$('.brand-slider-box').each(function(idx){
				$(this).addClass('_bs0' + idx);

				var swiper = new Swiper('._bs0' + idx + ' .tennis-story-box', {
					direction: 'horizontal',
					loop: true,
					spaceBetween: 40,
					freeMode: true,
					slidesPerView: 'auto',
					slidesOffsetBefore: 240,
					slidesOffsetAfter: 0
				});
			});		
		},
		bannerSlider: function(){
			var swiper = new Swiper('.banner__slider', {
				observer: true,
				observeParents: true,
				direction: 'horizontal',
				freeMode: true,
				noSwiping: false,
				spaceBetween: 40,
				allowSlidePrev: true,
				allowSlideNext: true,
				mousewheel: {
					invert: true,
					forceToAxis: true
				},
				slidesPerView: 'auto',
				slidesOffsetBefore: 0,
				slidesOffsetAfter: 0
			});

			if($('.main-banner-box .banner__slider .swiper-slide').length < 3){
				$('.main-banner-box .banner__slider .swiper-wrapper').addClass('_center_slide');
			}else{
				$('.main-banner-box .banner__slider .swiper-wrapper').removeClass('_center_slide');
			}
		},
		scrollTop: function() {
			$('.cateMain').on('click', function(){
				  $('html, body').animate({scrollTop: '0'}, 680);
			});
		}
	}
	
})(jQuery);
