package com.fila.app.controller.admin;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.categories.CategoriesVO;
import com.fila.app.domain.admin.ProductVO;
import com.fila.app.service.admin.AdminTagService;

@Controller
@RequestMapping("/admin")
public class AdminTagController {

    @Autowired
    private AdminTagService adminTagService;

    /**
     * 1. 태그 목록 조회
     */
    @RequestMapping(value = "/tagList.htm", method = RequestMethod.GET)
    public String tagList(Model model) {
        List<CategoriesVO> list = adminTagService.getTagList();
        model.addAttribute("tagList", list);
        return "tag_list";
    }

    /**
     * 2. 신규 태그 등록 (POST)
     */
    @RequestMapping(value = "/createTag.htm", method = RequestMethod.POST)
    public String createTag(@RequestParam("tagName") String tagName) {
        if (tagName != null && !tagName.trim().isEmpty()) {
            adminTagService.createTag(tagName.trim());
        }
        return "redirect:/admin/tagList.htm";
    }

    /**
     * 3. 특정 태그에 속한 상품 목록 조회 (AJAX용으로 적합)
     * 서비스의 getProductsByTag(int tagId) 호출
     */
    @RequestMapping(value = "/tagProducts.htm", method = RequestMethod.GET)
    @ResponseBody
    public List<ProductVO> getTagProducts(@RequestParam("tagId") int tagId) {
        return adminTagService.getProductsByTag(tagId);
    }
    
    /**
     * 4. 태그 수정
     */
    @RequestMapping(value = "/editTag.htm", method = RequestMethod.POST)
    public String editTag(@RequestParam("categoryId") int categoryId, 
                          @RequestParam("tagName") String tagName) {
        adminTagService.updateTag(categoryId, tagName);
        return "redirect:/admin/tagList.htm";
    }

    /**
     * 5. 태그 상태 변경 (사용/중지)
     */
    @RequestMapping(value = "/toggleTag.htm", method = RequestMethod.GET)
    public String toggleTag(@RequestParam("id") int categoryId, 
                            @RequestParam("status") int status) {
        adminTagService.updateTagStatus(categoryId, status);
        return "redirect:/admin/tagList.htm";
    }
}