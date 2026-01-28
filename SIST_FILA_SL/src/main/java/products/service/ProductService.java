package products.service;

import java.io.File;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.util.DBConn; 
import categories.CategoriesDAO;
import categories.CategoriesDTO;
import products.ProductsDAO;
import products.ProductsDTO;
import products.ProductsOptionDTO;

public class ProductService {

    private static ProductService instance = null;
    private ProductService() {}
    public static ProductService getInstance() {
        if(instance == null) instance = new ProductService();
        return instance;
    }

    // -----------------------------------------------------------
    // [추가] 1. 검색어 기반 상품 목록 조회 (핸들러에서 호출)
    // -----------------------------------------------------------
    public List<ProductsDTO> searchProducts(String searchItem) {
        Connection conn = null;
        try {
            conn = DBConn.getConnection();
            return ProductsDAO.getInstance().selectProductsBySearch(conn, searchItem);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            DBConn.close();
        }
    }

    // -----------------------------------------------------------
    // [추가] 2. 매개변수 없는 전체 목록 조회 (오버로딩)
    // -----------------------------------------------------------
    public List<ProductsDTO> getProductList() {
        Connection conn = null;
        try {
            conn = DBConn.getConnection();
            return ProductsDAO.getInstance().selectAllProducts(conn);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            DBConn.close();
        }
    }

    // -----------------------------------------------------------
    // 3. 기존 카테고리 리스트 조회 (Request 객체 제어)
    // -----------------------------------------------------------
    public void getProductList(HttpServletRequest request) {
        Connection conn = null;
        try {
            conn = DBConn.getConnection();
            ProductsDAO pDao = ProductsDAO.getInstance();
            CategoriesDAO cDao = CategoriesDAO.getInstance();
            
            // 1. 카테고리 ID 받기
            String cateParam = request.getParameter("category");
            int cateId = (cateParam != null) ? Integer.parseInt(cateParam) : 0;
            
            // 2. 제목(Title) 자동 완성 로직
            String mainTitle = ""; 
            String subTitle = "전체보기"; 
            
            if (cateId > 0) {
                CategoriesDTO curDto = cDao.selectCategory(conn, cateId);
                
                if (curDto != null) {
                    CategoriesDTO parent = null; 
                    if (curDto.getDepth() == 1) {
                        mainTitle = curDto.getName();
                    } else if (curDto.getDepth() == 2) {
                        parent = cDao.selectCategory(conn, curDto.getParent_id());
                        if (parent != null) mainTitle = parent.getName();
                    } else if (curDto.getDepth() == 3) {
                        parent = cDao.selectCategory(conn, curDto.getParent_id());
                        if (parent != null) {
                            CategoriesDTO grandParent = cDao.selectCategory(conn, parent.getParent_id());
                            if (grandParent != null) mainTitle = grandParent.getName();
                        }
                    }

                    if (curDto.getDepth() == 3) {
                        if (parent == null) parent = cDao.selectCategory(conn, curDto.getParent_id());
                        if (parent != null && parent.getName().equalsIgnoreCase("NewFeatured")) {
                            String myName = curDto.getName();
                            if (myName.equals("베스트")) subTitle = "BEST";
                            else if (myName.equals("세일")) subTitle = "SALE";
                            else subTitle = myName; 
                        } else {
                            if (parent != null) subTitle = parent.getName();
                        }
                    } else if (curDto.getDepth() == 2) {
                        subTitle = curDto.getName();
                    }
                }
            }
            
            if (mainTitle.equals("")) mainTitle = "WOMEN";

            // 3. 왼쪽 사이드바 기준점 잡기
            int sidebarParentId = 0;
            CategoriesDTO currentCategory = null;
            if (cateId > 0) {
                currentCategory = cDao.selectCategory(conn, cateId);
                if (currentCategory != null) {
                    if (currentCategory.getDepth() == 1) sidebarParentId = cateId;
                    else if (currentCategory.getDepth() == 2) sidebarParentId = cateId;
                    else if (currentCategory.getDepth() == 3) {
                        CategoriesDTO parent = cDao.selectCategory(conn, currentCategory.getParent_id());
                        sidebarParentId = parent.getCategory_id();
                    }
                }
            }

            // 4. 사이드바 목록 조회
            List<CategoriesDTO> sidebarList = null;
            if (sidebarParentId > 0) {
                 sidebarList = cDao.selectChildCategories(conn, sidebarParentId);
            } else {
                 sidebarList = cDao.selectMainCategories(conn); 
            }
            
            if (sidebarList != null) {
                int totalCount = 0;
                for (CategoriesDTO side : sidebarList) {
                    int realCount = pDao.getProductCount(conn, side.getCategory_id());
                    side.setProduct_count(realCount);
                    totalCount += realCount;
                }
                request.setAttribute("totalSidebarCount", totalCount);
            }

            // 5. 상품 리스트 조회
            List<ProductsDTO> list = null;
            if (cateId == 0) {
                list = pDao.selectAllProducts(conn);
            } else {
                list = pDao.selectProductsByCategory(conn, cateId);
            }
            
            request.setAttribute("productList", list);
            request.setAttribute("sidebarList", sidebarList);
            request.setAttribute("mainTitle", mainTitle); 
            request.setAttribute("subTitle", subTitle);   
            request.setAttribute("currentCateId", cateId);
            request.setAttribute("sidebarParentId", sidebarParentId); 

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConn.close();
        }
    }

    // 4. 상세페이지 로직
    public void getProductDetail(HttpServletRequest request) {
        Connection conn = null;
        try {
            conn = DBConn.getConnection();
            ProductsDAO pDao = ProductsDAO.getInstance();
            CategoriesDAO cDao = CategoriesDAO.getInstance();
            
            // ReviewDAO 객체 생성
            review.ReviewDAO reviewDao = new review.ReviewDAOImpl(conn);
            
            String productId = request.getParameter("product_id");
            if(productId == null || productId.isEmpty()) return;

            ProductsDTO dto = pDao.getProduct(conn, productId);
            
            if (dto != null) {
                productId = dto.getProduct_id();
                
                // 이미지 파일 스캔 로직
                List<String> mainImages = new ArrayList<>();
                List<String> modelImages = new ArrayList<>();
                List<String> detailImages = new ArrayList<>();
                
                File dir = new File("C:\\fila_upload\\product\\" + productId);
                if (dir.exists() && dir.isDirectory()) {
                    File[] files = dir.listFiles();
                    if (files != null) {
                        for (File file : files) {
                            String name = file.getName();
                            if (name.contains("_main_")) mainImages.add(name);
                            else if (name.contains("_model_")) modelImages.add(name);
                            else if (name.contains("_detail_")) detailImages.add(name);
                        }
                    }
                }
                Collections.sort(mainImages);
                Collections.sort(modelImages);
                Collections.sort(detailImages);

                List<ProductsOptionDTO> sizeOptions = pDao.getProductOptions(conn, productId);
                List<ProductsDTO> relatedList = pDao.selectProductsByCategory(conn, dto.getCategory_id());

                CategoriesDTO curDto = cDao.selectCategory(conn, dto.getCategory_id());
                String genderTag = "FILA";
                if (curDto != null) {
                    String depth1Name = "";
                    if (curDto.getDepth() == 1) depth1Name = curDto.getName();
                    else if (curDto.getDepth() == 2) {
                        CategoriesDTO parent = cDao.selectCategory(conn, curDto.getParent_id());
                        if (parent != null) depth1Name = parent.getName();
                    } else if (curDto.getDepth() == 3) {
                        CategoriesDTO parent = cDao.selectCategory(conn, curDto.getParent_id());
                        if (parent != null) {
                            CategoriesDTO grandParent = cDao.selectCategory(conn, parent.getParent_id());
                            if (grandParent != null) depth1Name = grandParent.getName();
                        }
                    }
                    if ("여성".equals(depth1Name)) genderTag = "FEMALE";
                    else if ("남성".equals(depth1Name)) genderTag = "MALE";
                    else if (!depth1Name.isEmpty()) genderTag = depth1Name;
                }

                int finalPrice = dto.getPrice();
                if(dto.getDiscount_rate() > 0) {
                    finalPrice = dto.getPrice() * (100 - dto.getDiscount_rate()) / 100;
                }

                String styleTag = pDao.getProductTag(conn, productId, 2);
                if (styleTag == null) styleTag = "라이프스타일";

                // -----------------------------------------------------------
                // [G] 추가 및 수정: 로그인한 유저 정보 확인 후 리뷰 목록 조회
                // -----------------------------------------------------------
                int userNumber = 0; // 기본값 (비로그인)
                
                // 세션 가져오기
                javax.servlet.http.HttpSession session = request.getSession();
                // MemberDTO는 패키지명 포함해서 명시 (혹시 import 안 되어 있을까봐)
                member.MemberDTO auth = (member.MemberDTO) session.getAttribute("auth");
                
                if (auth != null) {
                    userNumber = auth.getUserNumber(); // 로그인했으면 번호 추출
                }

                // [수정] userNumber를 파라미터로 같이 넘김 (내 좋아요 상태 확인용)
                List<review.ReviewDTO> reviewList = reviewDao.selectListByFilter(productId, null, userNumber, null, null);
                java.util.Map<String, Object> reviewSummary = reviewDao.getReviewSummary(productId);
                qna.QnaDAO qnaDao = qna.QnaDAOImpl.getInstance(); 
                java.util.List<qna.QnaDTO> qnaList = qnaDao.selectList(productId);
                
                // -----------------------------------------------------------
                // 4. JSP 전송 (Attribute 설정)
                // -----------------------------------------------------------
                request.setAttribute("product", dto);
                request.setAttribute("mainImages", mainImages);
                request.setAttribute("modelImages", modelImages);
                request.setAttribute("detailImages", detailImages);
                request.setAttribute("sizeOptions", sizeOptions);
                request.setAttribute("relatedList", relatedList);
                request.setAttribute("finalPrice", finalPrice);
                request.setAttribute("styleTag", styleTag);
                request.setAttribute("genderTag", genderTag);
                
                request.setAttribute("reviewList", reviewList);       // 리뷰 리스트 (myLike 포함됨)
                request.setAttribute("reviewSummary", reviewSummary); // 통계 정보
                request.setAttribute("qnaList", qnaList);
                
                if(sizeOptions != null && !sizeOptions.isEmpty()) {
                    request.setAttribute("sizeOption", "Y");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConn.close();
        }
    }

    public void getCartOptionInfo(HttpServletRequest request) {
        Connection conn = null;
        try {
            conn = DBConn.getConnection();
            String productId = request.getParameter("productId");
            
            // 1. 상품 상세 정보 가져오기
            ProductsDTO product = ProductsDAO.getInstance().getProduct(conn, productId);
            // 2. 해당 상품의 모든 옵션(사이즈) 가져오기
            List<ProductsOptionDTO> sizeOptions = ProductsDAO.getInstance().getProductOptions(conn, productId);

            // 3. JSP에서 쓸 수 있게 request에 세팅
            request.setAttribute("product", product);
            request.setAttribute("sizeOptions", sizeOptions);
            request.setAttribute("currentSize", request.getParameter("size"));
            request.setAttribute("currentQty", request.getParameter("qty"));
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConn.close();
        }
    }

}