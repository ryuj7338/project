package com.example.demo.vo;


import lombok.Data;

@Data
public class GptRequest {
    private String message;
    private String category;
}