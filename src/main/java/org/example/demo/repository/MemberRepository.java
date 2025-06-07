package org.example.demo.repository;


import org.apache.ibatis.annotations.Mapper;
import org.example.demo.vo.Member;

@Mapper
public interface MemberRepository {

    public int doJoin(String loginId, String loginPw, String name, String nickname, String email, String cellphone );

    public Member getMemberById(int id);

    public int getLastInsertId();

    public Member getMemberByLoginId(String loginId);

    public Member getMemberByNicknameAndEmail(String nickname, String email);
}
