package com.fila.app.mapper.address;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.address.AddressVO;

public interface AddressMapper {

	// 기본배송지 해제
	int clearDefault(@Param("userNumber") int userNumber) throws SQLException;

	// INSERT
	int insert(AddressVO dto) throws SQLException;

	// UPDATE (본인 주소만)
	int update(AddressVO dto) throws SQLException;

	// 내 배송지 전체 조회 (기본배송지 먼저)
	List<AddressVO> selectListByUser(@Param("userNumber") int userNumber) throws SQLException;

	// 기본 배송지
	int setDefault(@Param("addressId") int addressId,
			@Param("userNumber") int userNumber) throws SQLException;

	// 해당 주소가 기본배송지인지 확인 (본인 것만)
	int isDefault(@Param("addressId") int addressId,
			@Param("userNumber") int userNumber) throws SQLException;

	// DELETE (본인 주소만)
	int delete(@Param("addressId") int addressId,
			@Param("userNumber") int userNumber) throws SQLException;

	// 주문 참조 여부
	int hasOrderReference(@Param("addressId") int addressId,
            @Param("userNumber") int userNumber) throws SQLException;

	// 단건 조회 (본인 주소만)
	AddressVO selectOneById(@Param("addressId") int addressId,
			@Param("userNumber") int userNumber) throws SQLException;
}
