<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<section class="my-con">
    <%-- 1. 제목 수정 --%>
    <h2 class="tit__style4">교환 · 취소 · 반품 조회</h2>

    <div class="my-sort-wrap">
        <%-- 2. action 주소를 취소 조회 핸들러 주소로 변경 (예: cancelList.htm) --%>
        <form method="post" action="cancelList.htm" name="serchOrderForm">
            <div class="my-sort-box">
                <p class="total">총 ${totalCount}건</p>
                <div class="period">
                    <%-- 날짜 클릭 시 검색 로직 (기존 유지하되 필요시 .asp -> .htm 변경) --%>
                    <a href="javascript:void(0);" onclick="searchDate('7')" >1주일</a>
                    <a href="javascript:void(0);" onclick="searchDate('30')" class="on">1개월</a>
                    <a href="javascript:void(0);" onclick="searchDate('90')">3개월</a>
                </div>
            </div>
        </form>
    </div>

    <div class="my-odr-wrap">
        <c:choose>
            <c:when test="${not empty orderList}">
                <table class="tbl-list" style="width:100%; border-top:2px solid #000;">
                    <colgroup>
                        <col style="width:180px">
                        <col style="width:auto">
                        <col style="width:150px">
                        <col style="width:120px">
                    </colgroup>
                    <thead>
                        <tr style="height:50px; background:#f9f9f9; border-bottom:1px solid #ddd;">
                            <th>신청일자/주문번호</th>
                            <th>결제금액</th>
                            <th>처리상태</th>
                            <th>상세내역</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="dto" items="${orderList}">
                            <tr style="text-align:center; border-bottom:1px solid #eee;">
                                <td style="padding:15px 0;">
                                    <fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd"/><br>
                                    <span style="font-size: 12px; color: #666;">${dto.orderId}</span>
                                </td>
                                <td>
                                    <strong><fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />원</strong>
                                </td>
                                <td>
                                    <%-- 취소/반품용 붉은색 배지 --%>
                                    <span class="status-badge" style="background:#d9534f;">${dto.orderStatus}</span>
                                </td>
                                <td>
                                    <button type="button" class="btn-small" onclick="toggleUserOrderDetail('${dto.orderId}')">
                                        상세보기
                                    </button>
                                </td>
                            </tr>
                            <tr id="detail_${dto.orderId}" style="display:none; background:#fcfcfc;">
                                <td colspan="4" id="content_${dto.orderId}" style="padding:20px; border:1px solid #ddd;">
                                    <div class="loading">데이터를 불러오는 중...</div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p class="odr-txt_none" style="text-align:center; padding:50px 0;">최근 교환/취소/반품 내역이 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
</section>
<%-- 하단 안내 및 JS는 기존과 동일 --%>

</div>
</div>
