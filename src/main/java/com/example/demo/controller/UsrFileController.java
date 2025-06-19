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
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@RequestMapping("/usr/file")
public class UsrFileController {

    @Value("${custom.uploadDirPath}")
    private String uploadDirPath;

    @PostMapping("/upload")
    @ResponseBody
    public String uploadFiles(@RequestParam("files") MultipartFile[] files, HttpServletRequest req) {

        Rq rq = (Rq) req.getAttribute("rq");
        int loginedMemberId = rq.getLoginedMemberId();

        if (files.length == 0 || files[0].isEmpty()) {
            return "파일이 선택되지 않았습니다.";
        }

        String userPath = uploadDirPath + "/user/" + loginedMemberId;
        File folder = new File(userPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        StringBuilder result = new StringBuilder();

        for (MultipartFile file : files) {
            String originalFilename = file.getOriginalFilename();
            String extension = StringUtils.getFilenameExtension(originalFilename);
            String uuid = UUID.randomUUID().toString().replace("-", "");
            String savedFileName = uuid + "." + extension;

            try {
                file.transferTo(new File(userPath + "/" + savedFileName));
                result.append("업로드 완료: ").append(originalFilename).append("<br>");
            } catch (IOException e) {
                result.append("업로드 실패: ").append(originalFilename).append("<br>");
            }
        }

        return result.toString();
    }
}
