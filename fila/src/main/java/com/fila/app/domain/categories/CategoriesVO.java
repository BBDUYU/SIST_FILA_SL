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
   private int category_id;
   private String name;
   private int parent_id;
   private int depth;
   private Date created_at;
   private Date updated_at;
   private int use_yn;
   
   private int product_count;
}