<<<<<<< HEAD
//package com.example.demo.controller;
//
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//
//public class testController {
//
//    @GetMapping("/login")
//    public String loginForm(Model model) {
//        model.addAttribute("naverClientId", naverApi.getNaverCliendId());
//        model.addAttribute("naverRedirectUri", naverApi.getNaverRedirectUri());
//    }
//}
=======
package com.example.demo.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

public class testController {

    @GetMapping("/login")
    public String loginForm(Model model) {
        model.addAttribute("naverClientId", naverApi.getNaverCliendId());
        model.addAttribute("naverRedirectUri", naverApi.getNaverRedirectUri());
    }
}
>>>>>>> 641ab7f613c18b59f6d9be0463f8d567b37cfb87
