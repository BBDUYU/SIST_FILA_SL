<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

    <div class="content"> 
        <div class="page-header">
            <h1 class="page-title">신규 쿠폰 발행</h1>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/admin/create_coupon.htm" method="post">
                
                <%-- 1. 쿠폰 이름 --%>
                <div class="form-group">
                    <label for="name">쿠폰 명칭</label>
                    <input type="text" id="name" name="name" class="form-control" 
                           placeholder="예: 신규 회원 10% 할인 쿠폰" required>
                </div>

                <div class="row">
                    <%-- 2. 할인 유형 (AMOUNT / PERCENT) --%>
                    <div class="col">
                        <div class="form-group">
                            <label for="discount_type">할인 종류</label>
                            <select id="discount_type" name="discountType" class="form-control" onchange="toggleUnit()">
                                <option value="AMOUNT">정액 할인 (원)</option>
                                <option value="PERCENT">정율 할인 (%)</option>
                                <option value="DELIVERY">무료배송</option>
                            </select>
                        </div>
                    </div>
                    
                    <%-- 3. 할인 값 --%>
                    <div class="col">
                        <div class="form-group">
                            <label for="discount_value">할인 혜택</label>
                            <div class="input-wrapper">
                                <input type="number" id="discount_value" name="discountValue" class="form-control" 
                                       placeholder="0" required min="1">
                                <span id="unit-text" class="input-unit">원</span>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 4. 만료 날짜 (EXPIRES_AT) --%>
                <div class="form-group">
                    <label for="expires_at">쿠폰 만료일</label>
                    <input type="date" id="expires_at" name="expires_at" class="form-control" required>
                    <p style="font-size: 12px; color: #888; margin-top: 5px;">* 설정된 날짜가 지나면 쿠폰이 자동으로 무효화됩니다.</p>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-submit">쿠폰 등록하기</button>
                    <a href="${pageContext.request.contextPath}/admin/coupon_list.htm" class="btn btn-cancel">취소</a>
                </div>
            </form>
        </div>
    </div>
