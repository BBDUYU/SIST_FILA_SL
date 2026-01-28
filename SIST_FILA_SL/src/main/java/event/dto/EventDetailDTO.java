package event.dto;

import java.util.ArrayList;
import java.util.List;

public class EventDetailDTO {
    private EventDTO event;
    private List<SectionDTO> sections = new ArrayList<>();

    public EventDTO getEvent() { return event; }
    public void setEvent(EventDTO event) { this.event = event; }
    public List<SectionDTO> getSections() { return sections; }
    public void setSections(List<SectionDTO> sections) { this.sections = sections; }
}
