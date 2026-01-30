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
    
    // [POST] 리뷰 등록 처리 (기존 ReviewWrite 핸들러 역할)
    @PostMapping("/write.do")
    public String write(
            ReviewVO review, 
            @RequestParam("reviewFile") MultipartFile file, // 스프링의 파일 업로드 객체
            HttpServletRequest request,
            Model model
            ) throws Exception {

        // 1. 파일 업로드 처리
        if (!file.isEmpty()) {
            // 서버의 실제 저장 경로 찾기
            String uploadFolder = request.getServletContext().getRealPath("/images/review");
            File saveDir = new File(uploadFolder);
            if (!saveDir.exists()) saveDir.mkdirs(); // 폴더 없으면 생성
            
            String fileName = file.getOriginalFilename();
            // 실제 파일 저장
            File saveFile = new File(uploadFolder, fileName);
            file.transferTo(saveFile);
            
            // DB에 저장할 경로 세팅
            review.setReview_img("/images/review/" + fileName);
        }

        // 2. 서비스 호출 (리뷰 등록)
        int result = reviewService.writeReview(review);
        
        // 3. 결과 페이지 이동 (메시지 알림창)
        if (result == 1) {
            model.addAttribute("msg", "리뷰가 정상적으로 등록되었습니다.");
            model.addAttribute("loc", "/product/detail?product_id=" + review.getProduct_id());
        } else {
            model.addAttribute("msg", "리뷰 등록 실패.");
            model.addAttribute("loc", "javascript:history.back()");
        }
        
        // 공통 알림 페이지 (message.jsp)로 이동
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
