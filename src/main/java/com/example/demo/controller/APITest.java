package com.example.demo.controller;

import com.example.demo.service.LawService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Controller
public class APITest {

    @Autowired
    private LawService lawService;

    @RequestMapping("/usr/law/lawInfo")
    public String showLawInfo(@RequestParam(defaultValue = "1") int pageNo, @RequestParam(defaultValue = "10") int numOfRows, Model model) {

        List<String> queries = Arrays.asList("대한민국 헌법", "상법", "민법", "경비업법", "형법", "형사소송법", "민사소송법", "사회법");
        List<Map<String, String>> allLaws = new ArrayList<>();
        for (String query : queries) {
            allLaws.addAll(lawService.getLawInfoList(query));
        }

        // 3. 페이지에 맞는 부분 추출
        int totalCount = allLaws.size();
        int pagesCount = (int) Math.ceil((double) totalCount / numOfRows);
        int fromIndex = Math.min((pageNo - 1) * numOfRows, totalCount);
        int toIndex = Math.min(fromIndex + numOfRows, totalCount);
        List<Map<String, String>> pagedLaws = allLaws.subList(fromIndex, toIndex);

        // 4. model에 전달
        model.addAttribute("lawList", pagedLaws);
        model.addAttribute("pageNo", pageNo);
        model.addAttribute("pagesCount", pagesCount);
        model.addAttribute("numOfRows", numOfRows);
        return "/usr/law/lawInfo";

    }
}
