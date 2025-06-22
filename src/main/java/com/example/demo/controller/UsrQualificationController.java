// QualificationController.java
package com.example.demo.controller;

import com.example.demo.service.QualificationService;
import com.example.demo.vo.Qualification;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/usr/qualification")
@RequiredArgsConstructor
public class UsrQualificationController {

    private final QualificationService qualificationService;

    @RequestMapping("/list")
    public String showQualificationList(Model model) {
        List<Qualification> qualifications = qualificationService.findAll();
        model.addAttribute("qualifications", qualifications);
        return "usr/qualification/list";
    }

    @ResponseBody
    @RequestMapping(value = "/getInfo", method = RequestMethod.GET)
    public Map<String, Object> getQualificationInfo(@RequestParam("id") int id) {
        Qualification q = qualificationService.findById(id);

        Map<String, Object> result = new HashMap<>();
        result.put("name", q.getName() != null ? q.getName() : "");
        result.put("issuingAgency", q.getIssuingAgency() != null ? q.getIssuingAgency() : "");
        result.put("organizingAgency", q.getOrganizingAgency() != null ? q.getOrganizingAgency() : "");
        result.put("grade", q.getGrade() != null ? q.getGrade() : "");
        result.put("type", q.getType() != null ? q.getType() : "");
        result.put("applyUrl", q.getApplyUrl() != null ? q.getApplyUrl() : "");

        return result;
    }
}