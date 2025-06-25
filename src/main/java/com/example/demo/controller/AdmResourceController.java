package com.example.demo.controller;

import com.example.demo.service.AutoUploadService;
import com.example.demo.service.PostService;
import com.example.demo.service.ResourceService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.File;

@Controller
@RequestMapping("/adm/resource")
public class AdmResourceController {

    @Autowired
    private AutoUploadService autoUploadService;

    @RequestMapping("/autoUpload")
    @ResponseBody
    public String autoUpload() {
        int count = autoUploadService.autoUpload();
        return count + "개의 파일을 업로드했습니다.";
    }
}
