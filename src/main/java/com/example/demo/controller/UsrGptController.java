package com.example.demo.controller;


import com.example.demo.service.GptHistoryService;
import com.example.demo.service.GptService;
import com.example.demo.vo.*;
import com.google.gson.Gson;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/usr/gpt")
public class UsrGptController {

    @Autowired
    private GptService gptService;

    @Autowired
    private GptHistoryService gptHistoryService;

    @Autowired
    private Rq rq;

    //  면접 GPT 전용
    @GetMapping("/interview")
    public String showInterview(Model model) {
        if (!rq.isLogined()) {
            return "redirect:/usr/member/login?redirectUrl=/usr/gpt/interview";
        }

        int memberId = rq.getLoginedMemberId();
        List<GptAnswer> historyList = gptService.getAnswersByMemberAndCategory(memberId, "면접");
        String historyJson = new Gson().toJson(historyList);

        model.addAttribute("category", "면접");
        model.addAttribute("historyJson", historyJson);

        return "usr/gpt/form";
    }

    // 자기소개서 GPT 전용
    @GetMapping("/resume")
    public String showResume(Model model) {
        if (!rq.isLogined()) {
            return "redirect:/usr/member/login?redirectUrl=/usr/gpt/resume";
        }

        int memberId = rq.getLoginedMemberId();
        List<GptAnswer> historyList = gptService.getAnswersByMemberAndCategory(memberId, "자기소개서");
        String historyJson = new Gson().toJson(historyList);

        model.addAttribute("category", "자기소개서");
        model.addAttribute("historyJson", historyJson);

        return "usr/gpt/form";
    }

    // 질문 요청
//    @PostMapping("/ask")
//    @ResponseBody
//    public ResultData<?> ask(@RequestBody Map<String, String> param, HttpServletRequest req) {
//        Rq rq = (Rq) req.getAttribute("rq");
//        if (!rq.isLogined()) {
//            return ResultData.from("F-L", "로그인이 필요합니다.");
//        }
//
//        String question = param.get("message");
//        String category = param.get("category");
//        String answer = gptService.ask(question, category);
//
//        return ResultData.from("S-1", "성공", Map.of("answer", answer));
//    }

    @PostMapping("/ask")
    @ResponseBody
    public ResultData<?> ask(@RequestBody GptRequest request) {
        String answer = gptService.ask(request.getMessage(), request.getCategory());
        if (answer == null || answer.trim().isEmpty()) {
            return ResultData.from("F-2", "답변 없음");
        }
        return ResultData.from("S-1", "성공", Map.of("answer", answer));
    }


    //  질문/답변 저장
    @PostMapping("/save")
    @ResponseBody
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
        gptHistoryService.save(memberId, question, answer, category);

        return ResultData.from("S-1", "저장 완료");
    }

    // 피드백 요청
    @PostMapping("/feedback")
    @ResponseBody
    public ResultData<?> feedback(@RequestBody Map<String, String> param, HttpServletRequest req) {
        Rq rq = (Rq) req.getAttribute("rq");
        if (!rq.isLogined()) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        String answer = param.get("answer");
        String feedback = gptService.feedback(answer);

        return ResultData.from("S-1", "피드백 생성 완료", Map.of("feedback", feedback));
    }

    // 로그인 체크
    @GetMapping("/checkLogin")
    @ResponseBody
    public ResultData<?> checkLogin() {
        if (!rq.isLogined()) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        return ResultData.from("S-1", "로그인 상태입니다");
    }
}
