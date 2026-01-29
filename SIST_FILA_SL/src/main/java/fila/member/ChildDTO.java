package fila.member;

import java.util.Date;

import fila.order.domain.OrderDTO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChildDTO {
	private String childName;
    private String childBirth; // YYYYMMDD 형식
    private String childGender;
}
