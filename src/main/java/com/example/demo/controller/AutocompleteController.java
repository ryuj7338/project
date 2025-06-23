package com.example.demo.controller;

import com.example.demo.service.JobPostingService;
import com.example.demo.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/usr/autocomplete")
public class AutocompleteController {

    @Autowired
    private PostService postService;

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
}
