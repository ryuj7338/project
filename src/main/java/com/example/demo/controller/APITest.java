package com.example.demo.controller;

import com.example.demo.service.LawService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Controller
public class APITest {

    @Autowired
    private LawService lawService;

    @RequestMapping("/usr/law/lawInfo")
    public String showLawInfo(@RequestParam String type, @RequestParam(defaultValue = "1") int pageNo, @RequestParam(defaultValue = "10") int numOfRows, Model model) {

        Map<String, List<String>> lawCategories = Map.of(
                "경호학", List.of("경비업법", "경비업법 시행령", "경비업법 시행규칙", "청원경찰법", "국가공무원법", "군인사법"),
                "소방학", List.of("소방기본법", "소방시설공사업법", "위험물안전관리법"),
                "법학", List.of("헌법", "민법", "형법", "형사소송법", "행정법")
        );

        List<String> queries = lawCategories.getOrDefault(type, List.of());
        List<Map<String, String>> allLaws = new ArrayList<>();
        for (String q : queries) {
            allLaws.addAll(lawService.getLawInfoList(q));
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
        model.addAttribute("type", type);
        return "/usr/law/lawInfo";

    }
}
