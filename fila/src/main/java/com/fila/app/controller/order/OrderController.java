package com.fila.app.controller.order;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.admin.UserInfoVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.order.OrderItemVO;
import com.fila.app.domain.order.OrderVO;
import com.fila.app.domain.product.ProductsVO;
import com.fila.app.mapper.address.AddressMapper;
import com.fila.app.mapper.admin.CouponMapper;
import com.fila.app.mapper.cart.CartMapper;
import com.fila.app.mapper.order.OderMapper;
import com.fila.app.mapper.product.UserProductMapper;
import com.fila.app.service.mypage.coupon.MypageCouponService;

@Controller
@RequestMapping("/order")
public class OrderController {

	@Autowired
	private AddressMapper addressMapper;
	@Autowired
	private UserProductMapper productMapper;
	@Autowired
	private CartMapper cartMapper;
	@Autowired
	private CouponMapper couponMapper;
	@Autowired
	private OderMapper oderMapper;
	@Autowired
    private MypageCouponService mypageCouponService;
	
	
	// ✅ GET: 결제 페이지 (OrderHandler의 GET 로직 그대로)
    @GetMapping("/orderForm.htm")
    public String orderPage(
            HttpSession session,
            Model model,
            @RequestParam(required = false) String productId,
            @RequestParam(required = false) String quantity,
            @RequestParam(required = false) String combinationId,
            @RequestParam(required = false) String cartItemIds
    ) {
        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        if (authUser == null) {
            return "redirect:/member/login.htm";
        }

        int userNumber = authUser.getUserNumber();

        // 1) 배송지 목록
        List<?> addressList = new ArrayList<>();

        try {
            addressList = addressMapper.selectListByUser(userNumber);
        } catch (SQLException e) {
            e.printStackTrace();
            // 실패 시 빈 리스트 유지
        }

        model.addAttribute("addressList", addressList);

        if (!addressList.isEmpty()) {
            model.addAttribute("defaultAddr", addressList.get(0));
        }

        // 2) 상품 정보 조회 (직구 / 장바구니)
        List<OrderItemVO> orderItems = new ArrayList<>();

        if (productId != null && !productId.isEmpty()) {
            ProductsVO product = productMapper.getProduct(productId);
            if (product != null) {
                int originPrice = product.getPrice();
                int salePrice = originPrice * (100 - product.getDiscountRate()) / 100;

                orderItems.add(OrderItemVO.builder()
                        .productId(productId)
                        .productName(product.getName())
                        .quantity(Integer.parseInt(quantity))
                        .combinationId(Integer.parseInt(combinationId))
                        .originalPrice(originPrice)
                        .price(salePrice)
                        .build());

                model.addAttribute("isDirect", true);
            }
        } else if (cartItemIds != null && !cartItemIds.isEmpty()) {
            try {
				orderItems = cartMapper.selectSelectedCartItems(cartItemIds);
			} catch (SQLException e) {
				e.printStackTrace();
			}
            model.addAttribute("cartItemIds", cartItemIds);
        }

        if (orderItems.isEmpty()) {
            return "redirect:/pay/cart.htm";
        }

        // 3) 포인트/쿠폰 정보 조회 (OrderHandler의 SQL 조회 부분을 Mapper 조회로 대체)
        UserInfoVO userDetail = new UserInfoVO();

        // 조회 안 함
        int myPoint = 0;          
        userDetail.setBalance(myPoint);

        // 쿠폰은 CouponMapper에서 조회
        // (OrderHandler의 couponSql과 동일 조건: 미사용 + 만료 전)
        List<UserInfoVO> couponList = couponMapper.getUserCouponList(userNumber);
        userDetail.setCouponList(couponList);

        // 4) 합계 계산
        int totalOriginalPrice = 0;
        int totalSalePrice = 0;
        for (OrderItemVO item : orderItems) {
            totalOriginalPrice += (item.getOriginalPrice() * item.getQuantity());
            totalSalePrice += (item.getPrice() * item.getQuantity());
        }

        model.addAttribute("orderItems", orderItems);
        model.addAttribute("totalOriginalPrice", totalOriginalPrice);
        model.addAttribute("totalSalePrice", totalSalePrice);
        model.addAttribute("user", userDetail);

        return "order_pay";
    }

    // ✅ POST: 결제 처리 (OrderHandler의 POST 로직 그대로)
    // 서비스 없이 컨트롤러에서 주문 삽입까지 다 하려면 트랜잭션은 여기서라도 묶어야 합니다.
    @PostMapping(value = "/orderForm.htm", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> orderSubmit(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, String> param
    ) {

        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        Map<String, Object> json = new HashMap<>();

        if (authUser == null) {
            json.put("status", "error");
            json.put("message", "로그인이 필요합니다.");
            return json;
        }

        int userNumber = authUser.getUserNumber();

        try {
            // 1) 파라미터 수집 (OrderHandler와 동일)
            int addressId = Integer.parseInt(param.get("address_id"));
            int totalAmount = Integer.parseInt(param.get("OrderTotalPrice"));
            String deliveryMethod = param.get("deliveryOption");
            String deliveryRequest = param.get("OrderContents");
            String paymentMethod = param.get("gopaymethod");
            String cartItemIds = param.get("cartItemIds");

            String couponIdStr = param.get("userCouponId");
            int userCouponId = (couponIdStr != null && !couponIdStr.isEmpty()) ? Integer.parseInt(couponIdStr) : 0;

            int usedPoint = 0;
            String usemileStr = param.get("usemile");
            if (usemileStr != null && !usemileStr.isEmpty()) usedPoint = Integer.parseInt(usemileStr);

            // 2) 주문 객체 생성
            OrderVO order = OrderVO.builder()
                    .userNumber(userNumber)
                    .addressId(addressId)
                    .totalAmount(totalAmount)
                    .deliveryMethod("1".equals(deliveryMethod) ? "오늘도착" : "일반배송")
                    .deliveryRequest(deliveryRequest)
                    .paymentMethod(paymentMethod)
                    .usedPoint(usedPoint)
                    .userCouponId(userCouponId)
                    .orderStatus("결제완료")
                    .build();

            // 3) 주문 아이템 구성 (OrderHandler와 동일)
            List<OrderItemVO> items = new ArrayList<>();

            if (cartItemIds != null && !cartItemIds.isEmpty()) {
                items = cartMapper.selectSelectedCartItems(cartItemIds);
            } else {
                String pId = param.get("productId");
                String qtyStr = param.get("quantity");
                String cIdStr = param.get("combinationId");

                if (pId != null && !pId.isEmpty()) {
                    ProductsVO product = productMapper.getProduct(pId);
                    int salePrice = product.getPrice() * (100 - product.getDiscountRate()) / 100;

                    items.add(OrderItemVO.builder()
                            .productId(pId)
                            .quantity(Integer.parseInt(qtyStr))
                            .combinationId(Integer.parseInt(cIdStr))
                            .price(salePrice)
                            .build());
                }
            }

            // 4) 주문 처리 (OrderService 없이 컨트롤러에서 그대로 수행)
            String orderId = oderMapper.generateOrderId();
            order.setOrderId(orderId);

            oderMapper.insertOrder(order);

            for (OrderItemVO item : items) item.setOrderId(orderId);
            oderMapper.insertOrderItems(items);

            for (OrderItemVO item : items) {
                int stockResult = oderMapper.updateDecreaseStock(item.getCombinationId(), item.getQuantity());
                if (stockResult == 0) {
                    throw new RuntimeException("상품[" + item.getCombinationId() + "]의 재고가 부족합니다.");
                }
            }

            oderMapper.insertPayment(orderId, order.getTotalAmount(), order.getPaymentMethod());

            // 포인트 처리
            if (order.getUsedPoint() > 0) {
                oderMapper.insertPointHistory(order.getUserNumber(), orderId, order.getUsedPoint());
            } else {
                int rewardPoint = (int) (order.getTotalAmount() * 0.05);
                if (rewardPoint > 0) {
                    oderMapper.insertOrderPoint(order.getUserNumber(), rewardPoint, orderId);
                }
            }

            // 쿠폰 사용 처리
            if (order.getUserCouponId() > 0) {
                oderMapper.updateCouponUsed(order.getUserCouponId());
            }

            // 장바구니 비우기
            if (cartItemIds != null && !cartItemIds.isEmpty()) {
                cartMapper.deleteCartItems(cartItemIds, order.getUserNumber());
            }

            // 성공 응답 (OrderHandler와 동일하게 redirect JSON)
            json.put("status", "success");
            json.put("redirect", request.getContextPath() + "/order/complete.htm?orderId=" + orderId);
            return json;

        } catch (Exception e) {
            // @Transactional이 롤백시키게 예외 다시 던져야 하는데,
            // 여기서는 JSON 응답을 주기 위해 RuntimeException으로 감싸서 던집니다.
            e.printStackTrace();
            throw new RuntimeException("주문 처리 중 오류 발생: " + e.getMessage(), e);
        }
    }
    
    @GetMapping("/address_list.htm")
    public String addressList(HttpSession session, Model model) {
        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        if (authUser == null) return "redirect:/member/login.htm";

        try {
            List<?> addressList = addressMapper.selectListByUser(authUser.getUserNumber());
            model.addAttribute("addressList", addressList);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // 해당 JSP 파일 경로 (views/order/address_list.jsp라고 가정)
        return "order/order_address"; 
    }
    
    @GetMapping("/addAddressForm.htm")
    public String addAddressForm() {
        return "mypage/add_address"; 
    }
    
    @GetMapping("/order_coupon.htm")
    public String orderCouponForm() {
        return "order/order_coupon"; 
    }

    @GetMapping(value = "/api/mycoupon_ajax.htm", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<UserInfoVO> myCouponAjax(HttpSession session) {
        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        if (authUser == null) return new ArrayList<>();

        return couponMapper.getUserCouponList(authUser.getUserNumber());
    }
    @PostMapping(value = "/coupon_process.htm")
    @ResponseBody
    public Map<String, Object> couponProcess(
            HttpSession session, 
            @RequestParam("randomNo") String serialNo) {
        
        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        Map<String, Object> result = new HashMap<>();

        if (authUser == null) {
            result.put("status", "error");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        return mypageCouponService.registerCoupon(authUser.getUserNumber(), serialNo);
    }
    
}
