package com.fila.app.domain.categories;


import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CategoriesVO {
	private int categoryId;
	   private String name;
	   private Integer parentId;
	   private int depth;
	   private Date createdAt;
	   private Date updatedAt;
	   private int useYn;
   
	   private int productCount;
}