package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Resource {

    private int id;
    private int postId;
    private int memberId;
    private int boardId;
    private String regDate;
    private String updateDate;
    private String title;
    private String body;
    private String image;
    private String pdf;
    private String zip;
    private String hwp;
    private String word;
    private String xlsx;
    private String pptx;
    private String docx;
    private String originalName;
    private String savedName;

    private boolean auto;

    public boolean exists;

}