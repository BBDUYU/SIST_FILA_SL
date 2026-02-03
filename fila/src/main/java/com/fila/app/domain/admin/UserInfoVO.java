package com.fila.app.domain.admin;

import java.util.Date;
import java.util.List;

import com.fila.app.domain.order.OrderVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserInfoVO {
	//유저
	private int userNumber;
	private String name;
	private String id; 
	private String email;
	private String password;
	private String phone;
	private String role;
	private Date createAt;
	private Date updatedAt;
	private Date birthday;
	private String gender;
	private String marketingAgree;
	private String marketingType;
	private String grade;
	private String kakaoid;
	private String naverid;
	
	//포인트
	private int pointId;
	private String orderId;
	private String type;
	private int amout;
	private int balance;
	private String description;
	
	//자녀정보
	private int childId;
	private String childName;
	private Date childBirth;
	private String childGender;
	
	//배송지
	private int addressId;
	private String addressName;
	private String recipientName;
	private String recipientPhone;
	private String zipCode;
	private String mainAddr;
	private String detailAddr;
	private String isDefault;
	
	//주문상세정보
	private int orderItemId;
	private int quantity;
	private int price;
	private String cancelStatus;
	private String cancelReason;
	private Date statusUpdatedAt;
	private String productId;
	
	//회원보유쿠폰
	private int userCouponId;
	private int couponId;
	private String isUsed;
	private Date usedAt;
	private Date expiredDate;
	private Date receivedAt;
	private String couponName;          
	private String discountType;
	
	//문의 내역
	private int inquiryId;
	private int categoryId;
	private String title;
	private String content;
	private String imageUrl;
	private String status;
	private String reply;
	private Date replyAt;
	
	// UserInfoDTO.java 내부에 추가
	private java.util.List<UserInfoVO> childList;
	private java.util.List<UserInfoVO> pointList;
	private java.util.List<UserInfoVO> couponList;
	private List<OrderVO> orderList;
	
	private int couponCount; // 보유 쿠폰 개수
	private int wishCount;   // 위시리스트 상품 개수
	private int orderCount;  // 총 주문 건수
}
