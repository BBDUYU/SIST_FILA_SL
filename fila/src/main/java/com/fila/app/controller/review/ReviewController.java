package com.fila.app.controller.review;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.review.ReviewVO;
import com.fila.app.service.review.ReviewService;

import lombok.Setter;

@Controller
@RequestMapping("/review/*")
public class ReviewController {

    @Setter(onMethod_ = @Autowired)
    private ReviewService reviewService;
    
    // [AJAX] 1. 작성 권한 체크 (형이 말한 '작성하기' 버튼 클릭 시 호출용)
    @GetMapping("/checkAuthority.do")
    @ResponseBody
    public String checkAuthority(@RequestParam("productId") String productId, HttpSession session) {
        // 세션에서 로그인 정보 확인
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "login_required";

        // 서비스의 isPurchased 로직 호출 (유저번호, 상품ID 순서)
        // 옛날 JDBC 로직을 스프링 서비스가 실행하도록 연결
        boolean canWrite = reviewService.canWriteReview(auth.getUserNumber(), productId);
        
        return canWrite ? "success" : "fail";
    }

    // [POST] 2. 리뷰 등록 처리
    @PostMapping("/write.do")
    public String write(ReviewVO review, 
                       @RequestParam(value="reviewFile", required=false) MultipartFile file, 
                       HttpSession session, // 세션 추가
                       Model model) throws Exception {
        
        System.err.println(">>> [Write] 등록 요청 도착: " + review.toString());

        // 세션에서 진짜 유저번호 가져오기
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("loc", "/login.htm");
            return "message";
        }
        
        // 가짜 10001 대신 진짜 유저번호 세팅
        review.setUserNumber(auth.getUserNumber());

        // 파일 저장 로직
        if (file != null && !file.isEmpty()) {
            try {
                String uploadFolder = "C:\\fila_upload\\review"; 
                File saveDir = new File(uploadFolder);
                if (!saveDir.exists()) saveDir.mkdirs(); 
                
                String uuid = UUID.randomUUID().toString();
                String fileName = uuid + "_" + file.getOriginalFilename();
                File saveFile = new File(uploadFolder, fileName);
                file.transferTo(saveFile);
                
                review.setReviewImg("/upload/review/" + fileName);
            } catch (Exception e) {
                System.err.println(">>> [Write] 파일 저장 중 에러: " + e.getMessage());
            }
        }

        try {
            int result = reviewService.writeReview(review);
            if (result == 1) {
                model.addAttribute("msg", "리뷰 등록 성공");
                model.addAttribute("loc", "/product/detail.htm?productId=" + review.getProductId());
                return "message";
            }
        } catch (Exception e) {
            e.printStackTrace(); 
        }
        model.addAttribute("msg", "리뷰 등록 실패");
        model.addAttribute("loc", "javascript:history.back();");
        return "message"; 
    }
    
    // [AJAX] 3. 리뷰 목록 및 요약 정보 가져오기
    @GetMapping("/list.htm")
    @ResponseBody
    public void list(
            @RequestParam("productId") String productId,
            @RequestParam(value="sort", defaultValue="latest") String sort,
            @RequestParam(value="isPhotoFirst", defaultValue="false") boolean isPhotoFirst,
            @RequestParam(value="ratingArr", required=false) String[] ratingArr,
            @RequestParam(value="keyword", required=false) String keyword,
            HttpSession session, 
            HttpServletResponse response) throws Exception {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        int userNumber = (auth != null) ? auth.getUserNumber() : 0; 

        System.err.println(">>> [리뷰 목록 요청] productId: " + productId + ", userNumber: " + userNumber);
        
        List<ReviewVO> list = reviewService.getReviewList(productId, ratingArr, userNumber, sort, keyword, isPhotoFirst);
        Map<String, Object> summary = reviewService.getReviewSummary(productId);
        
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("reviewList", list);
        resultMap.put("reviewSummary", summary);
        
        ObjectMapper mapper = new ObjectMapper();
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(mapper.writeValueAsString(resultMap));
    }
    
    // [AJAX] 4. 좋아요 처리
    @PostMapping("/like.do")
    @ResponseBody
    public String likeReview(
            @RequestParam("reviewId") int reviewId,
            @RequestParam("type") int type,
            HttpSession session) { 
        
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) {
            return "login"; 
        }

        int userNumber = auth.getUserNumber(); 
        System.err.println(">>> [좋아요 요청] 유저:" + userNumber + ", 리뷰:" + reviewId + ", 타입:" + type);

        try {
            int result = reviewService.likeReview(reviewId, userNumber, type);
            return String.valueOf(result);
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }
}