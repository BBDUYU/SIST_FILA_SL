<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
:root { --fila-navy: #001E62; --fila-red: #E2001A; --fila-gray: #F4F4F4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--fila-gray); margin: 0; display: flex; }
.main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); }
.card { background: white; border: 1px solid #ddd; padding: 25px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }

/* 입력 테이블 스타일 (준식님 상품문의 스타일 계승) */
.info-table { width: 100%; border-top: 2px solid var(--fila-navy); border-collapse: collapse; margin-bottom: 20px; }
.info-table th { background-color: #f9f9f9; border: 1px solid #eee; padding: 12px 15px; text-align: left; width: 15%; font-size: 14px; color: #333; font-weight: bold; }
.info-table td { border: 1px solid #eee; padding: 12px 15px; }

/* 입력 요소 스타일 */
.input-text { width: 95%; padding: 8px 10px; border: 1px solid #ddd; font-size: 14px; }
.input-sel { padding: 8px 10px; border: 1px solid #ddd; font-size: 14px; }

.section-title { font-size: 18px; font-weight: bold; color: var(--fila-navy); margin: 30px 0 15px 0; display: flex; align-items: center; }
.section-title::before { content: ''; display: inline-block; width: 4px; height: 18px; background-color: var(--fila-red); margin-right: 10px; }

.btn-area { text-align: center; margin-top: 40px; border-top: 1px solid #eee; padding-top: 25px; }
.btn-fila { background: var(--fila-navy); color: white; border: none; padding: 10px 30px; cursor: pointer; font-size: 14px; font-weight: bold; }
.btn-list { background: #666; color: white; text-decoration: none; padding: 10px 30px; font-size: 14px; display: inline-block; margin-right: 10px; }
</style>