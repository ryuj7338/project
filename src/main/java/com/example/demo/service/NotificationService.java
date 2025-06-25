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

    private final NotificationRepository notificationRepository;

    @Autowired
    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public void addNotification(int memberId, String title, String link) {
        if (notificationRepository.existsByMemberIdAndTitleAndLink(memberId, title, link)) {
            return; // 중복 저장 방지
        }

        Notification notification = new Notification();
        notification.setMemberId(memberId);
        notification.setTitle(title);
        notification.setLink(link);
        notification.setRegDate(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        notification.setRead(false);

        notificationRepository.insert(notification); // ✅ insert로 통일
    }

    public void addNotification(Notification notification) {
        notificationRepository.insert(notification); // ✅ insert로 통일
    }

    public List<Notification> getNotificationsByMemberId(int memberId) {
        return notificationRepository.findByMemberIdOrderByRegDateDesc(memberId);
    }

    public boolean markAsRead(int memberId, int notificationId) {
        Notification notification = notificationRepository.findById(notificationId).orElse(null);
        if (notification == null || !notification.getMemberId().equals(memberId)) {
            return false;
        }

        notification.setRead(true);
        notificationRepository.insert(notification); // 또는 update()가 있다면 그걸로
        return true;
    }

    public List<Notification> getRecentNotifications(int memberId) {
        return notificationRepository.findByMemberIdOrderByRegDateDesc(memberId);
    }

    public void notifyMember(int memberId, String message, String link) {

        if(notificationRepository.existsByMemberIdAndTitleAndLink(memberId, message, link)) {
            return;
        }

        Notification notification = new Notification();
        notification.setMemberId(memberId);
        notification.setTitle(message);
        notification.setLink(link);
        notification.setRegDate(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        notification.setRead(false);

        notificationRepository.insert(notification);
    }
}
