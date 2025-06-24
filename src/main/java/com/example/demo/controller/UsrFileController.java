package com.example.demo.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.example.demo.vo.Rq;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/usr/file")
public class UsrFileController {

    @Value("${custom.uploadDirPath}")
    private String uploadDirPath;

    @PostMapping("/upload")
    @ResponseBody
    public Map<String, Object> uploadFiles(@RequestParam("files") MultipartFile[] files) {
        Map<String, Object> result = new HashMap<>();
        List<String> fileInfos = new ArrayList<>();

        String uploadPath = "uploadFiles"; // 루트 기준 외부 저장소
        File folder = new File(uploadPath);
        if (!folder.exists()) folder.mkdirs();

        for (MultipartFile file : files) {
            String originalFileName = file.getOriginalFilename();
            String savedFileName = originalFileName;

            File targetFile = new File(folder, savedFileName);
            int count = 1;
            while (targetFile.exists()) {
                savedFileName = originalFileName.replaceFirst("(\\.[^.]+)$", "_" + count + "$1");
                targetFile = new File(folder, savedFileName);
                count++;
            }


            try {
                file.transferTo(targetFile);

                fileInfos.add(savedFileName);
            } catch (IOException e) {
                e.printStackTrace();
            }

        }


        result.put("success", true);
        result.put("fileUrls", fileInfos);
        return result;
    }





    @PostMapping("/uploadImage")
    @ResponseBody
    public Map<String, Object> uploadImage(@RequestParam("file") MultipartFile file) {
        Map<String, Object> result = new HashMap<>();

        String uploadPath = "uploadFiles/images"; // 외부 경로로 변경
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        String ext = StringUtils.getFilenameExtension(file.getOriginalFilename());
        String uuid = UUID.randomUUID().toString().replace("-", "");
        String savedFileName = uuid + "." + ext;

        try {
            File targetFile = new File(dir, savedFileName);
            file.transferTo(targetFile);

            // 접근 가능한 정적 경로 URL
            String fileUrl = "/uploadFiles/images/" + savedFileName;
            result.put("url", fileUrl);
        } catch (IOException e) {
            e.printStackTrace();
            result.put("url", "");
        }

        return result;
    }


}
