package com.hs.houscore.controller;

import com.hs.houscore.postgre.entity.MemberEntity;
import com.hs.houscore.postgre.entity.MyInterestedAreaEntity;
import com.hs.houscore.postgre.service.MemberService;
import com.hs.houscore.postgre.service.MyInterestedAreaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/myinfo")
@Tag(name = "내정보 컨트롤러", description = "사용자 정보 관련 컨트롤러")
@CrossOrigin
public class MyInfoController {
    private final MyInterestedAreaService myInterestedAreaService;
    private final MemberService memberService;

    @Autowired
    public MyInfoController(MyInterestedAreaService myInterestedAreaService, MemberService memberService) {
        this.myInterestedAreaService = myInterestedAreaService;
        this.memberService = memberService;
    }

    @GetMapping("")
    @Operation(summary = "사용자 검색", description = "이메일로 사용자 검색")
    public MemberEntity getMyInfo(@RequestParam String refreshToken) {
        return memberService.getMemberByRefreshToken(refreshToken);
    }

    @GetMapping("/area")
    @Operation(summary = "관심 지역 리스트", description = "관심 지역 리스트 조회")
    public List<MyInterestedAreaEntity> getMyInterestedArea(String email, Pageable pageable) {
        return myInterestedAreaService.getMyInterestedAreaList(email, pageable);
    }

    @PostMapping("/area")
    @Operation(summary = "관심 지역 등록", description = "관심 지역 등록")
    public ResponseEntity<?> setMyInterestedArea(@RequestBody MyInterestedAreaEntity myInterestedArea) {
        try{
            myInterestedAreaService.setMyInterestedArea(myInterestedArea);
            return ResponseEntity.status(HttpStatus.CREATED).body("관심지역 등록 성공");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("유효하지 않은 관심지역 데이터");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("관심지역 등록 실패!");
        }
    }

    @DeleteMapping("/area")
    @Operation(summary = "관심 지역 삭제", description = "관심 지역 삭제")
    public ResponseEntity<?> delMyInterestedArea(@RequestParam Long areaId, @RequestParam String memberId) {
        myInterestedAreaService.deleteMyInterestedArea(areaId, memberId);
        return ResponseEntity.status(HttpStatus.OK).body("관심 지역 삭제 성공");
    }

}