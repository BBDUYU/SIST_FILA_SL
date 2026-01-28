function chkMobile(){
	var ua = window.navigator.userAgent.toLowerCase();
	var tempVal = false;
	if ( /iphone/.test(ua) || /ipad/.test(ua) ||/android/.test(ua) || /opera/.test(ua) || /bada/.test(ua) ) {
		tempVal = true
	}
	return tempVal
}

// 화면 사이즈 조정 - 최대 640 626
var sizeWidth = jQuery(window).width() * 0.85;	//가로 = 화면 넓이의 80%  
var sizeHeight = sizeWidth * 0.5;	//세로 = 가로의 120%

if ( chkMobile() )	{	//모바일 
	// 화면 사이즈 조정 - 최대 640 626
	var sizeWidth = jQuery(window).width() * 0.85;	//가로 = 화면 넓이의 80%  
	var sizeHeight = sizeWidth * 1.2;	//세로 = 가로의 120%
}else{	//PC
	if (sizeWidth > 640)	{ sizeWidth = 640 };
	if (sizeHeight > 626) { sizeHeight = 626	};
}

//레이어 스타일
var layerText='<div id="layer" style="width:'+sizeWidth+'px;height:'+sizeHeight+'px;position:fixed;-webkit-overflow-scrolling:touch;margin-top:10px;margin-left:10px;margin-right:10px; padding:10px; background:rgb(255,255,255);">';
layerText += '<img src="/images/btn/btn_pop_close.gif" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-10px;top:-10px;z-index:9999" alt="닫기 버튼" onclick="layer.close();"></div>';

//////////////  회원 가입 수정-->

function searchZipD()
{
	//layerText='<div id="layer" style="width:'+sizeWidth+'px;height:'+sizeHeight+'px;position:fixed;-webkit-overflow-scrolling:touch;margin-top:20px;margin-left:10px;margin-right:-20px; padding:10px; background:rgb(255,255,255);">';
	//layerText += '<img src="/images/btn/btn_close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-20px;top:-20px;z-index:9999" alt="닫기 버튼" onclick="layer.close();"></div>';

	layer.text(layerText,"starpop", {width:sizeWidth+40, height:sizeHeight+40, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	showDaumPostcode();
	return;
}

function showDaumPostcode() {
	var element = document.getElementById('layer');
	daum.postcode.load(function(){ 

		new daum.Postcode({
			oncomplete: function(data) {
			// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
				var zipcode = data.postcode1 + data.postcode2;
				//if(zipcode == ""){
					zipcode = data.zonecode;
				//}
				jQuery("input[name=zipcode1]").val(zipcode);
			
				if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
					var jibunAddress = data.autoJibunAddress;
					if(jibunAddress == ""){
						jibunAddress = data.jibunAddress;
					}
					if(jibunAddress == ""){
						jibunAddress = data.address;
					}
					jQuery("input[name=address1]").val(jibunAddress)
					jQuery("input[name=address3]").val(data.address);	
				
				}else{
					var roadAddress = data.autoRoadAddress;
					if(roadAddress == ""){
						roadAddress = data.roadAddress;
					}			
					if(roadAddress == ""){
						roadAddress = data.address;
					}
					jQuery("input[name=address1]").val(data.address);
					jQuery("input[name=address3]").val(roadAddress);
				}
				
				jQuery("input[name=address2]").focus();

				layer.close();
			},
			width : '100%',
			height : '100%'
		}).embed(element);

	});
}


function searchZipD_m()
{
	//layerText='<div id="layer" style="width:'+sizeWidth+'px;height:'+sizeHeight+'px;position:fixed;-webkit-overflow-scrolling:touch;margin-top:20px;margin-left:10px;margin-right:-20px; padding:10px; background:rgb(255,255,255);">';
	//layerText += '<img src="/images/btn/btn_close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-20px;top:-20px;z-index:9999" alt="닫기 버튼" onclick="layer.close();"></div>';

	layer.text(layerText,"starpop", {width:sizeWidth+40, height:sizeHeight+40, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	showDaumPostcode_m();
	return;
}

function showDaumPostcode_m() {
	var element = document.getElementById('layer');
	daum.postcode.load(function(){ 

		new daum.Postcode({
			oncomplete: function(data) {
			// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
				var zipcode = data.postcode1 + data.postcode2;
				//if(zipcode == ""){
					zipcode = data.zonecode;
				//}
				jQuery("input[name=zipcode1_m]").val(zipcode);
			
				if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
					var jibunAddress = data.autoJibunAddress;
					if(jibunAddress == ""){
						jibunAddress = data.jibunAddress;
					}
					if(jibunAddress == ""){
						jibunAddress = data.address;
					}
					jQuery("input[name=address1_m]").val(jibunAddress)
					jQuery("input[name=address3_m]").val(data.address);	
				
				}else{
					var roadAddress = data.autoRoadAddress;
					if(roadAddress == ""){
						roadAddress = data.roadAddress;
					}			
					if(roadAddress == ""){
						roadAddress = data.address;
					}
					jQuery("input[name=address1_m]").val(data.address);
					jQuery("input[name=address3_m]").val(roadAddress);
				}
				
				jQuery("input[name=address2_m]").focus();

				layer.close();
			},
			width : '100%',
			height : '100%'
		}).embed(element);

	});
}


////////////// <<-- 회원 가입 수정


////////////// 주문 배송지 변경 myOrder_View.asp -->>

function searchZipD2()
{
	layer.text(layerText,"starpop", {width:sizeWidth+40, height:sizeHeight+40, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	showDaumPostcode2();
	return;
}

function showDaumPostcode2() {
	var element = document.getElementById('layer');
	daum.postcode.load(function(){ 

		new daum.Postcode({
			oncomplete: function(data) {
			// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
				var zipcode = data.postcode1 + data.postcode2;
				//if(zipcode == ""){
					zipcode = data.zonecode;
				//}
				jQuery("input[name=OrderDzip]").val(zipcode);

				if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
					var jibunAddress = data.autoJibunAddress;
					if(jibunAddress == ""){
						jibunAddress = data.jibunAddress;
					}
					if(jibunAddress == ""){
						jibunAddress = data.address;
					}
					jQuery("input[name=OrderDAddress]").val(jibunAddress)
					jQuery("input[name=OrderDRoadAddress]").val(data.address);	
				
				}else{
					var roadAddress = data.autoRoadAddress;
					if(roadAddress == ""){
						roadAddress = data.roadAddress;
					}
					if(roadAddress == ""){
						roadAddress = data.address;
					}
					jQuery("input[name=OrderDAddress]").val(data.address);
					jQuery("input[name=OrderDRoadAddress]").val(roadAddress);
				}
				
	//			jQuery("input[name=address2]").focus();

				layer.close();
			},
			width : '100%',
			height : '100%'
		}).embed(element);

	});
}

////////////// <<-- 주문 배송지 변경 myOrder_View.asp




////////////// 주문자 정보 입력 pay.asp -->>
function searchZipD3()
{
	layer.text(layerText,"starpop", {width:sizeWidth+40, height:sizeHeight+40, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	showDaumPostcode3();
	return;
}

function showDaumPostcode3() {
	var element = document.getElementById('layer');
	daum.postcode.load(function(){ 

		new daum.Postcode({
			oncomplete: function(data) {
			// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
				var zipcode = data.postcode1 + data.postcode2;
				//if(zipcode == ""){
					zipcode = data.zonecode;
				//}
				jQuery("input[name=OrderOZip1]").val(zipcode);
			
				if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
					var jibunAddress = data.autoJibunAddress;
					if(jibunAddress == ""){
						jibunAddress = data.jibunAddress;
					}
					if(jibunAddress == ""){
						jibunAddress = data.address;
					}
					jQuery("input[name=OrderOAddress1]").val(jibunAddress)
					jQuery("input[name=OrderORoadAddress]").val(data.address);	
				
				}else{
					var roadAddress = data.autoRoadAddress;
					if(roadAddress == ""){
						roadAddress = data.roadAddress;
					}
					if(roadAddress == ""){
						roadAddress = data.address;
					}
					jQuery("input[name=OrderOAddress1]").val(data.address);
					jQuery("input[name=OrderORoadAddress]").val(roadAddress);
				}
				
				jQuery("input[name=OrderOAddress2]").focus();

				layer.close();
			},
			width : '100%',
			height : '100%'
		}).embed(element);

	});
}
////////////// <<-- 주문자 정보 입력  pay.asp






////////////// 배송지 정보 입력 pay.asp -->>
function searchZipD4()
{
	layer.text(layerText,"starpop", {width:sizeWidth+40, height:sizeHeight+40, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	showDaumPostcode4();
	
	return;
}

function showDaumPostcode4() {
	var element = document.getElementById('layer');

	daum.postcode.load(function(){ 
		new daum.Postcode({
			oncomplete: function(data) {
			// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
				var zipcode = data.postcode1 + data.postcode2;
				//if(zipcode == ""){
					zipcode = data.zonecode;
				//}

				jQuery("input[name=OrderDZip]").val(zipcode);
			
				if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
					var jibunAddress = data.autoJibunAddress;
					if(jibunAddress == ""){
						jibunAddress = data.jibunAddress;
					}
					if(jibunAddress == ""){
						jibunAddress = data.address;
					}
					jQuery("input[name=OrderDAddress1]").val(jibunAddress)
					jQuery("input[name=OrderDRoadAddress]").val(data.address);	
				
				}else{
					var roadAddress = data.autoRoadAddress;
					if(roadAddress == ""){
						roadAddress = data.roadAddress;
					}
					if(roadAddress == ""){
						roadAddress = data.address;
					}
					jQuery("input[name=OrderDAddress1]").val(data.address);
					jQuery("input[name=OrderDRoadAddress]").val(roadAddress);
				}
				
				islandCheck();		
				todayDelivery();
				jQuery("input[name=OrderDAddress2]").focus();
				

				layer.close();
			},
			width : '100%',
			height : '100%'
		}).embed(element);
	});
/*
	new daum.Postcode({
		oncomplete: function(data) {
		// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
		// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
			var zipcode = data.postcode1 + data.postcode2;
			//if(zipcode == ""){
				zipcode = data.zonecode;
			//}
			jQuery("input[name=OrderDZip]").val(zipcode);
		
			if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
				var jibunAddress = data.autoJibunAddress;
				if(jibunAddress == ""){
					jibunAddress = data.jibunAddress;
				}
				jQuery("input[name=OrderDAddress1]").val(jibunAddress)
				jQuery("input[name=OrderDRoadAddress]").val(data.address);	
			
			}else{
				var roadAddress = data.autoRoadAddress;
				if(roadAddress == ""){
					roadAddress = data.roadAddress;
				}			
				jQuery("input[name=OrderDAddress1]").val(data.address);
				jQuery("input[name=OrderDRoadAddress]").val(roadAddress);
			}
			
			islandCheck();			
			jQuery("input[name=OrderDAddress2]").focus();

			layer.close();
		},
		width : '100%',
		height : '100%'
	}).embed(element);
*/
}
////////////// <<-- 배송지 정보 입력 pay.asp



////////////// 주소록 정보 입력 -->>
function searchZipD5()
{

	layer.text(layerText,"starpop", {width:sizeWidth+40, height:sizeHeight+40, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	showDaumPostcode5();
	return;
}

function showDaumPostcode5() {
	var element = document.getElementById('layer');
	daum.postcode.load(function(){ 

		new daum.Postcode({
			oncomplete: function(data) {
			// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
				var zipcode = data.postcode1 + data.postcode2;
				//if(zipcode == ""){
					zipcode = data.zonecode;
				//}
				parent.jQuery("input[name=zipcode]").val(zipcode);
			
				var extraRoadAddr = ''; // 참고 항목 변수

				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
					extraRoadAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if(data.buildingName !== '' && data.apartment === 'Y'){
				   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
				if(extraRoadAddr !== ''){
					extraRoadAddr = ' (' + extraRoadAddr + ')';
				}

				if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
					var jibunAddress = data.autoJibunAddress;
					if(jibunAddress == ""){
						jibunAddress = data.jibunAddress;
					}
					if(jibunAddress == ""){
						jibunAddress = data.address;
					}

					parent.jQuery("input[name=addr1]").val(jibunAddress)
					parent.jQuery("input[name=addr3]").val(data.address + extraRoadAddr);	
				
				}else{
					var roadAddress = data.autoRoadAddress;
					if(roadAddress == ""){
						roadAddress = data.roadAddress;
					}
					if(roadAddress == ""){
						roadAddress = data.address;
					}
					parent.jQuery("input[name=addr1]").val(data.address);
					parent.jQuery("input[name=addr3]").val(roadAddress + extraRoadAddr);
				}
				
				parent.jQuery("input[name=addr2]").focus();

				layer.close();
			},
			width : '100%',
			height : '100%'
		}).embed(element);

	});
}

////////////// 주소록 정보 입력 -->>


////////////// 주소록 정보 입력 -->>
function searchZipD6()
{

	layer.text(layerText,"starpop", {width:sizeWidth+40, height:sizeHeight+40, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	showDaumPostcode6();
	return;
}

function showDaumPostcode6() {
	var element = document.getElementById('layer');
	daum.postcode.load(function(){ 

		new daum.Postcode({
			oncomplete: function(data) {
			// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
				var zipcode = data.postcode1 + data.postcode2;
				//if(zipcode == ""){
					zipcode = data.zonecode;
				//}
				parent.jQuery("input[name=zipcode]").val(zipcode);
			
				if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
					var jibunAddress = data.autoJibunAddress;
					if(jibunAddress == ""){
						jibunAddress = data.jibunAddress;
					}
					if(jibunAddress == ""){
						jibunAddress = data.address;
					}
					parent.jQuery("input[name=addr1]").val(data.address);	
				
				}else{
					var roadAddress = data.autoRoadAddress;
					if(roadAddress == ""){
						roadAddress = data.roadAddress;
					}
					if(roadAddress == ""){
						roadAddress = data.address;
					}
					parent.jQuery("input[name=addr1]").val(roadAddress);
				}
				
				parent.jQuery("input[name=addr2]").focus();

				layer.close();
			},
			width : '100%',
			height : '100%'
		}).embed(element);

	});
}

////////////// 주소록 정보 입력 -->>


////////////// 배송지 정보 입력 join_pm.asp -->>
function searchZipD7()
{
	layer.text(layerText,"starpop", {width:sizeWidth+40, height:sizeHeight+40, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	showDaumPostcode7();
	return;
}

function showDaumPostcode7() {
	var element = document.getElementById('layer');
	new daum.Postcode({
		oncomplete: function(data) {
		// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
		// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
			var zipcode = data.postcode1 + data.postcode2;
			//if(zipcode == ""){
				zipcode = data.zonecode;
			//}
			jQuery("input[name=OrderDZip]").val(zipcode);
		
			if (data.addressType == "R"){ //도로명 주소로 검색할땐 지번이 매칭됨
				var jibunAddress = data.autoJibunAddress;
				if(jibunAddress == ""){
					jibunAddress = data.jibunAddress;
				}
				if(jibunAddress == ""){
					jibunAddress = data.address;
				}
				jQuery("input[name=OrderDAddress1]").val(jibunAddress)
				jQuery("input[name=OrderDRoadAddress]").val(data.address);	
			
			}else{
				var roadAddress = data.autoRoadAddress;
				if(roadAddress == ""){
					roadAddress = data.roadAddress;
				}
				if(roadAddress == ""){
					roadAddress = data.address;
				}
				jQuery("input[name=OrderDAddress1]").val(data.address);
				jQuery("input[name=OrderDRoadAddress]").val(roadAddress);
			}
			
			jQuery("input[name=OrderDAddress2]").focus();

			layer.close();
		},
		width : '100%',
		height : '100%'
	}).embed(element);
}
////////////// <<-- 배송지 정보 입력 pay.asp