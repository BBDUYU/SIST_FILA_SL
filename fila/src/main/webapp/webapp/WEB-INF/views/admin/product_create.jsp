<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="wrap" class="admin-section">


		<form id="productForm" action="createProduct.htm" method="post" enctype="multipart/form-data">
			<div id="contents" style="max-width: 1300px; margin: 0 auto; display: flex; gap: 40px;">

				<div style="flex: 1.4;">
					<h3 class="section-title">상품 비주얼 등록</h3>
					
					<div class="input-group">
						<label>메인 상품 이미지 (최대 13장)</label>
						<div class="upload-wrapper">
							<div class="photo-upload-zone" onclick="document.getElementById('mainImgs').click()">
								<span style="font-size:24px;">+</span><br><span class="desc">클릭하여 메인 이미지 업로드</span>
								<input type="file" id="mainImgs" name="mainImages[]" multiple style="display: none" onchange="previewImages(this, 'main-preview')">
							</div>
							<div id="main-preview" class="preview-container"></div>
						</div>
					</div>

					<div class="input-group">
						<label>모델컷 이미지 등록</label>
						<div class="upload-wrapper">
							<div class="photo-upload-zone" onclick="document.getElementById('modelImgs').click()">
								<span style="font-size:24px;">+</span><br><span class="desc">클릭하여 모델 촬영 이미지 업로드</span>
								<input type="file" id="modelImgs" name="modelImages[]" multiple style="display: none" onchange="previewImages(this, 'model-preview')">
							</div>
							<div id="model-preview" class="preview-container"></div>
						</div>
					</div>

					<div class="input-group">
						<label>상세 설명 하단 이미지</label>
						<div class="upload-wrapper">
							<div class="photo-upload-zone" onclick="document.getElementById('detailImgs').click()">
								<span style="font-size:24px;">+</span><br><span class="desc">클릭하여 상세 이미지 업로드</span>
								<input type="file" id="detailImgs" name="detailImages[]" multiple style="display: none" onchange="previewImages(this, 'detail-preview')">
							</div>
							<div id="detail-preview" class="preview-container"></div>
						</div>
					</div>
				</div>

				<div style="flex: 1; background: #fff; padding: 30px; border: 1px solid var(--border-color); height: fit-content;">
					<h3 style="color: var(--fila-navy); border-bottom: 1px solid #eee; padding-bottom: 15px; margin-top:0;">상품 정보 설정</h3>

					<div class="input-group">
						<label>노출 카테고리 지정 (중복 선택 가능)</label>
						<div class="category-container">
							<div class="category-select" id="depth1">
								<c:forEach items="${list}" var="c"><c:if test="${c.depth eq 1}"><div class="cate-item" onclick="filterCategory(2, '${c.category_id}', this)">${c.name}</div></c:if></c:forEach>
							</div>
							<div class="category-select" id="depth2">
								<c:forEach items="${list}" var="c"><c:if test="${c.depth eq 2}"><div class="cate-item" data-parent="${c.parent_id}" onclick="filterCategory(3, '${c.category_id}', this)" style="display: none;">${c.name}</div></c:if></c:forEach>
							</div>
							<div class="category-select" id="depth3">
								<c:forEach items="${list}" var="c"><c:if test="${c.depth eq 3}"><div class="cate-item" data-parent="${c.parent_id}" onclick="toggleCategory(this, '${c.category_id}')" style="display: none;">${c.name}</div></c:if></c:forEach>
							</div>
						</div>
						<div id="selected-tags" style="margin-top: 15px; display: flex; gap: 8px; flex-wrap: wrap; min-height: 35px;"></div>
						<div id="hidden-inputs"></div>
					</div>
					<div class="input-group" style="margin-top: 30px;">
					    <label>인기 태그 지정 (중복 선택 가능)</label>
					    <div class="opt-list" style="background: #fff; border: 1px solid var(--border-color); padding: 15px;">
					        <c:forEach items="${tagList}" var="c">
					            <%-- 카테고리 ID가 4000번대인 것들만 루프 --%>
					            <c:if test="${c.category_id >= 4000 && c.category_id < 5000}">
					                <label class="opt-item tag-item">
					                    <input type="checkbox" name="tag_ids" value="${c.category_id}" 
					                        <c:forEach items="${productCategories}" var="pc">
					                            <c:if test="${pc.category_id == c.category_id}">checked</c:if>
					                        </c:forEach>
					                    > 
					                    <span># ${c.name}</span>
					                </label>
					            </c:if>
					        </c:forEach>
					        <c:if test="${empty tagList}">
					            <div style="font-size: 12px; color: #999;">등록된 태그가 없습니다. 태그 관리에서 먼저 등록해주세요.</div>
					        </c:if>
					    </div>
					</div>
					<div class="input-group">
						<label>상품 옵션 설정</label>
						<div style="background: #fff; border: 1px solid #333; padding: 20px;">
							<p style="font-size: 13px; font-weight: bold; margin-bottom: 10px;">스포츠 분류</p>
							<div class="opt-list">
							    <c:forEach items="${options}" var="entry">
							        <%-- 키값이 2인 경우가 스포츠 분류 --%>
							        <c:if test="${entry.key == 2}">
							            <c:forEach items="${entry.value}" var="opt">
							                <label class="opt-item">
							                    <input type="radio" name="sport_option" value="${opt.v_master_id}" required> 
							                    <span>${opt.value_name}</span>
							                </label>
							            </c:forEach>
							        </c:if>
							    </c:forEach>
							</div>
							<p style="font-size: 13px; font-weight: bold; margin-top: 20px; margin-bottom: 10px;">사이즈 <span id="size-target-name" style="color: var(--fila-red);"></span></p>
							<div id="size-area" class="opt-list">
						    <c:forEach items="${options}" var="entry">
						        <%-- 4~8번 사이의 마스터 ID인 경우 사이즈 아이템으로 생성 --%>
						        <c:if test="${entry.key >= 4 && entry.key <= 8}">
						            <c:forEach items="${entry.value}" var="opt">
						                <label class="opt-item size-item m-${entry.key}" style="display: none;">
						                    <input type="checkbox" name="size_options" value="${opt.v_master_id}"> 
						                    <span>${opt.value_name}</span>
						                </label>
						            </c:forEach>
						        </c:if>
						    </c:forEach>
						    <div id="size-placeholder" style="color: #999; font-size: 12px;">카테고리를 선택하면 사이즈 목록이 나타납니다.</div>
						</div>
						</div>
					</div>

					<div style="display: flex; gap: 15px;">
						<div class="input-group" style="flex: 1;">
							<label>스타일(룩북) 연결</label>
							<select name="styleId" class="f-input">
								<option value="0">-- 선택 안함 --</option>
								<c:forEach items="${styleList}" var="s"><option value="${s.styleId}">${s.styleName}</option></c:forEach>
							</select>
						</div>
						<div class="input-group" style="flex: 1;">
							<label>이벤트 섹션 연결</label>
							<select name="sectionId" class="f-input">
								<option value="0">-- 선택 안함 --</option>
								<c:forEach items="${eventSectionList}" var="es"><option value="${es.sectionId}">${es.name}</option></c:forEach>
							</select>
						</div>
					</div>

					<div class="input-group"><label>제품명</label><input type="text" name="name" class="f-input" required></div>

					<div style="display: flex; gap: 10px;">
						<div class="input-group" style="flex: 1;"><label>판매가(원)</label><input type="number" name="price" class="f-input" required></div>
						<div class="input-group" style="flex: 0.7;"><label>할인율(%)</label><input type="number" name="discount_rate" class="f-input" value="0"></div>
						<div class="input-group" style="flex: 1;"><label>초기 재고수량</label><input type="number" name="stock" class="f-input" placeholder="사이즈별 수량" required></div>
					</div>

					<div class="input-group">
						<label>상품 상세 설명</label>
						<textarea name="description" class="f-input" style="height: 100px; resize: none;"></textarea>
					</div>

					<button type="button" class="submit-btn" onclick="registProduct()">상품 등록 완료</button>
				</div>
			</div>
			<input type="hidden" id="gender_option_input" name="gender_option" value="">
		</form>
		
	</div>
