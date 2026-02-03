package com.fila.app.domain.search;


import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SearchVO {
	private int keywordId;
	private String keyword;
	private int searchCount;
	private Date lastSearchDate;
}
