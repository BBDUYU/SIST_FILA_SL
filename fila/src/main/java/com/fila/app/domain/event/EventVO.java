package com.fila.app.domain.event;
import java.util.Date;

import com.fila.app.domain.admin.StyleImageVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class EventVO {
    private int eventId;
    private String eventName;
    private String eventCategory;
    private String slug;
    private String description;
    private Date startAt;
    private Date endAt;
    private int isActive; // DB NUMBER(1) 반영
}