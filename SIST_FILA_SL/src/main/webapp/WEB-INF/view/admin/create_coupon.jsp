<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 쿠폰 등록</title>
<style>
    /* 전체 레이아웃 (기존 어드민 스타일 유지) */
    body { display: flex; margin: 0; background-color: #f4f6f9; font-family: 'Noto Sans KR', sans-serif; }
    .content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); }
    
    .page-header { margin-bottom: 30px; border-bottom: 2px solid #00205b; padding-bottom: 10px; }
    .page-title { font-size: 24px; font-weight: bold; color: #00205b; }

    /* 폼 카드 스타일 */
    .form-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); max-width: 700px; }
    
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-weight: bold; color: #00205b; margin-bottom: 8px; font-size: 14px; }
    
    .form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
    .form-control:focus { border-color: #e21836; outline: none; }

    .row { display: flex; gap: 20px; }
    .col { flex: 1; }

    /* 버튼 스타일 */
    .btn-group { margin-top: 30px; display: flex; gap: 10px; }
    .btn { padding: 12px 25px; border-radius: 4px; cursor: pointer; border: none; font-weight: bold; font-size: 14px; text-decoration: none; text-align: center; }
    .btn-submit { background: #e21836; color: white; flex: 2; }
    .btn-cancel { background: #666; color: white; flex: 1; }
    .btn:hover { opacity: 0.9; }
    
    .input-wrapper { position: relative; display: flex; align-items: center; }
    .input-unit { position: absolute; right: 15px; color: #888; font-weight: bold; }
</style>
</head>
<body>

    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="currentPage" value="coupon" />
    </jsp:include>

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
                            <select id="discount_type" name="discount_type" class="form-control" onchange="toggleUnit()">
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
                                <input type="number" id="discount_value" name="discount_value" class="form-control" 
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

    <script>
    function toggleUnit() {
        const type = document.getElementById('discount_type').value;
        const unitText = document.getElementById('unit-text');
        const valueInput = document.getElementById('discount_value');
        
        unitText.style.display = 'inline';
        valueInput.disabled = false;
        valueInput.placeholder = "0";

        if (type === 'AMOUNT') {
            unitText.innerText = '원';
        } else if (type === 'PERCENT') {
            unitText.innerText = '%';
        } else if (type === 'DELIVERY') {
            unitText.style.display = 'none';
            valueInput.value = 0;
            valueInput.readOnly = true; 
            valueInput.placeholder = "배송비 무료";
        }
    }
</script>

</body>
</html>