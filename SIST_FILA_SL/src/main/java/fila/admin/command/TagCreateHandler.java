package fila.admin.command; // 프로퍼티즈에 적은 패키지명

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.service.TagService;
import fila.command.CommandHandler;

public class TagCreateHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        String tagName = request.getParameter("tagName");

        if (tagName != null && !tagName.trim().isEmpty()) {
            TagService tagService = TagService.getInstance();
            tagService.createTag(tagName.trim());
        }

        response.sendRedirect(request.getContextPath() + "/admin/tagList.htm");
        
        return null; 
    }
}