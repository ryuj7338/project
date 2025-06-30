package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GptHistory {
    private int id;
    private int memberId;
    private String question;
    private String answer;
    private String category;
    private Date regDate;
    private Date updateDate;
}
