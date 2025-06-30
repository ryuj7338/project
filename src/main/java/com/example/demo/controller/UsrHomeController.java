package com.example.demo.controller;

import com.example.demo.service.*;
import com.example.demo.vo.News;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Collections;
import java.util.List;

@Controller
public class UsrHomeController {

    @Autowired
    private PostService postService;

    @Autowired
    private JobPostingService jobPostingService;

    @Autowired
    private QualificationService qualificationService;

    @Autowired
    private ResourceService resourceService;

    @Autowired
    private NewsService newsService;

    @RequestMapping("/usr/home/main")
    public String showMain(Model model) {
        model.addAttribute("newsList", postService.getRecentPostsByBoardCode("NEWS", 3));
        model.addAttribute("commList", postService.getRecentPostsByBoardCode("COMMUNITY", 3));
        model.addAttribute("resourceList", resourceService.getRecentResources(6));
        model.addAttribute("jobList", jobPostingService.getRecentJobPostings(4));
        model.addAttribute("qualList", qualificationService.getRecentQualifications(5));

        try {
            List<News> newsList = newsService.crawlNews("경호", 1);
            model.addAttribute("newsList", newsList);
        } catch (InterruptedException e) {
            model.addAttribute("newsList", Collections.emptyList());
        }

        return "usr/home/main";
    }

    @RequestMapping("/")
    public String showMain2() {
        return "redirect:/usr/home/main";
    }

}
