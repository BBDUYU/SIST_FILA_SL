<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/* 모달 전체 배경 */
.style-modal-overlay {
    display: none; 
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.8);
    z-index: 10000;
    justify-content: center;
    align-items: center;
}

/* 모달 흰색 박스 */
.style-modal-wrapper {
    position: relative;
    background: #fff;
    width: 1100px;
    
   
    overflow: hidden;
    z-index: 10001;
}

/* 휠라 내부 클래스 강제 보정 (가장 중요) */
.style-modal-wrapper .common__layer {
    display: flex !important;
    position: relative !important;
    left: 0 !important; top: 0 !important;
    visibility: visible !important;
}


.style-modal-wrapper .photo { !important;  }
.style-modal-wrapper .con { !important;   }
</style>