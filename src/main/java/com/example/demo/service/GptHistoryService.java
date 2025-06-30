package com.example.demo.service;

import com.example.demo.repository.GptHistoryRepository;
import com.example.demo.vo.GptHistory;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;


@Service
public class GptHistoryService {

    @Autowired
    private GptHistoryRepository gptHistoryRepository;

    public List<GptHistory> getHistory(int memberId, String category) {
        return gptHistoryRepository.getByMemberIdAndCategory(memberId, category);
    }

    public void save(int memberId, String question, String answer, String category) {
        GptHistory history = new GptHistory();
        history.setMemberId(memberId);
        history.setQuestion(question);
        history.setAnswer(answer);
        history.setCategory(category);
        gptHistoryRepository.save(history);
    }
}




