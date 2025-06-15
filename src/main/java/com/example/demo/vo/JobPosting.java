package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class JobPosting {

    private String gno;
    private String company;
    private String title;
    private List<String> certificates;
    private String startDate;
    private String deadline;
    private String link;

}