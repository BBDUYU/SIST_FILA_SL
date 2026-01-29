package order.command;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import admin.domain.UserInfoDTO;
import cart.persistence.CartDAO;
import command.CommandHandler;
import member.MemberDTO;
import mypage.domain.AddressDTO;
import mypage.persistence.AddressDAO;
import net.sf.json.JSONObject;
import order.domain.OrderDTO;
import order.domain.OrderItemDTO;
import order.service.OrderService;
import products.ProductsDAO;
import products.ProductsDTO;

public class OrderHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession(); 
        MemberDTO authUser = (MemberDTO) session.getAttribute("auth"); 
        
        if (authUser == null) {
            if (request.getMethod().equalsIgnoreCase("GET")) {
                response.sendRedirect(request.getContextPath() + "/member/login.htm");
                return null; 
            } else {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().print("{\"status\":\"error\", \"message\":\"로그인이 필요합니다.\"}");
                return null;
            }
        }

        int userNumber = authUser.getUserNumber();

        if (request.getMethod().equalsIgnoreCase("GET")) {
            String productId = request.getParameter("productId");
            String quantity = request.getParameter("quantity");
            String combinationId = request.getParameter("combinationId");
            String cartItemIds = request.getParameter("cartItemIds");

            Connection conn = null;
            try {
                conn = ConnectionProvider.getConnection();
                
                // 1. 배송지 목록 조회 추가
                AddressDAO addressDao = new AddressDAO();
                List<AddressDTO> addressList = addressDao.selectListByUser(conn, userNumber);
                request.setAttribute("addressList", addressList);
                
                // 기본 배송지 설정 (목록의 첫 번째가 IS_DEFAULT DESC로 인해 기본 배송지임)
                if (addressList != null && !addressList.isEmpty()) {
                    request.setAttribute("defaultAddr", addressList.get(0));
                }

                // 2. 상품 정보 조회 (기존 로직)
                List<OrderItemDTO> orderItems = new ArrayList<>();
                if (productId != null && !productId.isEmpty()) {
                    ProductsDAO productsDao = ProductsDAO.getInstance();
                    ProductsDTO product = productsDao.getProduct(conn, productId);
                    if (product != null) {
                        int originPrice = product.getPrice();
                        int salePrice = originPrice * (100 - product.getDiscount_rate()) / 100;
                        orderItems.add(OrderItemDTO.builder()
                            .productId(productId).productName(product.getName())
                            .quantity(Integer.parseInt(quantity)).combinationId(Integer.parseInt(combinationId))
                            .originalPrice(originPrice).price(salePrice).build());
                        request.setAttribute("isDirect", true);
                    }
                } else if (cartItemIds != null && !cartItemIds.isEmpty()) {
                    CartDAO cartDao = CartDAO.getInstance();
                    orderItems = cartDao.selectSelectedCartItems(conn, cartItemIds);
                    request.setAttribute("cartItemIds", cartItemIds);
                }

                if (orderItems.isEmpty()) return "/pay/cart.htm";

                // 3. 포인트/쿠폰 정보 조회 (기존 로직)
                UserInfoDTO userDetail = new UserInfoDTO();
                int myPoint = 0;
                String pointSql = "SELECT NVL(SUM(AMOUNT), 0) FROM USERPOINTS WHERE USER_NUMBER = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(pointSql)) {
                    pstmt.setInt(1, userNumber);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) myPoint = rs.getInt(1);
                    }
                }
                userDetail.setBalance(myPoint);

                List<UserInfoDTO> couponList = new ArrayList<>();
                String couponSql = "SELECT uc.USER_COUPON_ID, c.NAME, c.DISCOUNT_TYPE, c.DISCOUNT_VALUE " +
                                   "FROM USER_COUPON uc JOIN COUPON c ON uc.COUPON_ID = c.COUPON_ID " +
                                   "WHERE uc.USER_NUMBER = ? AND uc.IS_USED = 0 AND uc.EXPIRE_DATE >= SYSDATE";
                try (PreparedStatement pstmt = conn.prepareStatement(couponSql)) {
                    pstmt.setInt(1, userNumber);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            UserInfoDTO cp = new UserInfoDTO();
                            cp.setUsercouponid(rs.getInt("USER_COUPON_ID"));
                            cp.setCoupon_name(rs.getString("NAME"));
                            cp.setDiscount_type(rs.getString("DISCOUNT_TYPE"));
                            cp.setPrice(rs.getInt("DISCOUNT_VALUE"));
                            couponList.add(cp);
                        }
                    }
                }
                userDetail.setCouponList(couponList);

                int totalOriginalPrice = 0;
                int totalSalePrice = 0;
                for(OrderItemDTO item : orderItems) {
                    totalOriginalPrice += (item.getOriginalPrice() * item.getQuantity());
                    totalSalePrice += (item.getPrice() * item.getQuantity());
                }

                request.setAttribute("orderItems", orderItems);
                request.setAttribute("totalOriginalPrice", totalOriginalPrice);
                request.setAttribute("totalSalePrice", totalSalePrice);
                request.setAttribute("user", userDetail);

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                JdbcUtil.close(conn);
            }
            return "/view/order/order_pay.jsp";
        }

        else { // POST 처리
            response.setContentType("application/json; charset=UTF-8");
            PrintWriter out = response.getWriter();
            JSONObject jsonResponse = new JSONObject();

            try (Connection conn = ConnectionProvider.getConnection()) {
                // 1. 파라미터 수집
                int addressId = Integer.parseInt(request.getParameter("address_id"));
                int totalAmount = Integer.parseInt(request.getParameter("OrderTotalPrice"));
                String deliveryMethod = request.getParameter("deliveryOption");
                String deliveryRequest = request.getParameter("OrderContents");
                String paymentMethod = request.getParameter("gopaymethod");
                String cartItemIds = request.getParameter("cartItemIds");
                
                // [추가] 쿠폰(ISSUE_ID) 파라미터 받기 (나중에 JSP에서 name="issueId"로 넘겨주세요)
                String couponIdStr = request.getParameter("userCouponId");
                int userCouponId = (couponIdStr != null && !couponIdStr.isEmpty()) ? Integer.parseInt(couponIdStr) : 0;
                
                int usedPoint = 0;
                String usemileStr = request.getParameter("usemile");
                if(usemileStr != null && !usemileStr.isEmpty()) usedPoint = Integer.parseInt(usemileStr);


                // 2. OrderDTO 객체 생성
                // (OrderDTO 빌더에 issueId와 trackingNumber 필드가 있다고 가정합니다)
                OrderDTO order = OrderDTO.builder()
                        .userNumber(userNumber) 
                        .addressId(addressId)
                        .totalAmount(totalAmount)
                        .deliveryMethod("1".equals(deliveryMethod) ? "오늘도착" : "일반배송")
                        .deliveryRequest(deliveryRequest)
                        .paymentMethod(paymentMethod)
                        .usedPoint(usedPoint)
                        .userCouponId(userCouponId) // 미리 추가 (필드 없으면 DTO에 추가 필요)
                        .orderStatus("결제완료") // 기본 상태값 설정
                        .build();

                // 3. 상품 정보 가져오기 (기존 유지)
                CartDAO cartDao = CartDAO.getInstance();
                List<OrderItemDTO> items = new ArrayList<>();
                
                if (cartItemIds != null && !cartItemIds.isEmpty()) {
                    items = cartDao.selectSelectedCartItems(conn, cartItemIds);
                } else {
                    String pId = request.getParameter("productId");
                    String qtyStr = request.getParameter("quantity");
                    String cIdStr = request.getParameter("combinationId");
                    
                    if (pId != null) {
                    	ProductsDAO productsDao = ProductsDAO.getInstance();
                        ProductsDTO product = productsDao.getProduct(conn, pId);
                        
                        // 할인가 계산 (GET 방식에서 썼던 로직과 동일하게)
                        int salePrice = product.getPrice() * (100 - product.getDiscount_rate()) / 100;
                        items.add(OrderItemDTO.builder()
                                .productId(pId)
                                .quantity(Integer.parseInt(qtyStr))
                                .combinationId(Integer.parseInt(cIdStr))
                                .price(salePrice)
                                .build());
                    }
                }

                // 4. 서비스 호출하여 주문 처리 (DB INSERT)
                OrderService orderService = OrderService.getInstance();
                String orderId = orderService.processOrder(order, items,cartItemIds);

                // 5. 성공 응답
                jsonResponse.put("status", "success");
                jsonResponse.put("redirect", request.getContextPath() + "/order/complete.htm?orderId=" + orderId);
                out.print(jsonResponse.toString());

            } catch (Exception e) {
                e.printStackTrace();
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "주문 처리 중 오류 발생: " + e.getMessage());
                out.print(jsonResponse.toString());
            }
            return null;
        }
    }
}