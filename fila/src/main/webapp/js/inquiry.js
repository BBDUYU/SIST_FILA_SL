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
			inquiryList();
			// inquiryActivePaging();
			inpPlaceholder();
			inquiryWritePopup();
			inquiryItemSchPopup();
			reviewWrite();
		}
	};
	listener = {
		start : function(){
			ssq(window).bind("resize", listener.resizePage); listener.resizePage();
		},
		resizePage : function(e) {
			
		}
	};
	function inquiryList() {
		var list = ssq('.inquiry_list');
		var activeClass = 'is_open';
		list.on('click', '.inq_lst_top' , function(e) {
			e.preventDefault();
			var objThisP = ssq(this).parent();
			objThisP.siblings('.' + activeClass).removeClass(activeClass);
			objThisP.toggleClass(activeClass);
		});
	}
	// ※ 리뷰 리스트 로딩, 페이징 작업시 이부분 스크립트 꼭 넣어주세요!!
	// 상품평 페이징 클릭 작업과 비슷함, 페이징 클릭시 영역을 벗어나 보이는 부분 보완
	function inquiryActivePaging() {
		var hH = ssq('#headerNew').height();
		ssq('.product_inquiry').on('click', '.paging a', function(e){
			e.preventDefault();
			pAnchor = ssq('.product_inquiry').offset().top;
			jQuery('html, body').scrollTop(pAnchor - hH);
		});
	}
	function inpPlaceholder() {
		var writeForm = ssq('.inquiry_write_form');
		writeForm.on('focusout focusin', '.inp_placeholder > .inp', function(e){
			if(e.type === 'focusout') {
				ssq(this).next('.placeholder').show();
				if(ssq(this).val().length > 0){
					ssq(this).next('.placeholder').hide();			
				}
				else{
					ssq(this).next('.placeholder').show();
				}
			} 
			else if(e.type === 'focusin') {
				ssq(this).next('.placeholder').hide();
			}
		});
	}
	// 상품 문의 작성 팝업
	function inquiryWritePopup() {
		var btn = ssq('#btnInquiryWrite');
		var productNo = jQuery("#qpno").val();
		btn.on('click', function(e) {
			e.preventDefault();
			ssq.ajax({
				type: 'POST',
				url: '/product/pop_inquiry_write.asp?qpno=' + productNo,
				dataType: 'html',
				success: function(html) {
					layer.source(html, 'inquiryWritePop', {
						alignX : 0.5,
						alignY : 0.5,
						background : true, 
						backgroundColor : 'black',
						backgroundOpacity : 0.5,
						closeButtonId : 'closeBtn1'
					});
					var popup = ssq('#inquiryWritePop');
					popup.on('focusout focusin', '.inp_placeholder > .inp', function(e){
						if(e.type === 'focusout') {
							ssq(this).next('.placeholder').show();
							if(ssq(this).val().length > 0){
								ssq(this).next('.placeholder').hide();			
							}
							else{
								ssq(this).next('.placeholder').show();
							}
						} 
						else if(e.type === 'focusin') {
							ssq(this).next('.placeholder').hide();
						}
					});
				},
				error: function(e) {
					alert('e');
				}
			});
		});
	}
	// 일반문의 주문 조회 팝업
	function inquiryItemSchPopup() {
		// 2018-02-09 모바일
		var btn = ssq('#btnSchOrder');
		var btnM = ssq('#btnSchOrderMobile');
		btn.on('click', function(e) {
			e.preventDefault();
			ssq.ajax({
				type: 'POST',
				url: '/mypage/pop_inquiry_item_sch.asp',
				dataType: 'html',
				success: function(html) {
					layer.source(html, 'inquiryItemSchPop', {
						alignX : 0.5,
						alignY : 0.5,
						background : true, 
						backgroundColor : 'black',
						backgroundOpacity : 0.5,
						closeButtonId : 'closeBtn1'
					});
				},
				error: function(e) {
					alert('e');
				}
			});
		});
		btnM.on('click', function(e) {
			e.preventDefault();
			ssq.ajax({
				type: 'POST',
				url: '/mypage/pop_inquiry_item_sch_mobile.asp',
				dataType: 'html',
				success: function(html) {
					layer.source(html, 'inquiryItemSchPop', {
						alignX : 0.5,
						alignY : 0.5,
						background : true, 
						backgroundColor : 'black',
						backgroundOpacity : 0.5,
						closeButtonId : 'closeBtn1'
					});
					ssq('#inquiry_item_sch').on('change', '.inquiry_item input[name=itemCheck]', fn_selectOrderM);
				},
				error: function(e) {
					alert('e');
				}
			});
		});
	}
	function reviewWrite(){
				// 리뷰 별점
				jQuery(document).off("mouseover", "#popStarPoint i");
				jQuery(document).off("mouseout", "#popStarPoint i");
				jQuery(document).off("click", "#popStarPoint i");
				jQuery(document).off("click", "#starSubmit");

				var starPoint = 0;
				jQuery(document).on("mouseover", "#popStarPoint i", function(){

					starPoint = jQuery("#popStarPoint i[class=is_on]").length; // 이전 별점 저장
					setPointPosition(jQuery(this))
					jQuery("#qnaNo").val(jQuery(this).parent().attr("data-qno"));
					jQuery("#qnaStarPoint").val(starPoint);

				}).on("mouseout", "#popStarPoint i", function(){
					/*
					setPointPosition( jQuery("#popStarPoint i").eq( starPoint - 1 ) ); // 이전 별점으로 복귀
					jQuery("#qnaNo").val(jQuery(this).parent().attr("data-qno"));
					jQuery("#qnaStarPoint").val(starPoint);
					*/
				}).on("click", "#popStarPoint i", function(){
					//setPointPosition( jQuery("#popStarPoint i").eq( starPoint - 1 ) ); // 이전 별점으로 복귀
					setPointPosition(jQuery(this))
					starPoint = jQuery("#popStarPoint i[class=is_on]").length; // 클릭한 순번으로 별점 저장
					jQuery("#qnaNo").val(jQuery(this).parent().attr("data-qno"));
					jQuery("#qnaStarPoint").val(starPoint);
				}).on("click","#starSubmit", function(){
					starPoint = $("input[name='reviewStar']:checked").val();
					jQuery("#qnaNo").val(jQuery(this).attr("data-qno"));
					jQuery("#qnaStarPoint").val(starPoint);
					document.QnaStar.target = "dataFrame";
					document.QnaStar.action = "/mypage/inquiry_star.asp";
					document.QnaStar.submit();
				});
				function setPointPosition(obj){
					obj.prevAll().addClass("is_on"); // 선택위치 이전 클래스 부여
					obj.addClass("is_on"); // 선택위치 클래스 부여
					obj.nextAll().removeClass("is_on"); // 선택위치 이후 클래스 삭제
				}
	}
})(jQuery);

jQuery(function() {
	// 주문 기간 탭
	jQuery(document).on("click", "#inquiry_item_date_sch a", function(){
		jQuery("#inquiry_item_date_sch a").removeClass("curr");
		var obj = jQuery(this);
		obj.addClass("curr");

		jQuery("#inquiry_item_sch li").hide();
		jQuery("#inquiry_item_sch li[data-date=" + obj.attr("data-month") + "]").show();
		jQuery("#inquiry_item_sch li:lt(" + jQuery("#inquiry_item_sch li[data-date=" + obj.attr("data-month") + "]:first").index() + ")").show();

		
		//탭 눌러서 없을시
		if ( jQuery("#inquiry_item_sch li:visible").length < 1 ) {
			jQuery("#inquiry_item_sch").html('<li class="no_contents"><p>검색된 주문이 없습니다.</p></li>');
		}

		
	})
	//선택한 주문 삭제, 초기화
	jQuery(document).on("click", "#orderItemDel", function(){
		jQuery("#orderNo").val( '' );
		jQuery("#orderProductNo").val( '' );
		jQuery("#productNo2").val( '' );

		jQuery("#selectAfter").html( '' );
		jQuery("#selectAfter").hide();
		jQuery("#selectBefore").show();
	})
	//이메일 선택
	jQuery(document).on("change", "#memberEmail3", function(){
		jQuery("#memberEmail2").val( jQuery(this).val() );
		jQuery("#memberEmail3").blur();
	})
	//파일 선택
	jQuery(document).on("change", "#qnaFile", function(){
		try	{
			var data = jQuery(this).val();
			// 파일 용량 체크
			var FileSize = this.files[0].size;
			var maxFileSize = 10 * 1024 * 1024;
			if ( FileSize > maxFileSize )	{ alert("사진 용량은 10MB 이하여야 합니다."); resetFileHTML( "#file_input" ); return; }
			// 확장자 체크
			var ext = data.split('.').pop().toLowerCase();
			if ( jQuery.inArray( ext, ["bmp", "gif", "png", "jpg", "jpeg"] ) == -1 ) { alert("BMP, PNG, GIF, JPG 파일만 업로드 할 수 있습니다."); resetFileHTML( "#file_input" ); return; }

			var obj = document.inquiry_Form;
			obj.target = "qnaImgFrame";
			obj.method = "post";
			obj.action = "/mypage/inquiry_image.asp";
			obj.submit();	
		} catch (e) {
			resetFileHTML( "#file_input" ); return;
		}
	})
	//첨부한 파일 삭제
	jQuery(document).on("click", "#file_photo .btn_remove", function(){
		jQuery(this).parent().remove();
	})
	//문의 유형 선택
	/*
	jQuery(document).on("change", "#category", function(){
		jQuery("#category2").html( '<option value="" data-parent="">문의유형 선택</option>	' );
		
		var parentNo = jQuery("#category").val();
		if ( parentNo != "" ) {
			var tempHTML = jQuery("#category2_temp option[data-parent=" + parentNo + "]").clone();
			jQuery("#category2").append( tempHTML );
			jQuery("#category2 option[data-parent=" + parentNo + "]").length > 0 ? jQuery("#category2").prop("disabled", false) : jQuery("#category2").prop("disabled", true) ;
		} else {
			jQuery("#category2").prop("disabled", true);
			jQuery("#category2").html( '<option value="" data-parent="">문의유형 선택</option>	' );
		}

		jQuery("#category2").focus();
	})
	jQuery(document).on("change", "#category2", function(){
		//jQuery("button[id^=btnSchOrder]").focus();
		jQuery("#category2").blur();
	})
	*/
})
// 파일 업로드 후 미리보기
function setImageSrc( val ) {
	if (val != "" ) {
		if ( jQuery("#file_photo li").length < 3  ) {
			var fileHTML = "";
			fileHTML += '<li>';
			fileHTML += '	<img src="/data/qna/temp/' + val + '" alt="" class="autofit"><input type="hidden" name="boardImage" id="boardImage" value="' + val + '">';
			fileHTML += '	<a href="javascript:;" class="btn_remove">첨부파일삭제</a>';
			fileHTML += '</li>';
			
			jQuery("#file_photo").append(fileHTML);
			resetFileHTML( "#file_input" );
		} else {
			alert("파일은 최대 3개 등록 가능 합니다.");
			resetFileHTML( "#file_input" );
			return;
		}
	} else {
		alert("다시 시도해 주세요.");
		resetFileHTML( "#file_input" );
		return;
	}
}
// 파일 인풋 리셋
function resetFileHTML( obj ) {
	if ( obj != "" ) {
		var fileHTML = '<input type="file" name="qnaFile" id="qnaFile">';
		jQuery(obj).html('');
		jQuery(obj).html(fileHTML);
	}
}
//주문 선택
function fn_selectOrder(obj){
	// var obj = jQuery(".inquiry_item_box .check input[name=itemCheck]:checked");
	if ( obj.length < 1 ) {
		alert("주문번호를 선택해 주세요.");
		return;
	} else { 
		jQuery("#orderNo").val( obj.attr("data-OrderNo") );
		jQuery("#orderProductNo").val( obj.attr("data-OrderProductNo") );
		jQuery("#productNo2").val( obj.attr("data-ProductNo") );

		insertHTML = selectAfterHTML;
		insertHTML = insertHTML.replace("<@@date@@>", obj.val().split("^")[0] );
		insertHTML = insertHTML.replace("<@@no@@>", obj.val().split("^")[1] );
		insertHTML = insertHTML.replace("<@@style@@>", obj.val().split("^")[2] );
		insertHTML = insertHTML.replace("<@@color@@>", obj.val().split("^")[3] );
		insertHTML = insertHTML.replace("<@@brand@@>", obj.val().split("^")[4] );
		insertHTML = insertHTML.replace("<@@name@@>", obj.val().split("^")[5] );
		insertHTML = insertHTML.replace("<@@name2@@>", obj.val().split("^")[5] );
		insertHTML = insertHTML.replace("<@@code@@>", obj.val().split("^")[6] );
		insertHTML = insertHTML.replace("<@@size@@>", obj.val().split("^")[7] );
		insertHTML = insertHTML.replace("<@@price@@>", obj.val().split("^")[8] );

//		jQuery("#selectBefore").hide();
//		jQuery("#selectAfter").html(insertHTML);
//		jQuery("#selectAfter").show();
		jQuery("#selectBefore").empty().html(insertHTML);

		//layer.closeAll();
		$('.common__layer._order_search').remove();
					$('body').removeClass('lyr-order-search--open');
					$('.basic__layer._order_search').remove();
	}
}
function fn_selectOrderP() {
	var obj = jQuery(".inquiry_item_box .check input[name=itemCheck]:checked");
	fn_selectOrder(obj);
}
function fn_selectOrderM() {
	var obj = jQuery(".inquiry_item input[name=itemCheck]:checked");
	fn_selectOrder(obj);
}
//글쓰기
function fn_send() {
	var obj = document.inquiry_Form;

	if ( obj.privacy1[0].checked == false && obj.privacy1[1].checked == false ) {
		alert("개인정보 수집 동의여부를 체크해주세요.");
		obj.privacy1[0].focus();
		return;
	}

	if ( obj.privacy1.value != "1" ) { 
		alert("개인정보 수집에 동의하셔야 문의가 가능합니다.");
		obj.privacy1[0].focus();
		return;
	}


	if ( obj.category.value == "" ) {
		alert("문의 유형을 선택해 주세요.");
		obj.category.focus();
		return;
	}
	/*
	if ( !jQuery("#category2").prop("disabled") ) {
		if ( obj.category2.value == "" ) {
			alert("문의 유형을 선택해 주세요.");
			obj.category2.focus();
			return;
		}
	}
	*/
	if ( obj.orderNo.value == "" && !jQuery("#noItemCheck").prop("checked") ) {
		alert("주문상품을 선택 해주세요.");
		jQuery("#btnSchOrder").focus();
		return;
	}
	if ( obj.boardTitle.value == "" ) {
		alert("문의 제목을 입력해 주세요.");
		obj.boardTitle.focus();
		return;
	}
	if ( obj.boardContents.value == "" ) {
		alert("문의 내용을 입력해 주세요.");
		obj.boardContents.focus();
		return;
	}
	if ( obj.memberEmail1.value == "" ) {
		alert("이메일을 입력해 주세요.");
		obj.memberEmail1.focus();
		return;
	}

	var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;

	if(exptext.test(obj.memberEmail1.value)==false) {
		alert("이메일 형식에 맞혀 입력해주세요.");
		obj.memberEmail1.focus();
		return
	}
	jQuery("#writeButton").hide();
	jQuery("#writeButton2").show();

	obj.method = "post";
	obj.target = "dataFrame";
	obj.action = "/mypage/qna_result2.asp";
	obj.submit();
}

function fn_send2() {
	var obj = document.inquiry_Form;

	if ( obj.privacy1[0].checked == false ) {
		alert("개인정보 수집에 동의해주셔야 등록가능합니다.");
		obj.privacy1[0].focus();
		return;
	}

	if ( obj.category.value == "" ) {
		alert("문의 유형을 선택해 주세요.");
		obj.category.focus();
		return;
	}
	if ( !jQuery("#category2").prop("disabled") ) {
		if ( obj.category2.value == "" ) {
			alert("문의 유형을 선택해 주세요.");
			obj.category2.focus();
			return;
		}
	}
	if ( obj.orderNo.value == "" && !jQuery("#noItemCheck").prop("checked") ) {
		alert("주문상품을 선택 해주세요.");
		jQuery("#btnSchOrder").focus();
		return;
	}
	if ( obj.boardTitle.value == "" ) {
		alert("문의 제목을 입력해 주세요.");
		obj.boardTitle.focus();
		return;
	}
	if ( obj.boardContents.value == "" ) {
		alert("문의 내용을 입력해 주세요.");
		obj.boardContents.focus();
		return;
	}
	if ( obj.memberEmail1.value == "" ) {
		alert("이메일을 입력해 주세요.");
		obj.memberEmail1.focus();
		return;
	}
	if ( obj.memberEmail2.value == "" ) {
		alert("이메일을 입력해 주세요.");
		obj.memberEmail2.focus();
		return;
	}
	jQuery("#writeButton").hide();
	jQuery("#writeButton2").show();

	obj.method = "post";
	obj.target = "dataFrame";
	obj.action = "/mypage/qna_result2.asp";
	obj.submit();
}

function fn_productSend() {
	var obj = document.inquiry_Form;

	if ( obj.privacy1[0].checked == false ) {
		alert("개인정보 수집에 동의해주셔야 등록가능합니다.");
		obj.privacy1[0].focus();
		return;
	}

	if ( jQuery(".category2 option:selected").val() == "" ) {
		alert("문의 유형을 선택해 주세요.");
		//obj.category2.focus();
		return;
	}
	if ( obj.boardTitle.value == "" ) {
		alert("문의 제목을 입력해 주세요.");
		obj.boardTitle.focus();
		return;
	}
	if ( obj.boardContents.value == "" ) {
		alert("문의 내용을 입력해 주세요.");
		obj.boardContents.focus();
		return;
	}
	if ( obj.memberEmail1.value == "" ) {
		alert("이메일을 입력해 주세요.");
		obj.memberEmail1.focus();
		return;
	}


	jQuery("#writeButton").hide();
	jQuery("#writeButton2").show();

	obj.target = "dataFrame";
	obj.method = "post";
	obj.action = "/mypage/qna_result2.asp";
	obj.submit();
}

function qnaList(page) {
	page = page != "" ? page : 1 ;
	jQuery("#pageVal2").val(page);

	var mobileCHK = jQuery("#mchk").val();
	
	var pageSize = 10;
	var blockSize = 5;
	jQuery("#pageSizeVal2").val(pageSize);

	jQuery.ajax({
		url : "/product/qna/qnaList_json.asp",
		method : "post",
		data :  jQuery("#qoptForm").serialize(),
		success : function(data){
			result = eval(data);

			if (result.length > 0 ) {
				var pageCount = result[0].pageCount;
			} else {
				var pageCount = 0;
			}
			var obj, resultHTML = "";

			for ( var i = 0 ; i < result.length ; i++ )	{
				obj = result[i];

				var totalCount = Number(obj.recordCount);
				var nPage = Number(obj.page);
				
				if ( obj.astatus == "0" )	{ //답변여부 체크 
					var answerText = "대기"
					var addClass = ""
				} else {
					var answerText = "답변완료"
					var addClass = "complete"
				}
				if ( mobileCHK == "1" ) { // 모바일
					resultHTML += '<li>';
					resultHTML += '	<div class="inq_lst_top ' + addClass + '">';
					resultHTML += '		<a href="javascript:;">';
					resultHTML += '			<div class="info"><span class="state">' + answerText + '</span><span class="type">' + unescape(obj.cate) + '</span><span class="date">' + obj.regd + '</span></div>';
					resultHTML += '			<p class="title">' + unescape(obj.qtitle) + '</p>';
					resultHTML += '		</a>';
					resultHTML += '	</div>';
					resultHTML += '	<div class="inq_lst_cont">';
					resultHTML += '		<div class="inq_lst_cont_txt">';
					resultHTML += '			<div class="inq_lst_cont_q"><strong class="title">질문</strong><p>' + unescape(obj.qcont) + '</p></div>';
					if ( obj.astatus == "1" )	{
						resultHTML += '			<div class="inq_lst_cont_a"><strong class="title">답변 <span class="date">' + obj.adate + '</span></strong><p>' + unescape(obj.acont) + '</p></div>';
					}
					resultHTML += '		</div>';
					resultHTML += '	</div>';
					resultHTML += '</li>';
				} else { // PC
					/*
					resultHTML += '<li>';
					resultHTML += '	<div class="inq_lst_top ' + addClass + '">';
					resultHTML += '		<a href="javascript:;">';
					resultHTML += '			<span class="state">' + answerText + '</span><span class="type">' + unescape(obj.cate) + '</span><span class="title">' + unescape(obj.qtitle) + '</span><span class="name">' + unescape(obj.uid) + '</span><span class="date">' + obj.regd + '</span>';
					resultHTML += '		</a>';
					resultHTML += '	</div>';
					resultHTML += '	<div class="inq_lst_cont">';
					resultHTML += '		<div class="inq_lst_cont_txt">';
					resultHTML += '			<div class="inq_lst_cont_q_txt"><strong class="title">질문</strong><p>' + unescape(obj.qcont) + '</p></div>';
					if ( obj.astatus == "1" )	{
						resultHTML += '			<div class="inq_lst_cont_a"><p class="date">' + obj.adate + '</p><div class="txt"><strong class="title">답변</strong><p>' + unescape(obj.acont) + '</p></div></div>';
					}
					resultHTML += '		</div>';
					resultHTML += '	</div>';
					resultHTML += '</li>	';		
					*/

					resultHTML += '<li>';

					resultHTML += '	<div class="qna-q">';
					resultHTML += '		<div class="info">';
					resultHTML += '			<div>';
					resultHTML += '				<p class="status">' + answerText + '</p>';
					resultHTML += '				<p class="category">' + unescape(obj.cate) + '</p>';
					resultHTML += '			</div>';

					resultHTML += '			<p class="date">' + obj.regd + '</p>';
					resultHTML += '		</div>';

					resultHTML += '		<div class="qna-tit">';
					resultHTML += '		<p>' + unescape(obj.qcont) + '</p></div>';
					resultHTML += '	</div>';

					
					resultHTML += '	<div class="qna-a">';
					resultHTML += '		<div class="q-txt-box">';
					resultHTML += '			<div>';
					resultHTML += '				<p>' + unescape(obj.qcont) + '</p>';
					resultHTML += '			</div>';
					resultHTML += '		</div>';
					if ( obj.astatus == "1" )	{
					resultHTML += '		<div class="a-txt-box">';
					resultHTML += '			<div>';
					resultHTML += '				<p>';
					resultHTML += '					' + unescape(obj.acont) + '<br />';

					resultHTML += '				</p>';
					resultHTML += '			</div>';

					resultHTML += '			<p class="date">' + obj.adate + '</p>';
					resultHTML += '		</div>';
/*
					resultHTML += '		<div class="a-point-box">';
					resultHTML += '			<p>';
					resultHTML += '				답변 내용에 만족하셨나요? ';
					resultHTML += '				별점으로 평가해주세요.';
					resultHTML += '			</p>';

					resultHTML += '			<div class="star-inp-box">';
					resultHTML += '				<input type="radio" id="reviewStar01" name="reviewStars">';
					resultHTML += '				<label for="reviewStar01"></label>';

					resultHTML += '				<input type="radio" id="reviewStar02" name="reviewStars">';
					resultHTML += '				<label for="reviewStar02"></label>';

					resultHTML += '				<input type="radio" id="reviewStar03" name="reviewStars">';
					resultHTML += '				<label for="reviewStar03"></label>';

					resultHTML += '				<input type="radio" id="reviewStar04" name="reviewStars">';
					resultHTML += '				<label for="reviewStar04"></label>';

					resultHTML += '				<input type="radio" id="reviewStar05" name="reviewStars">';
					resultHTML += '				<label for="reviewStar05"></label>';

					resultHTML += '				<div class="bg">';
					resultHTML += '					<div></div>';
					resultHTML += '					<div></div>';
					resultHTML += '					<div></div>';
					resultHTML += '					<div></div>';
					resultHTML += '					<div></div>';
					resultHTML += '				</div>';
					resultHTML += '			</div>';

					resultHTML += '			<button type="button">제출하기</button>';
*/
					resultHTML += '		</div>';
					resultHTML += '	</div>';
					}
					resultHTML += '</li>';



				}
			}
			if ( mobileCHK == "1" ) { // 모바일
				if ( page == 1 )	{
					jQuery("#inquiry_list").html(resultHTML);
				} else {
					jQuery("#inquiry_list").append(resultHTML);
				}
				
				var pageHtml = "";
				if (resultHTML != "") {
					console.log( pageCount + " / " + page ) ; 
					if ( pageCount == page  )	{
						if ( page > 1 ) {
							pageHtml = '<p>마지막 Q&amp;A입니다.</p>'
						} else { 
							pageHtml = '<p></p>'
						}
					} else {
						pageHtml = '<a href="javascript:qnaList(' + ( page+1 ) + ')" id="btnQnaMore">더보기 <span>(' + ( page * pageSize ) + '/' + totalCount + ')</span></a>'
					}
					jQuery("#inquiryPaging").html(pageHtml);
				}
			}else {
				jQuery("#inquiry_list").html(resultHTML);
							$('.qna__list li .qna-q').on('click', function(){
								var tBox = $(this).parent('li').find('.qna-a');

								if(tBox.css('display') == 'none'){
									$('.qna__list li').removeClass('open');
									$(this).parent('li').addClass('open');
								}else{
									$('.qna__list li').removeClass('open');
								}
							});
				//페이징
				var pageHtml = "";
				if (resultHTML != "") {
					
					var pageCount = Math.floor( ( totalCount - 1 ) / pageSize ) + 1;
					var blockStart = 1;
					var blockEnd = pageCount;
				
					if ( pageCount > blockSize ) {
						blockStart = nPage - Math.round( ( blockSize / 2 ) - 0.1 );
						blockEnd = nPage + Math.round( ( blockSize / 2 ) - 0.1 );
						if ( blockStart < 1  ) { blockStart = 1; blockEnd = nPage + ( blockSize - 1 ); }
						if ( ( blockEnd - blockStart ) > ( blockSize - 1 ) ) { blockEnd = blockEnd - ( blockEnd - blockStart - blockSize + 1 ); }
						if ( blockEnd > pageCount ) { blockEnd = pageCount; blockStart = blockEnd - ( blockSize - 1 ); }
					} 
					if ( nPage > 1 ) { pageHtml += '<a href="javascript:qnaList(' + ( nPage - 1 ) + ');void(0);" class="prev on"></a>'; }
					
					pageHtml += '<div class="num">';
					for ( i = blockStart; i <= blockEnd; i++ ) {
						if ( i == nPage ) { pageHtml += '<a class="on">' + i + '</a>'; }
						else{ pageHtml += '<a href="javascript:qnaList(' + ( i ) + ');void(0);">' + i + '</a>'; }
					}
					pageHtml += '</div>';

					if ( nPage < pageCount ) { pageHtml += '<a href="javascript:qnaList(' + ( nPage + 1 ) + ');void(0);" class="next on"></a>'; }

					if ( pageCount <= 0 ) { pageHtml = ""; 	}
				} else {
					jQuery("#inquiry_list").html('<li class="no_contents"><p>작성된 상품 문의글이 없습니다.</p></li>');
				}
				jQuery("#inquiryPaging").html(pageHtml);

				var pAnchor = (jQuery('#detailTab').length != 0) ? jQuery('#detailTab').offset().top : 0;
				// console.log(pAnchor);
				 jQuery('#inquiryPaging').children('a').on('click', function(){
					var hH = jQuery('#headerNew').height();
					pAnchor = (jQuery('#inquiry_list').length != 0) ? jQuery('#inquiry_list').offset().top : pAnchor;
					jQuery('html, body').scrollTop(pAnchor - hH);
					// console.log(pAnchor);
				});
			}
		} //success : function(data){
	}) //jQuery.ajax({
}
var qnaReady = 0;
jQuery(function(){
	// 답변 여부 선택
	jQuery("#qAnswerList li a").click(function(){
		var obj = jQuery(this);
		jQuery("#answerVal2").val( obj.attr("data-val") );
		jQuery("#qAnswerList li a").removeClass("curr"); obj.addClass("curr");
		qnaList(1);
	})
	//분류 선택
	jQuery("#qCategoryList li a").click(function(){
		var obj = jQuery(this);
		jQuery("#cateVal2").val( obj.attr("data-val") );
		jQuery("#qCategoryList li a").removeClass("curr"); obj.addClass("curr");
		qnaList(1);
	})
	// 내문의글 선택
	jQuery("#myQna").change(function(){
		jQuery(this).prop("checked") ? jQuery("#myVal").val("1") : jQuery("#myVal").val("0") ;
		qnaList(1);
	})
	jQuery("#myQna2").change(function(){
		jQuery(this).prop("checked", false) ;
		alert("로그인 후 확인 가능 합니다.");
	})
	jQuery(".qna-more__btn").click(function(){
		if ( qnaReady == 0 ) {
			qnaList(1);
			qnaReady = 1;
		}
	})
})
