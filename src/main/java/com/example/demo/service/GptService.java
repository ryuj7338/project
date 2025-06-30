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

    public List<GptAnswer> getAnswersByMemberAndCategory(int memberId, String category) {
        return gptAnswerRepository.findByMemberIdAndCategoryOrderByRegDateDesc(memberId, category);
    }

    public String ask(String prompt, String category) {
        if (prompt == null) prompt = "";
        if (category == null) category = "";

        String systemPrompt = """
                너는 경호 및 보안 분야 전문가이자, 면접/자소서 첨삭 코치 역할을 하는 GPT입니다.
                사용자에게 정확하고 실용적인 답변을 제공합니다.
                """;

        String userPrompt;

        if ("면접".equals(category)) {
            if (prompt.contains("질문") || prompt.contains("추천")) {
                userPrompt = "면접 준비 중이야. 경호 관련 질문 5~7개만 추천해줘.";
            } else {
                userPrompt = "다음은 면접 답변이야: \"%s\"\n논리성, 직무 적합성, 개선점을 기준으로 피드백 줘."
                        .formatted(prompt);
            }
        } else if ("자기소개서".equals(category)) {
            userPrompt = "아래 문장은 자기소개서 문장이야:\n\"%s\"\n경호 직무에 어울리게 고쳐주고 이유도 설명해줘."
                    .formatted(prompt);
        } else {
            userPrompt = prompt;
        }

        System.out.println("[GPT 요청] category=" + category);
        System.out.println("[GPT 요청] userPrompt=" + userPrompt);

        return gptApi.ask(systemPrompt, userPrompt);
    }


//    public String ask(String prompt, String category) {
//        // GPT의 고정 역할 부여
//        String systemPrompt = """
//                    너는 경호 및 보안 분야 전문가이자, 면접/자기소개서 첨삭 코치야.
//                    너의 역할은 다음과 같아:
//                    1. 경호원, 보안요원, 신변보호사 등 관련 직무와 자격요건에 대해 잘 알고 있어야 해.
//                    2. 면접 준비나 자기소개서 첨삭이 필요한 사용자에게 논리적이고 구체적인 조언을 줘야 해.
//                    3. 응답은 명확하고 공손하게, 너무 어려운 전문용어는 피해서 설명해.
//                """;
//
//        String userPrompt = "";
//
//        if ("면접".equals(category)) {
//            if (prompt.contains("면접 질문") || prompt.contains("질문 추천")) {
//                userPrompt = """
//                            경호 직무 면접에서 자주 나오는 질문을 5~7개 추천해줘.
//                            예시를 참고해도 좋아:
//                            - 경호직에 지원하게 된 동기는?
//                            - 위기 상황에서 대처한 경험은?
//                            - 신뢰와 책임감을 증명한 사례는?
//                        """;
//            } else {
//                userPrompt = """
//                            아래는 사용자의 면접 답변입니다.
//                            "%s"
//
//                            위 답변에 대해 논리성, 직무 적합성, 개선 포인트 3가지를 기준으로 피드백 해줘.
//                        """.formatted(prompt);
//            }
//        } else if ("자기소개서".equals(category)) {
//            userPrompt = """
//                        아래 문장은 경호/보안 직무 자기소개서에 들어갈 내용입니다.
//                        "%s"
//
//                        이 문장을 더 자연스럽고 논리적으로 고쳐주고, 왜 그렇게 고쳤는지도 설명해줘.
//                    """.formatted(prompt);
//        } else {
//            // 예외 처리용
//            userPrompt = prompt;
//        }
//
//        return gptApi.ask(systemPrompt, userPrompt);
//    }


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


    public void deleteById(int id) {
        gptAnswerRepository.deleteById(id);
    }

}
