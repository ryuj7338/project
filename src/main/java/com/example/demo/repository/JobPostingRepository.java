package com.example.demo.repository;

import com.example.demo.vo.JobPosting;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;


public interface JobPostingRepository extends JpaRepository<JobPosting, Long> {

    @Query("SELECT jp FROM JobPosting jp WHERE jp.id IN (SELECT jf.jobPostingId FROM JobFavorite jf WHERE jf.memberId = :memberId)")
    List<JobPosting> findFavoriteJobsByMemberId(int memberId);

    @Query("SELECT jp.title FROM JobPosting jp WHERE jp.title LIKE %:keyword% ORDER BY jp.id DESC")
    List<String> findTitlesByKeyword(@Param("keyword") String keyword);
}



