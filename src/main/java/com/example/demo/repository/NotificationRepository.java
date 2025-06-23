package com.example.demo.repository;

import com.example.demo.vo.Notification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Integer> {

    // 특정 회원의 알림을 최신순으로 조회 (예: 최근 10개)
    List<Notification> findByMemberIdOrderByRegDateDesc(int memberId);
}
