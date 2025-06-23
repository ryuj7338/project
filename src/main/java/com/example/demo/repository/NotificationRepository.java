package com.example.demo.repository;

import com.example.demo.vo.Notification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface NotificationRepository {

    List<Notification> findByMemberIdOrderByRegDateDesc(@Param("memberId") int memberId);

    boolean existsByMemberIdAndTitleAndLink(@Param("memberId") int memberId, @Param("title") String title, @Param("link") String link);

    int save(Notification notification);

    Optional<Notification> findById(int notificationId);


}
