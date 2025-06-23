package com.example.demo.controller;

import com.example.demo.service.NotificationService;
import com.example.demo.vo.Notification;
import com.example.demo.vo.Rq;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/usr/notifications")
public class NotificationController {

    @Autowired
    private Rq rq;

    @Autowired
    private NotificationService notificationService;

    @GetMapping("/recent")
    public ResponseEntity<?> getRecentNotifications() {
        if (!rq.isLogined()) {
            // 로그인 안 된 경우 401 반환
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 후 알림을 확인하세요.");
        }

        int memberId = rq.getLoginedMemberId();
        List<Notification> notifications = notificationService.getRecentNotifications(memberId);

        // 필요에 따라 DTO 변환 후 반환
        return ResponseEntity.ok(notifications);
    }
}

