package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;



@Data
@AllArgsConstructor
public class News {

    private final String title;
    private final String link;
    private final String summary;
    private final String image;
}
