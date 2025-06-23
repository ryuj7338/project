package com.example.demo.controller;

import com.example.demo.service.GptService;
import com.example.demo.vo.GptAnswer;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/usr/gpt")
public class UsrGptViewController {

    @Autowired
    private Rq rq;

    @Autowired
    private GptService gptService;

    @RequestMapping("/interview")
    public String interviewForm(Model model) {
        model.addAttribute("category", "면접");
        return "usr/gpt/form";
    }

    @RequestMapping("/cover")
    public String coverForm(Model model) {
        model.addAttribute("category", "자소서");
        return "usr/gpt/form";
    }

    @GetMapping("/history")
    public String showHistory(
            @RequestParam(defaultValue = "all") String category,
            Model model,
            HttpServletRequest req
    ) {
        Rq rq = (Rq) req.getAttribute("rq");

        if (!rq.isLogined()) {
            return "redirect:/usr/member/login?redirectUrl=" + URLEncoder.encode(req.getRequestURI(), StandardCharsets.UTF_8);
        }

        List<GptAnswer> answers;

        if ("all".equals(category)) {
            answers = gptService.findAllByMemberId(rq.getLoginedMemberId());
        } else {
            // category에 해당하는 답변과, 피드백 포함
            answers = gptService.findByCategoryIncludingFeedback(rq.getLoginedMemberId(), category);
        }

        model.addAttribute("answers", answers);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("isLogined", true);

        return "usr/gpt/history";
    }



    @GetMapping("/history/{id}")
    public String showHistoryDetail(@PathVariable("id") int id, HttpServletRequest req, Model model) throws UnsupportedEncodingException {
        Rq rq = (Rq) req.getAttribute("rq");

        if (!rq.isLogined()) {
            return "redirect:/usr/member/login?redirectUrl=" + URLEncoder.encode(req.getRequestURI(), "UTF-8");
        }

        GptAnswer answer = gptService.findById(id);
        model.addAttribute("answer", answer);
        model.addAttribute("category", answer.getCategory()); // 필요시 category도 전달
        return "usr/gpt/history_detail";  // JSP 경로
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResultData deleteAnswer(@RequestParam int id) {

        if (!rq.isLogined()) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        int loginedMemberId = rq.getLoginedMemberId();

        GptAnswer answer = gptService.findById(id);

        if (answer == null) {
            return ResultData.from("F-1", "존재하지 않는 기록입니다.");
        }

        if (answer.getMemberId() != loginedMemberId) {
            return ResultData.from("F-2", "권한이 없습니다.");
        }

        gptService.deleteById(id);

        return ResultData.from("S-1", "삭제되었습니다.");
    }


}



