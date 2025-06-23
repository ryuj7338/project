package com.example.demo.repository;


import com.example.demo.vo.GptAnswer;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface GptAnswerRepository {

    void save(GptAnswer gptAnswer);

    List<GptAnswer> findByMemberId(int memberId);

    List<GptAnswer> findByMemberIdOrderByRegDateDesc(int memberId);

    GptAnswer findById(int id);

    List<GptAnswer> findByMemberIdAndCategoryOrderByRegDateDesc(int memberId, String category);


    List<GptAnswer> findByMemberIdAndCategoryLikeOrCategoryLikeOrderByRegDateDesc(Map<String, Object> params);

    void deleteById(int id);
}
