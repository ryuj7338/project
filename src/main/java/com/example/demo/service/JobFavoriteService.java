package com.example.demo.service;


import com.example.demo.repository.JobFavoriteRepository;
import com.example.demo.repository.JobPostingRepository;
import com.example.demo.vo.JobPosting;
import com.example.demo.vo.ResultData;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class JobFavoriteService {

    @Autowired
    private JobFavoriteRepository jobFavoriteRepository;

    @Autowired
    private JobPostingRepository jobPostingRepository;

    public JobFavoriteService(JobFavoriteRepository jobFavoriteRepository) {
        this.jobFavoriteRepository = jobFavoriteRepository;
    }

    public ResultData userFavorite(int memberId, int jobPostingId) {
        if(memberId == 0){
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        boolean alreadyFavorited = isFavorited(memberId, jobPostingId);

        if(alreadyFavorited){
            return ResultData.from("F-1", "이미 찜한 공고입니다.", "favorited", true);
        }

        return ResultData.from("S-1", "찜 가능", "favorited", false);
    }


    public ResultData addFavorite(int memberId, int jobPostingId) {
        boolean alreadyFavorited = isFavorited(memberId, jobPostingId);

        if (alreadyFavorited) {
            return ResultData.from("F-1", "이미 찜함");
        }

        jobFavoriteRepository.insert(memberId, jobPostingId);
        return ResultData.from("S-1", "찜 성공");
    }

    // 찜 삭제
    public ResultData removeFavorite(int memberId, int jobPostingId) {
        jobFavoriteRepository.delete(memberId, jobPostingId);
        return ResultData.from("S-1", "찜 해제 완료");
    }


    public ResultData<?> toggleFavorite(int memberId, int jobPostingId) {
        if (memberId == 0) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        try {
            if (isFavorited(memberId, jobPostingId)) {
                jobFavoriteRepository.delete(memberId, jobPostingId);
                return ResultData.from("S-2", "찜 해제", "favorited", false);
            } else {
                jobFavoriteRepository.insert(memberId, jobPostingId);
                return ResultData.from("S-1", "찜 추가", "favorited", true);
            }
        } catch (Exception e) {
            e.printStackTrace(); // 콘솔 확인용
            return ResultData.from("F-E", "찜 처리 중 오류가 발생했습니다.");
        }
    }


    public boolean isFavorited(int memberId, int jobPostingId) {
        return jobFavoriteRepository.countByMemberIdAndJobPostingId(memberId, jobPostingId) > 0;
    }


    public List<JobPosting> getFavoriteByMemberId(int memberId) {
        return jobFavoriteRepository.findFavoriteJobsByMemberId(memberId);
    }

    public List<JobPosting> getFavoriteJobPostingsWithDday(int memberId) {
        List<Long> jobPostingId = jobFavoriteRepository.findJobPostingIdByMemberId(memberId);
        return jobPostingRepository.findAllById(jobPostingId);
    }


}

