package com.example.demo;

import com.example.demo.service.ResourceService;
import com.example.demo.vo.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class ResourceServiceTest {

    @Autowired
    private ResourceService resourceService;

    @Test
    void testSave() {
        Resource resource = new Resource();
        resource.setBody("자동 업로드 테스트");
        resource.setPdf("uuid_testfile.pdf");

        resourceService.save(resource);

        System.out.println("테스트 save() 호출 완료");
    }
}
