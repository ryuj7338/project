package com.example.demo.service;

import org.springframework.stereotype.Component;

@Component
public class GptApi {

    public String ask(String prompt) {
        return "[임시 응답] 답변입니다: " + prompt;
    }


    public String feedback(String answer) {
        // 피드백에 대한 임시 응답
        return "[임시 피드백] 이 답변은 좀 더 구체적인 사례가 필요합니다.";
    }
}
