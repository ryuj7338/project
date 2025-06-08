package com.example.demo.service;


import com.example.demo.repository.ReactionRepository;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReactionService {

    @Autowired
    private ReactionRepository reactionRepository;
    @Autowired
    private PostService postService;

    public ReactionService(ReactionRepository reactionRepository) {
        this.reactionRepository = reactionRepository;
    }

    public ResultData usersReaction(int loginedMemberId, String relTypeCode, int relId){

        if(loginedMemberId == 0){
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        int sumReactionByMemberId = reactionRepository.getSumReaction(loginedMemberId, relTypeCode, relId);

        if(sumReactionByMemberId != 0){
            return ResultData.from("F-1", "추천 불가능", "sumReactionByMemberId", sumReactionByMemberId);
        }

        return ResultData.from("S-1", "추천 가능", "sumReactionByMemberId", sumReactionByMemberId);
    }

    public ResultData addLikeReaction(int loginedMemberId, String relTypeCode, int relId) {

        int affectedRow = reactionRepository.addLikeReaction(loginedMemberId, relTypeCode, relId);

        if(affectedRow == -1){
            return ResultData.from("F-1", "좋아요 실패");
        }
        switch (relTypeCode){
            case "post":
                postService.increaseLikeReaction(relId);
                break;
        }

        return ResultData.from("S-1", "좋아요 성공");
    }

    public ResultData deleteLikeReaction(int loginedMemberId, String relTypeCode, int relId) {

        reactionRepository.deleteLikeReaction(loginedMemberId, relTypeCode, relId);

        switch (relTypeCode){
            case "post":
                postService.decreaseLikeReaction(relId);
                break;
        }

        return ResultData.from("S-1", "좋아요 취소");
    }

    public boolean isAlreadyAddLikeRp(int memberId, int relId, String relTypeCode) {

        int getLikeTypeCoedByMemberId = reactionRepository.getSumReaction(memberId, relTypeCode, relId);

        if(getLikeTypeCoedByMemberId > 0){
            return true;
        }

        return false;
    }
}
