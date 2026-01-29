package fila.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.domain.StyleDTO;
import fila.admin.service.StyleService;

public class StyleDetailHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        StyleService service = StyleService.getInstance();
        String idParam = request.getParameter("id");
        
        // Ajax 요청인지 확인 (모달용 호출인지 판별)
        String xRequestedWith = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);

        // 1. id 파라미터가 있는 경우
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int styleId = Integer.parseInt(idParam);
                StyleDTO style = service.getStyleFullDetail(styleId);
                
                if (style == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return null;
                }
                request.setAttribute("style", style);

                if (isAjax) {
                    // [Case A] 모달 호출 (Ajax): 모달의 알맹이 HTML만 보냄
                    return "/view/product/style_modal_content.jsp";
                } else {
                    // [Case B] 메인에서 클릭 (페이지 이동): 
                    // 전체 목록 데이터를 함께 담아서 상세페이지(목록+자동모달)를 보여줌
                    List<StyleDTO> styleList = service.getActiveStyleList();
                    request.setAttribute("styleList", styleList);
                    return "/view/product/style_detail.jsp";
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return null;
            }
        }	
        
        // 2. id 파라미터가 없는 경우: 단순 목록 로드
        List<StyleDTO> styleList = service.getActiveStyleList();
        request.setAttribute("styleList", styleList);
        return "/view/product/style_detail.jsp";
    }
}