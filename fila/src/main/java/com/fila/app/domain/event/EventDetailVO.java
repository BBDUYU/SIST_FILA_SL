package com.fila.app.domain.event;

import java.util.ArrayList;
import java.util.List;

public class EventDetailVO {
    private EventVO event;
    private List<SectionVO> sections = new ArrayList<>();

    public EventVO getEvent() { return event; }
    public void setEvent(EventVO event) { this.event = event; }
    public List<SectionVO> getSections() { return sections; }
    public void setSections(List<SectionVO> sections) { this.sections = sections; }
}
