package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class News {

    private String title;
    private String link;
    private String summary;
    private String image;
}
