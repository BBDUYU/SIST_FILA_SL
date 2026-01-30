<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
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