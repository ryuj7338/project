package com.example.demo.vo;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GptAnswer {

    private int id;
    private int memberId;
    private String regDate;
    private String updateDate;
    private String question;
    private String answer;
    private String category;    // 면접, 자소서
}
