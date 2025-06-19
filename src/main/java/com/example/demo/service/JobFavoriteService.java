package com.example.demo.service;


import com.example.demo.repository.JobFavoriteRepository;
import com.example.demo.vo.JobPosting;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class JobFavoriteService {

    private JobFavoriteRepository jobFavoriteRepository;

    public boolean isFavorited(int memberId, int jobPostingId) {
        return jobFavoriteRepository.countByMemberIdAndJobPostingId(memberId, jobPostingId);
    }

    public void add(int memberId, int jobPostingId) {
        jobFavoriteRepository.insert(memberId, jobPostingId);
    }

    public void remove(int memberId, int jobPostingId) {
        jobFavoriteRepository.delete(memberId, jobPostingId);
    }

    public List<JobPosting> getFavoriteByMemberId(int memberId) {
        return jobFavoriteRepository.findFavoriteJobsByMemberId(memberId);
    }
}
