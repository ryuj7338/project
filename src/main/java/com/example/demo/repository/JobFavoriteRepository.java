package com.example.demo.repository;

import com.example.demo.vo.JobPosting;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface JobFavoriteRepository {


    boolean countByMemberIdAndJobPostingId(int memberId, int jobPostingId);

    void insert(int memberId, int jobPostingId);

    void delete(int memberId, int jobPostingId);

    List<JobPosting> findFavoriteJobsByMemberId(int memberId);
}
