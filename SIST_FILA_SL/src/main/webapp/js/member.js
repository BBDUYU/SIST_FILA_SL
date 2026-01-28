(function(ssq) {
	ssq(document).ready(function(){ 
		var txtInput = ssq('.placeholder');
	    txtInput.addClass('no_value');
		txtInput.focusout(function(){
		  if (ssq(this).val() == '') {
			  ssq(this).addClass('no_value');
		   }else{
				ssq(this).removeClass('no_value');
		   }
		});
		txtInput.focusin(function(){
		  ssq(this).removeClass('no_value');
		});
		
		//2020-10-22 로그인 탭으로 변경
		ssq('.login_form--tab a').on('click',function(e){
			var tab = ssq(this).attr('href');
			e.preventDefault()
			ssq('.login_form--tab a').removeClass('on');
			ssq(this).addClass('on');
			ssq('.member_wrap .login_form--tab ~ form').removeClass('on');
			ssq(''+ tab +'').addClass('on');
		});
		//2020-10-22 내정보수정 간편로그인 추가
		ssq('.modify_form .easy-login a').on('click',function(e){
			//e.preventDefault()
			//ssq(this).addClass('on');
		});
		
		/* 2021-06-21 생년월일 성별 수정
		ssq('#birthdaySex').on('click',function(){
			
			var input = ssq('#birthdaySex').prop("checked");
			if(input){
				ssq('.birthdaySex').removeClass('hidden')
			}else if(!input){
				ssq('.birthdaySex').addClass('hidden')
			}
		}); */
	});

})(jQuery);

function fnChkByte(obj) {
	var maxByte = 20; //최대 입력 바이트 수
	var str = obj.value;
	var str_len = str.length;

	var rbyte = 0;
	var rlen = 0;
	var one_char = "";
	var str2 = "";
	for (var i = 0; i < str_len; i++) {
		one_char = str.charAt(i);
		if (escape(one_char).length > 4) {
			rbyte += 3; //한글2Byte
		} else {
			rbyte++; //영문 등 나머지 1Byte
		}
		if (rbyte <= maxByte) {
			rlen = i + 1; //return할 문자열 갯수
		}
	}
	if (rbyte > maxByte) {
		str2 = str.substr(0, rlen); //문자열 자르기
		obj.value = str2;
		fnChkByte(obj, maxByte);
	} else {

	}
}

function fnChkByte25(obj) {
	var maxByte = 25; //최대 입력 바이트 수
	var str = obj.value;
	var str_len = str.length;

	var rbyte = 0;
	var rlen = 0;
	var one_char = "";
	var str2 = "";
	for (var i = 0; i < str_len; i++) {
		one_char = str.charAt(i);
		if (escape(one_char).length > 4) {
			rbyte += 3; //한글2Byte
		} else {
			rbyte++; //영문 등 나머지 1Byte
		}
		if (rbyte <= maxByte) {
			rlen = i + 1; //return할 문자열 갯수
		}
	}
	if (rbyte > maxByte) {
		str2 = str.substr(0, rlen); //문자열 자르기
		obj.value = str2;
		fnChkByte(obj, maxByte);
	} else {

	}
}

function fnChkByte50(obj) {
	var maxByte = 50; //최대 입력 바이트 수
	var str = obj.value;
	var str_len = str.length;

	var rbyte = 0;
	var rlen = 0;
	var one_char = "";
	var str2 = "";
	for (var i = 0; i < str_len; i++) {
		one_char = str.charAt(i);
		if (escape(one_char).length > 4) {
			rbyte += 3; //한글2Byte
		} else {
			rbyte++; //영문 등 나머지 1Byte
		}
		if (rbyte <= maxByte) {
			rlen = i + 1; //return할 문자열 갯수
		}
	}
	if (rbyte > maxByte) {
		str2 = str.substr(0, rlen); //문자열 자르기
		obj.value = str2;
		fnChkByte50(obj, maxByte);
	} else {

	}
}

function sleep(ms) {
  const wakeUpTime = Date.now() + ms;
  while (Date.now() < wakeUpTime) {}
}

function loginChk()
{
	alert("회원가입 또는 로그인을 하신후 사용하시기 바랍니다.")
	location.href = "/member/login.asp";
}

function memberJoin(){location.href='/member/join01.asp'}
function memberSearch(){window.open("/member/pop_idpw_search.asp","pop_idpw_search","scrollbars=no,resizeable=no,width=350,height=250");}
function memberSearch1(){window.open("/member/pop_id_search.asp","pop_id_search","scrollbars=no,resizeable=no,width=350,height=250");}
function memberSearch2(){window.open("/member/pop_pw_search.asp","pop_pw_search","scrollbars=no,resizeable=no,width=350,height=250");}
function mykipage(){shop_change('/member/mypage.asp?page=1');}
function updatePage(){shop_change('/member/update.asp?page=1');}

function idSearch()
{
	var obj = document.searchForm;
	if(obj.memberName.value == "") {alert('이름을 입력해주세요');obj.memberName.focus();return false;}
	if(obj.memberJumin1.value == "") {alert('주민등록번호를 입력해주세요');obj.memberJumin1.focus();return false;}
	if(obj.memberJumin2.value == "") {alert('주민등록번호를 입력해주세요');obj.memberJumin2.focus();return false;}
	obj.action="/member/idpwSearch_result.asp";
	obj.method="post";
	obj.target="dataFrame";
	obj.submit();
}

function idSearch1()
{
	var obj = document.searchForm;
	if(obj.memberName.value == "") {alert('이름을 입력해주세요');obj.memberName.focus();return false;}
	if(obj.memberJumin1.value == "") {alert('주민등록번호를 입력해주세요');obj.memberJumin1.focus();return false;}
	if(obj.memberJumin2.value == "") {alert('주민등록번호를 입력해주세요');obj.memberJumin2.focus();return false;}
	obj.action="/member/idSearch_result.asp";
	obj.method="post";
	obj.target="dataFrame";
	obj.submit();
}

function pwSearch()
{
	var obj = document.searchForm;
	if(obj.memberid.value == "") {alert('아이디를 입력해주세요');obj.memberid.focus();return false;}
	if(obj.memberName.value == "") {alert('이름을 입력해주세요');obj.memberName.focus();return false;}
	if(obj.memberJumin1.value == "") {alert('주민등록번호를 입력해주세요');obj.memberJumin1.focus();return false;}
	if(obj.memberJumin2.value == "") {alert('주민등록번호를 입력해주세요');obj.memberJumin2.focus();return false;}	
	obj.action="/member/pwSearch_result.asp";
	obj.method="post";
	obj.target="dataFrame";
	obj.submit();
}

function pwSearch2()
{
    var radiolen = 0;

    radio_button = document.searchForm.pwsearch;

    if (radio_button) {
        if (radio_button.length > 1) {
            for (i = 0; i < radio_button.length; i++) {
                if (radio_button[i].checked) {
                    radiolen = 1;
                }
            }
        }
        else {
            if (radio_button.checked) {
                radiolen = 1;
                }
        }

        if (radiolen == 0) {
            alert("선택해 주세요");
            return false;
        }
        
    	document.searchForm.action="/member/pwSearch_result_page2.asp";
    	document.searchForm.method="post";
    	document.searchForm.target="dataFrame";
    	document.searchForm.submit();            
    }
  
}

var nameCheck;
var agreeCheck;
var memberName;
var memberJumin;
var idCheck;
function nameCheck_fn() 
{
	var obj = document.nameCheck;
	if( obj.mb_name.value == "")
	{
		alert("이름을 입력하십시오!");
		obj.mb_name.focus();
		return false;
	}
	
	if (obj.jumin1.value=="") {alert("\n주민번호 앞자리를 입력해주세요.");obj.jumin2.focus();return false;}
	if (obj.jumin2.value=="") {alert("\n주민번호 뒷자리를 입력해주세요.");obj.jumin2.focus();return false;}
	
	jumin = obj.jumin1.value + obj.jumin2.value;
	
	if (jumin != "" )
	{
		var ssn = jumin
		if(ssn.length < 13)
		{
			alert("주민등록번호에 오류가 있습니다. 다시 확인하여 주십시오.");
			obj.jumin1.focus();
			return false;
		}
	
		var rn;
		rn= ssn;
		var sum=0;
		for(i=0;i<8;i++) { sum+=rn.substring(i,i+1)*(i+2); }
		for(i=8;i<12;i++) { sum+=rn.substring(i,i+1)*(i-6); }
		sum=11-(sum%11);
		if (sum>=10) { sum-=10; }
		if (rn.substring(12,13) != sum || (rn.substring(6,7) !=1 && rn.substring(6,7) != 2 && rn.substring(6,7) !=3 && rn.substring(6,7) != 4))
		{
			alert("주민등록번호에 오류가 있습니다. 다시 확인하십시오.");
			obj.jumin1.focus();
			return false;
		}
	} 
	//if (obj.agree.checked == false) {alert("\n이용약관과 개인정보취급방침 동의에 체크해 주세요.");obj.agree.focus();return false;}
	
	obj.action="/member/nameCheck.asp";
	//obj.action="/member/join02.asp";
	obj.method="post";
	obj.target="dataFrame3";
	
	return true;
	
	//obj.submit();
	
}

function agreePass()
{
	var obj = document.nameCheck;
	if(nameCheck == "1")
	{
		obj.mb_name.value = memberName;
		obj.jumin.value = memberJumin;
		obj.action="join_02.asp";
		obj.method="post";
		obj.target="_self";
		obj.submit();
	}
	else
	{
		alert('실명인증을 먼저해주세요');
	}
}

function checkid()  <!--이넘은 아이디 중복체킹을 할 때 새로운 창을 띄워준다. -->
{
   if (document.myform.memberId.value.length < 4) {
      alert("\회원 ID는 4자리 이상이어야 합니다.");
      document.myform.memberId.focus();
      return;
   }
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var memberId = document.myform.memberId.value;
    
    if(strFirst.indexOf(memberId.substring(0,1))<0) {
      alert("\nID 첫 글자는 영문자만 가능합니다.");
      document.myform.memberId.focus();
      return;
    }
    
    for(var n=0; n < memberId.length; n++) {
      thisChar = memberId.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
            document.myform.memberId.focus();
            return;
        }
    }
    
    for (i=0; i < memberId.length; i++) {
        if(strAll.indexOf(memberId.substring(i,i+1))<0)
        {
            alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            document.myform.memberId.focus();
            return;
        }
    }
	
	window.open("/member/popup_idcheck.asp?mb_id="+memberId,"checkid","scrollbars=no,resizeable=no,width=335,height=300");
	return;
}

function checkid2()  <!--이넘은 아이디 중복체킹을 할 때 새로운 창을 띄워준다. -->
{
   if (document.myform.memberId.value.length < 4) {
      alert("\회원 ID는 4자리 이상이어야 합니다.");
      document.myform.memberId.focus();
      return;
   }
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var memberId = document.myform.memberId.value;
    
    if(strFirst.indexOf(memberId.substring(0,1))<0) {
      alert("\nID 첫 글자는 영문자만 가능합니다.");
      document.myform.memberId.focus();
      return;
    }
    
    for(var n=0; n < memberId.length; n++) {
      thisChar = memberId.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
            document.myform.memberId.focus();
            return;
        }
    }
    
    for (i=0; i < memberId.length; i++) {
        if(strAll.indexOf(memberId.substring(i,i+1))<0)
        {
            alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            document.myform.memberId.focus();
            return;
        }
    }
	if(chkMobile()){
		var layerText='<iframe name="inneriframe" width="100%" height="250" id="inneriframe" src="" scrolling="no" allowtransparency="true"></iframe>';
		 layer.text(layerText,"checkid", {width:290, height:290, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
		//window.open("/member/popup_idcheck.asp?mb_id="+memberId,"checkid","scrollbars=no,resizeable=no,width=335,height=300");
		document.idform.mb_id.value = memberId;
		document.idform.target = "inneriframe";
		document.idform.method = "post";
		document.idform.action = "/member/popup_idcheck.asp";
		document.idform.submit();
		return;
	}else{
		
		var layerText='<iframe name="inneriframe" width="100%" height="250" id="inneriframe" src="" style="width: 100%; height: 100%;" scrolling="no" allowtransparency="true"></iframe>';
		 layer.text(layerText,"checkid", {width:810, height:315, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
		//window.open("/member/popup_idcheck.asp?mb_id="+memberId,"checkid","scrollbars=no,resizeable=no,width=335,height=300");
		document.idform.mb_id.value = memberId;
		document.idform.target = "inneriframe";
		document.idform.method = "post";
		document.idform.action = "/member/popup_idcheck.asp";
		document.idform.submit();
		return;
	}
}

function checkid3()  <!--이넘은 아이디 중복체킹을 할 때 새로운 창을 띄워준다. -->
{

	if(chkMobile()){
		var layerText='<iframe name="inneriframe" width="100%" height="250" id="inneriframe" src="/member/popup_idcheck.asp?mb_id='+memberId+'" scrolling="no" allowtransparency="true"></iframe>';
		 layer.text(layerText,"checkid", {width:290, height:290, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
		//window.open("/member/popup_idcheck.asp?mb_id="+memberId,"checkid","scrollbars=no,resizeable=no,width=335,height=300");
		
		return;
	}else{
		
		var layerText='<iframe name="inneriframe" width="100%" height="250" id="inneriframe" src="/member/popup_idcheck.asp?mb_id='+memberId+'" style="width: 100%; height: 100%;" scrolling="no" allowtransparency="true"></iframe>';
		 layer.text(layerText,"checkid", {width:810, height:315, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
		//window.open("/member/popup_idcheck.asp?mb_id="+memberId,"checkid","scrollbars=no,resizeable=no,width=335,height=300");
		document.idform.mb_id.value = document.myform.memberId.value;
		document.idform.target = "inneriframe";
		document.idform.method = "post";
		document.idform.action = "/member/popup_idcheck.asp";
		document.idform.submit();
		return;
	}
}


function checkid2_m()  <!--이넘은 아이디 중복체킹을 할 때 새로운 창을 띄워준다. -->
{
   if (document.myform.memberId_m.value.length < 4) {
      alert("\회원 ID는 4자리 이상이어야 합니다.");
      document.myform.memberId_m.focus();
      return;
   }
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var memberId = document.myform.memberId_m.value;
    
    if(strFirst.indexOf(memberId.substring(0,1))<0) {
      alert("\nID 첫 글자는 영문자만 가능합니다.");
      document.myform.memberId_m.focus();
      return;
    }
    
    for(var n=0; n < memberId.length; n++) {
      thisChar = memberId.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
            document.myform.memberId_m.focus();
            return;
        }
    }
    
    for (i=0; i < memberId.length; i++) {
        if(strAll.indexOf(memberId.substring(i,i+1))<0)
        {
            alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            document.myform.memberId_m.focus();
            return;
        }
    }
	if(chkMobile()){
		var layerText='<iframe name="inneriframe" width="100%" height="250" id="inneriframe" src="" scrolling="no" allowtransparency="true"></iframe>';
		 layer.text(layerText,"checkid", {width:290, height:290, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
		//window.open("/member/popup_idcheck.asp?mb_id="+memberId,"checkid","scrollbars=no,resizeable=no,width=335,height=300");
		document.idform.mb_id.value = memberId;
		document.idform.target = "inneriframe";
		document.idform.method = "post";
		document.idform.action = "https://www.fila.co.kr/member/popup_idcheck.asp";
		document.idform.submit();
		return;
	}else{
		
		var layerText='<iframe name="inneriframe" width="100%" height="250" id="inneriframe" src="" style="width: 100%; height: 100%;" scrolling="no" allowtransparency="true"></iframe>';
		 layer.text(layerText,"checkid", {width:810, height:315, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
		//window.open("/member/popup_idcheck.asp?mb_id="+memberId,"checkid","scrollbars=no,resizeable=no,width=335,height=300");
		document.idform.mb_id.value = memberId;
		document.idform.target = "inneriframe";
		document.idform.method = "post";
		document.idform.action = "https://www.fila.co.kr/member/popup_idcheck.asp";
		document.idform.submit();
		return;
	}
}

function searchZip()
{
	window.open("/member/pop_zipcode.asp","searchCode","resizeable=no,width=720,height=890, scrollbars=yes");
	return;
}

function searchZip2()
{
	var layerText='<!--div style="text-align:right;"><button type="button" onclick="layer.close();"><img src="/images/btn/btn_pop_close.gif"></button></div--><iframe name="inneriframe" width="640" height="626" id="inneriframe" src="/member/zipcode.asp" style="width: 100%; height: 100%;" allowtransparency="true"></iframe>';
	 layer.text(layerText,"filapop", {width:640, height:626, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});

	//window.open("/member/pop_zipcode.asp","searchZip","resizeable=no,width=720,height=890, scrollbars=yes");
	return;
}

function postSubmit()
{
	yorn = confirm("전송하시겠습니까?");
	if(yorn)
	{
	var PostValue = document.getElementById("PostS").value;
	opener.document.myform.zipcode1.value = address[PostValue][0].substring(0,3);
	opener.document.myform.zipcode2.value = address[PostValue][0].substring(4,7);
	opener.document.myform.address1.value = address[PostValue][1]+" "+ address[PostValue][2]+" "+ address[PostValue][3];
	self.close();
	}
}


function checkid_pop() {
   if (document.myform.memberId.value.length < 4  ) {
      alert("\회원 ID는 4자리 이상이어야 합니다.");
      document.myform.memberId.focus();
      return;
   }
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var memberId = document.myform.memberId.value;
    
    if(strFirst.indexOf(memberId.substring(0,1))<0) {
      alert("\nID 첫 글자는 영문자만 가능합니다.");
      document.myform.memberId.focus();
      return;
    }
    
    for(var n=0; n < memberId.length; n++) {
      thisChar = memberId.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
            document.myform.memberId.focus();
            return;
        }
    }
    
    for (i=0; i < memberId.length; i++) {
        if(strAll.indexOf(memberId.substring(i,i+1))<0) {
            alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            document.myform.memberId.focus();
            return;
        }
    }

	myform.submit();
}

function email_chg(objmove) {
  var obj = document.myform;
  if (objmove.options[objmove.options.selectedIndex].value == "") {
  	obj.email2.value = objmove.options[objmove.options.selectedIndex].value;
  	//obj.mb_Email2.disabled = false;
  }
  else {
  	obj.email2.value = objmove.options[objmove.options.selectedIndex].value;
  	//obj.mb_Email2.disabled = true;
  }
}

function checkid_submit(mb_id)
{
	opener.myform.memberId.value = mb_id;
	opener.idCheck = 1;
	self.close();
}

function checkBirth()
{
			b_sum = new Date(document.myform.birthY.value,(document.myform.birthM.value - 1),document.myform.birthD.value)
			if ( b_sum.getYear() % 100 != document.myform.birthY.value.substr(2,4) || b_sum.getMonth() != (document.myform.birthM.value - 1)|| b_sum.getDate() != document.myform.birthD.value) {alert("생년월일을 확인하세요");return false;}
}

function changeTel1()
{
	var obj = document.myform;
	if(obj.tel1_1.value == "000")
	{
		obj.tel1_2.value = "";
		obj.tel1_3.value = "";
		obj.tel1_2.readOnly = true;
		obj.tel1_3.readOnly = true;		
	}
	else
	{
		obj.tel1_2.readOnly = false;
		obj.tel1_3.readOnly = false;
	}
}

function changeTel2()
{
	var obj = document.myform;
	if(obj.tel2_1.value == "000")
	{
		obj.tel2_2.value = "";
		obj.tel2_3.value = "";
		obj.tel2_2.readOnly = true;
		obj.tel2_3.readOnly = true;		
	}
	else
	{
		obj.tel2_2.readOnly = false;
		obj.tel2_3.readOnly = false;
	}
}

function loginCheck()
{
	var obj = document.loginForm;
	if(obj.mb_id.value == "")
	{
		obj.mb_id.focus();
		alert("아이디를 입력해주세요");
		return false;
	}


	//공백 금지
	//var blank_pattern = /^\s+|\s+$/g;(/\s/g
	var blank_pattern = /[\s]/g;
	if( blank_pattern.test( obj.mb_id.value) == true){
		alert('아이디에 공백이 있습니다.');
		obj.mb_id.focus();
		return false;
	}


	if(obj.password.value == "")
	{
		obj.password.focus();
		alert("비밀번호를 입력해주세요.");
		return false;
	}

	//추가
	if ( jQuery("#defaultReal").length > 0 ) {
		if(obj.defaultReal.value == "")	{
			obj.defaultReal.focus();
			alert("보안 문자를 입력해주세요.");
			return false;
		}
	}
	
//	if (obj.lgc.value == 1)	{
//	}else{
		obj.lgc.value = 1;
		jQuery("#loginbtn").hide();
		jQuery("#loginbtn2").show();
		obj.action="/member/verify_result.asp";
	//obj.action="verify_result.asp";
	
		obj.submit();
//	}
}

function sendCheck() {
//	jQuery("#loginbtn").hide();
//	jQuery("#loginbtn2").show();
	alert("시스템 점검 중입니다.\n잠시 후 다시 이용해 주세요.");
	jQuery("#loginbtn").hide();
	jQuery("#loginbtn2").show();
//	jQuery("#loginbtn").show();
//	jQuery("#loginbtn2").hide();
	return;
	
	
/*
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

	jQuery("#loginbtn").hide();
	jQuery("#loginbtn2").show();	
	obj.action="/member/confirmSend.asp";

	//obj.action="verify_result.asp";
	
	obj.submit();
*/
}

function sendCheck_shop(){

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

	jQuery("#loginbtn").hide();
	jQuery("#loginbtn2").show();	
	obj.action="/member/confirmSend.asp";

	//obj.action="verify_result.asp";
	
	obj.submit();

}

function confirmCheck(){

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
	if(obj.confirmNo.value == "")
	{
		obj.confirmNo.focus();
		alert("인증번호를 입력해주세요");
		return false;
	}
	obj.action="/member/confirmJoin.asp";
	obj.method="post"
	//obj.action="verify_result.asp";
	
	obj.submit();

}

function confirmCheck2(){

		var obj = document.idTelForm;
		if (obj.membername.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername.focus();
			return false;
		}
		if (obj.mte1_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte1_1.focus();
			return false;
		}
		if (obj.mte2_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte2_1.focus();
			return false;
		}
		/*
		if (obj.mte3_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte3_1.focus();
			return false;
		}
		*/
		if(obj.confirmNo.value == "")
		{
			obj.confirmNo.focus();
			alert("인증번호를 입력해주세요");
			return false;
		}

		obj.action = "confirmSearchID.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();

}

function confirmCheck3(){

		var obj = document.passTelForm;
		if (obj.memberid.value == "" )  {
			alert("아이디를 입력해 주세요.");
			obj.memberid.focus();
			return false;
		}
		if (obj.membername.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername.focus();
			return false;
		}
		if (obj.mte1_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte1_1.focus();
			return false;
		}
		if (obj.mte2_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte2_1.focus();
			return false;
		}
		/*
		if (obj.mte3_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte3_1.focus();
			return false;
		}
		*/
		if(obj.confirmNo.value == "")
		{
			obj.confirmNo.focus();
			alert("인증번호를 입력해주세요");
			return false;
		}

		obj.action = "confirmSearchPW.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();

}

function confirmCheckmobile(){

		var obj = document.idTelForm;
		if (obj.membername.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername.focus();
			return false;
		}
		if (obj.mtel.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mtel.focus();
			return false;
		}

		if(obj.confirmNo.value == "")
		{
			obj.confirmNo.focus();
			alert("인증번호를 입력해주세요");
			return false;
		}

		obj.action = "/member/confirmSearchID.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();

}

function confirmCheckmobile2(){

		var obj = document.passTelForm;
		if (obj.memberid.value == "" )  {
			alert("아이디를 입력해 주세요.");
			obj.memberid.focus();
			return false;
		}
		if (obj.membername.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername.focus();
			return false;
		}
		if (obj.mtel.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mtel.focus();
			return false;
		}

		obj.action = "/member/confirmSearchPW.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();

}

function Merrychk(v){
  if (v=="1")  {
    document.getElementById("MerryTr").style.display="";
  }
  else {
    document.getElementById("MerryTr").style.display="none";
  }
}


function changeToProcess(){

    var processImg = new Image();
    processImg.src = "/images/waiting.gif";
    var lang;

    var imgLang = "";
	if (lang == "ja"){
	imgLang = "ja/";
	}
					
	if (document.all){
		document.all['checkoutbtn'].innerHTML = "<img src='"+processImg.src+"' name='overItems' id='overItems' border='0'>";
	} else if (document.layers){
		document.layers['checkoutbtn'].innerHTML = "<img src='"+processImg.src+"' name='overItems' id='overItems' border='0'>";
	} else if (document.getElementById){
		document.getElementById('checkoutbtn').innerHTML = "<img src='"+processImg.src+"' name='overItems' id='overItems' border='0'>";
	}
}

var is_setting;



/**
 * 유효한(존재하는) 월(月)인지 체크
 */
function isValidMonth(mm) {
    var m = parseInt(mm,10);
    return (m >= 1 && m <= 12);
}
 
/**
 * 유효한(존재하는) 일(日)인지 체크
 */
function isValidDay(yyyy, mm, dd) {
    var m = parseInt(mm,10) - 1;
    var d = parseInt(dd,10);
 
    var end = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
    if ((yyyy % 4 == 0 && yyyy % 100 != 0) || yyyy % 400 == 0) {
        end[1] = 29;
    }
 
    return (d >= 1 && d <= end[m]);
}


function updateform()  
{
	var obj = document.myform;


  if(obj.zipcode1.value == "")
  {
  	alert('\n주소를 입력해주세요');
  	//searchZip();
  	return;
  }
  
  if(obj.address1.value == "")
  {
  	alert('\n주소를 입력해주세요');
		//searchZip();
  	return;
  }

  if(obj.mtel2.value == "" || obj.mtel3.value == "")
  {
  		alert('\n전화번호를 입력해주세요');
		obj.mtel2.focus();
	  	return;
  }
   
  if(obj.email1.value == "")
  {
  	alert('\n메일주소를 입력해주세요');
		obj.email.focus();
  	return;
  }

	if(obj.MemberIsMaillinglist.checked == false){
		if (confirm("EMAIL 수신동의를 원치 않으실 경우 \n구매 내역 및 기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

		}else{
				obj.MemberIsMaillinglist.focus();
				return false;
		}
	}
	

	if(obj.MemberIsSMS.checked == false){
		if (confirm("SMS 수신동의를 원치 않으실 경우 \n구매 내역 및 기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

		}else{
				obj.MemberIsSMS.focus();
				return false;
		}
	}


	obj.action="update_result.asp";
	//obj.action="/member/update_result.asp";
	obj.method="post";
	obj.target="dataFrame";
	obj.submit();
} 

var is_setting;

function passchk()  
{
	var obj = document.passForm;

 // 비밀번호 체크
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var Passwd = obj.MemberPassword.value;

  if (  obj.uPass.value == "")
  {
    alert("\n현재비밀번호를 입력해 주세요");
    obj.uPass.focus();
    return false;
  }

  if ( Passwd == "")
  {
    alert("\n비밀번호를 입력해 주세요");
    obj.MemberPassword.focus();
    return false;
  }
  
  if (obj.MemberPassword.value.length < 6 )
  {
    alert("\비밀번호는 6자리 이상이어야 합니다.");
    obj.MemberPassword.focus();
    return false;
  }

  for (var n=0; n < Passwd.length; n++)
    {
        thisChar = Passwd.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
            obj.MemberPassword.focus();
            return false;
        }
  }
    
 for (i=0; i < Passwd.length; i++)
 {
        if(strAll.indexOf(Passwd.substring(i,i+1))<0)
        {
            alert("\n비밀번호에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            obj.MemberPassword.focus();
            return false;
        }
  }
  
  // 비밀번호 확인
  var rePasswd = obj.MemberPassword2.value;
  if (Passwd != rePasswd)
  {
    alert("\n비밀번호가 일치 하지 않습니다.\n\n비밀번호를 재확인 해 주세요.");
    obj.MemberPassword2.focus();
    return false;
  }

	obj.method = "post";
	obj.target = "dataFrame";
	obj.submit();
} 
function m_setting()
{
	is_setting = "Click";
}

function retire(){
if (confirm("회원에서 탈퇴하시겠습니까?\n\n탈퇴를 원하시면 확인버튼을 클릭하세요"))
	{
		retireForm.target = "dataFrame";
		retireForm.action = "/member/out_result.asp";
		retireForm.submit();
	}

}

var KMCIS_window;

function openKMCISWindow(){
		window.name="main"
		var obj = document.agreeForm;
		if (obj.agree1.checked == false) {alert("\n이용약관 동의에 체크해 주세요.");obj.agree1.focus();return false;}
		if (obj.agree2.checked == false) {alert("\개인정보수집 동의에 체크해 주세요.");obj.agree2.focus();return false;}
	
	KMCIS_window = window.open('/mobile_cert/join_mobile1.asp', 'KMCISWindow', 'width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250' );

	if(KMCIS_window == null){
		alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 사용자일 경우에는 \n화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
	}
}

function openKMCISWindow2(){
	KMCIS_window = window.open('/mobile_cert/search_mobile_id1.asp', 'KMCISWindow', 'width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250' );

	if(KMCIS_window == null){
		alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 사용자일 경우에는 \n화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
	}
}

function openKMCISWindow3(){
	var obj = document.searchForm3; 

 	if(obj.memberID2.value == "") {alert('아이디를 입력해주세요');obj.memberID2.focus();return;}

	KMCIS_window = window.open('/mobile_cert/search_mobile_pw1.asp?plusInfo='+obj.memberID2.value, 'KMCISWindow', 'width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250' );

	if(KMCIS_window == null){
		alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 사용자일 경우에는 \n화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
	}
}

function openKMCISWindow4(){
	
	var obj = document.myform;
	if (obj.agree[0].checked == false) {alert("\n개인정보 취급방침에 동의해 주세요.");obj.agree[0].focus();return false;}
	KMCIS_window = window.open('/mobile_cert/guest_pay.asp', 'KMCISWindow', 'width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250' );

	if(KMCIS_window == null){
		alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 사용자일 경우에는 \n화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
	}
}

function ipin_send(){
	var obj = document.agreeForm;
	if (obj.agree1.checked == false) {alert("\n이용약관 동의에 체크해 주세요.");obj.agree1.focus();return false;}
	if (obj.agree2.checked == false) {alert("\개인정보수집 동의에 체크해 주세요.");obj.agree2.focus();return false;}

	var popupWindow = window.open( "", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
	document.kcbInForm.target = "kcbPop";
	document.kcbInForm.action = "https://ipin.ok-name.co.kr/tis/ti/POTI01A_LoginRP.jsp";
	document.kcbInForm.submit();
	popupWindow.focus()	;
	return;
}

function ipin_idsearch(){

	var obj = document.myForm;

	var popupWindow = window.open( "", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
	document.kcbInForm.target = "kcbPop";

	document.kcbInForm.action = "https://ipin.ok-name.co.kr/tis/ti/POTI01A_LoginRP.jsp";

	document.kcbInForm.submit();
	popupWindow.focus()	;
	return	;

}

function ipin_idsearch2(){

	var layerText='<div style="text-align:right;position:absolute;right:-22px;top:-22px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="550" id="inneriframe" src="/member/cert/idsearch_ipin.asp?" style="width: 100%; height: 100%;" allowtransparency="true"></iframe>';
	 layer.text(layerText,"filapop", {width:450, height:560, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});

	//layer.iframe("/cert/idsearch_ipin.asp","cathPop", {width:450, height:550, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	return	;

}

function ipin_pwsearch(){

	var obj = document.searchForm3; 

 	if(obj.memberID2.value == "") {alert('아이디를 입력해주세요');obj.memberID2.focus();return;}

	var popupWindow = window.open( "", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
	document.kcbInForm2.target = "kcbPop";

	document.kcbInForm2.action = "https://ipin.ok-name.co.kr/tis/ti/POTI01A_LoginRP.jsp";

	document.kcbInForm2.submit();
	popupWindow.focus()	;
	return	;

}

function ipin_pwsearch2(){

	var obj = document.searchForm3; 

 	if(obj.memberID2.value == "") {alert('아이디를 입력해주세요');obj.memberID2.focus();return;}

	var layerText='<div style="text-align:right;position:absolute;right:-22px;top:-22px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="550" id="inneriframe" src="/member/cert/pwsearch_ipin.asp?uid=' + obj.memberID2.value + '" style="width: 100%; height: 100%;" allowtransparency="true"></iframe>';
	 layer.text(layerText,"filapop", {width:450, height:560, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});

	//layer.iframe("/cert/pwsearch_ipin.asp?uid=" + obj.memberID2.value,"cathPop", {width:450, height:550, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	return	;

}

function ipin_pwsearch_mobile(){

	var obj = document.searchForm3; 

 	if(obj.memberID2.value == "") {alert('아이디를 입력해주세요');obj.memberID2.focus();return;}
	location.href = "/cert/pwsearch_ipin.asp?uid=" + obj.memberID2.value;
	
	return	;

}

function ipin_guest(){

		var obj = document.myform;
	if(!jQuery("#yes").is(":checked")){
		alert("개인정보 취급방침에 동의해 주세요.");
		return false;
	}

	var popupWindow = window.open( "", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
	document.kcbInForm.target = "kcbPop";

	document.kcbInForm.action = "https://ipin.ok-name.co.kr/tis/ti/POTI01A_LoginRP.jsp";

	document.kcbInForm.submit();
	popupWindow.focus()	;
	return	;

}

function ipin_guest2(){

		var obj = document.myform;
	if(!jQuery("#yes").is(":checked")){
		alert("개인정보 취급방침에 동의해 주세요.");
		return false;
	}

//	var popupWindow = window.open( "", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
//	document.kcbInForm.target = "kcbPop";
	parent.jQuery("#cathPop").css("width","450px");
	parent.jQuery("#inneriframe").css("width","450px");
	document.kcbInForm.action = "https://ipin.ok-name.co.kr/tis/ti/POTI01A_LoginRP.jsp";
	document.kcbInForm.submit();
//	popupWindow.focus()	;
	return	;

}

function ipin_guest_mobile(){

		var obj = document.myform;
	if(!jQuery("#yes").is(":checked")){
		alert("개인정보 취급방침에 동의해 주세요.");
		return false;
	}

//	var popupWindow = window.open( "", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
//	document.kcbInForm.target = "kcbPop";

	document.kcbInForm.action = "https://ipin.ok-name.co.kr/tis/ti/POTI01A_LoginRP.jsp";

	document.kcbInForm.submit();
//	popupWindow.focus()	;
	return	;

}

function safe_send(){

	var obj = document.agreeForm;

	if(obj.agree1.checked == false){
		alert("\n이용약관 동의에 체크해 주세요.");
		obj.agree1.focus();
		return false;
	}
	if(obj.agree2.checked == false){
		alert("\개인정보수집 동의에 체크해 주세요.");
		obj.agree2.focus();
		return false;
	}

		window.open("", "auth_popup", "width=432,height=560,scrollbar=yes");
		
		document.form1.action = "http://safe.ok-name.co.kr/CommonSvl";
		document.form1.target = "auth_popup";
		document.form1.method = "post";

		document.form1.submit();

}

function safe_pwsearch(){

		window.open("", "auth_popup", "width=432,height=560,scrollbar=yes");
		
		document.form1.action = "http://safe.ok-name.co.kr/CommonSvl";
		document.form1.target = "auth_popup";
		document.form1.method = "post";

		document.form1.submit();

}

function safe_pwsearch2(){
	
	var obj = document.searchForm3;
	if(obj.memberID2.value == "") {alert('아이디를 입력해주세요');obj.memberID2.focus();return;}
	
	var layerText='<div style="text-align:right;position:absolute;right:-22px;top:-22px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="432" height="560" id="inneriframe" src="/member/cert/pwsearch_safe.asp?uid=' + obj.memberID2.value + '" style="width: 100%; height: 100%;" allowtransparency="true"></iframe>';
		 layer.text(layerText,"filapop", {width:510, height:600, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	
	//layer.iframe("/cert/pwsearch_safe.asp?uid=" + obj.memberID2.value,"cathPop", {width:432, height:560, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	return	;

}

function safe_pwsearch_mobile(){
	
	var obj = document.searchForm3;
	if(obj.memberID2.value == "") {alert('아이디를 입력해주세요');obj.memberID2.focus();return;}

	location.href = "/member/cert/pwsearch_safe.asp?uid=" + obj.memberID2.value;
	//layer.iframe("/cert/pwsearch_safe.asp?uid=" + obj.memberID2.value,"cathPop", {width:432, height:560, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	return	;

}

function safe_pwsearchGo(){


	var obj = document.searchForm3; 

 	if(obj.memberID2.value == "") {alert('아이디를 입력해주세요');obj.memberID2.focus();return;}
	dataFrame.location.href="idpw_search_iframe.asp";

}

function safe_idsearch(){

		window.open("", "auth_popup", "width=432,height=560,scrollbar=yes");
		
		document.form1.action = "http://safe.ok-name.co.kr/CommonSvl";
		document.form1.target = "auth_popup";
		document.form1.method = "post";

		document.form1.submit();

}

function safe_idsearch2(){

	var layerText='<div style="text-align:right;position:absolute;right:-22px;top:-22px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="560" id="inneriframe" src="/member/cert/idsearch_safe.asp" style="width: 100%; height: 100%;" allowtransparency="true"></iframe>';
	 layer.text(layerText,"smallpop", {width:510, height:600, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});

	//layer.iframe("/cert/idsearch_safe.asp","cathPop", {width:432, height:560, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
	return	;

}

function safe_send_Order(){

	if(!jQuery("#yes").is(":checked")){
		alert("개인정보 취급방침에 동의해 주세요.");
		return false;
	}

		window.open("", "auth_popup", "width=432,height=560,scrollbar=yes");
		
		document.form1.action = "http://safe.ok-name.co.kr/CommonSvl";
		document.form1.target = "auth_popup";
		document.form1.method = "post";

		document.form1.submit();

}

function safe_send_Order_mobile(){

	if(!jQuery("#yes").is(":checked")){
		alert("개인정보 취급방침에 동의해 주세요.");
		return false;
	}

		
		document.form1.action = "http://safe.ok-name.co.kr/CommonSvl";
		document.form1.method = "post";

		document.form1.submit();

}

function safe_send_Order_mobile2(){

	if(!jQuery("#yes").is(":checked")){
		alert("개인정보 취급방침에 동의해 주세요.");
		return false;
	}
	parent.jQuery("#cathPop").css("width","450px");
	parent.jQuery("#inneriframe").css("width","450px");
	//parent.jQuery("#cathPop").css("height","860px");
	
		//window.open("", "auth_popup", "width=432,height=560,scrollbar=yes");
		
		document.form1.action = "http://safe.ok-name.co.kr/CommonSvl";
		//document.form1.target = "auth_popup";
		document.form1.method = "post";

		document.form1.submit();

}

var nIndexBackup = -1

function ShowLayer_comment(nIndex)
{
//	alert(document.getElementById('info_div').style.height);

	if (document.all["BBS1" + nIndex].style.display == "") {
		document.all["BBS1" + nIndex].style.display = "none";		
		nIndexBackup = -1;
		return;
	}
	
	if (nIndexBackup != -1) {
		document.all["BBS1" + nIndexBackup].style.display = "none";		
	}
	
	document.all["BBS1" + nIndex].style.display = "";
	nIndexBackup = nIndex
}

function search_order(frm) {
	
	var frm = document.searchOrderFrom;

	if(frm.OrderOName.value=="" || frm.OrderOName.value=="주문자명") {
		alert("\n주문자명을  입력해주세요")
		frm.OrderOName.focus();
		return;
	}
	if(frm.OrderNo.value=="" || frm.OrderNo.value=="주문번호") {
		alert("\n주문번호를  입력해주세요")
		frm.OrderNo.focus();
		return;
	}
	//추가
	if ( jQuery("#defaultReal2").length > 0 ) {
		if(frm.defaultReal2.value == "")	{
			frm.defaultReal2.focus();
			alert("보안 문자를 입력해주세요.");
			return false;
		}
	}
	frm.submit();
}

function pw_updateform()  
{
	var obj = document.myform;

 // 비밀번호 체크
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var number = "1234567890";
    var sChar = "-_=+\|()*&^%$#@!~`?></;,.:'";
    var Passwd = obj.MemberPassword.value;
		var sChar_Count = 0;
		var strCheck = false;
		var numberCheck = false;

  if ( Passwd == "")
  {
    alert("\n비밀번호를 입력해 주세요");
    obj.MemberPassword.focus();
    return false;
  }

  for(var i=0; i<Passwd.length; i++){
  	if(sChar.indexOf(Passwd.charAt(i)) != -1){
    sChar_Count++;
   }
   if(strFirst.indexOf(Passwd.charAt(i)) != -1){
    strCheck = true;
   }
   if(number.indexOf(Passwd.charAt(i)) != -1){
    numberCheck = true;
   }
  }

  if(sChar_Count == 0 && strCheck != true && numberCheck == true){
   	//obj.MemberPassword.focus();
//   alert("비밀번호는 숫자로만 입력하실 수 없습니다.");
//   return false;
  }
  
  if (obj.MemberPassword.value.length < 6 )
  {
    alert("\비밀번호는 6자리 이상이어야 합니다.");
    obj.MemberPassword.focus();
    return false;
  }

  for (var n=0; n < Passwd.length; n++)
    {
        thisChar = Passwd.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
            obj.MemberPassword.focus();
            return false;
        }
  }
    
 for (i=0; i < Passwd.length; i++)
 {
        if(strAll.indexOf(Passwd.substring(i,i+1))<0)
        {
            alert("\n비밀번호에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            obj.MemberPassword.focus();
            return false;
        }
  }
  
  // 비밀번호 확인
  var rePasswd = obj.MemberPassword2.value;
  if (Passwd != rePasswd)
  {
    alert("\n비밀번호가 일치 하지 않습니다.\n\n비밀번호를 재확인 해 주세요.");
    obj.MemberPassword2.focus();
    return false;
  }

	obj.method = "post";
	obj.target = "dataFrame2";
	obj.action = "/member/pw_result.asp"
	obj.submit();
} 


	function chkMobile(){
		var ua = window.navigator.userAgent.toLowerCase();
		var tempVal = false;
		if ( /iphone/.test(ua) || /ipad/.test(ua) ||/android/.test(ua) || /opera/.test(ua) || /bada/.test(ua) ) {
			tempVal = true
		}
		return tempVal
	}

	function safe_send2(){
		var obj = document.agreeForm;
		var w = 450;
		var h = 560;
		var ww = window.document.body.offsetWidth;
		var hh = window.document.body.offsetHeight;

		if(obj.agree1.checked == false){
			alert("\n이용약관 동의에 체크해 주세요.");
			obj.agree1.focus();
			return false;
		}

		if(obj.agree2.checked == false){
			alert("\개인정보수집 및 활용에 대한 동의에 체크해 주세요.");
			obj.agree2.focus();
			return false;
		}
/*
		if(obj.agree3.checked == false){
			alert("\개인정보 취급 위탁에 대한 동의에 체크해 주세요.");
			obj.agree3.focus();
			return false;
		}
*/
		if (chkMobile())  {
			document.form_chk.action = "/member/cert/join_safe.asp";
			document.form_chk.method = "post";
			document.form_chk.submit();
		}else{
			var layerText='<div style="text-align:right;position:absolute;right:-23px;top:-25px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="560" id="inneriframe" src="/member/cert/join_safe.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"safe", {width:510, height:600, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			//layer.iframe("/cert/join_safe.asp","safe", {width:w, height:h, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
		}

	}

	function safe_send3(){
		var w = 410;
		var h = 600;
		var ww = window.document.body.offsetWidth;
		var hh = window.document.body.offsetHeight;
	

		if (chkMobile())  {
			location.href = "/member/cert/join_safe.asp";
		}else{
			/*
			var layerText='<div style="text-align:right;position:absolute;right:-23px;top:-25px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="560" id="inneriframe" src="/member/cert/join_safe.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"safe", {width:410, height:645, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			//layer.iframe("/cert/join_safe.asp","safe", {width:w, height:h, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			*/
			window.open( "/member/cert/join_safe.asp", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
		}

	}

	function safe_send4(){
		var w = 450;
		var h = 560;
		var ww = window.document.body.offsetWidth;
		var hh = window.document.body.offsetHeight;
	

		if (chkMobile())  {
			location.href = "/member/cert/login_safe.asp";
		}else{
/*
			var layerText='<div style="text-align:right;position:absolute;right:-23px;top:-25px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="560" id="inneriframe" src="/member/cert/login_safe.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"safe", {width:410, height:645, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			//layer.iframe("/cert/join_safe.asp","safe", {width:w, height:h, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
*/
			window.open( "/member/cert/login_safe.asp", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
		}

	}

	function safe_send5(){
		var w = 410;
		var h = 600;
		var ww = window.document.body.offsetWidth;
		var hh = window.document.body.offsetHeight;
	
		alert("간편로그인을 등록하기 위해서는 최초 1회 본인인증이 필요합니다.");
		if (chkMobile())  {
			location.href = "/member/cert/modify_safe.asp";
		}else{
			/*
			var layerText='<div style="text-align:right;position:absolute;right:-23px;top:-25px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="560" id="inneriframe" src="/member/cert/join_safe.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"safe", {width:410, height:645, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			//layer.iframe("/cert/join_safe.asp","safe", {width:w, height:h, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			*/
			window.open( "/member/cert/modify_safe.asp", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
		}

	}

	function safe_send6(){
		var w = 410;
		var h = 600;
		var ww = window.document.body.offsetWidth;
		var hh = window.document.body.offsetHeight;
	
		if (chkMobile())  {
			location.href = "/member/cert/social_safe.asp";
		}else{
			/*
			var layerText='<div style="text-align:right;position:absolute;right:-23px;top:-25px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="560" id="inneriframe" src="/member/cert/join_safe.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"safe", {width:410, height:645, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			//layer.iframe("/cert/join_safe.asp","safe", {width:w, height:h, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			*/
			window.open( "/member/cert/social_safe.asp", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
		}

	}

	function safe_send7(){
		var w = 410;
		var h = 600;
		var ww = window.document.body.offsetWidth;
		var hh = window.document.body.offsetHeight;
	
		if (chkMobile())  {
			location.href = "/member/cert/birth_safe.asp";
		}else{
			/*
			var layerText='<div style="text-align:right;position:absolute;right:-23px;top:-25px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="560" id="inneriframe" src="/member/cert/join_safe.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"safe", {width:410, height:645, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			//layer.iframe("/cert/join_safe.asp","safe", {width:w, height:h, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			*/
			window.open( "/member/cert/birth_safe.asp", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
		}

	}

	function safe_send8(){
		var w = 410;
		var h = 600;
		var ww = window.document.body.offsetWidth;
		var hh = window.document.body.offsetHeight;
	
		if (chkMobile())  {
			location.href = "/member/cert/phoneChg_safe.asp";
		}else{
			/*
			var layerText='<div style="text-align:right;position:absolute;right:-23px;top:-25px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="560" id="inneriframe" src="/member/cert/join_safe.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"safe", {width:410, height:645, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			//layer.iframe("/cert/join_safe.asp","safe", {width:w, height:h, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			*/
			window.open( "/member/cert/phoneChg_safe.asp", "kcbPop", "left=200, top=100, status=0, width=450, height=550" );
		}

	}

	function ipin_send2(){
/*
		var obj = document.agreeForm;
	
		if(obj.agree1.checked == false){
			alert("\n이용약관 동의에 체크해 주세요.");
			obj.agree1.focus();
			return false;
		}

		if(obj.agree2.checked == false){
			alert("\개인정보수집 및 활용에 대한 동의에 체크해 주세요.");
			obj.agree2.focus();
			return false;
		}
		if(obj.agree3.checked == false){
			alert("\개인정보 취급 위탁에 대한 동의에 체크해 주세요.");
			obj.agree3.focus();
			return false;
		}
*/		
		if (chkMobile())  {

			document.form_ipin.action = "https://cert.vno.co.kr/ipin.cb";
			document.form_ipin.submit();

		}else{

			var layerText='<div style="text-align:right;position:absolute;right:-37px;top:-22px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="590" id="inneriframe" src="/member/cert/join_ipin.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"ipin", {width:450, height:590, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			
			//layer.iframe("/cert/join_ipin.asp","ipin", {width:500, height:590, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
		}
	}

	function ipin_send3(){
		var obj = document.agreeForm;

		
		if (chkMobile())  {

			document.form_ipin.action = "https://cert.vno.co.kr/ipin.cb";
			document.form_ipin.submit();

		}else{

			var layerText='<div style="text-align:right;position:absolute;right:-37px;top:-22px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="590" id="inneriframe" src="/member/cert/oldMem_ipin.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"ipin", {width:450, height:590, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			
			//layer.iframe("/cert/join_ipin.asp","ipin", {width:500, height:590, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
		}
	}

	function ipin_send4(){
		var obj = document.agreeForm;

		
		if (chkMobile())  {

			document.form_ipin.action = "https://cert.vno.co.kr/ipin.cb";
			document.form_ipin.submit();

		}else{

			var layerText='<div style="text-align:right;position:absolute;right:-37px;top:-22px;"><button type="button" onclick="layer.close();" style="background:none;"><img src="/images/btn/btn_close.png" style="background:none;"></button></div><iframe name="inneriframe" width="450" height="590" id="inneriframe" src="/member/cert/dormant_ipin.asp" style="width: 100%; height: 100%;" allowtransparency="true" frameborder="0"></iframe>';
			layer.text(layerText,"ipin", {width:450, height:590, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
			
			//layer.iframe("/cert/join_ipin.asp","ipin", {width:500, height:590, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});
		}
	}

	function pw_id_check(mode){
		var obj = document.searchForm3; 
		
		if(obj.memberID2.value == "") {alert('아이디를 입력해주세요');obj.memberID2.focus();return;}

		obj.mode.value = mode;
		obj.target = "dataFrame"
		obj.method = "post";
		obj.action = "id_chk.asp";
		obj.submit();
	}

	function id_type_check(mode){
//		var mode =  jQuery("input[name=findID]:checked").val(); //체크박스 값 가져오기

		if (chkMobile())	{ //모바일일 경우
			if ( mode == "safe" ){
				location.href = "/member/cert/idsearch_safe.asp";
			}else{
				location.href = "/member/cert/idsearch_ipin.asp";
			}
		}else{ 
			if ( mode == "safe" ){
				safe_idsearch2();
			}else{
				ipin_idsearch2();
			}

		}

	}

function updateform_pw()  // 비밀번호 찾기후 변경하는것..!
{
	var obj = document.myform2;

 // 비밀번호 체크
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var Passwd = obj.MemberPassword.value;

  if ( Passwd == "")
  {
    alert("\n비밀번호를 입력해 주세요");
    obj.MemberPassword.focus();
    return false;
  }
  
  if (obj.MemberPassword.value.length < 8 )
  {
    alert("\비밀번호는 8자리 이상이어야 합니다.");
    obj.MemberPassword.focus();
    return false;
  }

  for (var n=0; n < Passwd.length; n++)
    {
        thisChar = Passwd.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
            obj.MemberPassword.focus();
            return false;
        }
  }
/*    
 for (i=0; i < Passwd.length; i++)
 {
        if(strAll.indexOf(Passwd.substring(i,i+1))<0)
        {
            alert("\n비밀번호에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            obj.MemberPassword.focus();
            return false;
        }
  }
*/
  
	var regexp = /^(?=.*[a-zA-Z]+)(?=.*[!`~@#$%^)(&*+_=-]+)(?=.*[0-9]+).{8,16}$/;
	
	if (!regexp.test(Passwd)){
		 alert("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=- ");
		 return;
	}



	obj.method = "post";
	obj.target = "dataFrame"; 
	obj.action = "pwsearch_result.asp";
	obj.submit(); 
} 

function changeLater() {
	
	setCookie( "pwCampaign", "done" , 10); 
	
	pwLaterCheck(function(callback){
			if (callback) {
					var rtnUrl = jQuery("#rtnUrl").val();
					
					if ( rtnUrl == "") {
						top.location.href="/main/main.asp";
					}else { 
						top.location.href = rtnUrl;
					}
			}
			else { 
  			top.location.href = "/";
				return false;
			}						
	});
}

function pwLaterCheck(callback) {
	jQuery.ajax({
		type: "POST",
		url: "/member/pwLater.asp",
		data: "",
		dataType : "JSON",
		async: false,		
		success: function(data) {
      if (data.status == "0")	{ // success!
      		callback(true);
      }
      else {	// fail!
          alert(data.msg);
					callback(false);
      }
		},
		error: function(e) {
			callback(false);
		}
	});
	//return false;
}

function setCookie( name, value, expiredays ) {
	var todayDate = new Date(); 
	todayDate.setDate( todayDate.getDate() + expiredays ); 
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
}


function pwcampaign_updateform()  
{
	var obj = document.myform;

 // 비밀번호 체크
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var number = "1234567890";
    var sChar = "-_=+\|()*&^%$#@!~`?></;,.:'";
    var Passwd = obj.MemberPassword.value;
		var sChar_Count = 0;
		var strCheck = false;
		var numberCheck = false;

  if ( Passwd == "")
  {
    alert("\n비밀번호를 입력해 주세요");
    obj.MemberPassword.focus();
    return false;
  }

  for(var i=0; i<Passwd.length; i++){
  	if(sChar.indexOf(Passwd.charAt(i)) != -1){
    sChar_Count++;
   }
   if(strFirst.indexOf(Passwd.charAt(i)) != -1){
    strCheck = true;
   }
   if(number.indexOf(Passwd.charAt(i)) != -1){
    numberCheck = true;
   }
  }

  if(sChar_Count == 0 && strCheck != true && numberCheck == true){
   	//obj.MemberPassword.focus();
//   alert("비밀번호는 숫자로만 입력하실 수 없습니다.");
//   return false;
  }
  
  if (obj.MemberPassword.value.length < 8 )
  {
    alert("\비밀번호는 8자리 이상이어야 합니다.");
    obj.MemberPassword.focus();
    return false;
  }

  for (var n=0; n < Passwd.length; n++)
    {
        thisChar = Passwd.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
            obj.MemberPassword.focus();
            return false;
        }
  }
    
	var regexp = /^(?=.*[a-zA-Z]+)(?=.*[!`~@#$%^)(&*+_=-]+)(?=.*[0-9]+).{8,16}$/;
	
	if (!regexp.test(Passwd)){
		 alert("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=- ");
		 return;
	}
  
  // 비밀번호 확인
  var rePasswd = obj.MemberPassword2.value;
  if (Passwd != rePasswd)
  {
    alert("\n비밀번호가 일치 하지 않습니다.\n\n비밀번호를 재확인 해 주세요.");
    obj.MemberPassword2.focus();
    return false;
  }

	obj.method = "post";
	obj.target = "dataFrame";
	obj.action = "/member/pw_campaign_result.asp"
	obj.submit();
} 


function login_pw_updateform()  
{
	var obj = document.myform;

 // 비밀번호 체크
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var number = "1234567890";
    var sChar = "-_=+\|()*&^%$#@!~`?></;,.:'";
    var Passwd = obj.MemberPassword.value;
		var sChar_Count = 0;
		var strCheck = false;
		var numberCheck = false;

  if ( Passwd == "")
  {
    alert("\n비밀번호를 입력해 주세요");
    obj.MemberPassword.focus();
    return false;
  }

  for(var i=0; i<Passwd.length; i++){
  	if(sChar.indexOf(Passwd.charAt(i)) != -1){
    sChar_Count++;
   }
   if(strFirst.indexOf(Passwd.charAt(i)) != -1){
    strCheck = true;
   }
   if(number.indexOf(Passwd.charAt(i)) != -1){
    numberCheck = true;
   }
  }

  if(sChar_Count == 0 && strCheck != true && numberCheck == true){
   	//obj.MemberPassword.focus();
//   alert("비밀번호는 숫자로만 입력하실 수 없습니다.");
//   return false;
  }
  
  if (obj.MemberPassword.value.length < 6 )
  {
    alert("\비밀번호는 6자리 이상이어야 합니다.");
    obj.MemberPassword.focus();
    return false;
  }

  for (var n=0; n < Passwd.length; n++)
    {
        thisChar = Passwd.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
            obj.MemberPassword.focus();
            return false;
        }
  }
    
 for (i=0; i < Passwd.length; i++)
 {
        if(strAll.indexOf(Passwd.substring(i,i+1))<0)
        {
            alert("\n비밀번호에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            obj.MemberPassword.focus();
            return false;
        }
  }
  
  // 비밀번호 확인
  var rePasswd = obj.MemberPassword2.value;
  if (Passwd != rePasswd)
  {
    alert("\n비밀번호가 일치 하지 않습니다.\n\n비밀번호를 재확인 해 주세요.");
    obj.MemberPassword2.focus();
    return false;
  }

	obj.method = "post";
	obj.target = "dataFrame";
	obj.action = "/member/login_pw_result.asp"
	obj.submit();
} 


function dormant_pw_updateform()  
{
	var obj = document.myform;

 // 비밀번호 체크
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var number = "1234567890";
    var sChar = "-_=+\|()*&^%$#@!~`?></;,.:'";
    var Passwd = obj.MemberPassword.value;
		var sChar_Count = 0;
		var strCheck = false;
		var numberCheck = false;

  if ( Passwd == "")
  {
    alert("\n비밀번호를 입력해 주세요");
    obj.MemberPassword.focus();
    return false;
  }

  for(var i=0; i<Passwd.length; i++){
  	if(sChar.indexOf(Passwd.charAt(i)) != -1){
    sChar_Count++;
   }
   if(strFirst.indexOf(Passwd.charAt(i)) != -1){
    strCheck = true;
   }
   if(number.indexOf(Passwd.charAt(i)) != -1){
    numberCheck = true;
   }
  }

  if(sChar_Count == 0 && strCheck != true && numberCheck == true){
   	//obj.MemberPassword.focus();
//   alert("비밀번호는 숫자로만 입력하실 수 없습니다.");
//   return false;
  }
  
  if (obj.MemberPassword.value.length < 6 )
  {
    alert("\비밀번호는 6자리 이상이어야 합니다.");
    obj.MemberPassword.focus();
    return false;
  }

  for (var n=0; n < Passwd.length; n++)
    {
        thisChar = Passwd.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
            obj.MemberPassword.focus();
            return false;
        }
  }
    
 for (i=0; i < Passwd.length; i++)
 {
        if(strAll.indexOf(Passwd.substring(i,i+1))<0)
        {
            alert("\n비밀번호에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            obj.MemberPassword.focus();
            return false;
        }
  }
  
  // 비밀번호 확인
  var rePasswd = obj.MemberPassword2.value;
  if (Passwd != rePasswd)
  {
    alert("\n비밀번호가 일치 하지 않습니다.\n\n비밀번호를 재확인 해 주세요.");
    obj.MemberPassword2.focus();
    return false;
  }

	obj.method = "post";
	obj.target = "dataFrame";
	obj.action = "/member/dormant_pw_result.asp"
	obj.submit();
} 


function AllAgreeCheck(){
    var frm = document.agreeForm;

    if (frm.joinall_ok.checked == true){
        frm.agree1.checked = true;
        frm.agree2.checked = true;
        frm.agree3.checked = true;
    }else{
        frm.agree1.checked = false;
        frm.agree2.checked = false;
        frm.agree3.checked = false;
    }   
}

function validate(evt) {
  var theEvent = evt || window.event;
  var key = theEvent.keyCode || theEvent.which;
  
  key = String.fromCharCode( key );
  var regex = /[0-9]|\./;
  if( !regex.test(key) ) {
  	
    theEvent.returnValue = false;
    if(theEvent.preventDefault) theEvent.preventDefault();
  }
}

function validate3(evt) {
  var theEvent = evt || window.event;
  var key = theEvent.keyCode || theEvent.which;
  
  //key = String.fromCharCode( key );
  
 if(( key >= 32 && key < 48 ) || ( key > 57 && key < 127 ) ) {
    theEvent.returnValue = false;
    if(theEvent.preventDefault) theEvent.preventDefault();
 }
  
}


function idChoice(){
	var obj = document.choiceForm;
	obj.submit();
}


// 회원가입 간소화 추가 함수 -->
function joinSMS(){
	var obj = document.myform;

	if( obj.memberName.value == "" ){
		alert("이름을 입력해 주세요.");
		obj.memberName.focus();
		return false;
	} else if( obj.mtel1.value == "" ){
		alert("핸드폰 번호를 입력해 주세요.");
		obj.mtel1.focus();
		return false;
	} else if ( obj.mtel2.value == "" ) {
		alert("핸드폰 번호를 입력해 주세요.");
		obj.mtel2.focus();
		return false;
	} else if ( obj.mtel3.value == "" ) {
		alert("핸드폰 번호를 입력해 주세요.");
		obj.mtel3.focus();
		return false;
	} else {

		var memberTel2 = obj.mtel1.value + "-" + obj.mtel2.value + "-" + obj.mtel3.value
		memberTel2 = memberTel2.replace(/-/g, "");

		var expText = /^\d{3}\d{3,4}\d{4}$/;
		var expText2 = /^\d{2,3}\d{3,4}\d{4}$/;

		var nans2 = memberTel2 ; 
		nans2 = nans2.replace(/-/g, "");
		if(expText.test(nans2) != true && expText2.test(nans2) != true){    
			alert("올바른 번호를 입력해 주세요.");	
			return false;	
		}
	}

	parent.myform.mtel1.disabled  = false ;

	obj.action = "join_sms.asp";
	obj.target = "dataFrame";
	obj.method = "post";
	obj.submit();
}


function sendform()   <!--이부분은 회원가입시의 빈값을 체킹하는 부분이다.!!-->
{
	var obj = document.myform;

	sleep(200);

	try {

		if( obj.join_cert.value != "ok" ) {
			//alert("본인인증을 해주세요.");
			$("#certCheckText").html("본인인증을 해주세요.");
			$("#certCheckText").addClass("on");
			$("#certCheckText").show();
			obj.Certall1.focus();
			return;
		}else{
			$("#certCheckText").removeClass("on");
			$("#certCheckText").hide();
		}

	/*
		if(obj.totalMembership[0].checked == false){
			alert("통합멤버십에 동의 하셔야 가입이 됩니다.");
			obj.totalMembership[0].focus();
			return;
		}
	*/
		if(obj.memberId.value=="") {
			//alert("아이디를 입력하십시오!");
			obj.memberId.focus();
			$("#idCheckText").html("아이디를 입력해주세요.");
			$("#idCheckText").addClass("on");
			$("#idCheckText").show()
			return;
		}else{
			$("#idCheckText").removeClass("on");
			$("#idCheckText").hide()
		}

		if( obj.id_check.value != "ok" ) {
			//alert("아이디 중복체크를 해주세요!");
			obj.memberId.focus();
			$("#idCheckText").html("아이디를 중복체크를 해주세요.");
			$("#idCheckText").addClass("on");
			$("#idCheckText").show()
			return;
		}else{
			$("#idCheckText").removeClass("on");
			$("#idCheckText").hide()
		}


		if ( obj.memberId.value.length < 4  ) {
			//alert("\회원 ID는 4자리 이상이어야 합니다.");
			obj.memberId.focus();
			$("#idCheckText").html("회원 ID는 4자리 이상이어야 합니다.");
			$("#idCheckText").addClass("on");
			$("#idCheckText").show()
			return;
		}else{
			$("#idCheckText").removeClass("on");
			$("#idCheckText").hide()
		}
	    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
	    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	    var MemberID = obj.memberId.value;
	    
	    if(strFirst.indexOf(MemberID.substring(0,1))<0) {
	      //alert("\nID 첫 글자는 영문자만 가능합니다.");
	      obj.memberId.focus();
			$("#idCheckText").html("ID 첫 글자는 영문자만 가능합니다.");
			$("#idCheckText").addClass("on");
			$("#idCheckText").show()
	      return;
	    }else{
			$("#idCheckText").removeClass("on");
			$("#idCheckText").hide()
		}
	    
	    for(var n=0; n < MemberID.length; n++) {
	      thisChar = MemberID.substring(n, n+1);
	        if(thisChar==' ') {
	            //alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
	            obj.memberId.focus();
				$("#idCheckText").html("공백이 포함된 ID 는 조회할 수 없습니다.");
				$("#idCheckText").addClass("on");
				$("#idCheckText").show();
	            return;
	        }else{
				$("#idCheckText").removeClass("on");
				$("#idCheckText").hide();
			}
	    }
	    
	    for (i=0; i < MemberID.length; i++) {
	        if(strAll.indexOf(MemberID.substring(i,i+1))<0) {
	            //alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
	            obj.memberId.focus();
				$("#idCheckText").html("ID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
				$("#idCheckText").addClass("on");
				$("#idCheckText").show();
	            return;
	        }else{
				$("#idCheckText").removeClass("on");
				$("#idCheckText").hide();
			}
	    }

	 // 비밀번호 체크
	    strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
	    strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	    Passwd = obj.memberPassword.value;

		if ( Passwd == "")
		{
		//alert("\n비밀번호를 입력해 주세요");
		obj.memberPassword.focus();
				$("#pwResult3").html("\n비밀번호를 입력해 주세요.");
				$("#pwResult3").addClass("on");
				$("#pwResult3").show();
		return;
		}else{
			$("#pwResult3").removeClass("on");
			$("#pwResult3").hide();
		}
		
		if (obj.memberPassword.value.length < 8 )
		{
		//alert("\비밀번호는 8자리 이상이어야 합니다.");
		obj.memberPassword.focus();
				$("#pwResult3").html("비밀번호는 8자리 이상이어야 합니다.");
				$("#pwResult3").addClass("on");
				$("#pwResult3").show();
		return;
		}else{
			$("#pwResult3").removeClass("on");
			$("#pwResult3").hide();
		}
		
		for (var n=0; n < Passwd.length; n++)
		{
			thisChar = Passwd.substring(n, n+1);
			if(thisChar==' ')
			{
				//alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
				obj.memberPassword.focus();
				$("#pwResult3").html("공백이 포함된 비밀번호는 사용할 수 없습니다.");
				$("#pwResult3").addClass("on");
				$("#pwResult3").show();
				return;
			}else{
				$("#pwResult3").removeClass("on");
				$("#pwResult3").hide();
			}
		}
	  
		var regexp = /^(?=.*[a-zA-Z]+)(?=.*[!`~@#$%^)(&*+_=-]+)(?=.*[0-9]+).{8,16}$/;
		
		if (!regexp.test(Passwd)){
			 //alert("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=- ");
				$("#pwResult3").html("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=-");
				$("#pwResult3").addClass("on");
				$("#pwResult3").show();
			 return;
		}else{
			$("#pwResult3").removeClass("on");
			$("#pwResult3").hide();
		}


		
		if(obj.memberName.value == ""){
			//alert('\n이름을 입력해주세요');
			obj.memberName.focus();
			$("#nameCheckText").html("이름을 입력해주세요");
			$("#nameCheckText").addClass("on");
			$("#nameCheckText").show();
			return;  		
		}else{
			$("#nameCheckText").removeClass("on");
			$("#nameCheckText").hide();
		}


		if(obj.birthDay.value == ""){
			//alert('\n생년월일을 선택해 주세요.');
			obj.birthDay.focus();
			$("#bdayCheckText").html("생년월일을 입력해 주세요.");
			$("#bdayCheckText").addClass("on");
			$("#bdayCheckText").show();
			return;  		
		}else{
			$("#bdayCheckText").removeClass("on");
			$("#bdayCheckText").hide();
		}

		if (obj.email1.value == ""){
			//alert('\n생년월일을 선택해 주세요.');
			obj.email1.focus();
			$("#emailCheckText").html("Email을 입력해 주세요.");
			$("#emailCheckText").addClass("on");
			$("#emailCheckText").show();
			return;  		
		}else{
			$("#emailCheckText").removeClass("on");
			$("#emailCheckText").hide();
		}

		var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z\-]+/;

		if(exptext.test(obj.email1.value)==false) {
			$("#emailCheckText").html("Email이 올바르지 않습니다.");
			$("#emailCheckText").addClass("on");
			$("#emailCheckText").show();
	        obj.email1.focus();
			return;
		}else{
			$("#emailCheckText").removeClass("on");
			$("#emailCheckText").hide();
		}
			

		if(obj.agree1.checked == false){
			//alert("이용약관에 동의 하셔야 가입이 가능합니다.");
			$("#agreeCheckText").html("이용약관에 동의 하셔야 가입이 가능합니다.");
			$("#agreeCheckText").addClass("on");
			$("#agreeCheckText").show();
			obj.agree1.focus();
			return;
		}else{
			$("#agreeCheckText").removeClass("on");
			$("#agreeCheckText").hide();
		}
		if(obj.agree2.checked == false){
			//alert("개인정보수집 및 활용에 대한 동의 하셔야 가입이 가능합니다.");
			$("#agreeCheckText").html("개인정보수집 및 활용에 대한 동의 하셔야 가입이 가능합니다.");
			$("#agreeCheckText").addClass("on");
			$("#agreeCheckText").show();
			obj.agree2.focus();
			return;
		}else{
			$("#agreeCheckText").removeClass("on");
			$("#agreeCheckText").hide();
		}
		/*
		if(obj.agree3.checked == false){
			//alert("개인정보 국외 이전에 관한 동의 하셔야 가입이 가능합니다.");
			$("#agreeCheckText").html("개인정보 국외 이전에 관한 동의 하셔야 가입이 가능합니다.");
			$("#agreeCheckText").addClass("on");
			$("#agreeCheckText").show();
			obj.agree3.focus();
			return;
		}else{
			$("#agreeCheckText").removeClass("on");
			$("#agreeCheckText").hide();
		}
		*/


	/*
		if(obj.totalMembership[0].checked == false){
			//alert("통합멤버십에 동의 하셔야 가입이 됩니다.");
			$("#termsCheckText").html("통합멤버십에 동의 하셔야 가입이 됩니다.");
			$("#termsCheckText").addClass("on");
			obj.totalMembership[0].focus();
			return;
		}else{
			$("#termsCheckText").removeClass("on");
		}
	*/
			obj.joinMode.value = ""


			if (is_setting == "Click") {
				alert("처리중입니다.\n\n잠시만 기다려 주세요");
			}     
			else
			{
				m_setting();
				//myform.mtel1.disabled  = false ;
				jQuery("#loginButton").hide();
				jQuery("#loginButton2").show();
				//jQuery("#loginButton").html("<img src='/images/waiting.gif'>");
				obj.action="member_result_simple.asp";
				obj.method="post";
				obj.target="dataFrame";
				obj.submit();
			}
			
	} catch (error) {
	    $.ajax({
	        url: "/ext/javascript_catch.asp", // 오류 정보를 처리할 서버의 URL
	        type: "POST",
	        data: {
	            message: error.message,
	            stack: error.stack,
	            scriptVal: "sendform"
	        },
	        success: function(response) {
	            console.log("Error logged successfully");
	        },
	        error: function(xhr, status, error) {
	            console.log("Error logging failed: ", error);
	        }
	    });
	}	
}
//이메일 유효성 체크
function validEmailCheck(obj){
    var pattern = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
    return (obj.value.match(pattern)!=null)
}

function sendform_simple_off_2022(){
	var obj = document.myform;

	sleep(200);

	try {

			if( obj.join_cert.value != "ok" ) {
				//alert("본인인증을 해주세요.");
				$("#certCheckText").html("본인인증을 해주세요.");
				$("#certCheckText").addClass("on");
				$("#certCheckText").show();
				obj.Certall1.focus();
				return;
			}else{
				$("#certCheckText").removeClass("on");
				$("#certCheckText").hide();
			}

		/*
			if(obj.totalMembership[0].checked == false){
				alert("통합멤버십에 동의 하셔야 가입이 됩니다.");
				obj.totalMembership[0].focus();
				return;
			}
		*/

			//아이디는 필수가 아니라 아이디 입력시에만 체크 S
			if(obj.memberId.value != "" || obj.joinMode.value == "online" ) {

				if(obj.memberId.value=="") {
					//alert("아이디를 입력하십시오!");
					obj.memberId.focus();
					$("#idCheckText").html("아이디를 입력해주세요.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show()
					return;
				}else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide()
				}

				if( obj.id_check.value != "ok" ) {
					//alert("아이디 중복체크를 해주세요!");
					obj.memberId.focus();
					$("#idCheckText").html("아이디를 중복체크를 해주세요.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show()
					return;
				}else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide()
				}


				if ( obj.memberId.value.length < 4  ) {
					//alert("\회원 ID는 4자리 이상이어야 합니다.");
					obj.memberId.focus();
					$("#idCheckText").html("회원 ID는 4자리 이상이어야 합니다.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show()
					return;
				}else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide()
				}
				var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
				var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var MemberID = obj.memberId.value;
				
				if(strFirst.indexOf(MemberID.substring(0,1))<0) {
				  //alert("\nID 첫 글자는 영문자만 가능합니다.");
				  obj.memberId.focus();
					$("#idCheckText").html("ID 첫 글자는 영문자만 가능합니다.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show()
				  return;
				}else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide()
				}
				
				for(var n=0; n < MemberID.length; n++) {
				  thisChar = MemberID.substring(n, n+1);
					if(thisChar==' ') {
						//alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
						obj.memberId.focus();
						$("#idCheckText").html("공백이 포함된 온라인 ID는 가입 불가합니다.");
						$("#idCheckText").addClass("on");
						$("#idCheckText").show();
						return;
					}else{
						$("#idCheckText").removeClass("on");
						$("#idCheckText").hide();
					}
				}
				
				for (i=0; i < MemberID.length; i++) {
					if(strAll.indexOf(MemberID.substring(i,i+1))<0) {
						//alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
						obj.memberId.focus();
						//$("#idCheckText").html("ID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
						$("#idCheckText").html("영문, 숫자 조합 4글자 이상 입력해주세요. (첫글자는 영문 필수)");
						
						$("#idCheckText").addClass("on");
						$("#idCheckText").show();
						return;
					}else{
						$("#idCheckText").removeClass("on");
						$("#idCheckText").hide();
					}
				}

			 // 비밀번호 체크
				strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
				strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
				Passwd = obj.memberPassword.value;

				if ( Passwd == "")
				{
				//alert("\n비밀번호를 입력해 주세요");
				obj.memberPassword.focus();
						$("#pwResult3").html("\n비밀번호를 입력해 주세요.");
						$("#pwResult3").addClass("on");
						$("#pwResult3").show();
				return;
				}else{
					$("#pwResult3").removeClass("on");
					$("#pwResult3").hide();
				}
				
				if (obj.memberPassword.value.length < 8 )
				{
				//alert("\비밀번호는 8자리 이상이어야 합니다.");
				obj.memberPassword.focus();
						$("#pwResult3").html("비밀번호는 8자리 이상이어야 합니다.");
						$("#pwResult3").addClass("on");
						$("#pwResult3").show();
				return;
				}else{
					$("#pwResult3").removeClass("on");
					$("#pwResult3").hide();
				}
				
				for (var n=0; n < Passwd.length; n++)
				{
					thisChar = Passwd.substring(n, n+1);
					if(thisChar==' ')
					{
						//alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
						obj.memberPassword.focus();
						$("#pwResult3").html("공백이 포함된 비밀번호는 사용할 수 없습니다.");
						$("#pwResult3").addClass("on");
						$("#pwResult3").show();
						return;
					}else{
						$("#pwResult3").removeClass("on");
						$("#pwResult3").hide();
					}
				}
			  
				var regexp = /^(?=.*[a-zA-Z]+)(?=.*[!`~@#$%^)(&*+_=-]+)(?=.*[0-9]+).{8,16}$/;
				
				if (!regexp.test(Passwd)){
					 //alert("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=- ");
						$("#pwResult3").html("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=-");
						$("#pwResult3").addClass("on");
						$("#pwResult3").show();
					 return;
				}else{
					$("#pwResult3").removeClass("on");
					$("#pwResult3").hide();
				}

				if (obj.email1.value == ""){
					//alert('\n생년월일을 선택해 주세요.');
					obj.email1.focus();
					$("#emailCheckText").html("Email을 입력해 주세요.");
					$("#emailCheckText").addClass("on");
					$("#emailCheckText").show();
					return;  		
				}else{
					$("#emailCheckText").removeClass("on");
					$("#emailCheckText").hide();
				}

				var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z\-]+/;

				if(exptext.test(obj.email1.value)==false) {
					$("#emailCheckText").html("이메일 양식이 올바르지 않습니다.");
					$("#emailCheckText").addClass("on");
					$("#emailCheckText").show();
					obj.email1.focus();
					return;
				}else{
					$("#emailCheckText").removeClass("on");
					$("#emailCheckText").hide();
				}
					

			}

			
			if(obj.memberName.value == ""){
				//alert('\n이름을 입력해주세요');
				obj.memberName.focus();
				$("#nameCheckText").html("이름을 입력해주세요");
				$("#nameCheckText").addClass("on");
				$("#nameCheckText").show();
				return;  		
			}else{
				$("#nameCheckText").removeClass("on");
				$("#nameCheckText").hide();
			}


			if(obj.birthDay.value == ""){
				//alert('\n생년월일을 선택해 주세요.');
				obj.birthDay.focus();
				$("#bdayCheckText").html("생년월일을 입력해 주세요.");
				$("#bdayCheckText").addClass("on");
				$("#bdayCheckText").show();
				return;  		
			}else{
				$("#bdayCheckText").removeClass("on");
				$("#bdayCheckText").hide();
			}

			if(obj.agree1.checked == false){
				//alert("이용약관에 동의 하셔야 가입이 가능합니다.");
				$("#agreeCheckText").html("이용약관에 동의 하셔야 가입이 가능합니다.");
				$("#agreeCheckText").addClass("on");
				$("#agreeCheckText").show();
				obj.agree1.focus();
				return;
			}else{
				$("#agreeCheckText").removeClass("on");
				$("#agreeCheckText").hide();
			}
			if(obj.agree2.checked == false){
				//alert("개인정보수집 및 활용에 대한 동의 하셔야 가입이 가능합니다.");
				$("#agreeCheckText").html("개인정보수집 및 활용에 대한 동의 하셔야 가입이 가능합니다.");
				$("#agreeCheckText").addClass("on");
				$("#agreeCheckText").show();
				obj.agree2.focus();
				return;
			}else{
				$("#agreeCheckText").removeClass("on");
				$("#agreeCheckText").hide();
			}
			/*
			if(obj.agree3.checked == false){
				//alert("개인정보 국외 이전에 관한 동의 하셔야 가입이 가능합니다.");
				$("#agreeCheckText").html("개인정보 국외 이전에 관한 동의 하셔야 가입이 가능합니다.");
				$("#agreeCheckText").addClass("on");
				$("#agreeCheckText").show();
				obj.agree3.focus();
				return;
			}else{
				$("#agreeCheckText").removeClass("on");
				$("#agreeCheckText").hide();
			}
			*/

		/*
			if(obj.totalMembership[0].checked == false){
				//alert("통합멤버십에 동의 하셔야 가입이 됩니다.");
				$("#termsCheckText").html("통합멤버십에 동의 하셔야 가입이 됩니다.");
				$("#termsCheckText").addClass("on");
				obj.totalMembership[0].focus();
				return;
			}else{
				$("#termsCheckText").removeClass("on");
			}
		*/
			//obj.joinMode.value = ""


		/*
			if(obj.MemberIsMaillinglist.checked == false || obj.MemberIsSMS.checked == false ){
				if (confirm("EMAIL 및 SMS 수신동의를 원치 않으실 경우 \n기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

				}else{
						//obj.MemberIsMaillinglist.focus();
						return false;
				}
			}
		*/

			if (is_setting == "Click") {
				alert("처리중입니다.\n\n잠시만 기다려 주세요");
			}     
			else
			{
				m_setting();
				//myform.mtel1.disabled  = false ;
				jQuery("#loginButton").hide();
				jQuery("#loginButton2").show();
				//jQuery("#loginButton").html("<img src='/images/waiting.gif'>");
				obj.action="/member/member_result_simple_off.asp";
				obj.method="post";
				obj.target="dataFrame";
				obj.submit();
			}
				
	} catch (error) {
	    $.ajax({
	        url: "/ext/javascript_catch.asp", // 오류 정보를 처리할 서버의 URL
	        type: "POST",
	        data: {
	            message: error.message,
	            stack: error.stack,
	            scriptVal: "sendform_simple_off_2022"
	        },
	        success: function(response) {
	            console.log("Error logged successfully");
	        },
	        error: function(xhr, status, error) {
	            console.log("Error logging failed: ", error);
	        }
	    });
	}		
}

function sendform_simple_sns_2022()   <!--이부분은 회원가입시의 빈값을 체킹하는 부분이다.!!-->
{
	var obj = document.myform;

	sleep(200);

		try {

				if( obj.id_check.value != "ok" ) {
					//alert("아이디 중복체크를 해주세요!");
					obj.memberId.focus();
					$("#idCheckText").html("아이디를 중복체크를 해주세요.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show()
					return;
				}else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide()
				}

			if ( obj.memberId.value.length < 4  ) {
				//alert("\회원 ID는 4자리 이상이어야 합니다.");
				obj.memberId.focus();
				$("#idCheckText").html("회원 ID는 4자리 이상이어야 합니다.");
				$("#idCheckText").addClass("on");
				$("#idCheckText").show()
				return;
			}else{
				$("#idCheckText").removeClass("on");
				$("#idCheckText").hide()
			}
		    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
		    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		    var MemberID = obj.memberId.value;
		    
		    if(strFirst.indexOf(MemberID.substring(0,1))<0) {
		      //alert("\nID 첫 글자는 영문자만 가능합니다.");
		      obj.memberId.focus();
				$("#idCheckText").html("ID 첫 글자는 영문자만 가능합니다.");
				$("#idCheckText").addClass("on");
				$("#idCheckText").show()
		      return;
		    }else{
				$("#idCheckText").removeClass("on");
				$("#idCheckText").hide()
			}
		    
		    for(var n=0; n < MemberID.length; n++) {
		      thisChar = MemberID.substring(n, n+1);
		        if(thisChar==' ') {
		            //alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
		            obj.memberId.focus();
					$("#idCheckText").html("공백이 포함된 ID 는 조회할 수 없습니다.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show();
		            return;
		        }else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide();
				}
		    }
		    
		    for (i=0; i < MemberID.length; i++) {
		        if(strAll.indexOf(MemberID.substring(i,i+1))<0) {
		            //alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
		            obj.memberId.focus();
					$("#idCheckText").html("ID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show();
		            return;
		        }else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide();
				}
		    }

		 // 비밀번호 체크
		    strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
		    strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		    Passwd = obj.memberPassword.value;

			if ( Passwd == "")
			{
			//alert("\n비밀번호를 입력해 주세요");
			obj.memberPassword.focus();
					$("#pwResult3").html("\n비밀번호를 입력해 주세요.");
					$("#pwResult3").addClass("on");
					$("#pwResult3").show();
			return;
			}else{
				$("#pwResult3").removeClass("on");
				$("#pwResult3").hide();
			}
			
			if (obj.memberPassword.value.length < 8 )
			{
			//alert("\비밀번호는 8자리 이상이어야 합니다.");
			obj.memberPassword.focus();
					$("#pwResult3").html("비밀번호는 8자리 이상이어야 합니다.");
					$("#pwResult3").addClass("on");
					$("#pwResult3").show();
			return;
			}else{
				$("#pwResult3").removeClass("on");
				$("#pwResult3").hide();
			}
			
			for (var n=0; n < Passwd.length; n++)
			{
				thisChar = Passwd.substring(n, n+1);
				if(thisChar==' ')
				{
					//alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
					obj.memberPassword.focus();
					$("#pwResult3").html("공백이 포함된 비밀번호는 사용할 수 없습니다.");
					$("#pwResult3").addClass("on");
					$("#pwResult3").show();
					return;
				}else{
					$("#pwResult3").removeClass("on");
					$("#pwResult3").hide();
				}
			}
		  
			var regexp = /^(?=.*[a-zA-Z]+)(?=.*[!`~@#$%^)(&*+_=-]+)(?=.*[0-9]+).{8,16}$/;
			
			if (!regexp.test(Passwd)){
				 //alert("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=- ");
					$("#pwResult3").html("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=-");
					$("#pwResult3").addClass("on");
					$("#pwResult3").show();
				 return;
			}else{
				$("#pwResult3").removeClass("on");
				$("#pwResult3").hide();
			}
			 
			if (obj.email1.value == ""){
				//alert('\n생년월일을 선택해 주세요.');
				obj.email1.focus();
				$("#emailCheckText").html("Email을 입력해 주세요.");
				$("#emailCheckText").addClass("on");
				$("#emailCheckText").show();
				return;  		
			}else{
				$("#emailCheckText").removeClass("on");
				$("#emailCheckText").hide();
			}

			var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z\-]+/;

			if(exptext.test(obj.email1.value)==false) {
				$("#emailCheckText").html("Email이 올바르지 않습니다.");
				$("#emailCheckText").addClass("on");
				$("#emailCheckText").show();
		        obj.email1.focus();
				return;
			}else{
				$("#emailCheckText").removeClass("on");
				$("#emailCheckText").hide();
			}

			obj.joinMode.value = ""
		/*
			if(obj.MemberIsMaillinglist.checked == false || obj.MemberIsSMS.checked == false ){
				if (confirm("EMAIL 및 SMS 수신동의를 원치 않으실 경우 \n기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

				}else{
						//obj.MemberIsMaillinglist.focus();
						return false;
				}
			}
		*/

			if (is_setting == "Click") {
				alert("처리중입니다.\n\n잠시만 기다려 주세요");
			}     
			else
			{
				m_setting();
				//myform.mtel1.disabled  = false ;
				jQuery("#loginButton").hide();
				jQuery("#loginButton2").show();
				//jQuery("#loginButton").html("<img src='/images/waiting.gif'>");
				obj.action="/member/member_result_simple_sns.asp";
				obj.method="post";
				obj.target="dataFrame";
				obj.submit();
			}
				
	} catch (error) {
	    $.ajax({
	        url: "/ext/javascript_catch.asp", // 오류 정보를 처리할 서버의 URL
	        type: "POST",
	        data: {
	            message: error.message,
	            stack: error.stack,
	            scriptVal: "sendform_simple_sns_2022"
	        },
	        success: function(response) {
	            console.log("Error logged successfully");
	        },
	        error: function(xhr, status, error) {
	            console.log("Error logging failed: ", error);
	        }
	    });
	}
}
//오프라인 sns가입
function sendform_simple_sns_off_2022() 
{
	var obj = document.myform;

	sleep(200);
	
	try {
		
			//아이디는 필수가 아니라 아이디 입력시에만 체크 S
			if(obj.memberId.value != "") {

				if ( obj.memberId.value.length < 4  ) {
					//alert("\회원 ID는 4자리 이상이어야 합니다.");
					obj.memberId.focus();
					$("#idCheckText").html("회원 ID는 4자리 이상이어야 합니다.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show()
					return;
				}else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide()
				}
				var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
				var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var MemberID = obj.memberId.value;
				
				if(strFirst.indexOf(MemberID.substring(0,1))<0) {
				  //alert("\nID 첫 글자는 영문자만 가능합니다.");
				  obj.memberId.focus();
					$("#idCheckText").html("ID 첫 글자는 영문자만 가능합니다.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show()
				  return;
				}else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide()
				}
				
				for(var n=0; n < MemberID.length; n++) {
				  thisChar = MemberID.substring(n, n+1);
					if(thisChar==' ') {
						//alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
						obj.memberId.focus();
						$("#idCheckText").html("공백이 포함된 온라인 ID는 가입 불가합니다.");
						$("#idCheckText").addClass("on");
						$("#idCheckText").show();
						return;
					}else{
						$("#idCheckText").removeClass("on");
						$("#idCheckText").hide();
					}
				}
				
				for (i=0; i < MemberID.length; i++) {
					if(strAll.indexOf(MemberID.substring(i,i+1))<0) {
						//alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
						obj.memberId.focus();
						$("#idCheckText").html("ID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
						$("#idCheckText").addClass("on");
						$("#idCheckText").show();
						return;
					}else{
						$("#idCheckText").removeClass("on");
						$("#idCheckText").hide();
					}
				}

				if( obj.id_check.value != "ok" ) {
					//alert("아이디 중복체크를 해주세요!");
					obj.memberId.focus();
					$("#idCheckText").html("아이디를 중복체크를 해주세요.");
					$("#idCheckText").addClass("on");
					$("#idCheckText").show()
					return;
				}else{
					$("#idCheckText").removeClass("on");
					$("#idCheckText").hide()
				}

			 // 비밀번호 체크
				strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
				strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
				Passwd = obj.memberPassword.value;

				if ( Passwd == "")
				{
				//alert("\n비밀번호를 입력해 주세요");
				obj.memberPassword.focus();
						$("#pwResult3").html("\n비밀번호를 입력해 주세요.");
						$("#pwResult3").addClass("on");
						$("#pwResult3").show();
				return;
				}else{
					$("#pwResult3").removeClass("on");
					$("#pwResult3").hide();
				}
				
				if (obj.memberPassword.value.length < 8 )
				{
				//alert("\비밀번호는 8자리 이상이어야 합니다.");
				obj.memberPassword.focus();
						$("#pwResult3").html("비밀번호는 8자리 이상이어야 합니다.");
						$("#pwResult3").addClass("on");
						$("#pwResult3").show();
				return;
				}else{
					$("#pwResult3").removeClass("on");
					$("#pwResult3").hide();
				}
				
				for (var n=0; n < Passwd.length; n++)
				{
					thisChar = Passwd.substring(n, n+1);
					if(thisChar==' ')
					{
						//alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
						obj.memberPassword.focus();
						$("#pwResult3").html("공백이 포함된 비밀번호는 사용할 수 없습니다.");
						$("#pwResult3").addClass("on");
						$("#pwResult3").show();
						return;
					}else{
						$("#pwResult3").removeClass("on");
						$("#pwResult3").hide();
					}
				}
			  
				var regexp = /^(?=.*[a-zA-Z]+)(?=.*[!`~@#$%^)(&*+_=-]+)(?=.*[0-9]+).{8,16}$/;
				
				if (!regexp.test(Passwd)){
					 //alert("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=- ");
						$("#pwResult3").html("비밀번호는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다. \n(8자~16자)\n허용되는 특수문자 !`~@#$%^)(&*+_=-");
						$("#pwResult3").addClass("on");
						$("#pwResult3").show();
					 return;
				}else{
					$("#pwResult3").removeClass("on");
					$("#pwResult3").hide();
				}
			}
			if (obj.email1.value == ""){
				//alert('\n생년월일을 선택해 주세요.');
				obj.email1.focus();
				$("#emailCheckText").html("Email을 입력해 주세요.");
				$("#emailCheckText").addClass("on");
				$("#emailCheckText").show();
				return;  		
			}else{
				$("#emailCheckText").removeClass("on");
				$("#emailCheckText").hide();
			}

			var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z\-]+/;

			if(exptext.test(obj.email1.value)==false) {
				$("#emailCheckText").html("이메일 양식이 올바르지 않습니다.");
				$("#emailCheckText").addClass("on");
				$("#emailCheckText").show();
		        obj.email1.focus();
				return;
			}else{
				$("#emailCheckText").removeClass("on");
				$("#emailCheckText").hide();
			}

			obj.joinMode.value = ""
		/*
			if(obj.MemberIsMaillinglist.checked == false || obj.MemberIsSMS.checked == false ){
				if (confirm("EMAIL 및 SMS 수신동의를 원치 않으실 경우 \n기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

				}else{
						//obj.MemberIsMaillinglist.focus();
						return false;
				}
			}
		*/

			if (is_setting == "Click") {
				alert("처리중입니다.\n\n잠시만 기다려 주세요");
			}     
			else
			{
				//myform.mtel1.disabled  = false ;
				jQuery("#loginButton").hide();
				jQuery("#loginButton2").show();
				//jQuery("#loginButton").html("<img src='/images/waiting.gif'>");
				obj.action="/member/member_result_simple_sns.asp";
				obj.method="post";
				obj.target="dataFrame";
				obj.submit();
			}
						
	} catch (error) {
	    $.ajax({
	        url: "/ext/javascript_catch.asp", // 오류 정보를 처리할 서버의 URL
	        type: "POST",
	        data: {
	            message: error.message,
	            stack: error.stack,
	            scriptVal: "sendform_simple_sns_off_2022"
	        },
	        success: function(response) {
	            console.log("Error logged successfully");
	        },
	        error: function(xhr, status, error) {
	            console.log("Error logging failed: ", error);
	        }
	    });
	}	
}
///2022-06-25 소켓통신본인인증
///2022-06-25 소켓통신본인인증
function confirmJoin(){
	var obj = document.myform;

	sleep(200);
	///초기화
	jQuery("#memberName").attr("readonly",false);
	jQuery("#birthYmn").attr("disabled",false);
	jQuery("#birthMmn").attr("disabled",false);
	jQuery("#birthDmn").attr("disabled",false);
	jQuery("#MemberGenderM").attr("disabled",false);
	jQuery("#MemberGenderW").attr("disabled",false);
	jQuery("#cellphone").attr("disabled",false);
	jQuery("#phone1").attr("readonly",false);
	jQuery("#phone2").attr("readonly",false);
	jQuery("#phone3").attr("readonly",false);
	jQuery("#Certall1").attr("disabled",false);
	jQuery("#Certagree1").attr("disabled",false);
	jQuery("#Certagree2").attr("disabled",false);
	jQuery("#Certagree3").attr("disabled",false);
	jQuery("#Certagree4").attr("disabled",false);

	jQuery("#responsedata").val("");
	jQuery("#requestdata").val("");


	
	//20230418 내국인일 경우 이름에 공백제거
	if (jQuery('#NationalInfo').val() == 0){
		jQuery('#memberName').val(jQuery('#memberName').val().replace(/ /g, '')); //모든 공백 없어짐.﻿ 
	}


	if(obj.memberName.value == ""){
		//alert('\n이름을 입력해주세요');
		obj.memberName.focus();
		$("#nameCheckText").html("이름을 입력해주세요");
		$("#nameCheckText").show()
		return;  		
	}else{
		$("#nameCheckText").hide();
	}

	if(obj.birthDay.value == ""){
		//alert('\n이름을 입력해주세요');
		obj.birthDay.focus();
		$("#bdayCheckText").html("생년월일을 입력해주세요");
		$("#bdayCheckText").show()
		return;  		
	}else{
		$("#bdayCheckText").hide();
	}

	if(obj.birthDay.value.length < 8){
		//alert('\n이름을 입력해주세요');
		obj.birthDay.focus();
		$("#bdayCheckText").html("생년월일을 8자리로 입력해주세요");
		$("#bdayCheckText").show()
		return;  		
	}else{
		$("#bdayCheckText").hide();
	}

	if($("#MemberGender option:selected").val() == ""){
		//alert('\n이름을 입력해주세요');
		obj.MemberGender.focus();
		$("#bdayCheckText").html("성별을 선택해주세요");
		$("#bdayCheckText").show()
		return;  		
	}else{
		$("#bdayCheckText").hide();
	}

	if(obj.phone1.value == ""){
		//alert('\n휴대폰 번호를 입력해 주세요.');
		obj.phone1.focus();
		$("#phoneCheckText").html("휴대폰 번호를 입력해 주세요.");
		$("#phoneCheckText").show()
		return;  		
	}else{
		$("#phoneCheckText").hide();
	}
	if(obj.phone2.value == ""){
		//alert('\n휴대폰 번호를 입력해 주세요.');
		obj.phone2.focus();
		$("#phoneCheckText").html("휴대폰 번호를 입력해 주세요.");
		$("#phoneCheckText").show()
		return;  		
	}else{
		$("#phoneCheckText").hide();
	}
	if (obj.Certall1.checked == false){
		//alert("본인 인증을 위한 약관에 동의해주세요.");
		obj.Certall1.focus();
		$("#certCheckText").html("본인 인증을 위한 약관에 동의해주세요.");
		$("#certCheckText").show()
		return;  		
	}else{
		$("#certCheckText").hide();
	}
	strQuery = jQuery(":input",document.myform).serialize();
	document.domain="fila.co.kr";
	jQuery.ajax({
		type: "POST",
		url: "https://web1.fila.co.kr/member/cert/join_socket.asp",
		data: strQuery + "&" + new Date().getTime(),
		contentType: "application/x-www-form-urlencoded; charset=EUC-KR",
		dataType : "JSON",
		success: function (data) {
			var rtnCode = data.rtnCode;
			var rtnMsg = unescape(data.rtnMsg);
			if (rtnCode == "OK"){
				jQuery("#memberName").attr("readonly",true);
				jQuery("#birthYmn").attr("disabled",true);
				jQuery("#birthMmn").attr("disabled",true);
				jQuery("#birthDmn").attr("disabled",true);
				jQuery("#MemberGenderM").attr("disabled",true);
				jQuery("#MemberGenderW").attr("disabled",true);
				jQuery("#cellphone").attr("disabled",true);
				jQuery("#phone1").attr("readonly",true);
				jQuery("#phone2").attr("readonly",true);
				jQuery("#phone3").attr("readonly",true);
				jQuery("#Certall1").attr("disabled",true);
				jQuery("#Certagree1").attr("disabled",true);
				jQuery("#Certagree2").attr("disabled",true);
				jQuery("#Certagree3").attr("disabled",true);
				jQuery("#Certagree4").attr("disabled",true);

				var responsedata = data.responsedata;
				var requestdata = data.requestdata;

				jQuery("#responsedata").val(responsedata);
				jQuery("#requestdata").val(requestdata);

				jQuery("#certAfter").show();
				countdown('countdown', 300);
				jQuery("#loginbtn").hide();
				jQuery("#loginbtn2").show()
				alert("인증번호를 발송했습니다. 입력해주세요.");
			}else{
				if (rtnCode == "moreJoin"){
					alert("이미 가입한 정보가 있습니다.");
				}else if (rtnCode == "moreC"){
					alert("해당 휴대폰과 다른 성명으로 가입된 정보가 이미 존재합니다. 고객센터에 문의해주세요.");
				}else if (rtnCode == "noInfo"){
					alert("입력하신 정보가 정확하지 않습니다. 다시 입력 후 진행해주세요.");
				}else{
					alert("시스템오류입니다. 잠시 후 이용해주세요.");
				}
				return false;
			}
		}
	})

}
///인증번호 입력
function confirmReturn(){
	var obj = document.myform;

	sleep(200);

	if(obj.sAuthNo.value == ""){
		alert('\n인증번호를 입력해주세요');
		obj.sAuthNo.focus();
		return;  		
	}

	jQuery("#memberName").attr("readonly",false);
	jQuery("#birthYmn").attr("disabled",false);
	jQuery("#birthMmn").attr("disabled",false);
	jQuery("#birthDmn").attr("disabled",false);
	jQuery("#MemberGenderM").attr("disabled",false);
	jQuery("#MemberGenderW").attr("disabled",false);
	jQuery("#cellphone").attr("disabled",false);
	jQuery("#phone1").attr("readonly",false);
	jQuery("#phone2").attr("readonly",false);
	jQuery("#phone3").attr("readonly",false);
	jQuery("#Certall1").attr("disabled",false);
	jQuery("#Certagree1").attr("disabled",false);
	jQuery("#Certagree2").attr("disabled",false);
	jQuery("#Certagree3").attr("disabled",false);
	jQuery("#Certagree4").attr("disabled",false);

	strQuery = jQuery(":input",document.myform).serialize();

	jQuery("#memberName").attr("readonly",true);
	jQuery("#birthYmn").attr("disabled",true);
	jQuery("#birthMmn").attr("disabled",true);
	jQuery("#birthDmn").attr("disabled",true);
	jQuery("#MemberGenderM").attr("disabled",true);
	jQuery("#MemberGenderW").attr("disabled",true);
	jQuery("#cellphone").attr("disabled",true);
	jQuery("#phone1").attr("readonly",true);
	jQuery("#phone2").attr("readonly",true);
	jQuery("#phone3").attr("readonly",true);
	jQuery("#Certall1").attr("disabled",true);
	jQuery("#Certagree1").attr("disabled",true);
	jQuery("#Certagree2").attr("disabled",true);
	jQuery("#Certagree3").attr("disabled",true);
	jQuery("#Certagree4").attr("disabled",true);
	document.domain="fila.co.kr";
	jQuery.ajax({
		type: "POST",
		url: "https://web1.fila.co.kr/member/return/socket_return.asp",
		data: strQuery + "&" + new Date().getTime(),
		contentType: "application/x-www-form-urlencoded; charset=EUC-KR",
		dataType : "JSON",
		success: function (data) {
			var rtnCode = data.rtnCode;
			if (rtnCode == "OK" || rtnCode == "OFF"){

				jQuery("#memberName").attr("readonly",false);

				jQuery("#MemberGenderM").attr("disabled",false);
				jQuery("#MemberGenderW").attr("disabled",false);


				var sName = data.sName;
				var birthY = data.birthY;
				var birthM = data.birthM;
				var birthD = data.birthD;

				var hpNo = data.hpNo;
				var cellphone = data.cellphone;

				var CI = data.CI;
				var DI = data.DI;

				var custNo = data.custNo;


				var MemberGender = data.MemberGender;
				if (MemberGender == "M"){
					var MemberGenderTxt = "남자";
				}else{
					var MemberGenderTxt = "여자";
				}

				var NationalInfo = data.NationalInfo;
				if (NationalInfo == 0){
					var NationalInfoTxt = "내국인";
				}else{
					var NationalInfoTxt = "외국인";
				}

				if (cellphone == 1){
					var cellphoneTxt = "SKT";
				}else if (cellphone == 2){
					var cellphoneTxt = "KT";
				}
				else if (cellphone == 3){
					var cellphoneTxt = "LGU+";
				}
				else if (cellphone == 5){
					var cellphoneTxt = "알뜰폰(SKT)";
				}
				else if (cellphone == 6){
					var cellphoneTxt = "알뜰폰(KT)";
				}
				else if (cellphone == 7){
					var cellphoneTxt = "알뜰폰(LGU+)";
				}else{
					var cellphoneTxt = "";
				}

				jQuery("#memberTel2").val(hpNo);

				jQuery("#join_cert").val("ok");

				jQuery("#birthY").val(birthY);
				jQuery("#birthM").val(birthM);
				jQuery("#birthD").val(birthD);

				jQuery("#CI").val(CI);
				jQuery("#DI").val(DI);
				jQuery("#custNo").val(custNo);

				jQuery("#memberName").hide();
				jQuery("#memberNameTxt").append(sName);
				jQuery("#bday").hide();
				jQuery("#bday3").hide();
				$(".gender").hide();
				jQuery("#bday4").hide();
				jQuery("#bday2").html(birthY + "년 " + birthM + "월 " + birthD + "일 (" + MemberGenderTxt + ", " + NationalInfoTxt + ")");
				jQuery("#bday2").show();
				jQuery("#hplist").hide();
				jQuery("#hplist2").html("(" + cellphoneTxt + ") " + hpNo);
				jQuery("#hplist2").show();
				jQuery("#certAfter").hide();
				jQuery(".hbox").empty();
				jQuery(".cbox").hide();
				jQuery(".hbox").addClass("btn-box");
				jQuery(".hbox").html('<a class="btn_sld__bk" >본인인증완료</a>');

				jQuery("._bf").hide();

				jQuery("#memberNametemp").val(sName);
				jQuery("#NationalTemp").append('<option>' + NationalInfoTxt + '</option>');
				jQuery("#genderTemp").append('<option>' + MemberGenderTxt + '</option>');
				jQuery("#cellphonetemp").append('<option>' + cellphoneTxt + '</option>');
				jQuery("#phone1temp").append('<option>' + jQuery("#phone1 option:selected").val() + '</option>');
				jQuery("#birthTemp").val(birthY+''+birthM+''+birthD);
				jQuery("#phone2temp").val(jQuery("#phone2").val());

				jQuery("._af").show();
				jQuery(".certView").show();

				if (rtnCode == "OFF"){
					idCheckPopup6();
					obj.joinMode.value="online";
				}	

			}else if (rtnCode == "moreJoin"){
				//alert("이미 가입한 정보가 있습니다.");
				$("#certCheckText").html("이미 가입한 정보가 있습니다.");
				$("#certCheckText").show();
				return;
			}else if (rtnCode == "moreC"){
				//alert("해당 휴대폰과 다른 성명으로 가입된 정보가 이미 존재합니다. 고객센터에 문의해주세요.");
				$("#certCheckText").html("해당 휴대폰과 다른 성명으로 가입된 정보가 이미 존재합니다. 고객센터에 문의해주세요.");
				$("#certCheckText").show();
				return;
			}else if (rtnCode == "moreRest"){
				if(confirm("고객님은 휴면고객이십니다.\n휴면상태를 해제하시겠습니까?")){
					/*
					var TempcustNo = data.TempcustNo;
					var TempName = data.TempName;
					var memberTel = data.memberTel;
					var joinGbn = data.joinGbn;
					var tempDI = data.tempDI;
					var tempCI = data.tempCI;

					document.restFrm.TempcustNo.value = TempcustNo;
					document.restFrm.TempName.value = TempName;
					document.restFrm.memberTel.value = memberTel;
					document.restFrm.joinGbn.value = joinGbn;
					document.restFrm.tempDI.value = tempDI;
					document.restFrm.tempCI.value = tempCI;
					*/
					//document.restFrm.submit()

					dataFrame.location.href = "/member/RestDI.asp"
				}else{
					location.href="/"
				}
				return;
			}else if (rtnCode == "moreRetire"){
				//alert("탈퇴 후 30일간 재가입이 불가능합니다.");
				$("#certCheckText").html("탈퇴 후 30일간 재가입이 불가능합니다.");
				$("#certCheckText").show();
				return;
			}else if (rtnCode == "moreError"){
				alert("시스템이 문제가 있습니다.\n고객센터에 문의해주세요.");
				return;
			}
		}
	})
}


jQuery(document).ready(function(){
	jQuery("#joinId").keyup(function(){
		//idcheckAjax();
	})
})
var idTime = "";
var idchk_temp = "no";
function idcheckAjax() {
	
	idchk_temp = "no";
	clearTimeout(idTime);
	if ( checkidpattern() && jQuery("#joinId").val().length >= 4 ){

		idTime = setTimeout(function(){
		
			jQuery.ajax({
				type: "POST",
				url: "joinIDCheck.asp",
				data:"memberid="+jQuery("#joinId").val(),
				async: false,
				beforeSend: function () {
				},
				success: function (data) {
					if (data == "ok")	{
						jQuery("#idCheckText").html("사용 가능한 아이디 입니다.");
						idchk_temp = "ok";
					}else{
						jQuery("#idCheckText").html("사용 하실 수 없는 아이디 입니다.");
						idchk_temp = "no";
					}
				}
			})
		
		}, 500);
	}else{
		idchk_temp = "no";
		jQuery("#idCheckText").html("사용 하실 수 없는 아이디 입니다.");
	}
	
}

function checkidpattern() {
	if (document.myform.memberId.value.length < 4) {
		return false;
	}

	var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
	var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var memberId = document.myform.memberId.value;

	if(strFirst.indexOf(memberId.substring(0,1))<0) {
		return false;
	}

	for(var n=0; n < memberId.length; n++) {
		thisChar = memberId.substring(n, n+1);
		if(thisChar==' ')	{
			return false;	
		}
	}

	for (i=0; i < memberId.length; i++) {
		if(strAll.indexOf(memberId.substring(i,i+1))<0)	{
			return false;
		}
	}
	return true;
}

function serchID_result(val1, val2){
		var layerText='<iframe name="inneriframe" width="450" height="320" id="inneriframe" src="/member/popup_searchid.asp?mb_id=' + val1 + '&md_name=' + val2 + '" style="width: 100%; height: 100%;border:0;" allowtransparency="true"></iframe>';
		layer.text(layerText,"searchid", {width:450, height:320, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
	}

function serachID(mode){
	if (mode == "tel")	{
		var obj = document.idTelForm;
		if (obj.membername1.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername1.focus();
			return false;
		}
		if (obj.mte1_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte1_1.focus();
			return false;
		}
		if (obj.mte2_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte2_1.focus();
			return false;
		}
		if (obj.mte3_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte3_1.focus();
			return false;
		}

		obj.action = "searchidpw_result.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();

	} else if (mode == "mail") {
		var obj = document.idMailForm;
		if (obj.membername2.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername2.focus();
			return false;
		}
		if (obj.email1_2.value == "" )  {
			alert("이메일을 입력해 주세요.");
			obj.email1_2.focus();
			return false;
		}
		if (obj.email2_2.value == "" )  {
			alert("이메일을 입력해 주세요.");
			obj.email2_2.focus();
			return false;
		}

		obj.action = "searchidpw_result.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();
	}else{
		return;
	}
}

function serachID2(mode){
	if (mode == "tel")	{
		var obj = document.idTelForm;
		if (obj.membername.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername.focus();
			return false;
		}
		if (obj.mte1_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte1_1.focus();
			return false;
		}
		if (obj.mte2_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte2_1.focus();
			return false;
		}
		/*
		if (obj.mte3_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte3_1.focus();
			return false;
		}
		*/
		jQuery("#loginbtn").hide();
		jQuery("#loginbtn2").hide()
		obj.action = "confirmSend.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();

	} else if (mode == "mail") {
		var obj = document.idMailForm;
		if (obj.membername2.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername2.focus();
			return false;
		}
		if (obj.email1_2.value == "" )  {
			alert("이메일을 입력해 주세요.");
			obj.email1_2.focus();
			return false;
		}
		if (obj.email2_2.value == "" )  {
			alert("이메일을 입력해 주세요.");
			obj.email2_2.focus();
			return false;
		}

		jQuery("#loginbtn").hide();
		jQuery("#loginbtn2").hide()
		obj.action = "searchidpw_result.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();
	}else{
		return;
	}
}

function searchIDmobile(){
		var obj = document.idTelForm;
		if (obj.membername.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername.focus();
			return false;
		}
		if (obj.mtel.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mtel.focus();
			return false;
		}

		jQuery("#loginbtn").hide();
		jQuery("#loginbtn2").show()
		obj.action = "/member/confirmSend.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();
}

function serchPW_result(val1, val2){
		var layerText='<iframe name="inneriframe" width="450" height="320" id="inneriframe" src="/member/popup_searchpw.asp?md_name=' + val1 + '&opt=' + val2 + '" style="width: 100%; height: 100%;border:0;" allowtransparency="true"></iframe>';
		layer.text(layerText,"searchid", {width:450, height:320, alignX:"50%", alignY:"50%", background:true, backgroundOpacity:0.8, backgroundColor:"#333"});	
	}

function serachPass(mode){
	if (mode == "tel")	{
		var obj = document.passTelForm;
		if (obj.memberid3.value == "" )  {
			alert("아이디를 입력해 주세요.");
			obj.memberid3.focus();
			return false;
		}
		if (obj.mte1_3.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte1_1.focus();
			return false;
		}
		if (obj.mte2_3.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte2_1.focus();
			return false;
		}
		if (obj.mte3_3.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte3_1.focus();
			return false;
		}
		jQuery("#loginbtn3").hide();
		jQuery("#loginbtn4").show();

		obj.action = "searchidpw_result.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();

	} else if (mode == "mail") {
		var obj = document.passMailForm;
		if (obj.memberid4.value == "" )  {
			alert("아이디를 입력해 주세요.");
			obj.memberid4.focus();
			return false;
		}
		if (obj.email1_4value == "" )  {
			alert("이메일을 입력해 주세요.");
			obj.email1_4.focus();
			return false;
		}
		if (obj.email2_4.value == "" )  {
			alert("이메일을 입력해 주세요.");
			obj.email2_4.focus();
			return false;
		}

		jQuery("#loginbtn3").hide();
		jQuery("#loginbtn4").show();
		obj.action = "searchidpw_result.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();
	
	}else{
		return;
	}
}

function serachPass2(){

		var obj = document.passTelForm;
		if (obj.memberid.value == "" )  {
			alert("아이디를 입력해 주세요.");
			obj.memberid.focus();
			return false;
		}
		if (obj.membername.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername.focus();
			return false;
		}
		if (obj.mte1_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte1_1.focus();
			return false;
		}
		if (obj.mte2_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte2_1.focus();
			return false;
		}
		if (obj.mte3_1.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mte3_1.focus();
			return false;
		}
		jQuery("#loginbtn3").hide();
		jQuery("#loginbtn4").show();
		obj.action = "confirmSend.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();


}

function serachPassmobile(){

		var obj = document.passTelForm;
		if (obj.memberid.value == "" )  {
			alert("아이디를 입력해 주세요.");
			obj.memberid.focus();
			return false;
		}
		if (obj.membername.value == "" )  {
			alert("이름을 입력해 주세요.");
			obj.membername.focus();
			return false;
		}
		if (obj.mtel.value == "" )  {
			alert("휴대폰 번호를 입력해 주세요.");
			obj.mtel.focus();
			return false;
		}
		jQuery("#loginbtn3").hide();
		jQuery("#loginbtn4").show();
		obj.action = "/member/confirmSend.asp";
		obj.method = "post";
		obj.target = "dataFrame";
		obj.submit();


}

function updateform_simple()  
{
	var obj = document.myform;

 // 비밀번호 체크
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var Passwd = obj.MemberPassword.value;


  if ( Passwd == "")
  {
    alert("\n비밀번호를 입력해 주세요");
    obj.MemberPassword.focus();
    return false;
  }
  
  if (obj.MemberPassword.value.length < 6 )
  {
    alert("\비밀번호는 6자리 이상이어야 합니다.");
    obj.MemberPassword.focus();
    return false;
  }

  for (var n=0; n < Passwd.length; n++)
    {
        thisChar = Passwd.substring(n, n+1);
        if(thisChar==' ')
        {
            alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
            obj.MemberPassword.focus();
            return false;
        }
  }
    
 for (i=0; i < Passwd.length; i++)
 {
        if(strAll.indexOf(Passwd.substring(i,i+1))<0)
        {
            alert("\n비밀번호에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
            obj.MemberPassword.focus();
            return false;
        }
  }
  
  // 비밀번호 확인
  var rePasswd = obj.MemberPassword2.value;
  if (Passwd != rePasswd)
  {
    alert("\n비밀번호가 일치 하지 않습니다.\n\n비밀번호를 재확인 해 주세요.");
    obj.MemberPassword2.focus();
    return false;
  }
	/*
	if (obj.ngpsKd[0].checked == false && obj.ngpsKd[1].checked == false)
	{
		alert("양력/음력 여부를 선택해주세요.");
		obj.ngpsKd[0].focus();
		return false;
	}
	if (obj.MemberGender[0].checked == false && obj.MemberGender[1].checked == false)
	{
		alert("성별을 선택해주세요.");
		obj.MemberGender[0].focus();
		return false;
	}
	*/

/*   
  if(obj.email1.value == "")
  {
  	alert('\n메일주소를 입력해주세요');
		obj.email.focus();
  	return;
  }
*/
  if(obj.birthY.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthY.focus();
		return;  		
	}
	if(obj.birthM.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthM.focus();
		return;  		
	}
	if(obj.birthD.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthD.focus();
		return;  		
	}

	if(obj.MemberIsMaillinglist.checked == false || obj.MemberIsSMS.checked == false ){
		if (confirm("EMAIL 및 SMS 수신동의를 원치 않으실 경우 \n기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

		}else{
				//obj.MemberIsMaillinglist.focus();
				return false;
		}
	}
//		if(obj.MemberIsSMS.checked == false){
//			if (confirm("SMS 수신동의를 원치 않으실 경우 \n구매 내역 및 기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{
//
//			}else{
//					obj.MemberIsSMS.focus();
//					return false;
//			}
//		}


	obj.action="update_result_simple.asp";
	//obj.action="/member/update_result.asp";
	obj.method="post";
	obj.target="dataFrame";
	obj.submit();
} 
///비밀번호 변경안함
function updateform_simple2()  
{
	var obj = document.myform;

	if (obj.userEmail.value == ""){
		//alert('\n생년월일을 선택해 주세요.');
		obj.userEmail.focus();
		$("#emailCheckText").html("Email을 입력해 주세요.");
		$("#emailCheckText").addClass("on");
		$("#emailCheckText").show();
		return;  		
	}else{
		$("#emailCheckText").removeClass("on");
		$("#emailCheckText").hide();
	}

	var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z\-]+/;

	if(exptext.test(obj.userEmail.value)==false) {
		$("#emailCheckText").html("Email이 올바르지 않습니다.");
		$("#emailCheckText").addClass("on");
		$("#emailCheckText").show();
        obj.userEmail.focus();
		return;
	}else{
		$("#emailCheckText").removeClass("on");
		$("#emailCheckText").hide();
	}


	if(obj.MemberIsMaillinglist.checked == false || obj.MemberIsSMS.checked == false ){
		if (confirm("EMAIL 및 SMS 수신동의를 원치 않으실 경우 \n기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

		}else{
				//obj.MemberIsMaillinglist.focus();
				return false;
		}
	}

	jQuery("#loginButton").hide();
	jQuery("#loginButton2").show();
	obj.action="/mypage/update_result.asp";
	obj.method="post";
	obj.target="dataFrame";
	obj.submit();
} 

function updateform_simple_m()  
{
	var obj = document.myform;
/*
	if(obj.email_m.value == "")
	{
		alert('\n메일주소를 입력해주세요');
		obj.email_m.focus();
		return;
	}
*/
 // 비밀번호 체크
    strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+";
    strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    Passwd = obj.memberPassword_m.value;

	if ( Passwd == "")
	{
	alert("\n비밀번호를 입력해 주세요");
	obj.memberPassword_m.focus();
	return;
	}
	
	if (obj.memberPassword_m.value.length < 6 )
	{
	alert("\비밀번호는 6자리 이상이어야 합니다.");
	obj.memberPassword_m.focus();
	return;
	}
	
	for (var n=0; n < Passwd.length; n++)
	{
		thisChar = Passwd.substring(n, n+1);
		if(thisChar==' ')
		{
			alert("\n공백이 포함된 비밀번호는 사용할 수 없습니다.") ;
			obj.memberPassword_m.focus();
			return;
		}
	}
	
	for (i=0; i < Passwd.length; i++)
	{
		if(strAll.indexOf(Passwd.substring(i,i+1))<0)
		{
			alert("\n비밀번호에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
			obj.memberPassword_m.focus();
			return;
		}
	}
	
	// 비밀번호 확인
	var rePasswd = obj.memberPassword2_m.value;
	if (Passwd != rePasswd)
	{
		alert("\n비밀번호가 일치 하지 않습니다.\n\n비밀번호를 재확인 해 주세요.");
		obj.memberPassword2_m.focus();
		return;
	}
	 /*
	if (obj.ngpsKd_m[0].checked == false && obj.ngpsKd_m[1].checked == false)
	{
		alert("양력/음력 여부를 선택해주세요.");
		obj.ngpsKd_m[0].focus();
		return false;
	}
	if (obj.MemberGender_m[0].checked == false && obj.MemberGender_m[1].checked == false)
	{
		alert("성별을 입력해주세요.");
		obj.MemberGender_m[0].focus();
		return false;
	}
	*/
	if(obj.birthY_m.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthY_m.focus();
		return;  		
	}
	if(obj.birthM_m.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthM_m.focus();
		return;  		
	}
	if(obj.birthD_m.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthD_m.focus();
		return;  		
	}
	
	obj.joinMode.value = "mobile"
	obj.email1.value = obj.email_m.value;
	obj.MemberPassword.value = obj.memberPassword_m.value;
	obj.birthY.value = obj.birthY_m.value;
	obj.birthM.value = obj.birthM_m.value;
	obj.birthD.value = obj.birthD_m.value;
	obj.zipcode1.value = obj.zipcode1_m.value;
	obj.address3.value = obj.address3_m.value;
	obj.address2.value = obj.address2_m.value;
	obj.Tel11.value = obj.Tel11_m.value;
	obj.Tel12.value = obj.Tel12_m.value;
	obj.Tel13.value = obj.Tel13_m.value;

	obj.ngpsKd[0].checked = obj.ngpsKd_m[0].checked
	obj.ngpsKd[1].checked = obj.ngpsKd_m[1].checked
	obj.MemberGender[0].checked = obj.MemberGender_m[0].checked
	obj.MemberGender[1].checked = obj.MemberGender_m[1].checked
	obj.MemberIsMaillinglist.checked = obj.MemberIsMaillinglist_m.checked
	obj.MemberIsSMS.checked = obj.MemberIsSMS_m.checked
	obj.MemberIsDm.checked = obj.MemberIsDm_m.checked
	obj.MemberIsTM.checked = obj.MemberIsTM_m.checked


	if(obj.MemberIsMaillinglist.checked == false || obj.MemberIsSMS.checked == false ){
		if (confirm("EMAIL 및 SMS 수신동의를 원치 않으실 경우 \n기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

		}else{
				//obj.MemberIsMaillinglist.focus();
				return false;
		}
	}
	jQuery("#loginButton_m").hide();
	jQuery("#loginButton2").show();
	obj.action="update_result_simple.asp";
	//obj.action="/member/update_result.asp";
	obj.method="post";
	obj.target="dataFrame";
	obj.submit();
} 

// <-- 회원가입 간소화 추가 함수

function updateform_simple_m2()  
{
	var obj = document.myform;
/*
	if(obj.email_m.value == "")
	{
		alert('\n메일주소를 입력해주세요');
		obj.email_m.focus();
		return;
	}
*/

	 /*
	if (obj.ngpsKd_m[0].checked == false && obj.ngpsKd_m[1].checked == false)
	{
		alert("양력/음력 여부를 선택해주세요.");
		obj.ngpsKd_m[0].focus();
		return false;
	}
	if (obj.MemberGender_m[0].checked == false && obj.MemberGender_m[1].checked == false)
	{
		alert("성별을 입력해주세요.");
		obj.MemberGender_m[0].focus();
		return false;
	}
	*/
	if(obj.birthY_m.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthY_m.focus();
		return;  		
	}
	if(obj.birthM_m.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthM_m.focus();
		return;  		
	}
	if(obj.birthD_m.value == ""){
		alert('\n생년월일을 선택해 주세요.');
		obj.birthD_m.focus();
		return;  		
	}
	
	obj.joinMode.value = "mobile"
	obj.email1.value = obj.email_m.value;
	obj.birthY.value = obj.birthY_m.value;
	obj.birthM.value = obj.birthM_m.value;
	obj.birthD.value = obj.birthD_m.value;
	obj.zipcode1.value = obj.zipcode1_m.value;
	obj.address3.value = obj.address3_m.value;
	obj.address2.value = obj.address2_m.value;
	obj.Tel11.value = obj.Tel11_m.value;
	obj.Tel12.value = obj.Tel12_m.value;
	obj.Tel13.value = obj.Tel13_m.value;

	obj.ngpsKd[0].checked = obj.ngpsKd_m[0].checked
	obj.ngpsKd[1].checked = obj.ngpsKd_m[1].checked
	obj.MemberGender[0].checked = obj.MemberGender_m[0].checked
	obj.MemberGender[1].checked = obj.MemberGender_m[1].checked
	obj.allcheck.checked = obj.allcheck_m.checked;
	obj.MemberIsMaillinglist.checked = obj.MemberIsMaillinglist_m.checked
	obj.MemberIsSMS.checked = obj.MemberIsSMS_m.checked
	obj.MemberIsDm.checked = obj.MemberIsDm_m.checked
	obj.MemberIsTM.checked = obj.MemberIsTM_m.checked



	if(obj.MemberIsMaillinglist.checked == false || obj.MemberIsSMS.checked == false ){
		if (confirm("EMAIL 및 SMS 수신동의를 원치 않으실 경우 \n기타 쿠폰, 행사 등의 안내를 받으실 수 없습니다."))	{

		}else{
				//obj.MemberIsMaillinglist.focus();
				return false;
		}
	}
	jQuery("#loginButton_m").hide();
	jQuery("#loginButton2").show();
	obj.action="update_result_simple2.asp";
	//obj.action="/member/update_result.asp";
	obj.method="post";
	obj.target="dataFrame";
	obj.submit();
} 

function passform(){
	var obj = document.myform;
	if(obj.memberPassword.value == "")
	{
		obj.memberPassword.focus();
		alert("암호를 입력해주세요");
		return false;
	}
	
	obj.submit();
}

function passform_m(){
	var obj = document.myform;
	obj.memberPassword.value = obj.memberPassword_m.value;
	if(obj.memberPassword.value == "")
	{
		obj.memberPassword.focus();
		alert("암호를 입력해주세요");
		return false;
	}
	
	obj.submit();
}
function agrees(){
	var obj = document.myform;
	var checkend = 0;
	if (obj.agree1.checked == true){
		checkend++;
	}
	if (obj.agree2.checked == true){
		checkend++;
	}
	if (obj.agree3.checked == true){
		checkend++;
	}

	if (checkend == 3){
		obj.all1.checked = true;
	}else{
		obj.all1.checked = false;
	}
}
function agreeAll(){
	var obj = document.myform;
	obj.agree1.checked = obj.all1.checked;
	obj.agree2.checked = obj.all1.checked;
	obj.agree3.checked = obj.all1.checked;
}
function reception(){
	var obj = document.myform;
	var checkend = 0;
	if (obj.MemberIsMaillinglist.checked == true){
		checkend++;
	}
	if (obj.MemberIsSMS.checked == true){
		checkend++;
	}
	/*
	if (obj.MemberIsDm.checked == true){
		checkend++;
	}
	if (obj.MemberIsTM.checked == true){
		checkend++;
	}
	*/
	if (checkend > 0){
		obj.agree4.checked = true;
	}else{
		obj.agree4.checked = false;
	}
}
function receptionAll(){
	var obj = document.myform;
	obj.MemberIsMaillinglist.checked = obj.agree4.checked;
	obj.MemberIsSMS.checked = obj.agree4.checked;
	/*
	obj.MemberIsDm.checked = obj.allcheck.checked;
	obj.MemberIsTM.checked = obj.allcheck.checked;
	*/
}

function receptionAll2(){
	var obj = document.myform;
	if(obj.allcheck.checked == false){
		obj.MemberIsMaillinglist.checked = obj.allcheck.checked;
		obj.MemberIsSMS.checked = obj.allcheck.checked;
		obj.MemberIsDm.checked = obj.allcheck.checked;
		obj.MemberIsTM.checked = obj.allcheck.checked;
	}
}

function receptionM(){
	var obj = document.myform;
	var checkend = 0;
	if (obj.MemberIsMaillinglist_m.checked == true){
		checkend++;
	}
	if (obj.MemberIsSMS_m.checked == true){
		checkend++;
	}
	if (obj.MemberIsDm_m.checked == true){
		checkend++;
	}
	if (obj.MemberIsTM_m.checked == true){
		checkend++;
	}
	if (checkend > 0){
		obj.allcheck_m.checked = true;
	}else{
		obj.allcheck_m.checked = false;
	}
}
function receptionAllM(){
	var obj = document.myform;
	obj.MemberIsMaillinglist_m.checked = obj.allcheck_m.checked;
	obj.MemberIsSMS_m.checked = obj.allcheck_m.checked;
	obj.MemberIsDm_m.checked = obj.allcheck_m.checked;
	obj.MemberIsTM_m.checked = obj.allcheck_m.checked;
}

function Certagrees(){
	var obj = document.myform;
	var checkend = 0;
	if (obj.Certagree1.checked == true){
		checkend++;
	}
	if (obj.Certagree2.checked == true){
		checkend++;
	}
	if (obj.Certagree3.checked == true){
		checkend++;
	}
	if (obj.Certagree4.checked == true){
		checkend++;
	}
	/*
	if (obj.Certagree5.checked == true){
		checkend++;
	}
	*/

	if (checkend == 4){
		obj.Certall1.checked = true;
	}else{
		obj.Certall1.checked = false;
	}
}
function CertagreeAll(){
	var obj = document.myform;
	obj.Certagree1.checked = obj.Certall1.checked;
	obj.Certagree2.checked = obj.Certall1.checked;
	obj.Certagree3.checked = obj.Certall1.checked;
	obj.Certagree4.checked = obj.Certall1.checked;
	//obj.Certagree5.checked = obj.Certall1.checked;
	if (!jQuery(".cbox").hasClass("on")){
		jQuery(".cbox").addClass("on");
	}
}

function categoryOp(){
	/*
	var obj = document.myform;
	var objNo = jQuery("#cellphone option:selected").val();
	if (objNo == "5"|| objNo == "6" || objNo == "7" ){
		obj.Certagree5.checked = obj.Certall1.checked;
		jQuery("#Certagree5").show();
	}else{
		obj.Certagree5.checked = true;
		jQuery("#Certagree5").hide();
	}
	*/
}

function agreeAll2022(){
	var obj = document.myform;
	obj.agree1.checked = obj.all1.checked;
	obj.agree2.checked = obj.all1.checked;
	//obj.agree3.checked = obj.all1.checked;
	obj.agree4.checked = obj.all1.checked;
	//obj.agree5.checked = obj.all1.checked;

	obj.MemberIsSMS.checked = obj.all1.checked;
	obj.MemberIsMaillinglist.checked = obj.all1.checked;
	/*
	obj.MemberIsTM.checked = obj.all1.checked;
	*/
	if (obj.all1.checked == true){
		jQuery(".join_terms .all").addClass("on");
	}else{
		//obj.email1.value = "";
		//obj.email2.value = "";
		//fn_reset('Children');
	}
}

function agrees2022(){
	var obj = document.myform;
	var checkend = 0;
	if (obj.agree1.checked == true){
		checkend++;
	}
	if (obj.agree2.checked == true){
		checkend++;
	}
	/*
	if (obj.agree3.checked == true){
		checkend++;
	}
	*/
	if (obj.agree4.checked == true){
		checkend++;
	}
	/*
	if (obj.agree5.checked == true){
		checkend++;
	}
	*/
	if (obj.MemberIsSMS.checked == true){
		checkend++;
	}
	if (obj.MemberIsMaillinglist.checked == true){
		checkend++;
	}
	/*
	if (obj.MemberIsTM.checked == true){
		checkend++;
	}
	*/
	if (checkend == 5){
		obj.all1.checked = true;
	}else{
		obj.all1.checked = false;
	}
}


function autoLg(obj){
	if(jQuery(obj).is(":checked")){
		alert("로그인 상태 유지을 사용하시면 다음부터 회원아이디와 패스워드를 입력하실 필요가 없습니다.\n\n공공장소에서는 개인정보가 유출될 수 있으니 사용을 자제하여 주십시오.");
	}else{
	}
}



function checkidN(){

   if (document.myform.memberId.value.length < 4) {
      //alert("\회원 ID는 4자리 이상이어야 합니다.");
		$("#idCheckText").html("회원 ID는 4자리 이상이어야 합니다.");
		$("#idCheckText").addClass("on");
		$("#idCheckText").removeClass("useid");
		$("#idCheckText").show();
      document.myform.memberId.focus();
      return;
   }else{
		$("#idCheckText").removeClass("on");
		$("#idCheckText").removeClass("useid");
		$("#idCheckText").hide();
   }
    var strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
    var strFirst = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var memberId = document.myform.memberId.value;
    
    if(strFirst.indexOf(memberId.substring(0,1))<0) {
      //alert("\nID 첫 글자는 영문자만 가능합니다.");
		$("#idCheckText").html("ID 첫 글자는 영문자만 가능합니다.");
		$("#idCheckText").addClass("on");
		$("#idCheckText").removeClass("useid");
		$("#idCheckText").show();
      document.myform.memberId.focus();
      return;
    }else{
		$("#idCheckText").removeClass("on");
		$("#idCheckText").removeClass("useid");
		$("#idCheckText").hide();
   }
    
    for(var n=0; n < memberId.length; n++) {
      thisChar = memberId.substring(n, n+1);
        if(thisChar==' ')
        {
            //alert("\n공백이 포함된 ID 는 조회할 수 없습니다.") ;
		$("#idCheckText").html("공백이 포함된 온라인 ID는 가입 불가합니다.");
		$("#idCheckText").addClass("on");
		$("#idCheckText").removeClass("useid");
		$("#idCheckText").show();
            document.myform.memberId.focus();
            return;
        }else{
		$("#idCheckText").removeClass("on");
		$("#idCheckText").removeClass("useid");
		$("#idCheckText").hide();
		}
    }
    
    for (i=0; i < memberId.length; i++) {
		if(strAll.indexOf(memberId.substring(i,i+1))<0)
		{
			// alert("\nID 에 허용할 수 없는 문자가 입력되었습니다\n\n다시 입력해 주십시요.");
			$("#idCheckText").html("영문, 숫자 조합 4글자 이상 입력해주세요. (첫글자는 영문 필수)");
			$("#idCheckText").addClass("on");
			$("#idCheckText").removeClass("useid");
			$("#idCheckText").show();
			document.myform.memberId.focus();
			return;
		}else{
			$("#idCheckText").removeClass("on");
			$("#idCheckText").hide();
		}
    }

	jQuery.ajax({
		type: 'GET',
		url: '/member/popup_idcheck.asp?mb_id=' + memberId ,
		dataType: 'json',
		success: function(data) {
			resultCD = data.result;
			if (resultCD == "S"){
				$("#idCheckText").html("사용 가능한 아이디 입니다.");
				$("#idCheckText").addClass("on");
				$("#idCheckText").addClass("useid");
				$("#idCheckText").show();
				document.myform.id_check.value = "ok";
			}else{
				$("#idCheckText").html("이미 사용중인 아이디입니다. 다른 아이디를 입력해주세요.");
				$("#idCheckText").addClass("on");
				$("#idCheckText").removeClass("useid");
				$("#idCheckText").show();
				document.myform.memberId.focus();
			}
		},
		error: function(e) {
//			console.log(e)
//			alert('e');
		}
	});
}

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

/*회원가입하기 - 매장가입 */
var idCheckPop5;
function idCheckPopup5() {
	var formStr = "";
	formStr +='	<div class="main_popup member-login__popup">';
	formStr +='			<div class="member__info">';				
	formStr +='				이미 매장 가입하신 FILA 멤버십 고객입니다.<br/>온라인 통합회원으로 전환하시겠습니까?';
	formStr +='			</div>';
	formStr +='		<div class="close_area close_style2">';
	formStr +='			<a href="/member/join_sns.asp" class="btn_close fl">통합회원 가입</a>';
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

/*회원가입하기 - 휴먼고객 */
var idCheckPop6;
function idCheckPopup6() {
	var formStr = "";
	formStr +='	<div class="main_popup member-login__popup">';
	formStr +='			<div class="member__info">';				
	formStr +='				이미 매장 가입하신 FILA 멤버십 고객입니다.<br/>온라인 통합회원으로 전환하시겠습니까?';
	formStr +='			</div>';
	formStr +='		<div class="close_area close_style2">';
	formStr +='			<a href="javascript:essential();void(0);" class="btn_close fl" id="closeBtn1">통합회원 가입</a>';
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
			backgroundOpacity : 0.7,
			closeButtonId : 'closeBtn1'
		});

}


function valchk(obj,n){
	if ($(obj).val().length < n){
		//alert('\n이름을 입력해주세요');
		$("#bdayCheckText").html("생년월일을 8자리로 입력해주세요");
		$("#bdayCheckText").show()
		return;  		
	}else{
		$("#bdayCheckText").hide();
	}
}

function essential(){
	document.myform.joinMode.value="online"
	$("#essentialTxt").html("필수정보");
}

function emailChk(){
	var obj = document.myform;
	var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z\-]+/;

	if(exptext.test(obj.email1.value)==false) {
		$("#emailCheckText").html("이메일 양식이 올바르지 않습니다.");
		$("#emailCheckText").addClass("on");
		$("#emailCheckText").show();
        obj.email1.focus();
		return;
	}else{
		$("#emailCheckText").removeClass("on");
		$("#emailCheckText").hide();
	}
}

window.onerror = function(message, source, lineno, colno, error) {
    console.log("Error message: " + message);
    console.log("Script URL: " + source);
    console.log("Line number: " + lineno);
    console.log("Column number: " + colno);
    console.log("Error object: " + error);

	var errMsg = "Error message: " + message + "|Script URL: " + source + "|Line number: " + lineno + "|Column number: " + colno + "|Error object: " + error;

    // 여기서 오류를 서버로 전송하거나 다른 방식으로 처리할 수 있습니다.
	$.ajax({
		type: 'GET',
		url: '/ext/errChk.asp',
		data: "errMsg=" + errMsg + "&nowUrl=" + location.href + "&" + new Date().getTime(),
		dataType: 'html',
		success: function(html) {


		},
		error: function(e) {

		}
	});
};