package com.example.demo.controller;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;

@Controller
@RequestMapping("/file")
public class FileDownloadController {

    @Value("${custom.uploadDirPath}")
    private String uploadDirPath;

    @GetMapping("/download")
    public void download(@RequestParam String path, @RequestParam String original, HttpServletResponse response) throws IOException {

        String fileName = Paths.get(path).getFileName().toString();
        File file = new File(uploadDirPath, fileName);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String encodedFilename = URLEncoder.encode(original, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFilename + "\"");
        response.setContentLengthLong(file.length());

        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            in.transferTo(out);
        }
    }

}
