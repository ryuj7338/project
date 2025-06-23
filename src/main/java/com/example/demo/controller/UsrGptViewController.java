package com.example.demo.controller;

import com.example.demo.service.GptService;
import com.example.demo.vo.GptAnswer;
import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
@RequestMapping("/usr/gpt")
public class UsrGptViewController {

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


}



