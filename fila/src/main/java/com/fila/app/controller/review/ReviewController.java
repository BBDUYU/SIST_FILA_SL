package com.fila.app.controller.review;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fila.app.domain.review.ReviewVO;
import com.fila.app.service.review.ReviewService;

import lombok.Setter;

@Controller
@RequestMapping("/review/*")
public class ReviewController {

    @Setter(onMethod_ = @Autowired)
    private ReviewService reviewService;
    
    // [POST] 리뷰 등록 처리
    @PostMapping("/write.do")
    public String write(
            ReviewVO review, 
            @RequestParam("reviewFile") MultipartFile file, 
            HttpServletRequest request,
            Model model
            ) throws Exception {

        // 1. 파일 업로드 처리
        if (!file.isEmpty()) {
            // [수정 1] 서버 내부 경로(getRealPath)가 아니라, 고정된 로컬 경로(C드라이브) 사용
            String uploadFolder = "C:\\fila_upload\\review"; 
            
            File saveDir = new File(uploadFolder);
            if (!saveDir.exists()) saveDir.mkdirs(); // 폴더 없으면 생성
            
            // [권장] 파일명 중복 방지를 위해 UUID 추가 (선택사항)
            String uuid = java.util.UUID.randomUUID().toString();
            String originalName = file.getOriginalFilename();
            String fileName = uuid + "_" + originalName;
            
            // 실제 파일 저장 (C:\fila_upload\review\_파일명.jpg)
            File saveFile = new File(uploadFolder, fileName);
            file.transferTo(saveFile);
            
            // [수정 2] DB에는 웹 접근 경로("/upload/review/...")로 저장
            // servlet-context.xml 의 mapping="/upload/**" 설정 덕분에 연결됨
            // (주의: VO 필드명이 review_img라면 setReview_img 로 쓰셔야 합니다)
            review.setReviewImg("/upload/review/" + fileName);
        }

        // 2. 서비스 호출
        int result = reviewService.writeReview(review);
        
        // 3. 결과 페이지 이동
        if (result == 1) {
            model.addAttribute("msg", "리뷰가 정상적으로 등록되었습니다.");
            // (주의: VO 필드명이 product_id라면 getProduct_id 로 쓰셔야 합니다)
            model.addAttribute("loc", "/product/detail?product_id=" + review.getProductId());
        } else {
            model.addAttribute("msg", "리뷰 등록 실패.");
            model.addAttribute("loc", "javascript:history.back()");
        }
        
        return "common/message"; 
    }
    
    // [AJAX] 리뷰 목록 가져오기 (비동기 로딩용)
    @GetMapping("/list")
    public String list(
            @RequestParam("productId") String productId,
            @RequestParam(value="ratingArr", required=false) String[] ratingArr,
            @RequestParam(value="userNumber", defaultValue="0") int userNumber,
            @RequestParam(value="sort", defaultValue="latest") String sort,
            @RequestParam(value="keyword", required=false) String keyword,
            Model model
            ) {
        
        List<ReviewVO> list = reviewService.getReviewList(productId, ratingArr, userNumber, sort, keyword);
        Map<String, Object> summary = reviewService.getReviewSummary(productId);
        
        model.addAttribute("reviewList", list);
        model.addAttribute("reviewSummary", summary);
        
        // JSP 조각 파일(Fragment)을 리턴해서 화면 일부분만 갱신
        return "review/review_list_fragment"; 
    }
}
