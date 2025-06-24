package com.example.demo.service;


import com.example.demo.vo.Post;
import com.example.demo.vo.Resource;
import org.springframework.beans.factory.annotation.Autowired;
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

    private final String basePath = "C:/Users/rjh73/IdeaProjects/project/src/main/resources/static/uploadFiles";



    public int autoUpload() {

        System.out.println("basePath 절대경로: " + new File(basePath).getAbsolutePath());

        String[] types = {"pdf", "pptx", "image", "hwp", "xlsx", "docx"};
        int count = 0;



        for (String type : types) {

            File baseFolder = new File(basePath + "/" + type);
            if (!baseFolder.exists()) continue;


            count += uploadFilesRecursively(baseFolder, type);

        }


        System.out.println("총 업로드된 파일 개수: " + count);
        return count;
    }


    private int uploadFilesRecursively(File folder, String type) {

        int count = 0;
        File[] files = folder.listFiles();

        if (files == null) {

            return 0;
        }

        for (File file : files) {
            if (file.isDirectory()) {


                count += uploadFilesRecursively(file, type);
            } else {

                String originalName = file.getName();
                String savedName = generateSavedName(originalName);

                String relativePath = "/uploadFiles/" + savedName;
                System.out.println("[DEBUG] 중복 검사 - 제목: " + originalName);
                System.out.println("[DEBUG] 중복 검사 - savedName 포함여부: " + resourceService.existsBySavedNameContains(savedName));


                if (postService.existsByTitle(originalName) || resourceService.existsBySavedNameContains(savedName)) {
                    System.out.println("[DEBUG] [SKIP] 이미 등록된 파일: " + originalName);
                    System.out.println("[DEBUG] [SKIP] 이미 등록된 파일: " + relativePath);

                    Post existingPost = postService.getPostByTitle(originalName);
                    if (existingPost != null) {
                        String newBody = "<a href='" + relativePath + "' target='_blank'>[다운로드]</a>";
                        postService.updatePostBody(existingPost.getId(), newBody);
                        System.out.println("[DEBUG] [UPDATE] 기존 게시글 본문 업데이트: " + originalName + " / 새 본문: " + newBody);
                    }

                    continue;
                }

                System.out.println("[DEBUG] 중복 없음, 게시글 작성 및 리소스 저장 시작");

                String body = "문제 파일입니다.<br>파일 다운로드: <a href='" + relativePath + "' target='_blank'>[다운로드]</a>";
                int boardId = getBoardIdByType(type);

                Post post = postService.writePostAndReturnPost(1, boardId, originalName, body);
                System.out.println("[DEBUG] 게시글 작성 완료, post 객체: " + post);
                System.out.println("[DEBUG] 게시글 본문: " + post.getBody());

                Resource resource = new Resource();
                resource.setPostId(post.getId());
                resource.setMemberId(1);
                resource.setBoardId(5);
                resource.setTitle(originalName != null ? originalName : "");
                resource.setBody("자동 업로드 파일입니다.");
                resource.setOriginalName(originalName);
                resource.setSavedName(savedName);
                resource.setAuto(true);




                if ("pdf".equalsIgnoreCase(type.trim())) {
                    resource.setPdf(savedName);
                    System.out.println("pdf 필드 세팅: " + resource.getPdf());
                } else if ("image".equalsIgnoreCase(type.trim())) {
                    resource.setImage(savedName);
                    System.out.println("image 필드 세팅: " + resource.getImage());
                }else if ("hwp".equalsIgnoreCase(type.trim())) {
                    resource.setHwp(savedName);
                    System.out.println("hwp 필드 세팅: " + resource.getHwp());
                }else if ("xlsx".equalsIgnoreCase(type.trim())) {
                    resource.setXlsx(savedName);
                    System.out.println("xlsx 필드 세팅: " + resource.getXlsx());
                }else if ("docx".equalsIgnoreCase(type.trim())) {
                    resource.setDocx(savedName);
                    System.out.println("docx 필드 세팅: " + resource.getDocx());
                }else if ("pptx".equalsIgnoreCase(type.trim())) {
                    resource.setPptx(savedName);
                    System.out.println("pptx 필드 세팅: " + resource.getPptx());
                }else {

                }

                System.out.println("[DEBUG] 저장 직전 resource 객체: " + resource);
                resourceService.save(resource);
                System.out.println("[DEBUG] save 호출 직후");


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
