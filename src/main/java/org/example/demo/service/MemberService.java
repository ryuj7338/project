package org.example.demo.service;


import org.example.demo.repository.MemberRepository;
import org.example.demo.vo.Member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberService {

    @Autowired
    private MemberRepository memberRepository;

    public MemberService(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }


    public Member getMemberById(int id) {

        return memberRepository.getMemberById(id);
    }


    public int dojoin(String loginId, String loginPw, String name, String nickname, String email, String cellphone) {

        Member existsMember = memberRepository.getMemberByLoginId(loginId);
        System.out.println("existMember: " + existsMember);

        if(existsMember != null) {
            return -1;
        }

        existsMember = getMemberByNicknameAndEmail(nickname, email);

        if(existsMember != null) {
            return -2;
        }

        memberRepository.doJoin(loginId, loginPw, name, nickname, email, cellphone);
        return memberRepository.getLastInsertId();
    }

    public Member getMemberByNicknameAndEmail(String nickname, String email) {

        return memberRepository.getMemberByNicknameAndEmail(nickname, email);
    }

    public Member getMemberByLoginId(String loginId) {

        return memberRepository.getMemberByLoginId(loginId);
    }
}
