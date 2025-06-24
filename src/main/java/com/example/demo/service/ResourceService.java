package com.example.demo.service;

import com.example.demo.repository.ResourceRepository;
import com.example.demo.vo.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ResourceService {

    @Autowired
    private ResourceRepository resourceRepository;

    public void save(Resource resource) {
        resourceRepository.insertResource(resource);
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
        return resourceRepository.getListByPostId(postId);
    }

    public Resource getByPostId(int postId) {
        return resourceRepository.getByPostId(postId); // 상세 페이지 조회용 메서드
    }

    public boolean existsBySavedName(String savedName) {
        return resourceRepository.countBySavedName(savedName) > 0;
    }
}
