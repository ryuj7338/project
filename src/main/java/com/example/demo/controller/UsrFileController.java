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
    public Map<String, Object> uploadFiles(@RequestParam("files") MultipartFile[] files, HttpServletRequest req) {
        Map<String, Object> result = new HashMap<>();
        List<String> fileUrls = new ArrayList<>();

        Rq rq = (Rq) req.getAttribute("rq");
        int memberId = rq.getLoginedMemberId();

        String userPath = uploadDirPath + "/user/" + memberId;
        File folder = new File(userPath);
        if (!folder.exists()) folder.mkdirs();

        for (MultipartFile file : files) {
            String originalFilename = file.getOriginalFilename();
            String ext = StringUtils.getFilenameExtension(originalFilename);
            String uuid = UUID.randomUUID().toString();
            String savedFileName = uuid + "." + ext;

            try {
                file.transferTo(new File(userPath + "/" + savedFileName));
                // 다운로드용 링크 삽입
                String downloadUrl = "/file/download?path=" + uuid + "." + ext + "&original=" + URLEncoder.encode(originalFilename, StandardCharsets.UTF_8);
                fileUrls.add(downloadUrl);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        result.put("success", true);
        result.put("fileUrls", fileUrls);
        return result;
    }



    @PostMapping("/uploadImage")
    @ResponseBody
    public Map<String, Object> uploadImage(@RequestParam("file") MultipartFile file, HttpServletRequest req) {
        Map<String, Object> result = new HashMap<>();
        Rq rq = (Rq) req.getAttribute("rq");
        int memberId = rq.getLoginedMemberId();

        String uploadPath = uploadDirPath + "/user/" + memberId;
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        String ext = StringUtils.getFilenameExtension(file.getOriginalFilename());
        String uuid = UUID.randomUUID().toString().replace("-", "");
        String savedFileName = uuid + "." + ext;

        try {
            file.transferTo(new File(uploadPath + "/" + savedFileName));
            String fileUrl = "/upload/user/" + memberId + "/" + savedFileName;
            result.put("url", fileUrl);
        } catch (IOException e) {
            e.printStackTrace();
            result.put("url", "");
        }

        return result;
    }
}
