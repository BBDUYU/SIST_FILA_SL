package fila.search;


import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SearchDTO {
	private int keyword_id;
	private String keyword;
	private int search_count;
	private Date last_search_date;
}
