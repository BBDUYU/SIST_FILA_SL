<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%>
<style>
:root { --fila-navy: #001E62; --fila-red: #E2001A; --fila-gray: #F4F4F4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--fila-gray); margin: 0; display: flex; }

.main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); }
.card { background: white; border: 1px solid #ddd; padding: 30px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }

/* 상세 테이블 스타일 */
.detail-table { width: 100%; border-top: 2px solid var(--fila-navy); border-collapse: collapse; margin-top: 20px; }
.detail-table th { background-color: #f9f9f9; border-bottom: 1px solid #ddd; padding: 15px; text-align: left; width: 150px; font-size: 14px; color: #333; }
.detail-table td { border-bottom: 1px solid #eee; padding: 15px; font-size: 14px; color: #666; }

/* 이미지 영역 */
.notice-img-box { margin-top: 20px; padding: 20px; background: #fafafa; border: 1px dashed #ddd; text-align: center; }
.notice-img-box img { max-width: 100%; height: auto; border: 1px solid #eee; }

/* 버튼 영역 */
.btn-area { margin-top: 30px; text-align: center; }
.btn { padding: 10px 25px; font-size: 14px; font-weight: bold; border-radius: 4px; cursor: pointer; border: none; margin: 0 5px; text-decoration: none; display: inline-block; }
.btn-list { background-color: #666; color: white; }
.btn-edit { background-color: var(--fila-navy); color: white; }
.btn-delete { background-color: var(--fila-red); color: white; }
</style>