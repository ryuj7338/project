package com.example.demo.repository;

import com.example.demo.vo.JobFavorite;
import com.example.demo.vo.JobPosting;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

@Mapper
public interface JobFavoriteRepository{

    List<JobFavorite> findByMemberId(int memberId);

    void insert(int memberId, int jobPostingId);

    void delete(int memberId, int jobPostingId);

    int countByMemberIdAndJobPostingId(int memberId, int jobPostingId);

    List<Long> findJobPostingIdByMemberId(int memberId);

    List<JobPosting> findFavoriteJobsByMemberId(int memberId);
}
