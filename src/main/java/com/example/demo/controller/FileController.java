package com.example.demo.controller;


import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@Controller
@RequestMapping("/file")
public class FileController {

    @Value("${custom.uploadDirPath}")  // 예: "C:/프로젝트경로/uploadFiles/"
    private String uploadDirPath;


    // ✅ 1. 일반 파일 업로드
    @PostMapping("/upload")
    @ResponseBody
    public Map<String, Object> uploadFiles(@RequestParam("files") MultipartFile[] files) {
        // ✅ 결과 변수 누락되었던 부분 추가!
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> uploadedFiles = new ArrayList<>();

        // ✅ 정확한 경로로 디렉토리 지정
        File dir = new File(uploadDirPath); // 예: static/uploadFiles
        if (!dir.exists()) dir.mkdirs();

        for (MultipartFile file : files) {
            String originalName = file.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String savedName = uuid + "_" + originalName;

            File destFile = new File(dir, savedName); // ✅ 저장 경로 확인용 로그
            System.out.println("[DEBUG] uploadDirPath = " + uploadDirPath);
            System.out.println("[DEBUG] 저장 경로: " + destFile.getAbsolutePath());

            try {
                file.transferTo(destFile);


                Map<String, String> fileInfo = new HashMap<>();
                fileInfo.put("savedPath", savedName);
                fileInfo.put("originalName", originalName);
                uploadedFiles.add(fileInfo);

                // 📌 필요 시 DB 저장 로직 여기에 추가 가능

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        result.put("success", true);
        result.put("files", uploadedFiles);
        return result;
    }


    @GetMapping("/download")
    public void downloadFile(@RequestParam String path, @RequestParam String original, HttpServletResponse response) throws IOException {
        // 경로 포함된 savedName 기준으로 처리
        File file = new File(uploadDirPath, path);  // path 예: "auto/시험문제.pdf" 또는 "자료1.pdf"

        if (!file.exists() || !file.isFile() || !file.canRead()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일을 찾을 수 없거나 읽을 수 없습니다.");
            return;
        }

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(original, StandardCharsets.UTF_8) + "\"");
        response.setHeader("Content-Length", String.valueOf(file.length()));

        try (InputStream is = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int len;
            while ((len = is.read(buffer)) != -1) {
                os.write(buffer, 0, len);
            }
        }
    }

}