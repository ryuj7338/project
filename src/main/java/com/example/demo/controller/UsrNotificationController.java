package com.example.demo.controller;

import com.example.demo.service.NotificationService;
import com.example.demo.vo.Notification;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/usr/notifications")
public class UsrNotificationController {

    @Autowired
    private Rq rq;

    @Autowired
    private NotificationService notificationService;

    @GetMapping("")
    public String redirectToList() {
        return "redirect:/usr/notifications/list";
    }

    @GetMapping("/recent")
    @ResponseBody
    public List<Notification> getRecentNotifications() {
        if (!rq.isLogined()) {
            return Collections.emptyList(); // 비로그인 시 빈 리스트 반환
        }
        int memberId = rq.getLoginedMemberId();
        return notificationService.getRecentNotifications(memberId);
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

    @PostMapping("/markAsRead")
    @ResponseBody
    public ResultData markAsRead(@RequestParam int notificationId) {
        if (!rq.isLogined()) {
            return ResultData.from("F-1", "로그인이 필요합니다.");
        }

        int memberId = rq.getLoginedMemberId();

        boolean success = notificationService.markAsRead(memberId, notificationId);

        if (success) {
            return ResultData.from("S-1", "읽음 처리되었습니다.");
        } else {
            return ResultData.from("F-1", "읽음 처리 실패 또는 권한 없음.");
        }
    }

    @GetMapping("/unreadCount")
    @ResponseBody
    public ResultData getUnreadCount() {
        if (!rq.isLogined()) {
            return ResultData.from("S-1", "로그인 필요 없음", "count", 0);
        }

        int count = notificationService.getUnreadCount(rq.getLoginedMemberId());
        return ResultData.from("S-1", "성공", "count", count);
    }

    @PostMapping("/markAllAsRead")
    @ResponseBody
    public ResultData markAllAsRead() {
        if (!rq.isLogined()) {
            return ResultData.from("F-1", "로그인이 필요합니다.");
        }

        notificationService.markAllAsRead(rq.getLoginedMemberId());
        return ResultData.from("S-1", "모든 알림을 읽음 처리했습니다.");
    }

    @GetMapping("/readAndGo")
    public String readAndRedirect(@RequestParam int id) {
        Notification n = notificationService.findById(id);
        if (n != null && rq.isLogined() && rq.getLoginedMemberId() == n.getMemberId()) {
            notificationService.markAsRead(n.getMemberId(), n.getId());
            return "redirect:" + n.getLink();
        }
        return "redirect:/"; // fallback
    }

}