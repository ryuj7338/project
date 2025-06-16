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
    public String showLawInfo(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "10") int numOfRows,
            Model model) {

        // 1. 카테고리별 법령 목록 정의
        List<String> queries = List.of(
                "경비업법",
                "청원경찰법", "국가공무원법", "군인사법",
                "헌법", "민법", "형법", "형사소송법", "행정법",
                "소방기본법", "소방시설공사업법", "위험물안전관리법"
        );

        List<Map<String, String>> allLaws = new ArrayList<>();

        for (String query : queries) {
            List<Map<String, String>> result = lawService.getLawInfoList(query);
            for(Map<String, String> item : result){
                if(item.get("법령명") == null) {
                    continue;
                }

                String lawName = item.get("법령명");

                if (keyword == null || keyword.isBlank()) {
                    allLaws.add(item);  // 전체 출력
                } else if (lawName.contains(keyword)) {
                    allLaws.add(item);  // 검색어 포함된 항목만
                }
            }
        }
        // 3. 페이지 처리
        int totalCount = allLaws.size();
        int pagesCount = (int) Math.ceil((double) totalCount / numOfRows);
        int fromIndex = Math.min((pageNo - 1) * numOfRows, totalCount);
        int toIndex = Math.min(fromIndex + numOfRows, totalCount);
        List<Map<String, String>> pagedLaws = allLaws.subList(fromIndex, toIndex);

        // 4. 모델에 값 전달
        model.addAttribute("lawList", pagedLaws);
        model.addAttribute("pageNo", pageNo);
        model.addAttribute("pagesCount", pagesCount);
        model.addAttribute("numOfRows", numOfRows);
        model.addAttribute("keyword", keyword == null ? "" : keyword);

        return "/usr/law/lawInfo";
    }
}