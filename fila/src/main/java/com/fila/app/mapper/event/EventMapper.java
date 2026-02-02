package com.fila.app.mapper.event;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.event.EventVO;
import com.fila.app.domain.event.EventDetailVO;

@Mapper
public interface EventMapper {

    EventDetailVO selectEventDetail(@Param("eventId") long eventId);

    List<EventVO> selectActiveEvents();

    List<EventVO> selectEventsByCategory(@Param("category") String category);

    int updateViewCount(@Param("eventId") long eventId);

    int updateEventStatus(@Param("eventId") long eventId, @Param("isActive") int isActive);
}