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
	private int coupon_id;
	private String name;
	private String discount_type;
	private int discount_value;
	private Date expires_at;
	private Timestamp created_at;
	private String status;
	private String serial_number; 
}
