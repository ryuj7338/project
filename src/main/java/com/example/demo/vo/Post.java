package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Post {

    private int id;
    private String regDate;
    private String updateDate;
    private String title;
    private String body;
    private int memberId;

    private String extra__writer;
}

