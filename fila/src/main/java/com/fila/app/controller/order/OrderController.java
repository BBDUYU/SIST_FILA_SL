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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fila.app.domain.admin.UserInfoVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.mypage.coupon.MypageCouponVO;
import com.fila.app.domain.order.OrderItemVO;
import com.fila.app.domain.order.OrderVO;
import com.fila.app.domain.product.ProductsVO;
import com.fila.app.mapper.address.AddressMapper;
import com.fila.app.mapper.admin.CouponMapper;
import com.fila.app.mapper.cart.CartMapper;
import com.fila.app.mapper.order.OrderMapper;
import com.fila.app.mapper.product.UserProductMapper;
import com.fila.app.service.admin.AdminUserService;
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
	private OrderMapper orderMapper;
	@Autowired
    private MypageCouponService mypageCouponService;
	@Autowired
	private AdminUserService adminUserService;
	
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
           
                for (OrderItemVO item : orderItems) {
                    if(item.getPrice() == 0 && item.getOriginalPrice() == 0) {
                        ProductsVO p = productMapper.getProduct(item.getProductId());
                        item.setOriginalPrice(p.getPrice());
                        item.setPrice(p.getPrice() * (100 - p.getDiscountRate()) / 100);
                    }
                }
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

        int myPoint = orderMapper.getUserPointBalance(userNumber); // 🚩 실제 DB 조회
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

    @Transactional(rollbackFor = Exception.class) // 🚩 트랜잭션 보장 (에러 시 전체 취소)
    @PostMapping(value = "/processOrder.htm")
    public String orderSubmit(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, String> param,
            RedirectAttributes rttr
    ) {
        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        if (authUser == null) return "redirect:/login.htm";

        int userNumber = authUser.getUserNumber();

        try {
            // 1) 주문 번호 먼저 생성 (모든 테이블에 공통으로 쓰임)
            String orderId = orderMapper.generateOrderId();

            // 2) 파라미터 수집
            int addressId = Integer.parseInt(param.get("addressId"));
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

            // 3) 주문 객체 생성 및 orderId 세팅
            OrderVO order = OrderVO.builder()
                    .orderId(orderId) // 🚩 주입
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

            // 4) 주문 아이템 리스트 구성
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

            // 5) [핵심] 모든 아이템에 OrderId 부여 및 재고 차감
            for (OrderItemVO item : items) {
                item.setOrderId(orderId); // 🚩 여기서 확실히 모든 아이템에 orderId 주입
                
                // 재고 감소 로직
                int stockResult = orderMapper.updateDecreaseStock(item.getCombinationId(), item.getQuantity());
                if (stockResult == 0) {
                    throw new RuntimeException("상품 재고가 부족하거나 옵션 정보가 잘못되었습니다.");
                }
            }

            // 6) DB 처리 (부모 -> 자식 순서)
            orderMapper.insertOrder(order); // 부모 테이블(ORDERS) 먼저 저장

            for (OrderItemVO item : items) {
                item.setOrderId(orderId); // 생성된 주문번호 세팅
                
                // 🚩 여기서 하나씩 DB에 저장합니다.
                orderMapper.insertOrderItem(item); 
                
                // 재고 감소 로직
                int stockResult = orderMapper.updateDecreaseStock(item.getCombinationId(), item.getQuantity());
                if (stockResult == 0) {
                    throw new RuntimeException("상품 재고가 부족합니다.");
                }
            }
            orderMapper.insertPayment(orderId, order.getTotalAmount(), order.getPaymentMethod());

            // 7) 포인트 및 쿠폰 처리
            if (order.getUsedPoint() > 0) {
                orderMapper.insertPointHistory(order.getUserNumber(), orderId, order.getUsedPoint());
            } else {
                int rewardPoint = (int) (order.getTotalAmount() * 0.05);
                if (rewardPoint > 0) orderMapper.insertOrderPoint(order.getUserNumber(), rewardPoint, orderId);
            }

            if (order.getUserCouponId() > 0) {
                orderMapper.updateCouponUsed(order.getUserCouponId());
            }

            // 8) 장바구니 비우기
            if (cartItemIds != null && !cartItemIds.isEmpty()) {
                cartMapper.deleteCartItems(cartItemIds, order.getUserNumber());
            }

            UserInfoVO newSummary = adminUserService.getMyPageSummary(userNumber);
            session.setAttribute("summary", newSummary);
            
            return "redirect:/order/complete.htm?orderId=" + orderId;

        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("error", e.getMessage());
            return "redirect:/order/orderForm.htm"; 
        }
    }

    @GetMapping("/complete.htm")
    public String orderComplete(@RequestParam("orderId") String orderId, Model model) {
        OrderVO order = orderMapper.selectOrderById(orderId);
        if (order != null) {
            List<OrderItemVO> items = orderMapper.selectOrderItemsDetail(orderId);
            order.setOrderItems(items);
            model.addAttribute("order", order);
        }
        return "complete";
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

 // OrderController.java

    @GetMapping(value = "/api/mycoupon_ajax.htm", produces = "text/html; charset=utf-8") // 🚩 타입을 html로 변경
    @ResponseBody
    public String myCouponAjax(HttpSession session) {
        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        if (authUser == null) return "<li>로그인이 필요합니다.</li>";

        List<MypageCouponVO> list = mypageCouponService.getMyCouponList(authUser.getUserNumber());
        
        if (list == null || list.isEmpty()) {
            return "<li><p class='txt1'>선택 가능한 쿠폰이 없습니다.</p></li>";
        }

        StringBuilder sb = new StringBuilder();
        for (MypageCouponVO cpn : list) {
            String priceText = "PERCENT".equals(cpn.getDiscountType()) 
                               ? cpn.getDiscountValue() + "%" 
                               : String.format("%,d원", cpn.getDiscountValue());

            sb.append("<li>");
            sb.append("    <input type='radio' id='cpRd_").append(cpn.getUserCouponId()).append("' name='popupCoupon3' ");
            sb.append("           class='rd__style1' value='").append(cpn.getUserCouponId()).append("' ");
            sb.append("           data-name='").append(cpn.getCouponName()).append("' ");
            sb.append("           data-type='").append(cpn.getDiscountType()).append("' ");
            sb.append("           data-val='").append(cpn.getDiscountValue()).append("'>");
            sb.append("    <label for='cpRd_").append(cpn.getUserCouponId()).append("'></label>");
            sb.append("    <div style='margin-left:40px;'>");
            sb.append("        <p class='txt1' style='font-weight:bold; color:#333;'>").append(cpn.getCouponName()).append("</p>");
            sb.append("        <p class='txt2' style='color:#ff0000; font-size:13px;'>").append(priceText).append(" 할인 쿠폰</p>");
            sb.append("    </div>");
            sb.append("</li>");
        }
        return sb.toString();
    }

    @PostMapping("/coupon_process.htm") 
    @ResponseBody
    public void couponProcess(
            HttpSession session, 
            @RequestParam("randomNo") String serialNo,
            javax.servlet.http.HttpServletResponse response) throws java.io.IOException {
        
        // 한글 깨짐 방지
        response.setContentType("text/plain; charset=utf-8");
        
        MemberVO authUser = (MemberVO) session.getAttribute("auth");
        if (authUser == null) {
            response.getWriter().print("login_required");
            return;
        }

        Map<String, Object> result = mypageCouponService.registerCoupon(authUser.getUserNumber(), serialNo);
        
        if ("success".equals(result.get("status"))) {
        	UserInfoVO newSummary = adminUserService.getMyPageSummary(authUser.getUserNumber());
            session.setAttribute("summary", newSummary);
            response.getWriter().print("success");
        } else {
            response.getWriter().print(result.get("message"));
        }
    }
    
}
