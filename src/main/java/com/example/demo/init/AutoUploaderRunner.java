package com.example.demo.init;

import com.example.demo.controller.AdmResourceController;
import com.example.demo.service.AutoUploadService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AutoUploaderRunner implements CommandLineRunner {

    private final AutoUploadService autoUploadService;

    @Override
    public void run(String... args) {
        int count = autoUploadService.autoUpload(); // 오버로딩 된 메서드
        System.out.println("[AutoUpload 실행 결과] " + count + "개의 파일 자동 업로드 완료");
    }
}