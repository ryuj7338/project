package com.example.demo.repository;


import org.apache.ibatis.annotations.Mapper;
import com.example.demo.vo.Member;

@Mapper
public interface MemberRepository {

    int doJoin(String loginId, String loginPw, String name, String nickname, String email, String cellphone );

    Member getMemberById(int id);

    int getLastInsertId();

    Member getMemberByLoginId(String loginId);

    Member getMemberByNicknameAndEmail(String nickname, String email);

    void modify(int loginedMemberId, String loginPw, String name, String nickname, String cellphone, String email);

    void modifyWithoutPw(int loginedMemberId, String loginPw, String name, String nickname, String email);
}
