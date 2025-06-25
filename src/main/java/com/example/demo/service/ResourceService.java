package com.example.demo.service;

import com.example.demo.repository.ResourceRepository;
import com.example.demo.vo.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ResourceService {

    private final ResourceRepository resourceRepository;

    @Autowired
    public ResourceService(ResourceRepository resourceRepository) {
        this.resourceRepository = resourceRepository;
    }


    public void save(Resource resource) {
        System.out.println("[DEBUG] save 메서드 시작: resource=" + resource);
        try {
            resourceRepository.insertResource(resource);
            System.out.println("[DEBUG] save 메서드 성공, 저장 후 id: " + resource.getId());
        } catch (Exception e) {
            System.err.println("[ERROR] save 메서드 예외 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }


    public void updateResource(Resource resource) {
        resourceRepository.updateResource(resource);
    }

    public void deleteResource(int id) {
        resourceRepository.deleteResource(id);
    }

    public Resource getById(int id) {
        return resourceRepository.getById(id);
    }

    public List<Resource> getListByPostId(int postId) {
        List<Resource> resources = resourceRepository.getListByPostId(postId);
        for (Resource r : resources) {
            System.out.println("DB 조회 Resource: savedName=" + r.getSavedName() + ", originalName=" + r.getOriginalName());
        }
        return resources;
    }

    public List<Resource> getByPostId(int postId) {
        return resourceRepository.getByPostId(postId);
    }
//
//    public List<Resource> getAutoFilesByPostId(int postId) {
//        List<Resource> allFiles = resourceRepository.getListByPostId(postId);
//
//        return allFiles.stream()
//                .filter(this::isAutoUploadFile)
//                .collect(Collectors.toList());
//    }

    /**
     * 자동 업로드 파일 판단 로직
     * 예: 저장된 파일명(savedName) 에 UUID 형태가 포함되어 있으면 자동 업로드로 판단
     * UUID 예시 정규식: 8-4-4-4-12 형식
     */
    private boolean isAutoUploadFile(Resource resource) {
        String savedName = resource.getSavedName();

        // uuidRegex 변수를 먼저 선언
        String uuidRegex = "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}";

        System.out.println("savedName: " + savedName + " isAutoUpload: " + (savedName != null && savedName.matches(".*" + uuidRegex + ".*")));

        if (savedName == null) {
            return false;
        }

        return savedName.matches(".*" + uuidRegex + ".*");
    }


    public boolean existsBySavedNameContains(String savedName) {
        System.out.println("[ResourceService] existsBySavedNameContains 호출: " + savedName);
        boolean exists = resourceRepository.existsBySavedNameContains(savedName);
        System.out.println("[ResourceService] existsBySavedNameContains 결과: " + exists);
        return exists;
    }

    public List<Resource> getAutoFilesByPostId(int postId) {
        List<Resource> files = resourceRepository.findByPostIdAndAuto(postId, true);
        for (Resource r : files) {
            System.out.println("AutoFile savedName: " + r.getSavedName() + ", originalName: " + r.getOriginalName());
        }
        return files;
    }

    public List<Resource> getDirectFilesByPostId(int postId) {
        List<Resource> files = resourceRepository.findByPostIdAndAuto(postId, false);
        for (Resource r : files) {
            System.out.println("DirectFile savedName: " + r.getSavedName() + ", originalName: " + r.getOriginalName());
        }
        return files;
    }

    public List<Resource> getFilesByPostId(int postId) {
        return resourceRepository.getListByPostId(postId);
    }
}