package com.fila.app.domain.admin;

import lombok.Data;

@Data
public class StyleImageVO {
    private int styleImageId;
    private int styleId;
    private String imageUrl;
    private int isMain;      // 1: 메인, 0: 일반
    private int sortOrder;
    private String altText;
}
