package com.example.demo.controller;

import com.example.demo.service.JobPostingService;
import com.example.demo.service.LawService;
import com.example.demo.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/usr/autocomplete")
public class AutocompleteController {

    @Autowired
    private PostService postService;

    @Autowired
    private LawService lawService;

    @Autowired
    private JobPostingService jobPostingService;

    /**
     * 자동완성 검색어 리스트 반환
     * 예) /usr/autocomplete/search?keyword=모집
     */
    @GetMapping("/search")
    public List<String> search(@RequestParam String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        // 게시판 전체 또는 특정 범위에서 'keyword' 포함하는 제목 리스트 반환
        return postService.getAutocompleteSuggestions(keyword.trim());
    }

    @GetMapping("/job")
    public List<String> jobAutocomplete(@RequestParam String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return jobPostingService.findTitlesByKeyword(keyword.trim());
    }

    @GetMapping("/law")
    public List<String> lawAutocomplete(@RequestParam String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        List<String> queries = List.of(
                "경비업법", "청원경찰법", "국가공무원법", "군인사법",
                "헌법", "민법", "형법", "형사소송법", "행정법",
                "소방기본법", "소방시설공사업법", "위험물안전관리법"
        );

        Set<String> suggestions = new HashSet<>();
        String trimmedKeyword = keyword.trim();

        for (String query : queries) {
            List<Map<String, String>> result = lawService.getLawInfoList(query);
            for (Map<String, String> item : result) {
                String lawName = item.get("법령명");
                if (lawName != null && lawName.contains(trimmedKeyword)) {
                    suggestions.add(lawName);
                }
            }
        }

        return suggestions.stream()
                .sorted()
                .limit(10)
                .toList();
    }

    @GetMapping("/post")
    public List<String> autocompletePost(@RequestParam String keyword, @RequestParam(required = false) int boardId) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        // boardId가 있으면 해당 게시판만 검색, 없으면 전체
        return postService.getAutocompleteSuggestions(keyword.trim(), boardId);
    }
}