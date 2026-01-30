<%@ page language="java" contentType="text/html; charset=UTF-8"  
    pageEncoding="UTF-8"%>
<script>
	function toggleOrderDetail(orderId) {
	    const detailRow = $('#detail_' + orderId);
	    const contentBox = $('#content_' + orderId);

	    if (detailRow.is(':visible')) {
	        detailRow.hide();
	    } else {
	        $.ajax({
	            url: "${pageContext.request.contextPath}/admin/orderDetail.htm",
	            data: { orderId: orderId },
	            dataType: "json",
	            success: function(items) {
	                let html = '<div style="font-weight:bold; margin-bottom:10px;">[주문 상세 상품 리스트]</div>';
	                html += '<table style="width:100%; border-collapse:collapse; background:white;">';
	                html += '<tr style="background:#f8f9fa; border-bottom:2px solid #eee;">' +
                    '<th style="padding:10px;">상품명</th>' +
                    '<th>옵션(사이즈)</th>' +
                    '<th>수량</th>' +
                    '<th>단가</th></tr>';
	                
	                items.forEach(item => {
	                	html += `<tr style="border-bottom:1px solid #ddd; text-align:center;">
	                        <td style="padding:10px; text-align:left;">\${item.productName}</td>
	                        <td>\${item.size}</td>
	                        <td>\${item.quantity}개</td>
	                        <td style="font-weight:bold; color:var(--fila-navy);">
	                            \${Number(item.price).toLocaleString()}원
	                        </td>
	                    </tr>`;
	                });
	                html += '</table>';
	                
	                contentBox.html(html);
	                detailRow.show();
	            }
	        });
	    }
	}
    function showTab(tabName, element) {
        // 모든 컨텐츠 숨기기
        const contents = document.getElementsByClassName('tab-content');
        for (let i = 0; i < contents.length; i++) {
            contents[i].style.display = 'none';
        }

        // 선택한 섹션 보이기
        document.getElementById('section-' + tabName).style.display = 'block';

        // 모든 탭 버튼에서 active 클래스 제거
        const tabs = document.getElementsByClassName('nav-item-tab');
        for (let i = 0; i < tabs.length; i++) {
            tabs[i].classList.remove('active');
        }

        // 현재 클릭한 버튼에 active 추가
        element.classList.add('active');
    }
    function changeOrderStatus(orderId) {
        const newStatus = document.getElementById('status_' + orderId).value;
        
        if(!confirm('주문 상태를 [' + newStatus + '](으)로 변경하시겠습니까?')) return;

        // jQuery가 이미 포함되어 있다고 가정합니다.
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/updateOrder.htm",
            type: "POST",
            data: {
                orderId: orderId,
                status: newStatus
            },
            dataType: "json",
            success: function(res) {
                if(res.status === "success") {
                    alert("성공적으로 변경되었습니다.");
                    location.href = location.pathname + location.search + "#order";
                    location.reload(); // 상태 반영을 위해 새로고침
                } else {
                    alert("실패: " + res.message);
                }
            },
            error: function() {
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    }
    $(document).ready(function() {
        // 1. URL에 #tabName이 있는지 확인 (예: #order, #point)
        const hash = window.location.hash;
        
        if (hash) {
            // #을 제거한 이름 (order, point 등)
            const tabName = hash.replace('#', '');
            
            // 해당 탭 버튼을 찾아서 클릭 이벤트 발생시킴
            // .nav-item-tab 중에서 onclick 속성에 해당 tabName이 포함된 것을 찾음
            const targetTab = $(".nav-item-tab[onclick*='" + tabName + "']");
            
            if (targetTab.length > 0) {
                targetTab.click();
            }
        }
    });
    </script>