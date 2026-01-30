package com.fila.app.domain.product;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductsOptionVO {
    
	// DB 컬럼과 매핑되는 필드들 (CamelCase 권장)
    private int combinationId;   // PK
    private String groupName;    // 옵션 종류 (색상, 사이즈)
    private String optionValue;  // 옵션 값 (90, 100 등)
    private int stock;           // 재고량
    private String productId;  

}
