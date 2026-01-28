package admin.command; // 프로퍼티즈에 적은 패키지명

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import command.CommandHandler; // 프로젝트의 핸들러 인터페이스
import admin.service.TagService;

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