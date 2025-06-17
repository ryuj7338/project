package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;



@Data
@AllArgsConstructor
@NoArgsConstructor

public class News {

    private String title;
    private String link;
    private String summary;
    private String image;
    private String press;
    private String date;

}

