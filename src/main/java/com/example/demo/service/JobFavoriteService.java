package com.example.demo.service;

import com.example.demo.repository.JobFavoriteRepository;
import com.example.demo.repository.JobPostingRepository;
import com.example.demo.vo.JobPosting;
import com.example.demo.vo.Notification;
import com.example.demo.vo.ResultData;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class JobFavoriteService {

    @Autowired
    private JobFavoriteRepository jobFavoriteRepository;

    @Autowired
    private JobPostingRepository jobPostingRepository;

    @Autowired
    private NotificationService notificationService;

    // 토글 찜 기능 + 알림 생성 포함
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

                JobPosting jobPosting = jobPostingRepository.findById((long) jobPostingId).orElse(null);

                if (jobPosting != null) {
                    // 편의 메서드 활용해서 알림 생성
                    notificationService.addNotification(
                            memberId,
                            "찜하신 채용공고가 등록되었습니다: " + jobPosting.getTitle(),
                            "/usr/job/detail?id=" + jobPostingId
                    );
                }

                return ResultData.from("S-1", "찜 추가", "favorited", true);
            }
        } catch (Exception e) {
            e.printStackTrace(); // 오류 로그 확인용
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
