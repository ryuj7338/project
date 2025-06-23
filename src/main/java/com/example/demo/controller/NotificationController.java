package com.example.demo.controller;

import com.example.demo.service.NotificationService;
import com.example.demo.vo.Notification;
import com.example.demo.vo.Rq;  // 로그인 관련 객체 가정
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/usr/notifications")
public class NotificationController {

    @Autowired
    private Rq rq;

    @Autowired
    private NotificationService notificationService;

    @GetMapping("")
    public String redirectToList() {
        return "redirect:/usr/notifications/list";
    }

    // 알림 목록 페이지
    @GetMapping("/list")
    public String showNotificationList(Model model) {
        if (!rq.isLogined()) {
            return "redirect:/usr/member/login";
        }

        int memberId = rq.getLoginedMemberId();

        List<Notification> notifications = notificationService.getNotificationsByMemberId(memberId);

        // 변환 없이 바로 JSP에 전달
        model.addAttribute("notifications", notifications);

        return "usr/notification/list";
    }


}
