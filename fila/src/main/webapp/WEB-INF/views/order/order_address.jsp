<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="common__layer _addr_list sch-idpw">
	<div class="layer-bg__wrap"></div>

	<div class="inner">
		<div class="head">
			<p class="tit">배송지 관리</p>
			<button type="button" class="close__btn">close</button>
		</div>

		<div class="con">
    <div class="addr-list-box">
        <ul class="addr__list">
            <%-- 1. 먼저 데이터가 있는지 확인 --%>
            <c:choose>
                <c:when test="${not empty addressList}">
                    <%-- 2. 데이터가 있을 때만 inside에서 반복문 실행 --%>
                    <c:forEach var="addr" items="${addressList}">
                        <li>
                        
                            <label class="addr-info" style="display:flex; align-items: center; padding: 10px 0;">
                                <input type="radio" name="addr_select" value="${addr.addressId}" 
                                       data-name="${addr.recipientName}" data-tel="${addr.recipientPhone}"
                                       data-zip="${addr.zipcode}" data-addr1="${addr.mainAddr}" data-addr2="${addr.detailAddr}"
                                       <c:if test="${addr.isDefault == 1}">checked</c:if>>
                                <div class="addr-detail" style="margin-left: 10px;">
                                    <p><strong>${addr.addressName}</strong> [${addr.recipientName}]</p>
                                    <p>${addr.recipientPhone}</p>
                                    <p>(${addr.zipcode}) ${addr.mainAddr} ${addr.detailAddr}</p>
                                </div>
                            </label>
                        </li>
                    </c:forEach>
                </c:when>
                <%-- 3. 데이터가 없을 때 --%>
                <c:otherwise>
                    <li>
                        <div class="addr-info">
                            <div class="addr-detail no-addr-txt">
                                <p>등록된 주소가 없습니다.</p>
                            </div>
                        </div>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
        <button type="button" class="addr-add__btn">신규 배송지 추가</button>
    </div>
</div>

		<div class="foot">
			<button type="button" class="cbt">취소</button>
			<button type="button" class="on" onclick="addr_choice();">선택하기</button>
		</div>
	</div>
</div>
