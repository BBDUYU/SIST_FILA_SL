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
        return "admin/tag_list";
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
    
    // 참고: 기존 핸들러에 있던 수정/상태변경 로직은 
    // 서비스 인터페이스에 해당 메서드가 정의되어 있다면 추가 구현이 가능합니다.
}