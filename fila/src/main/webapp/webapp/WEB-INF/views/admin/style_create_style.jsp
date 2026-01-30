<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/* 기존 FILA 브랜드 컬러 변수 및 레이아웃 유지 */
:root { --fila-navy: #00205b; --fila-red: #e31837; --bg-gray: #f4f4f4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--bg-gray); margin: 0; }
.admin-section { margin-left: 240px; padding: 50px 40px; min-height: 100vh; }
.section-title { font-size: 22px; font-weight: 800; color: var(--fila-navy); position: relative; padding-left: 15px; margin-bottom: 30px; }
.section-title::before { content: ''; position: absolute; left: 0; top: 50%; transform: translateY(-50%); width: 4px; height: 20px; background-color: var(--fila-red); }

/* 폼 및 테이블 공통 */
.write-table, .product-select-table { width: 100%; border-collapse: collapse; background: #fff; border-top: 2px solid var(--fila-navy); margin-bottom: 30px; }
.write-table th, .product-select-table th { background: #f9f9f9; padding: 15px; border-bottom: 1px solid #eee; text-align: left; font-size: 13px; }
.write-table td, .product-select-table td { padding: 12px 15px; border-bottom: 1px solid #eee; vertical-align: middle; font-size: 14px; }

/* 이미지 업로드 존 (Product Create 스타일) */
.photo-upload-zone { border: 2px dashed #ccc; padding: 30px; text-align: center; cursor: pointer; transition: 0.3s; background: #fff; }
.photo-upload-zone:hover { border-color: var(--fila-navy); background: #f0f4f9; }
.preview-container { display: flex; gap: 10px; margin-top: 15px; flex-wrap: wrap; }
.preview-box { width: 80px; height: 100px; border: 1px solid #eee; position: relative; }
.preview-box img { width: 100%; height: 100%; object-fit: cover; }

/* 선택된 상품 태그 */
.product-tag-container { display: flex; flex-wrap: wrap; gap: 10px; padding: 10px; background: #fdfdfd; border: 1px solid #eee; min-height: 50px; }
.product-tag { background: var(--fila-navy); color: #fff; padding: 5px 12px; border-radius: 2px; font-size: 12px; display: flex; align-items: center; }
.btn-tag-del { margin-left: 8px; cursor: pointer; font-weight: bold; }

/* 버튼 스타일 */
.submit-btn { background: var(--fila-navy); color: #fff; padding: 15px 50px; border: none; font-weight: 700; cursor: pointer; font-size: 16px; }
.small-add-btn { background: var(--fila-navy); color: #fff; border: none; padding: 5px 10px; cursor: pointer; font-size: 12px; }
.small-add-btn.added { background: #ccc; cursor: default; }
</style>