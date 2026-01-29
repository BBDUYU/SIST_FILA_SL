package command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.domain.MemberDTO;
import mypage.service.WishListService;
import products.ProductsDTO;
import products.service.ProductService;
import review.ReviewDAO;
import review.ReviewDAOImpl;

public class ProductDetailHandler implements CommandHandler {
	
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1) 상품 상세 데이터 세팅 (기존 그대로)
        ProductService service = ProductService.getInstance();
        service.getProductDetail(request);

        // 2) ✅ 유저별 찜 상태(wished) 세팅 (세션 auth 기준)
        boolean wished = false;

        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");

        // ✅ product_id를 '파라미터'가 아니라, 서비스가 넣어준 product에서 우선 확보
        // (파라미터 꼬임/누락 대비)
        String productId = null;

        Object prodObj = request.getAttribute("product");
        if (prodObj instanceof ProductsDTO) {
            ProductsDTO p = (ProductsDTO) prodObj;
            productId = p.getProduct_id();   // ✅ DTO getter 이름이 다르면 너꺼에 맞게 수정
        }

        // product에서 못 꺼냈으면 파라미터로 fallback
        if (productId == null || productId.trim().isEmpty()) {
            productId = request.getParameter("product_id");
        }

        if (productId != null) productId = productId.trim();

        // ✅ 로그인 상태 + productId 있을 때만 DB 체크 (유저마다 다르게)
        if (loginUser != null && productId != null && !productId.isEmpty()) {
            wished = WishListService.getInstance()
                    .isWished(loginUser.getUserNumber(), productId);
        }

        request.setAttribute("wished", wished);

        // -------------------------------------------------------------
        // 리뷰 작성 권한 체크
        // -------------------------------------------------------------
        boolean canReview = false;

        // 로그인했고, 상품ID가 확실히 있을 때만 DB 조회
        if (loginUser != null && productId != null && !productId.isEmpty()) {
            ReviewDAO reviewDao = ReviewDAOImpl.getInstance();
            // 위에서 만든 메서드 호출
            canReview = reviewDao.isPurchased(loginUser.getUserNumber(), productId);
        }

        // JSP로 권한(true/false)을 보냄
        request.setAttribute("canReview", canReview);
        
        // 3) JSP
        return "/view/product/product_detail.jsp";
    }
}