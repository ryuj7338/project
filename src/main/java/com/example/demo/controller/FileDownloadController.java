package com.example.demo.controller;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequestMapping("/file")
public class FileDownloadController {

    @GetMapping("/download")
    public ResponseEntity<InputStreamResource> downloadFile(@RequestParam String filename) throws IOException {
        String fileBasePath = "src/main/resources/static/uploadFiles/";
        File file = new File(fileBasePath + filename);

        if (!file.exists()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }

        // 파일명 인코딩
        String encodedFilename = URLEncoder.encode(file.getName(), StandardCharsets.UTF_8)
                .replaceAll("\\+", "%20");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(getMediaType(filename));
        headers.setContentLength(file.length());
        headers.setContentDisposition(ContentDisposition.attachment()
                .filename(encodedFilename, StandardCharsets.UTF_8)
                .build());

        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));

        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }

    private MediaType getMediaType(String filename) {
        if (filename.endsWith(".pdf")) return MediaType.APPLICATION_PDF;
        if (filename.endsWith(".png")) return MediaType.IMAGE_PNG;
        if (filename.endsWith(".jpg") || filename.endsWith(".jpeg")) return MediaType.IMAGE_JPEG;
        if (filename.endsWith(".zip")) return MediaType.APPLICATION_OCTET_STREAM;
        if (filename.endsWith(".hwp") || filename.endsWith(".pptx") || filename.endsWith(".docx"))
            return MediaType.APPLICATION_OCTET_STREAM;

        return MediaType.APPLICATION_OCTET_STREAM;
    }
}
