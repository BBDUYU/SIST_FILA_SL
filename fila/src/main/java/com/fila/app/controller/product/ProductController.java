package com.fila.app.controller.product;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.service.product.ProductService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ProductController {
    
    // ★ 구현체(Impl)가 아니라 인터페이스(Service)를 주입받습니다.
    private final ProductService productService; 

    @GetMapping("/product/detail")
    public String detail(@RequestParam("product_id") String productId, Model model) {
        // 인터페이스의 메서드 호출
        Map<String, Object> map = productService.getProductDetail(productId);
        model.addAttribute("map", map);
        return "product/detail";
    }
}
