package fila.event.dto;
import java.util.Date;
import lombok.Data;

@Data
public class EventDTO {
    private int eventId;
    private String eventName;
    private String eventCategory;
    private String slug;
    private String description;
    private Date startAt;
    private Date endAt;
    private int isActive; // DB NUMBER(1) 반영
}