package com.example.demo.controller;

import com.example.demo.service.BoardService;
import com.example.demo.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.File;

@Controller
@RequestMapping("/adm/resource")
@RequiredArgsConstructor
public class AdmResourceController {

    @Autowired
    private PostService postService;

    @Autowired
    private final BoardService boardService;

    private final String basePath = "src/main/resources/static/uploadFiles";

    @RequestMapping("/autoUpload")
    @ResponseBody
    public String autoUpload() {
        String[] types = {"pdf", "pptx", "image", "hwp", "xlsx"};
        int count = 0;

        for (String type : types) {
            File folder = new File(basePath + "/" + type);
            if (!folder.exists()) continue;

            count += uploadFilesRecursively(folder, type);
                }

             return count + "개의 파일을 업로드했습니다.";

        }



    private int uploadFilesRecursively(File folder, String type) {
    int count = 0;
    File[] files = folder.listFiles();
    if (files == null) return 0;

    for (File file : files) {
        if (file.isDirectory()) {
            count += uploadFilesRecursively(file, type);
        } else {
            String title = file.getName();

            // 상대 경로 추출
            String relativePath = file.getAbsolutePath()
                    .replace("\\", "/")
                    .replace(new File(basePath).getAbsolutePath().replace("\\", "/"), "");
            String fileUrl = "/uploadFiles" + relativePath;

            // 중복 방지
            if (postService.existsByTitle(title)) continue;

            // 게시글 등록
            int boardId = 5; // 기출문제 게시판
            postService.writePost(1, boardId, title,
                    "<a href='" + fileUrl + "' target='_blank'>[다운로드]</a>");

            count++;
        }
    }
    return count;
}


    private int getBoardIdByType(String type) {
        switch (type) {
            case "pdf": return 20;
            case "pptx": return 21;
            case "image": return 22;
            default: return 0;
        }
    }
}
