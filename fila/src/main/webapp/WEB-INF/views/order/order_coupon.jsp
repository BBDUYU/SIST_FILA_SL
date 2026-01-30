<%@ page contentType="text/html; charset=UTF-8" %>
<div class="common__layer _coupon">
	<div class="layer-bg__wrap"></div>
	
	<div class="inner2">
		<div class="head">
			<p class="tit">쿠폰 혜택 정보</p>
			<button type="button" class="close__btn">close</button>
		</div>

		<div class="con">

<form name="ucoupon" method="post" action=""> 
<input type="hidden" name="cartNo" value="12709912">
<input type="hidden" name="pageNo" value="">		
			<div class="coupon-select-box">
				<div class="hd">
					<p class="tit">할인 쿠폰 선택</p>
					<p class="txt">사용 가능한 쿠폰만 보여집니다.</p>
				</div>

				<div class="cn">
					<ul>
			
						<li>
							<input type="radio" id="cpRd99" name="popupCoupon3" class="rd__style1" value="" checked="">
							<label for="cpRd99"></label>

							<div>
								<p class="txt1">선택가능한 쿠폰이 없습니다.</p>
							</div>
						</li>
	
					</ul>
				</div>
			</div>


			<div class="coupon-code-box">
				<div class="hd">
					<p class="tit">쿠폰 등록</p>
				</div>

				<div class="cn">
				    <input type="text" placeholder="쿠폰 번호입력" id="coupon_serial_input"> <button type="button" id="offlineBtn">등록</button>
				</div>
			</div>
			</form>

		</div>

		<div class="foot">
			<button type="button" class="btn_txt__gr cancel__btn">취소</button>
			<button type="button" id="cpnBtn" class="btn_txt__wt" onclick="useCouponLayer();">쿠폰 적용하기</button>
		</div>
	</div>
</div>