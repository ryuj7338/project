package com.example.demo.init;

import com.example.demo.controller.AdmResourceController;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AutoUploaderRunner implements CommandLineRunner {

    private final AdmResourceController admResourceController;

    @Override
    public void run(String... args) {
        // 서버 시작 시 자동 실행
        String result = admResourceController.autoUpload();
        System.out.println("[AutoUpload 실행 결과] " + result);
    }
}
