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
			ja.init();
			la.init();
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
	
	var ja = {
		init: function(){
			ja.step1.init();
			ja.selectStyle();
			ja.inputStyle();
		},
		step1: {
			init: function(){
				ja.step1.tg();
				ja.step1.sel();
				ja.step1.eye();
			},
			tg: function(){
				var lb = ssq('.all-agree-box label');

				lb.on('click', function(){
					var cInput = ssq(this).parent().find('input');

					if(cInput.prop('checked') == true){
						ssq(this).parent('div').find('.arr-down-btn').removeClass('on');
						ssq(this).parent('div').parent('div').find('.agree-chk-wrap').removeClass('open');
						ssq(this).parent('div').parent('div').find('.self-agree-wrap').removeClass('open');
					}else{
						ssq(this).parent('div').find('.arr-down-btn').addClass('on');
						ssq(this).parent('div').parent('div').find('.agree-chk-wrap').addClass('open');
						ssq(this).parent('div').parent('div').find('.self-agree-wrap').addClass('open');
					}


				});

				ssq('.arr-down-btn').on('click', function(){
					ssq(this).toggleClass('on');
					ssq(this).parent('div').parent('div').find('.agree-chk-wrap').toggleClass('open');
					ssq(this).parent('div').parent('div').find('.self-agree-wrap').toggleClass('open');

				});

			},
			sel: function(){
				ssq('.title-box .btn_sel').on('click', function(){
					ssq(this).toggleClass('on');
					ssq('.join-sec > .children-box').stop().slideToggle();
					ssq('.join-sec > .children-btn').stop().slideToggle();
				});
			},
			eye: function(){
				ssq('.pwonoff__btn').click(function(){
					ssq(this).toggleClass('off')
					ssq('.mbr-box .inp-box .inp__pw').attr('type', 'text');
					if(!ssq(this).hasClass('off')){
						ssq('.mbr-box .inp-box .inp__pw').attr('type', 'password');
					}
				})	
			}
		},
		selectStyle: function(){
			$('select').on('change', function(){
				$(this).addClass('_start');
			});
		},
		inputStyle: function(){
			$('input').on('keyup', function(){
				if(!$(this).val() == ''){
					$(this).addClass('_start');
				}else{
					$(this).removeClass('_start');
				}
			});
		}
	};

	var la = {
		init: function(){
			la.layer('view1');
			la.layer('view2');
			la.layer('view3');
			la.layer('view4');
			la.layer('view5');
			la.layer('view6');
			la.layer('view7');
			la.layer('view8');
			la.layer('view9');
			la.layerId();
			la.layerPw();
		},
		layer: function(fileName){
			
			var popup = function(){
				ssq.ajax({
					type: 'GET',
					url: '/member/pop_' + fileName + '.asp',
					dataType: 'html',
					success: function(html) {
						ssq('body').addClass('view--open');
						ssq('body').append(html);



						//tab
						 ssq('.cs-agree-con .tab li').on('click', function(){
							ssq(this).addClass('on');
							ssq(this).siblings().removeClass('on');

							var tIdx = ssq(this).index();
							ssq('.cs-agree-con .tab-content').removeClass('on');
							ssq('.cs-agree-con .tab-content').eq(tIdx).addClass('on');
						});


					}
				});
			}

			ssq('body').on('click', '#' + fileName, function(){
				popup();
			});

			ssq('body').on('click', '.common__layer .close__btn', function(){
				ssq('body').removeClass('view--open');
				ssq('.common__layer').remove();
			});
		},

		layerId: function(){
			
			var popup = function(){
				ssq.ajax({
					type: 'GET',
					url: '/member/pop_id.asp',
					dataType: 'html',
					success: function(html) {
						ssq('body').addClass('schid--open');
						ssq('body').append(html);



					}
				});
			}

			ssq('body').on('click', '.btn_chk', function(){
				popup();
			});

			ssq('body').on('click', '.common__layer .close__btn', function(){
				ssq('body').removeClass('schid--open');
				ssq('.common__layer').remove();
			});
		},
		layerPw: function(){
			
			var popup = function(){
				ssq.ajax({
					type: 'GET',
					url: '/member/pop_pw.asp',
					dataType: 'html',
					success: function(html) {
						ssq('body').addClass('schid--open');
						ssq('body').append(html);

						// 눈
						ssq('.pwonoff__btn').click(function(){
							ssq(this).toggleClass('off')
							ssq('.sch-idpw .password-box .inp__pw').attr('type', 'text');
							if(!ssq(this).hasClass('off')){
								ssq('.sch-idpw .password-box .inp__pw').attr('type', 'password');
							}
						})	


					}
				});
			}

			ssq('body').on('click', '.btn_pw', function(){
				ssq('body').removeClass('schid--open');
				ssq('.common__layer').remove();
				popup();
			});

			ssq('body').on('click', '.common__layer .close__btn', function(){
				ssq('body').removeClass('schid--open');
				ssq('.common__layer').remove();
			});
		}
	};

	
})(jQuery);


/*회원가입하기 - 휴먼고객 */
var idCheckPop4;
function idCheckPopup4() {
	var formStr = "";
	formStr +='	<div class="main_popup member-login__popup">';
	formStr +='			<div class="member__info">';				
	formStr +='				고객님은 휴면고객이십니다.<br/>휴면상태를 해지합니까?';
	formStr +='			</div>';
	formStr +='		<div class="close_area close_style2">';
	formStr +='			<a href="/member/confirmRest.asp" class="btn_close fl">휴면상태 해지</a>';
	formStr +='			<a href="/" class="btn_close fr">취소</a>';
	formStr +='		</div>'; 
	formStr +='	</div>';
/*
	var formStr = "";
		formStr +='	<div class="main_popup member-login__popup">'
		formStr +='		<p>고객님은 휴면고객이십니다.<br/>휴면상태를 해지합니까?  </p>';
		formStr +='			<a href="confirmRest.asp" target="dataFrame">휴면상태 해지</a>';
		formStr +='			<a href="/" class="member_popup_btn2">취소</a>';
		formStr +='		<div class="close_area close_style2"><button class="btn_close" id="closeBtn1"><img src="/images/btn/btn_close6.png" alt="닫기" /></button></div>'
		formStr +='	</div>'
*/
		layer.source(formStr,'cmtPop', {
			alignX : 0.5,
			alignY : 0.5,
			background : true, 
			backgroundColor : 'black',
			backgroundOpacity : 0.7
			//closeButtonId : 'closeBtn1'
		});

}

var idCheckPop4;
function idCheckPopup4_re() {
	var formStr = "";
	/*
		formStr +='	<div class="main_popup member-login__popup">'
		formStr +='		<p>고객님은 휴면고객이십니다.<br/>휴면상태를 해지하고 계속 이용 하시려면 <br/>인증번호 받기를 클릭 후 진행해 주세요. </p>';
		formStr +='			<a href="javascript:restSend();void(0);" >인증번호 받기</a>';
		formStr +='		<div class="close"><button id="closeBtn1"><img src="/images/btn/btn_close6.png" alt="닫기" /></button></div>'
		formStr +='	</div>'
	*/
		formStr +='	<div class="main_popup member-login__popup">';
		formStr +='			<div class="member__info">';				
		formStr +='				고객님은 휴면고객이십니다.<br/>휴면상태를 해지하고 계속 이용 하시려면 <br/>인증번호 받기를 클릭 후 진행해 주세요.';
		formStr +='			</div>';
		formStr +='		<div class="close_area close_style2">';
		formStr +='			<a href="javascript:restSend();void(0);" class="btn_close fl">인증번호 받기</a>';
		formStr +='			<a href="/" class="btn_close fr">취소</a>';
		formStr +='		</div>'; 
		formStr +='	</div>';

		layer.source(formStr,'cmtPop', {
			alignX : 0.5,
			alignY : 0.5,
			background : true, 
			backgroundColor : 'black',
			backgroundOpacity : 0.7
			//closeButtonId : 'closeBtn1'
		});
}

function restSend(){
	var obj = document.loginForm;
	if(obj.mb_name.value == "")
	{
		obj.mb_name.focus();
		alert("이름을 입력해주세요");
		return false;
	}
	if(obj.memberTel.value == "")
	{
		obj.memberTel.focus();
		alert("연락처를 입력해주세요");
		return false;
	}
	

	// 휴대폰번호를 입력시 올바른 휴대폰 번호인지 체크  
	if(obj.memberTel.value != "") { 
		var rgEx = /(01[016789])(\d{4}|\d{3})\d{4}$/g;  
		var strValue = obj.memberTel.value;
		var chkFlg = rgEx.test(strValue);   
		if(!chkFlg){
			alert("올바른 휴대폰번호가 아닙니다.1");
			obj.memberTel.focus();
			return false; 
		}
	}
	if (obj.memberTel.value.length < 10){
		alert("올바른 휴대폰번호가 아닙니다.2");
    obj.memberTel.focus();
    return false; 
	}
	
	obj.action="/member/confirmRestSend.asp";

	//obj.action="verify_result.asp";
	idCheckPop4.remove();
	obj.submit();
}