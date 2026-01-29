package admin.command;

import java.sql.Connection;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.util.ConnectionProvider;

import command.CommandHandler;
import categories.CategoriesDAO;
import categories.CategoriesDTO;
import admin.service.TagService;

public class TagListHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String command = request.getRequestURI();
        // 싱글톤 인스턴스 가져오기
    	TagService tagService = TagService.getInstance();
    	// 수정 시 (POST 방식)
    	if (command.contains("editTag.htm")) {
    	    int id = Integer.parseInt(request.getParameter("categoryId"));
    	    String name = request.getParameter("tagName");
    	    
    	    try (Connection conn = ConnectionProvider.getConnection()) {
    	        CategoriesDAO.getInstance().updateTag(conn, id, name);
    	    }
    	    response.sendRedirect(request.getContextPath() + "/admin/tagList.htm");
    	    return null;
    	}

    	// 삭제 시 (GET 방식)
    	else if (command.contains("toggleTag.htm")) {
    	    int id = Integer.parseInt(request.getParameter("id"));
    	    int status = Integer.parseInt(request.getParameter("status")); // 0 또는 1
    	    
    	    try (Connection conn = ConnectionProvider.getConnection()) {
    	        // 기존에 만든 deleteTag 메서드명을 updateStatus 등으로 바꾸거나 그대로 사용
    	        // 여기서는 전달받은 status 값으로 USE_YN을 업데이트합니다.
    	        CategoriesDAO.getInstance().updateTagStatus(conn, id, status);
    	    } catch (Exception e) {
    	        e.printStackTrace();
    	    }
    	    
    	    response.sendRedirect(request.getContextPath() + "/admin/tagList.htm");
    	    return null; 
    	}
        // 태그 목록 가져오기
        ArrayList<CategoriesDTO> tagList = tagService.getTagList();
        
        // JSP로 데이터 전달
        request.setAttribute("tagList", tagList);
        
        // 뷰 경로 (환경에 맞게 수정)
        return "/view/admin/tag_list.jsp";
    }
}