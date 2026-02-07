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

        $.ajax({
            // 🚩 URL을 processOrderCancel에서 쓰는 것과 동일하게 맞춥니다.
            url: "${pageContext.request.contextPath}/admin/orderUpdate.htm", 
            type: "POST",
            data: {
                orderId: orderId,
                status: newStatus
            },
            // 🚩 dataType: "json"을 제거하여 텍스트 응답을 받을 수 있게 합니다.
            success: function(res) {
                // 🚩 SUCCESS_OK 텍스트 비교 방식으로 통일
                if(res.trim() === "SUCCESS_OK") {
                    alert("성공적으로 변경되었습니다.");
                    
                    // 현재 보고 있던 탭(#order)을 유지하며 새로고침
                    const currentHash = window.location.hash || "#order";
                    location.href = window.location.pathname + window.location.search + currentHash;
                    location.reload(); 
                } else {
                    alert("변경 실패: 서버 응답이 올바르지 않습니다.");
                }
            },
            error: function(xhr) {
                alert("서버 통신 중 오류가 발생했습니다. (상태코드: " + xhr.status + ")");
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