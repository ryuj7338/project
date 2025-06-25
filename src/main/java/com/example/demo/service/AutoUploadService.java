package com.example.demo.service;

import com.example.demo.vo.Post;
import com.example.demo.vo.Resource;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;

@Service
public class AutoUploadService {

    @Autowired
    private PostService postService;

    @Autowired
    private ResourceService resourceService;

    @Value("${custom.uploadDirPath}")
    private String uploadDir;  // 예: /uploadFiles (auto는 붙이지 않음)

    @PostConstruct
    public void init() {
        System.out.println("[DEBUG] @PostConstruct 호출됨");
        System.out.println("[DEBUG] 주입된 uploadDir: " + uploadDir);
        autoUpload(); // 자동 실행
    }

    // ✅ [1] 수동 호출용 (auto 폴더 경로 생성 후 전달)
    public int autoUpload() {
        File autoFolder = new File(uploadDir, "auto");
        return autoUpload(autoFolder);
    }

    // ✅ [2] 실제 로직
    public int autoUpload(File autoFolder) {
        if (!autoFolder.exists()) {
            System.out.println("❌ auto 폴더가 존재하지 않습니다: " + autoFolder.getAbsolutePath());
            return 0;
        }

        int count = 0;
        File[] files = autoFolder.listFiles();

        if (files == null) return 0;

        for (File file : files) {
            if (file.isDirectory()) continue;

            String originalName = file.getName();
            String ext = getFileExtension(originalName).toLowerCase();
            String savedName = originalName;

            if (postService.existsByTitle(originalName) || resourceService.existsBySavedNameContains(savedName)) {
                System.out.println("[SKIP] 이미 등록된 파일: " + originalName);
                continue;
            }

            Post post = postService.writePostAndReturnPost(1, 5, originalName, "자동 업로드 파일입니다.");

            Resource resource = new Resource();
            resource.setPostId(post.getId());
            resource.setMemberId(1);
            resource.setBoardId(5);
            resource.setTitle(originalName);
            resource.setBody("필요하면 다운로드하세요");
            resource.setOriginalName(originalName);
            resource.setSavedName(savedName);
            resource.setAuto(true); // 자동 업로드 표시

            switch (ext) {
                case "pdf" -> resource.setPdf(savedName);
                case "hwp" -> resource.setHwp(savedName);
                case "xlsx" -> resource.setXlsx(savedName);
                case "docx" -> resource.setDocx(savedName);
                case "pptx" -> resource.setPptx(savedName);
                case "jpg", "jpeg", "png" -> resource.setImage(savedName);
                default -> System.out.println("⚠ 알 수 없는 확장자: " + ext);
            }

            resourceService.save(resource);
            System.out.println("✅ 자동 업로드 완료: " + originalName);
            count++;
        }

        System.out.println("총 자동 업로드 수: " + count);
        return count;
    }

    private String getFileExtension(String fileName) {
        int dotIndex = fileName.lastIndexOf(".");
        return (dotIndex == -1) ? "" : fileName.substring(dotIndex + 1);
    }
}
