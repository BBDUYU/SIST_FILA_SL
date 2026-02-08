package com.fila.app.controller.notice;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fila.app.domain.notice.NoticeVO;
import com.fila.app.service.notice.NoticeService;

import lombok.Setter;

@Controller
public class NoticeController {

    @Setter(onMethod_ = @Autowired)
    private NoticeService noticeService;

    // ==========================================
    // [1. 사용자 목록]
    // ==========================================
    @GetMapping({"/noticeList.htm", "/notice/list"}) 
    public String list(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model
            ) {
        
        List<NoticeVO> list = noticeService.getNoticeList(category, keyword);
        model.addAttribute("noticeList", list);
        
        return "notice_list"; 
    }

    // ==========================================
    // [2. 관리자 목록]
    // ==========================================
    @GetMapping("/admin/noticeManage.htm")
    public String adminList(Model model) {
        List<NoticeVO> list = noticeService.getNoticeList(null, null); 
        model.addAttribute("noticeList", list);
        model.addAttribute("pageName", "notice");
        return "notice_admin_list";
    }

    // ==========================================
    // [3. 관리자 상세]
    // ==========================================
    @GetMapping({"/admin/noticeDetail.htm", "/notice/admin/detail"})
    public String adminDetail(@RequestParam("id") int noticeId, Model model) {
        NoticeVO dto = noticeService.getNoticeDetail(noticeId);
        
        if (dto == null) {
            return "redirect:/admin/noticeManage.htm";
        }
        
        model.addAttribute("dto", dto);
        model.addAttribute("pageName", "notice");
        
        // JSP 파일 위치 확인 필수 (views/admin/notice_detail.jsp 라면 아래처럼)
        return "admin/notice_detail"; 
    }

    // ==========================================
    // [4. 관리자 글쓰기 폼]
    // ==========================================
    @GetMapping("/admin/noticeWrite")
    public String writeForm(Model model) {
        model.addAttribute("pageName", "notice");
        return "notice_admin_write";
    }

    // ==========================================
    // [5. 관리자 글쓰기 처리]
    // ==========================================
    @PostMapping("/admin/noticeWrite.htm")
    public String writePro(NoticeVO notice, HttpSession session) {
        String createdId = "admin";
        notice.setCreatedId(createdId);

        int result = noticeService.writeNotice(notice);

        if (result > 0) {
            return "redirect:/admin/noticeManage.htm";
        } else {
            return "redirect:/admin/noticeWrite.htm";
        }
    }

    // ==========================================
    // [6. 관리자 삭제]
    // ==========================================
    @org.springframework.web.bind.annotation.RequestMapping({"/admin/notice_delete.htm", "/notice/admin/delete"}) 
    public String delete(@RequestParam("id") int noticeId) {
        noticeService.removeNotice(noticeId);
        return "redirect:/admin/noticeManage.htm";
    }
    
    // ==========================================
    // [7. 이미지 업로드] (관리자 에디터용) - 미리보기 수정완료!
    // ==========================================
    @PostMapping(value = "/admin/imageUpload.htm")
    @ResponseBody
    public String uploadAjax(@RequestParam("uploadFile") MultipartFile uploadFile, HttpServletRequest request) {
        
        // [1] 저장 경로: 조장님 규칙(C:/fila_upload/notice/)
        String savePath = "C:\\fila_upload\\notice";
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        try {
            String uuid = UUID.randomUUID().toString();
            String originalName = uploadFile.getOriginalFilename();
            String realFileName = uuid + "_" + originalName;

            File saveFile = new File(savePath, realFileName);
            uploadFile.transferTo(saveFile);

            String imageUrl = request.getContextPath() + "/displayImage.do?path=" + realFileName;

            return "{\"url\": \"" + imageUrl + "\"}";

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\": \"upload failed\"}";
        }
    }
    
    // ==========================================
    // [8. 멤버십]
    // ==========================================
    @GetMapping("/notice/membership.htm")
    public String membership(Model model) {
        model.addAttribute("pageName", "membership");
        return "membership";
    }
}