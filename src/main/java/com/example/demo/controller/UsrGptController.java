package com.example.demo.controller;


import com.example.demo.service.GptService;
import com.example.demo.vo.GptAnswer;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RequestMapping("/usr/gpt")
@RestController
public class UsrGptController {

    @Autowired
    private GptService gptService;

    @PostMapping("/ask")
    public ResultData<?> ask(@RequestBody Map<String, String> param, HttpServletRequest req) {
        Rq rq = (Rq) req.getAttribute("rq");
        if (!rq.isLogined()) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        String question = param.get("message");
        String category = param.get("category");
        String answer = gptService.ask(question, category);
        return ResultData.from("S-1", "성공", Map.of("answer", answer));
    }

    @PostMapping("/save")
    public ResultData<?> save(@RequestBody Map<String, String> param, HttpServletRequest req) {
        Rq rq = (Rq) req.getAttribute("rq");
        if (!rq.isLogined()) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        int memberId = rq.getLoginedMemberId();
        String question = param.get("question");
        String answer = param.get("answer");
        String category = param.get("category");

        gptService.save(memberId, question, answer, category);
        return ResultData.from("S-1", "저장 완료");
    }

    @PostMapping("/feedback")
    public ResultData<?> feedback(@RequestBody Map<String, String> param, HttpServletRequest req) {
        Rq rq = (Rq) req.getAttribute("rq");
        if (!rq.isLogined()) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        String answer = param.get("answer");
        String feedback = gptService.feedback(answer);
        return ResultData.from("S-1", "피드백 생성 완료", Map.of("feedback", feedback));
    }


}
