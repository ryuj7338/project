package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReactionRepository {

    int getSumReaction(int memberId, String relTypeCode, int relId);

    int addLikeReaction(int memberId, String relTypeCode, int relId);

    void deleteLikeReaction(int memberId, String relTypeCode, int relId);

    int getSumReactionTotal(String relTypeCode, int relId);

    boolean existsByMemberIdAndRelTypeCodeAndRelId(int memberId, String relTypeCode, int relId);

    void delete(int memberId, String relTypeCode, int relId);

    void insert(int memberId, String relTypeCode, int relId);
}
