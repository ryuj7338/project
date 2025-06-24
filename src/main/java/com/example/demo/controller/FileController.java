package com.example.demo.controller;


import java.net.URLDecoder;
import com.example.demo.vo.Resource;
import java.net.URLDecoder;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.*;

@Controller
@RequestMapping("/file")
public class FileController {

    @Value("${custom.uploadDirPath}")
    private String uploadDirPath;

    // ✅ 1. 일반 파일 업로드
    @PostMapping("/upload")
    @ResponseBody
    public Map<String, Object> uploadFiles(@RequestParam("files") MultipartFile[] files) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> uploadedFiles = new ArrayList<>();

        File dir = new File(uploadDirPath);
        if (!dir.exists()) dir.mkdirs();

        for (MultipartFile file : files) {
            String originalName = file.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String savedName = uuid + "_" + originalName;

            File destFile = new File(dir, savedName);

            try {
                file.transferTo(destFile);

                Resource resource = new Resource();
                resource.setOriginalName(originalName);
                resource.setSavedName(savedName);

                Map<String, String> fileInfo = new HashMap<>();
                fileInfo.put("savedPath", savedName);
                fileInfo.put("originalName", originalName);
                uploadedFiles.add(fileInfo);
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
        String decodedPath = URLDecoder.decode(path, "UTF-8");
        String uploadDir = "C:/Users/rjh73/IdeaProjects/project/uploadFiles/";
        File file = new File(uploadDir, decodedPath);

        System.out.println("downloadFile 호출 - 전체 경로: " + file.getAbsolutePath());
        System.out.println("파일명(path 파라미터): '" + path + "'");
        System.out.println("디코딩된 파일명(decodedPath): '" + decodedPath + "'");
        System.out.println("파일 존재 여부: " + file.exists());
        System.out.println("파일 읽기 가능 여부: " + file.canRead());
        System.out.println("파일인지 여부: " + file.isFile());

        if (!file.exists() || !file.canRead() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(original, "UTF-8") + "\"");

        try (InputStream is = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int length;
            while ((length = is.read(buffer)) > 0) {
                os.write(buffer, 0, length);
            }
        }
    }

}