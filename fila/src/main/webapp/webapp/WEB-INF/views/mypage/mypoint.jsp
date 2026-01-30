<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<section class="my-con">
    <h2 class="tit__style4">포인트 이용 내역</h2>
    
    <div class="point-summary" style="background:#f9f9f9; padding:20px; margin-bottom:20px; display:flex; justify-content:space-between; align-items:center;">
        <span style="font-size:16px;">가용 포인트</span>
        <strong style="font-size:24px; color:#00205b;">
            <fmt:formatNumber value="${user.balance}" pattern="#,###" /> P
        </strong>
    </div>

    <table class="info-table" style="width:100%; border-collapse:collapse; text-align: center;">
        <thead>
            <tr style="background: #f4f4f4; border-top:2px solid #00205b;">
                <th style="padding:15px; border-bottom:1px solid #ddd;">일자</th>
                <th style="padding:15px; border-bottom:1px solid #ddd;">구분</th>
                <th style="padding:15px; border-bottom:1px solid #ddd;">금액</th>
                <th style="padding:15px; border-bottom:1px solid #ddd;">잔액</th>
                <th style="padding:15px; border-bottom:1px solid #ddd;">내역</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${user.pointList}">
                <tr style="border-bottom:1px solid #eee;">
                    <td style="padding:15px;"><fmt:formatDate value="${p.createAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                    <td style="padding:15px;">
                        <c:choose>
                            <c:when test="${p.type eq 'EARN'}">
                                <span style="color: #28a745; font-weight: bold;">+ 적립</span>
                            </c:when>
                            <c:when test="${p.type eq 'USED'}">
                                <span style="color: #ed1c24; font-weight: bold;">- 사용</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #666;">${p.type}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="padding:15px; font-weight: bold;">
                        <fmt:formatNumber value="${p.amout}" pattern="#,###" /> P
                    </td>
                    <td style="padding:15px; color:#888;">
                        <fmt:formatNumber value="${p.balance}" pattern="#,###" /> P
                    </td>
                    <td style="padding:15px; text-align: left;">${p.description}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty user.pointList}">
                <tr>
                    <td colspan="5" style="padding: 100px; color: #999;">포인트 내역이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</section>
</div>
</div>