package fila.admin.domain;

import java.util.Date;
import java.util.List;

import fila.order.domain.OrderDTO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserInfoDTO {
	//유저
	private int usernumber;
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
	private String marketingagree;
	private String marketingtype;
	private String grade;
	private String kakaoid;
	private String naverid;
	
	//포인트
	private int pointid;
	private String orderid;
	private String type;
	private int amout;
	private int balance;
	private String description;
	
	//자녀정보
	private int childid;
	private String childname;
	private Date childbirth;
	private String childgender;
	
	//배송지
	private int addressid;
	private String addressname;
	private String recipientname;
	private String recipientphone;
	private String zipcode;
	private String mainaddr;
	private String detailaddr;
	private String isdefault;
	
	//주문상세정보
	private int orderitemid;
	private int quantity;
	private int price;
	private String cancelstatus;
	private String cancelreason;
	private Date statusupdatedat;
	private String productid;
	
	//회원보유쿠폰
	private int usercouponid;
	private int couponid;
	private String isused;
	private Date usedat;
	private Date expireddate;
	private Date receivedat;
	private String coupon_name;          
	private String discount_type;
	
	//문의 내역
	private int inquiryid;
	private int categoryid;
	private String title;
	private String content;
	private String imageurl;
	private String status;
	private String reply;
	private Date replyat;
	
	// UserInfoDTO.java 내부에 추가
	private java.util.List<UserInfoDTO> childList;
	private java.util.List<UserInfoDTO> pointList;
	private java.util.List<UserInfoDTO> couponList;
	private List<OrderDTO> orderList;
	
	private int couponCount; // 보유 쿠폰 개수
	private int wishCount;   // 위시리스트 상품 개수
	private int orderCount;  // 총 주문 건수
}
