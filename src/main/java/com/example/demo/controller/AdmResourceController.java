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

    @RequestMapping("/autoUpload")
    @ResponseBody
    public String autoUpload() {
        String basePath = "src/main/resources/static/uploadFiles";
        String[] types = {"pdf", "pptx", "image"};

        int count = 0;

        for (String type : types) {
            File folder = new File(basePath + "/" + type);
            if (!folder.exists()) continue;

            for (File file : folder.listFiles()) {
                if (file.isFile()) {
                    String title = file.getName();
                    String filePath = "/uploadFiles/" + type + "/" + title;

                    // boardId는 자료실 게시판 번호로 고정 또는 매핑 필요
                    int boardId = getBoardIdByType(type);

                    // 중복 등록 방지 로직도 넣을 수 있음 (선택)
                    if (postService.existsByTitle(title)) continue;

                    postService.write(
                            boardId,
                            "관리자",
                            1, // admin id
                            title,
                            "<a href='" + filePath + "' target='_blank'>[다운로드]</a>"
                    );
                    count++;
                }
            }
        }

        return count + "개의 자료가 자동 등록되었습니다.";
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
