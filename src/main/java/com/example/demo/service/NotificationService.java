package com.example.demo.service;

import com.example.demo.repository.NotificationRepository;
import com.example.demo.vo.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    // 회원별 최신 알림 조회 (limit 개수 만큼)
    public List<Notification> getRecentNotifications(int memberId) {
        return notificationRepository.findByMemberIdOrderByRegDateDesc(memberId);
    }

    // timeAgo 계산 예시 (몇 분/몇 시간 전 등)
    private void setTimeAgo(Notification notification) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime regDate = notification.getRegDate();

        Duration duration = Duration.between(regDate, now);
        long minutes = duration.toMinutes();

        if (minutes < 1) {
            notification.setTimeAgo("방금 전");
        } else if (minutes < 60) {
            notification.setTimeAgo(minutes + "분 전");
        } else if (minutes < 60 * 24) {
            notification.setTimeAgo((minutes / 60) + "시간 전");
        } else {
            notification.setTimeAgo((minutes / (60 * 24)) + "일 전");
        }
    }
}
