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
    private int boardId;
    private int hit;

    private String extra__writer;

    private boolean userCanModify;
    private boolean userCanDelete;

    private String searchKeyword;
    private String searchType;

    private int like;

    private int extra__repliesCount;

    private int commentsCount;

    private String pdf;
    private String pptx;
    private String hwp;
    private String word;
    private String xlsx;
    private String image;
    private String zip;
}