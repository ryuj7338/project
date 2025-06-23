package com.example.demo.service;


import com.example.demo.repository.GptAnswerRepository;
import com.example.demo.vo.GptAnswer;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GptService {

    @Autowired
    private GptAnswerRepository gptAnswerRepository;

    @Autowired
    private GptApi gptApi;


    public String ask(String prompt, String category) {
        String basePrompt = "";

        if ("면접".equals(category)) {
            if (prompt.contains("면접 질문") || prompt.contains("면접 도와줘")) {
                basePrompt = """
            너는 경호원을 준비하는 사람에게 면접 코치를 해주는 전문가야.
            다음은 경호 직무에서 자주 나오는 실제 면접 질문이야. 
            아래처럼 5~7개 정도 추천해줘.
            - 본인이 경호직에 적합하다고 생각하는 이유는?
            - 긴급 상황에서 대처한 경험이 있다면?
            """;
            } else {
                basePrompt = """
            너는 경호원 면접 피드백을 제공하는 전문가야.
            사용자의 답변에 대해 다음 3가지를 기준으로 피드백 해줘.
            1. 논리성과 일관성
            2. 경호 직무와의 적합성
            3. 구체적인 개선 포인트
            아래 답변을 평가해줘:
            """;
            }
        } else if ("자소서".equals(category)) {
            basePrompt = """
        너는 경호 직무에 지원하는 사람들을 위한 자기소개서 코치야.
        사용자가 입력한 문장을 자연스럽고 논리적으로 바꾸고,
        부족한 점을 설명해줘. 문장을 먼저 고치고 그 아래에 개선 포인트를 적어줘.
        아래 문장을 도와줘:
        """;
        }

        String finalPrompt = basePrompt + "\n\n" + prompt;

        // 실제 GPT 호출 로직으로 연결 (OpenAI API 등)
        return gptApi.ask(finalPrompt);
    }




    public void save(int memberId, String question, String answer, String category) {
        GptAnswer gptAnswer = new GptAnswer();
        gptAnswer.setMemberId(memberId);
        gptAnswer.setQuestion(question);
        gptAnswer.setAnswer(answer);
        gptAnswer.setCategory(category);

        // LocalDateTime.now()를 yyyy.MM.dd 형식의 문자열로 변환
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");
        String formattedDate = LocalDateTime.now().format(formatter);
        gptAnswer.setRegDate(formattedDate);

        gptAnswer.setUpdateDate(formattedDate);

        gptAnswerRepository.save(gptAnswer);
    }


    public String feedback(String answer) {
        String prompt = """
    너는 경호원 면접 또는 자기소개서 코치야.
    아래 내용을 기반으로 피드백을 제공해줘.
    
    평가 기준:
    1. 논리성과 일관성
    2. 직무 적합성 (경호 관련)
    3. 개선할 점

    아래 내용을 평가해줘:
    """ + "\n\n" + answer;

        return "📌 피드백 예시: 내용이 구체적이고 직무와 연결되어 있어 좋습니다.\n개선할 점: 위기 대처 사례가 더 구체적이면 좋겠습니다.";
        // 실제 연동 시 GPT API 호출로 대체
    }


    public List<GptAnswer> findByMemberId(int memberId) {
        return gptAnswerRepository.findByMemberIdOrderByRegDateDesc(memberId);
    }

    public GptAnswer findById(int id) {

        return gptAnswerRepository.findById(id);
    }

    public List<GptAnswer> findByMemberIdAndCategory(int memberId, String category) {
        return gptAnswerRepository.findByMemberIdAndCategoryOrderByRegDateDesc(memberId, category);
    }

    // 모든 데이터 가져오기
    public List<GptAnswer> findAllByMemberId(int memberId) {
        return gptAnswerRepository.findByMemberIdOrderByRegDateDesc(memberId);
    }

    // 카테고리 포함 + '-피드백' 포함 데이터 조회
    public List<GptAnswer> findByCategoryIncludingFeedback(int memberId, String category) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("category1", category);          // "면접"
        params.put("category2", category + "-피드백");  // "면접-피드백"

        return gptAnswerRepository.findByMemberIdAndCategoryLikeOrCategoryLikeOrderByRegDateDesc(params);
    }


}
