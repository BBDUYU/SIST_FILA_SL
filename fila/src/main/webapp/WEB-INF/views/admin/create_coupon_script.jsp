<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
