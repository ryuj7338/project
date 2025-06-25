package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Comment {

    private int id;
    private String regDate;
    private String updateDate;
    private int memberId;
    private String relTypeCode;
    private int relId;
    private String body;
    private int like;

    private String extra__writer;
    private String extra__sumLike;

    private boolean userCanModify;
    private boolean userCanDelete;
    private boolean alreadyLiked;

    private int likeCount;             // 좋아요 개수 (명확한 이름)
    private boolean isAlreadyAddLikeRp; // 내가 좋아요 눌렀는지


}
