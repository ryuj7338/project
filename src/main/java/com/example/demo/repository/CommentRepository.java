package com.example.demo.repository;


import com.example.demo.vo.Comment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommentRepository {

    List<Comment> getForPrintComments(int loginedMemberId, String relTypeCode, int relId);

    void writeComment(int loginedMemberId, String body, String relTypeCode, int relId);

    int getLastInsertId();

    Comment getComment(int id);

    void modifyComment(int id, String body);

    Comment findById(@Param("id") int relId);
}
