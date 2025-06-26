package com.example.demo.controller;

import com.example.demo.service.NotificationService;
import com.example.demo.vo.Rq;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalNotificationAdvice {

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private Rq rq;

    @ModelAttribute("hasUnreadNotification")
    public boolean hasUnreadNotification() {
        if(!rq.isLogined()) return false;
        return notificationService.hasUnread(rq.getLoginedMemberId());
    }
}
