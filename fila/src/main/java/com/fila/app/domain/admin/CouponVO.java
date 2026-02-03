package com.fila.app.domain.admin;


import java.sql.Date;
import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CouponVO {
	private int couponId;
	private String name;
	private String discountType;
	private int discountValue;
	private Date expiresAt;
	private Timestamp createdAt;
	private String status;
	private String serialNumber; 
}
