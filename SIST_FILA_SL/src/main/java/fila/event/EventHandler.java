package fila.event;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.com.util.ConnectionProvider;
import fila.com.util.JdbcUtil;
import fila.command.CommandHandler;
import fila.event.EventDAO;
import fila.event.dto.EventDetailDTO;

public class EventHandler implements CommandHandler {

    private final EventDAO eventDao = new EventDAO();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // 1) 파라미터 받기
        long eventId;
        try {
            eventId = Long.parseLong(request.getParameter("eventId"));
        } catch (Exception e) {
            // 파라미터 없거나 이상하면 바로 400 처리(원하면 기본값 1로 바꿔도 됨)
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "eventId is required");
            return null;
        }

        System.out.println("[EventDetailHandler] called. eventId=" + eventId);

        Connection con = null;
        try {
            con = ConnectionProvider.getConnection();

            // 2) DB 조회
            EventDetailDTO detail = eventDao.selectEventDetail(con, eventId);

            if (detail == null) {
                System.out.println("[EventDetailHandler] Event not found. eventId=" + eventId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
                return null;
            }

            // 3) JSP에서 쓰게 request에 담기
            request.setAttribute("detail", detail);
            request.setAttribute("event", detail.getEvent());
            request.setAttribute("sections", detail.getSections());

            System.out.println("[EventDetailHandler] sections size=" + detail.getSections().size());

            // 4) view 리턴 (DispatcherServlet이 forward 해줌)
            return "/view/event/event.jsp";

        } finally {
            JdbcUtil.close(con);
        }
    }
}
