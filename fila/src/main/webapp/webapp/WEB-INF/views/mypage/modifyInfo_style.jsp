<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
    .tbl-list th { font-size: 14px; color: #666; font-weight: 500; }
    .status-badge { 
        display: inline-block; 
        padding: 4px 8px; 
        background: #00205b; 
        color: #fff; 
        font-size: 12px; 
        border-radius: 2px; 
    }
    .btn-small {
        padding: 5px 10px;
        border: 1px solid #ddd;
        background: #fff;
        cursor: pointer;
        font-size: 12px;
    }
    .btn-small:hover { background: #f4f4f4; }
</style>
<style>
/* 기존 스타일 아래에 추가 */
.style-modal-overlay {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
    z-index: 1000;
    display: none; /* 기본은 숨김 */
    align-items: center;
    justify-content: center;
}

.style-modal-wrapper {
    position: relative;
    z-index: 1001;
    background: #fff;
    width: auto;
    max-width: 500px;
}

/* FILA 스타일 레이어 보정 */
.common__layer { display: block !important; position: static !important; }
</style>