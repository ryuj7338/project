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

        if (notification == null || !notification.getMemberId().equals(memberId)) {
            return false; // 알림이 없거나, 회원이 다르면 실패
        }

        notification.setRead(true);
        notificationRepository.save(notification);

        return true;
    }

}
