package fila.categories.domain;


import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CategoriesDTO {
   private int category_id;
   private String name;
   private int parent_id;
   private int depth;
   private Date created_at;
   private Date updated_at;
   private int use_yn;
   
   private int product_count;
}