package fila.admin.command;

import java.sql.Connection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.domain.StyleDTO;
import fila.admin.persistence.StyleDAO;
import fila.admin.service.StyleService;
import fila.com.util.ConnectionProvider;
import fila.command.CommandHandler;

public class StyleListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        StyleService service = StyleService.getInstance();
        
        List<StyleDTO> styleList = service.getStyleList();
        

        request.setAttribute("styleList", styleList);
        
        request.setAttribute("pageName", "style");

        return "/view/admin/style_list.jsp";
    }
}