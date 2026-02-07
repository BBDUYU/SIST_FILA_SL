package com.fila.app.domain.address;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AddressVO {

	private int addressId;
	private int userNumber;
	private String addressName;
	private String recipientName;
	private String recipientPhone;
	private String zipcode;
	private String mainAddr;
	private String detailAddr;
	private int isDefault;
}
