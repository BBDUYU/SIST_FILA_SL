package member.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import order.domain.OrderDTO;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChildDTO {
	private String childName;
    private String childBirth; // YYYYMMDD Çü½Ä
    private String childGender;
}
