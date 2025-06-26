package com.example.demo.service;

import com.example.demo.repository.JobFavoriteRepository;
import com.example.demo.repository.JobPostingRepository;
import com.example.demo.vo.JobPosting;
import com.example.demo.vo.Notification;
import com.example.demo.vo.ResultData;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
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
    @RequestMapping("/usr/job/favorite/toggle")
    @ResponseBody
    public ResultData<?> toggleFavorite(int memberId, int jobPostingId) {

        if (memberId == 0) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        // 찜했는지 체크
        boolean isFavorited = isFavorited(memberId, jobPostingId);

        if (isFavorited) {
            jobFavoriteRepository.delete(memberId, jobPostingId);
            return ResultData.from("S-2", "찜 해제", "favorited", false);
        } else {
            jobFavoriteRepository.insert(memberId, jobPostingId);

            // ✅ 알림 생성
            JobPosting jobPosting = jobPostingRepository.findById((long) jobPostingId).orElse(null);
            if (jobPosting != null) {


                String title = "📌 찜한 채용공고가 등록되었습니다. (" + jobPosting.getTitle() + ")";
                String link = "usr/job/detail?id=" + jobPosting.getId();    // 페이지 못 들어가게 할지 고민중

                boolean exists = notificationService.existByMemberIdAndLinkAndTitle(memberId, link, title);
                if(!exists) {
                    Notification notification = new Notification();
                    notification.setMemberId(memberId);
                    notification.setTitle(title);
                    notification.setLink(link);
                    notification.setRead(false);

                    LocalDateTime localDateTime = LocalDateTime.now();
                    Date regDate = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
                    notification.setRegDate(regDate);

                    notificationService.addNotification(notification); // ✅ 알림 저장
                }


                Notification notification = new Notification();
                notification.setMemberId(memberId);
                notification.setTitle("📌 찜한 채용공고가 등록되었습니다: " + jobPosting.getTitle());
                notification.setLink("/usr/job/detail?id=" + jobPostingId);
                notification.setRead(false);

                LocalDateTime localDateTime = LocalDateTime.now();
                Date regDate = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
                notification.setRegDate(regDate);

                notificationService.addNotification(notification); // ✅ 알림 저장

            }

            return ResultData.from("S-1", "찜 성공", "favorited", true);
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

    public List<Long> getFavoriteIdsByMemberId(int memberId) {
        return jobFavoriteRepository.findJobPostingIdByMemberId(memberId);
    }

}
