package com.fila.app.controller.notice;

import java.io.File;
import java.nio.file.Files;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
    // [1. 사용자 기능] NoticeListHandler 대체
    // ==========================================
    @GetMapping("/noticeList")
    public String list(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model
            ) {
        // 사용자용 목록 조회 (이미지 포함된 카드 형태)
        List<NoticeVO> list = noticeService.getNoticeList(category, keyword);
        model.addAttribute("noticeList", list);
        return "notice_list"; 
    }
    
    // [추가] 이미지 출력 기능 (imageDisplay.htm 대체)
    // <img src="/notice/display?fileName=사진.jpg"> 처럼 사용
    @GetMapping("/display")
    public ResponseEntity<byte[]> getFile(String fileName) {
    	File file = new File("C:\\fila_upload\\notice\\" + fileName); // 실제 업로드 경로
        ResponseEntity<byte[]> result = null;
        try {
            HttpHeaders header = new HttpHeaders();
            header.add("Content-Type", Files.probeContentType(file.toPath()));
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // ==========================================
    // [2. 관리자 기능] NoticeManageHandler 대체
    // ==========================================
    @GetMapping("/admin/noticeManage")
    public String adminList(Model model) {
        // 관리자용 목록 조회 (전체 조회, 표 형태)
        List<NoticeVO> list = noticeService.getNoticeList(null, null); 
        
        model.addAttribute("noticeList", list);
        model.addAttribute("pageName", "notice"); // 사이드바 활성화용
        
        return "notice_admin_list"; 
    }

    // ==========================================
    // [3. 관리자 상세] NoticeDetailHandler 대체
    // ==========================================
    @GetMapping("/admin/noticeDetail")
    public String adminDetail(@RequestParam("id") int noticeId, Model model) {
        NoticeVO dto = noticeService.getNoticeDetail(noticeId);
        
        // 데이터가 없으면 목록으로 리다이렉트 (방어 코드)
        if (dto == null) {
            return "redirect:/notice/admin/list";
        }
        
        model.addAttribute("dto", dto);
        model.addAttribute("pageName", "notice");
        
        return "notice_detail";
    }

    // ==========================================
    // [4. 관리자 글쓰기] NoticeWriteHandler 대체
    // ==========================================
    
    // 글쓰기 폼 (GET)
    @GetMapping("/admin/noticeWrite")
    public String writeForm(Model model) {
        model.addAttribute("pageName", "notice");
        return "notice_admin_write";
    }

    // 글쓰기 처리 (POST)
    @PostMapping("/admin/noticeWrite")
    public String writePro(NoticeVO notice, HttpSession session) {
        // 1. 세션에서 관리자 ID 가져오기 (방어 로직 포함)
        // (LoginController에서 세션에 "auth"나 "id"로 저장했다고 가정)
        String createdId = "admin"; // 임시 기본값
        
        // 실제로는 아래처럼 세션에서 꺼내 써야 함
        // MemberVO member = (MemberVO) session.getAttribute("auth");
        // if(member != null) createdId = member.getId();
        
        notice.setCreatedId(createdId);

        // 2. 서비스 호출 (DB 저장)
        int result = noticeService.writeNotice(notice);

        // 3. 성공/실패 페이지 이동
        if (result > 0) {
            return "redirect:/admin/noticeManage"; // 성공 시 목록으로
        } else {
            return "redirect:/admin/noticeWrite"; // 실패 시 다시 글쓰기로
        }
    }

    // ==========================================
    // [5. 관리자 삭제] NoticeDeleteHandler 대체
    // ==========================================
    @PostMapping("/admin/notice_delete")
    public String delete(@RequestParam("id") int noticeId) {
        // 서비스 호출 (삭제 실행)
        noticeService.removeNotice(noticeId);
        
        // 결과 상관없이 목록으로 리다이렉트 (기존 핸들러 로직 유지)
        return "redirect:/admin/noticeManage";
    }
    
    // ==========================================
    // [6. 이미지 업로드] ImageUploadHandler 대체
    // ==========================================
    @PostMapping("/upload/image")
    @ResponseBody
    public String uploadAjax(@RequestParam("uploadFile") MultipartFile uploadFile) {
        
        // 1. 저장 경로 설정 (기존과 동일하게 유지)
        String savePath = "C:\\fila_upload\\notice";
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        try {
            // 2. 파일명 생성 (UUID로 중복 방지)
            String uuid = java.util.UUID.randomUUID().toString();
            String originalName = uploadFile.getOriginalFilename();
            String realFileName = uuid + "_" + originalName;

            // 3. 파일 저장 (transferTo 한 줄이면 끝!)
            File saveFile = new File(savePath, realFileName);
            uploadFile.transferTo(saveFile);

            // 4. 클라이언트가 접근할 URL 생성
            // (서버 설정에서 /upload/ 경로가 C:/fila_upload/로 매핑되어 있어야 함)
            String imageUrl = "/upload/notice/" + realFileName;

            // 5. JSON 문자열 리턴 {"url": "/upload/notice/..."}
            return "{\"url\": \"" + imageUrl + "\"}";

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\": \"upload failed\"}";
        }
    }
}