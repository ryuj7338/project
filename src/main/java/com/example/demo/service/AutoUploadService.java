package com.example.demo.service;


import com.example.demo.vo.Post;
import com.example.demo.vo.Resource;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.Arrays;
import java.util.UUID;

@Service
public class AutoUploadService {

    @Autowired
    private PostService postService;

    @Autowired
    private ResourceService resourceService;

    @Value("${custom.uploadDirPath}")
    private String uploadDir;

    @PostConstruct
    public void init() {
        System.out.println("[DEBUG] @PostConstruct 호출됨");
        System.out.println("[DEBUG] 주입된 uploadDir: " + uploadDir);
        autoUpload();
    }

    public int autoUpload() {
        System.out.println("[DEBUG] 업로드 대상 경로: " + new File(uploadDir).getAbsolutePath());

        String[] types = {"pdf", "pptx", "image", "hwp", "xlsx", "docx"};
        int count = 0;

        for (String type : types) {
            File baseFolder = new File(uploadDir + "/" + type);
            System.out.println("[DEBUG] 검사할 폴더: " + baseFolder.getAbsolutePath());

            if (!baseFolder.exists()) {
                System.out.println("❌ 폴더 없음: " + baseFolder.getAbsolutePath());
                continue;
            }

            count += uploadFilesRecursively(baseFolder, type);
        }

        System.out.println("총 업로드된 파일 개수: " + count);
        return count;
    }


    private int uploadFilesRecursively(File folder, String type) {
        return uploadFilesRecursively(folder, type, "");
    }

    private int uploadFilesRecursively(File folder, String type, String relativePathPrefix) {
        int count = 0;
        File[] files = folder.listFiles();

        if (files == null) return 0;

        for (File file : files) {
            if (file.isDirectory()) {
                // 하위 폴더명 + "/" 붙여서 경로 누적
                count += uploadFilesRecursively(file, type, relativePathPrefix + file.getName() + "/");
            } else {
                String originalName = file.getName();
                String uuid = UUID.randomUUID().toString();
                String savedName = generateSavedName(originalName);

                File dest = new File(uploadDir + "/" + savedName);
                file.renameTo(dest);

                if (postService.existsByTitle(originalName) || resourceService.existsBySavedNameContains(savedName)) {
                    System.out.println("[DEBUG] [SKIP] 이미 등록된 파일: " + originalName);
                    continue;
                }

                String body = "savedName ";

                Post post = postService.writePostAndReturnPost(1, getBoardIdByType(type), originalName, body);

                Resource resource = new Resource();
                resource.setPostId(post.getId());
                resource.setMemberId(1);
                resource.setBoardId(5);
                resource.setTitle(originalName);
                resource.setBody("자동 업로드 파일입니다.");
                resource.setOriginalName(originalName);
                resource.setSavedName(savedName);
                resource.setAuto(true);

                switch (type.toLowerCase()) {
                    case "pdf" -> resource.setPdf(savedName);
                    case "image" -> resource.setImage(savedName);
                    case "hwp" -> resource.setHwp(savedName);
                    case "xlsx" -> resource.setXlsx(savedName);
                    case "docx" -> resource.setDocx(savedName);
                    case "pptx" -> resource.setPptx(savedName);
                }


                resourceService.save(resource);
                count++;
            }
        }
        return count;
    }

    private String generateSavedName(String originalName) {
        String uuid = UUID.randomUUID().toString();
        return uuid + "_" + originalName;
    }


    private int getBoardIdByType(String type) {
        return 5;
    }
}
