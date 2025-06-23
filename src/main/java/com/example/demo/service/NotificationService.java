package com.example.demo.service;

import com.example.demo.repository.NotificationRepository;
import com.example.demo.vo.Notification;
import org.checkerframework.checker.units.qual.A;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public void addNotification(int memberId, String title, String link) {
        if (notificationRepository.existsByMemberIdAndTitleAndLink(memberId, title, link)) {
            return; // 중복 시 저장 안 함
        }
        Notification notification = new Notification();
        notification.setMemberId(memberId);
        notification.setTitle(title);
        notification.setLink(link);
        // LocalDateTime.now() 대신 Date로 변환해서 저장
        notification.setRegDate(Date.from(java.time.LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        notification.setRead(false);

        notificationRepository.save(notification);
    }

    public List<Notification> getNotificationsByMemberId(int memberId) {
        return notificationRepository.findByMemberIdOrderByRegDateDesc(memberId);
    }

    public boolean markAsRead(int memberId, int notificationId) {
        Notification notification = notificationRepository.findById(notificationId).orElse(null);

        if (notification == null) {
            System.out.println("알림이 없습니다. id=" + notificationId);
            return false;
        }

        if (!notification.getMemberId().equals(memberId)) {
            System.out.println("회원 ID 불일치. 알림 memberId=" + notification.getMemberId() + ", 요청 memberId=" + memberId);
            return false;
        }

        System.out.println("읽음 처리 전 isRead = " + notification.isRead());

        notification.setRead(true);
        notificationRepository.save(notification);

        System.out.println("읽음 처리 후 isRead = " + notification.isRead());

        return true;
    }

    public List<Notification> getRecentNotifications(int memberId) {
        // 예를 들어 최근 5건 조회 같은 로직 추가 가능
        return notificationRepository.findByMemberIdOrderByRegDateDesc(memberId);
    }

}
