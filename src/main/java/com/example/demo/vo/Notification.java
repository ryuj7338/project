package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


import java.util.Date;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {

    private int id;
    private Integer memberId; // 회원 ID
    private String title;     // 알림 제목
    private String link;      // 알림 링크
    private Date regDate;// 등록일

    private boolean read;        // 읽음 여부
    private String timeAgo;       // 클라이언트 표시용 (필요시)


}
