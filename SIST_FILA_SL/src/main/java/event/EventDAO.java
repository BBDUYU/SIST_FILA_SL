package event;

import event.dto.*;
import products.ProductsDTO;

import java.sql.*;
import java.util.*;

public class EventDAO {

    public EventDetailDTO selectEventDetail(Connection con, long eventId) throws SQLException {
        EventDTO event = selectEvent(con, eventId);
        if (event == null) return null;

        List<SectionDTO> sections = selectSections(con, eventId);
        Map<Integer, SectionDTO> sectionMap = new LinkedHashMap<>();
        for (SectionDTO s : sections) {
            // 섹션 제목 컬럼이 없다면 임시로 이렇게라도
            s.setTitle("SECTION " + s.getSectionId());
            sectionMap.put(s.getSectionId(), s);
        }

        if (!sectionMap.isEmpty()) {
            attachSectionImages(con, eventId, sectionMap);
            attachSectionProducts(con, sectionMap);
        }

        EventDetailDTO detail = new EventDetailDTO();
        detail.setEvent(event);
        detail.setSections(new ArrayList<>(sectionMap.values()));
        System.out.println("sections size=" + sections.size());
        System.out.println("sectionMap keys=" + sectionMap.keySet());
        return detail;
    }

    private EventDTO selectEvent(Connection con, long eventId) throws SQLException {
        String sql = "SELECT EVENT_ID, EVENT_NAME, EVENT_CATEGORY, SLUG, DESCRIPTION, START_AT, END_AT, IS_ACTIVE " +
                     "FROM EVENT WHERE EVENT_ID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                EventDTO e = new EventDTO();
                e.setEventId(rs.getInt("EVENT_ID"));
                e.setEventName(rs.getString("EVENT_NAME"));
                e.setEventCategory(rs.getString("EVENT_CATEGORY"));
                e.setSlug(rs.getString("SLUG"));
                e.setDescription(rs.getString("DESCRIPTION"));
                e.setStartAt(rs.getDate("START_AT"));
                e.setEndAt(rs.getDate("END_AT"));
                e.setIsActive(rs.getInt("IS_ACTIVE"));
                return e;
            }
        }
    }

    private List<SectionDTO> selectSections(Connection con, long eventId) throws SQLException {
        String sql = "SELECT SECTION_ID, EVENT_ID, SORT_ORDER " +
                     "FROM EVENT_SECTION WHERE EVENT_ID = ? ORDER BY SORT_ORDER";
        List<SectionDTO> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                	SectionDTO s = new SectionDTO();
                    s.setSectionId(rs.getInt("SECTION_ID"));
                    s.setEventId(rs.getInt("EVENT_ID"));
                    int v = rs.getInt("SORT_ORDER");
                    s.setSortOrder(rs.wasNull() ? null : v);
                    list.add(s);
                }
            }
        }
        return list;
    }

    private void attachSectionImages(Connection con, long eventId, Map<Integer, SectionDTO> sectionMap) throws SQLException {
        String sql =
            "SELECT " +
            "  ES.SECTION_ID, " +
            "  ESI.SECTION_IMAGE_ID, " +
            "  ESI.IMAGE_URL, " +
            "  ESI.ALT_TEXT, " +
            "  ESI.LINK_URL, " +
            "  ESI.SORT_ORDER AS IMAGE_SORT " +
            "FROM EVENT_SECTION ES " +
            "JOIN EVENT_SECTION_IMAGE ESI ON ES.SECTION_ID = ESI.SECTION_ID " +
            "WHERE ES.EVENT_ID = ? " +
            "ORDER BY ES.SORT_ORDER, ESI.SORT_ORDER";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, eventId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int sectionId = rs.getInt("SECTION_ID");

                    SectionImageDTO img = new SectionImageDTO();
                    img.setSectionImageId(rs.getInt("SECTION_IMAGE_ID"));
                    img.setSectionId(sectionId);
                    img.setImageUrl(rs.getString("IMAGE_URL"));
                    img.setAltText(rs.getString("ALT_TEXT"));
                    img.setLinkUrl(rs.getString("LINK_URL"));

                    int v = rs.getInt("IMAGE_SORT");
                    img.setSortOrder(rs.wasNull() ? null : v);

                    SectionDTO sec = sectionMap.get(sectionId);
                    if (sec != null) sec.getImages().add(img);
                }
            }
        }
    }


    private void attachSectionProducts(Connection con, Map<Integer, SectionDTO> sectionMap) throws SQLException {
        String sql =
            "SELECT ep.SECTION_ID, p.PRODUCT_ID, p.NAME, p.PRICE, p.VIEW_COUNT, p.STATUS, p.DISCOUNT_RATE " +
            "FROM EVENT_PRODUCT ep " +
            "JOIN PRODUCTS p ON p.PRODUCT_ID = ep.PRODUCT_ID " +
            "WHERE ep.SECTION_ID = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (Integer sectionId : sectionMap.keySet()) {
                ps.setLong(1, sectionId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                    	ProductsDTO p = new ProductsDTO();
                        p.setProduct_id(rs.getString("PRODUCT_ID"));
                        p.setName(rs.getString("NAME"));
                        p.setPrice(rs.getInt("PRICE"));
                        p.setView_count( rs.getInt("VIEW_COUNT"));
                        p.setStatus(rs.getString("STATUS"));
                        int v = rs.getInt("DISCOUNT_RATE");
                        p.setDiscount_rate(rs.wasNull() ? null : v);

                        sectionMap.get(sectionId).getProducts().add(p);
                    }
                }
            }
        }
    }
}
