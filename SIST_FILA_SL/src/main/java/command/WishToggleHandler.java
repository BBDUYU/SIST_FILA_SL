package command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.MemberDTO;
import mypage.service.WishListService;

public class WishToggleHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json; charset=UTF-8");

        // 1) 로그인 체크
        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        
        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"LOGIN_REQUIRED\"}");
            return null;
        }

        // 2) product_id 파라미터
        String productId = request.getParameter("product_id");
        if (productId == null || productId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"NO_PRODUCT_ID\"}");
            return null;
        }
        productId = productId.trim();

        // 3) sizeText 파라미터 (삭제할 땐 없어도 됨 / 추가할 땐 필수)
        String sizeText = request.getParameter("sizeText");
        if (sizeText != null) sizeText = sizeText.trim();
        
        String from = request.getParameter("from");
        boolean fromList = "list".equalsIgnoreCase(from);

        int userNumber = loginUser.getUserNumber();
        
        boolean alreadyWished =
                WishListService.getInstance().isWished(userNumber, productId);

        if (alreadyWished) {
            // ✅ [핵심] 이미 찜된 상태면 = 취소
            // sizeText는 건드리지 않음
        }
        else {
            // ✅ 추가 상황
            if (fromList) {
                // list에서 추가 → 사이즈 null 저장
                sizeText = null;
            } else {
                // detail에서 추가 → 사이즈 필수
                if (sizeText == null || sizeText.isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"SIZE_REQUIRED\"}");
                    return null;
                }
            }
        }

        // 4) 토글 실행
        boolean wished = WishListService.getInstance().toggleWished(userNumber, productId, sizeText);

        // 5) 결과 반환
        response.getWriter().write("{\"wished\":" + wished + "}");
        return null;
    }
}