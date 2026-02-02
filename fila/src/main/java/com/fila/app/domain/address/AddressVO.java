package com.fila.app.domain.address;

import lombok.Data;

@Data
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
