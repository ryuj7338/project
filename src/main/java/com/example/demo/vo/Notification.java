package com.example.demo.vo;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "notification")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private int memberId;       // 알림 받는 회원 ID

    private String title;       // 알림 제목

    private String link;        // 알림 클릭 시 이동할 링크

    private LocalDateTime regDate; // 알림 생성 시간

    private Boolean isRead;     // 읽음 여부

    @Transient
    private String timeAgo;     // DB 컬럼 아님, 클라이언트 표시용
}
