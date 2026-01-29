package products;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductsOptionDTO {
	private int combinationId;
    private String groupName; // 옵션 종류 (예: "색상", "사이즈")
    private List<String> values = new ArrayList<>(); // 옵션 값 목록

    // ★ 추가: 상세 옵션 데이터용 변수
    private String optionValue; // 사이즈 이름 (예: "90(S)", "100(L)")
    private int stock;          // 재고량

    public ProductsOptionDTO() {}
    public ProductsOptionDTO(String groupName) {
        this.groupName = groupName;
    }

    public void addValue(String value) {
        this.values.add(value);
    }
    
}