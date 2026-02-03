package com.fila.app.domain.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StyleImageVO {
    private int styleImageId;
    private int styleId;
    private String imageUrl;
    private int isMain;      // 1: 메인, 0: 일반
    private int sortOrder;
    private String altText;
}
