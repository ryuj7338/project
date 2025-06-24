package com.example.demo.controller;

import com.example.demo.service.BoardService;
import com.example.demo.service.PostService;
import com.example.demo.service.ResourceService;
import com.example.demo.vo.Resource;
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
    private ResourceService resourceService;


    private final String basePath = "src/main/resources/static/uploadFiles";

    @RequestMapping("/autoUpload")
    @ResponseBody
    public String autoUpload() {
        String[] types = {"pdf", "pptx", "image", "hwp", "xlsx", "docx"};
        int count = 0;

        for (String type : types) {
            File baseFolder = new File(basePath + "/" + type);
            if (!baseFolder.exists()) continue;

            count += uploadFilesRecursively(baseFolder, type);
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

                String relativePath = file.getAbsolutePath()
                        .replace("\\", "/")
                        .replace(new File(basePath).getAbsolutePath().replace("\\", "/"), "");
                String fileUrl = "/uploadFiles" + relativePath;

                // 중복 방지
                if (resourceService.existsBySavedName(title)) {
                    System.out.println("[SKIP] 이미 등록됨");
                    continue;
                }

                Resource resource = new Resource();
                resource.setSavedName(title);
                resource.setOriginalName(title);
                resource.setType(type); // optional

                // ✅ body에 다운로드 링크 자동 삽입
                String downloadLink = "<a href='" + fileUrl + "' download>" + title + " [다운로드]</a>";
                resource.setBody(downloadLink);

                // ✅ 파일 경로를 컬럼에 저장
                switch (type) {
                    case "pdf" -> resource.setPdf(fileUrl);
                    case "pptx" -> resource.setPptx(fileUrl);
                    case "xlsx" -> resource.setXlsx(fileUrl);
                    case "hwp" -> resource.setHwp(fileUrl);
                    case "docx" -> resource.setDocx(fileUrl);
                    case "image" -> resource.setImage(fileUrl);
                }

                resourceService.save(resource);
                count++;
            }
        }
        return count;
    }

}
