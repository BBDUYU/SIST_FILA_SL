package com.fila.app.controller.cart;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.service.product.ProductService;

@Controller
@RequestMapping("/pay")
public class CartOptionController {

	@Autowired
    private ProductService productService;

    @GetMapping("/cart/cartOption.htm")
    public String cartOption(@RequestParam("product_id") String productId,
                             HttpServletRequest request) {

        request.setAttribute("resultMap", productService.getProductDetail(productId));
        return "/view/pay/cart_option_modal";
    }
}
