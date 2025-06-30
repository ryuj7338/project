package com.example.demo.service;

import com.example.demo.repository.QualificationRepository;
import com.example.demo.vo.Qualification;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class QualificationService {

    private final QualificationRepository qualificationRepository;

    public List<Qualification> findAll() {
        return qualificationRepository.findAll();
    }

    public Qualification findById(int id) {
        return qualificationRepository.findById(id);
    }

    public List<Qualification> getRecentQualifications(int count) {
        return qualificationRepository.findRecent(count);
    }
}
