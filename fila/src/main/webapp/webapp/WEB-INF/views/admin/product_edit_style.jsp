<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
:root {
	--fila-navy: #00205b;
	--fila-red: #e21836;
	--fila-white: #ffffff;
	--bg-gray: #f4f4f4;
	--border-color: #ddd;
}
/* 레이아웃 */
.admin-section { margin-left: 240px; padding: 50px 0; background-color: var(--bg-gray); min-height: 100vh; width: calc(100% - 240px); }
.section-title { border-bottom: 2px solid #000; padding-bottom: 10px; margin-bottom: 20px; font-size: 20px; font-weight: bold; color: var(--fila-navy); text-transform: uppercase; }
.input-group { margin-bottom: 25px; }
.input-group label { display: block; font-weight: bold; margin-bottom: 10px; font-size: 14px; color: #333; }
.f-input { width: 100%; padding: 12px; border: 1px solid #333 !important; font-size: 14px; box-sizing: border-box; background: #fff; }
.f-input:focus { border: 1.5px solid var(--fila-navy) !important; outline: none; }

/* 이미지 업로드 */
.upload-wrapper { background: #fff; padding: 20px; border: 1px solid var(--border-color); }
.photo-upload-zone { border: 2px dashed var(--border-color); padding: 25px; text-align: center; background: #fafafa; cursor: pointer; }
.preview-container { display: flex; gap: 8px; margin-top: 15px; flex-wrap: wrap; }
.preview-container .img-box { position: relative; width: 80px; height: 80px; }
.preview-container img { width: 100%; height: 100%; object-fit: cover; border: 1px solid #eee; }
.del-btn { position: absolute; top: -5px; right: -5px; background: var(--fila-red); color: #fff; width: 18px; height: 18px; border-radius: 50%; font-size: 12px; text-align: center; cursor: pointer; border: none; }

/* 카테고리 선택 */
.category-container { display: flex; gap: 10px; background: white; padding: 15px; border: 1px solid var(--border-color); }
.category-select { flex: 1; height: 160px; border: 1px solid #eee; overflow-y: auto; }
.cate-item { padding: 10px; cursor: pointer; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
.cate-item:hover { background-color: #f9f9f9; }
.cate-item.active { background-color: var(--fila-navy) !important; color: white !important; font-weight: bold; }
.cate-tag { background: var(--fila-red); color: #fff; padding: 6px 14px; border-radius: 4px; font-size: 12px; display: inline-flex; align-items: center; gap: 10px; margin-bottom: 5px; }

/* 옵션(스포츠/사이즈) */
.opt-list { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px; }
.opt-item { display: inline-flex; align-items: center; padding: 8px 15px; border: 1px solid #ddd; background: #fff; cursor: pointer; font-size: 13px; }
.opt-item:has(input:checked) { border-color: var(--fila-navy); background-color: #f0f4f9; color: var(--fila-navy); font-weight: bold; }

.submit-btn { width: 100%; height: 60px; background: var(--fila-navy); color: white; border: none; font-size: 18px; font-weight: bold; cursor: pointer; margin-top: 40px; }
</style>