<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<style>
:root { --fila-navy: #001E62; --fila-red: #E2001A; --fila-gray: #F4F4F4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--fila-gray); margin: 0; display: flex; }
.main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); }
.card { background: white; border: 1px solid #ddd; padding: 25px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); min-height: 600px; }
.list-table { width: 100%; border-top: 2px solid var(--fila-navy); border-collapse: collapse; margin-top: 20px; text-align: center; }
.list-table th { background-color: #f9f9f9; border-bottom: 1px solid #ddd; padding: 15px 10px; font-size: 14px; color: #333; font-weight: bold; }
.list-table td { border-bottom: 1px solid #eee; padding: 15px 10px; font-size: 14px; color: #666; }
.list-table tbody tr:hover { background-color: #f0f4ff; }
.link-title { color: #333; text-decoration: none; font-weight: 500; cursor: pointer; }
.td-subject { max-width: 400px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-align: left; padding-left: 20px; }

/* 추가: 작성하기 버튼 스타일 */
.btn-write {
    float: right;
    background-color: var(--fila-navy);
    color: white;
    padding: 10px 20px;
    text-decoration: none;
    font-size: 14px;
    border-radius: 4px;
    font-weight: bold;
}
.btn-write:hover { background-color: #001440; }
</style>