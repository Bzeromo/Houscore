import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
const USER_EMAIL_KEY = 'USER_EMAIL';
const USER_NAME_KEY = 'USER_NAME';
// localhost
final emulatorIp = '10.0.2.2:3000';
final simulatorIp = '127.0.0.1:3000';

// final ip = Platform.isIOS ? simulatorIp : emulatorIp;
// final ip = '84818524-ad0e-4d24-89c9-2ef5767416ea.mock.pstmn.io'; //우진 목서버
// final ip = '192.168.31.166:8084'; // 희주누나 ip
// final ip = '70ac0dcc-9306-42b5-9117-1c159e282c00.mock.pstmn.io'; // 상준 Mock 서버
final ip = 'k10s206.p.ssafy.io:8084';
// final ip = '192.168.31.199:8084'; //영규 ip

// 사용자 개인 정보나 인증 토큰과 같은 중요한 데이터를 안전하게 보관하는데 사용되는 플러그인
// iOS : Keychain 활용
// Android : 안전 저장소(Secure SharedPreferences) 사용
// WEB : Local Storage 활용
// 사용자 기기에 데이터를 저장 & 외부 앱이나 사용자 접근 불가
final storage = FlutterSecureStorage();

const List<String> regions = [
  '서울',
  '경기',
  '인천',
  '세종',
  '강원',
  '충북',
  '충남',
  '대전',
  '전북',
  '전남',
  '광주',
  '경북',
  '경남',
  '대구',
  '부산',
  '울산',
  '제주',
  '전국'
];
const Map<String, List<String>> subRegions = {
  '서울': [
    '강남구',
    '강동구',
    '강북구',
    '강서구',
    '관악구',
    '광진구',
    '구로구',
    '금천구',
    '노원구',
    '도봉구',
    '동대문구',
    '동작구',
    '마포구',
    '서대문구',
    '서초구',
    '성동구',
    '성북구',
    '송파구',
    '양천구',
    '영등포구',
    '용산구',
    '은평구',
    '종로구',
    '중구',
    '중랑구',
    // '전체'
  ],
  '경기': [
    '가평군',
    '고양시',
    '과천시',
    '광명시',
    '광주시',
    '구리시',
    '군포시',
    '김포시',
    '남양주시',
    '동두천시',
    '부천시',
    '성남시',
    '수원시',
    '시흥시',
    '안산시',
    '안성시',
    '안양시',
    '양주시',
    '양평군',
    '여주시',
    '연천군',
    '오산시',
    '용인시',
    '의왕시',
    '의정부시',
    '이천시',
    '파주시',
    '평택시',
    '포천시',
    '하남시',
    '화성시',
    // '전체'
  ],
  '인천': [
    '강화군',
    '계양구',
    '남동구',
    '동구',
    '미추홀구',
    '부평구',
    '서구',
    '연수구',
    '옹진군',
    '중구',
    // '전체'
  ],
  '세종': [
    '전체',
  ],
  '강원': [
    '강릉시',
    '고성군',
    '동해시',
    '삼척시',
    '속초시',
    '양구군',
    '양양군',
    '영월군',
    '원주시',
    '인제군',
    '정선군',
    '철원군',
    '춘천시',
    '태백시',
    '평창군',
    '홍천군',
    '화천군',
    '횡성군',
    // '전체'
  ],
  '충북': [
    '괴산군',
    '단양군',
    '보은군',
    '영동/증평군',
    '옥천군',
    '음성군',
    '제천시',
    '진천군',
    '청주시',
    '충주시',
    // '전체'
  ],
  '충남': [
    '계룡시',
    '공주시',
    '금산군',
    '논산시',
    '당진시',
    '보령시',
    '부여군',
    '서산시',
    '서천군',
    '아산시',
    '예산군',
    '천안시',
    '청양군',
    '태안군',
    '홍성군',
    '보령시',
    // '전체'
  ],
  '대전': [
    '대덕구', '동구', '서구', '유성구', '중구',
    // '전체'
  ],
  '전북': [
    '고창군',
    '군산시',
    '김제시',
    '남원시',
    '무주군',
    '부안군',
    '순창군',
    '완주군',
    '익산시',
    '임실군',
    '장수군',
    '전주시',
    '정읍시',
    '진안군',
    // '전체'
  ],
  '전남': [
    '강진군',
    '고흥군',
    '곡성군',
    '광양시',
    '구례군',
    '나주시',
    '담양군',
    '목포시',
    '무안군',
    '보성군',
    '순천시',
    '신안군',
    '여수시',
    '영광군',
    '영암군',
    '완도군',
    '장성군',
    '장흥군',
    '진도군',
    '함평군',
    '해남군',
    '화순군',
    // '전체'
  ],
  '광주': [
    '광산구', '남구', '동구', '북구', '서구',
    // '전체'
  ],
  '경북': [
    '경산시',
    '경주시',
    '고령군',
    '구미시',
    '군위군',
    '김천시',
    '문경시',
    '봉화군',
    '상주시',
    '성주군',
    '안동시',
    '영덕군',
    '영양군',
    '영주시',
    '영천시',
    '예천군',
    '울릉군',
    '울진군',
    '의성군',
    '청도군',
    '청송군',
    '칠곡군',
    '포항시',
    // '전체'
  ],
  '경남': [
    '거제시',
    '거창군',
    '고성군',
    '김해시',
    '남해군',
    '밀양시',
    '사천시',
    '산청군',
    '양산시',
    '의령군',
    '진주시',
    '창녕군',
    '창원시',
    '통영시',
    '하동군',
    '함안군',
    '함양군',
    '합천군',
    // '전체'
  ],
  '대구': [
    '남구', '달서구', '달성군', '동구', '북구', '서구', '수성구', '중구',
    // '전체'
  ],
  '부산': [
    '강서구',
    '금정구',
    '기장군',
    '남구',
    '동구',
    '동래구',
    '부산진구',
    '북구',
    '사상구',
    '사하구',
    '서구',
    '수영구',
    '연제구',
    '영도구',
    '중구',
    '해운대구',
    // '전체'
  ],
  '울산': [
    '남구', '동구', '북구', '울주군', '중구',
    // '전체'
  ],
  '제주': [
    '서귀포시', '제주시',
    // '전체'
  ],
  // '전국': ['전체']
};
const Map<String, Map<String, String>> sigunguCode = {
  '서울': {
    '종로구': '1111',
    '중구': '1114',
    '용산구': '1117',
    '성동구': '1120',
    '광진구': '1121',
    '동대문구': '1123',
    '성북구': '1129',
    '강북구': '1130',
    '도봉구': '1132',
    '노원구': '1135',
    '은평구': '1138',
    '서대문구': '1141',
    '마포구': '1144',
    '양천구': '1147',
    '강서구': '1150',
    '구로구': '1153',
    '금천구': '1154',
    '영등포구': '1156',
    '동작구': '1159',
    '관악구': '1162',
    '서초구': '1165',
    '강남구': '1168',
    '송파구': '1171',
    '강동구': '1174',
  },
  '경기': {
    '수원시': '4111',
    '성남시': '4113',
    '의정부시': '4115',
    '안양시': '4117',
    '부천시': '4119',
    '광명시': '4121',
    '평택시': '4122',
    '동두천시': '4125',
    '안산시': '4127',
    '고양시': '4128',
    '과천시': '4129',
    '구리시': '4131',
    '남양주시': '4136',
    '오산시': '4137',
    '시흥시': '4139',
    '군포시': '4141',
    '의왕시': '4143',
    '하남시': '4145',
    '용인시': '4146',
    '파주시': '4148',
    '이천시': '4150',
    '안성시': '4155',
    '김포시': '4157',
    '화성시': '4159',
    '광주시': '4161',
    '양주시': '4163',
    '포천시': '4165',
    '여주시': '4167',
    '연천군': '4180',
    '가평군': '4182',
    '양평군': '4183',
  },
  '인천': {
    '중구': '2811',
    '동구': '2814',
    '미추홀구': '2817',
    '연수구': '2818',
    '남동구': '2820',
    '부평구': '2823',
    '계양구': '2824',
    '서구': '2826',
    '강화군': '2871',
    '웅진군': '2872',
  },
  '세종': {
    '전체': '36110',
  },
  '강원': {
    '춘천시': '5111',
    '원주시': '5113',
    '강릉시': '5115',
    '동해시': '5117',
    '태백시': '5119',
    '속초시': '5121',
    '삼척시': '5123',
    '홍천군': '5172',
    '횡성군': '5173',
    '영월군': '5175',
    '평창군': '5176',
    '정선군': '5177',
    '철원군': '5178',
    '화천군': '5179',
    '양구군': '5180',
    '인제군': '5181',
    '고성군': '5182',
    '양양군': '5183',
  },
  '충북': {
    '청주시': '4311',
    '충주시': '4313',
    '제천시': '4315',
    '보은군': '4372',
    '옥천군': '4373',
    '영동/증평군': '4374',
    '진천군': '4375',
    '괴산군': '4376',
    '음성군': '4377',
    '단양군': '4380',
  },
  '충남': {
    '천안시': '4413',
    '공주시': '4415',
    '보령시': '4418',
    '아산시': '4420',
    '서산시': '4421',
    '논산시': '4423',
    '계룡시': '4425',
    '당진시': '4427',
    '금산군': '4471',
    '부여군': '4476',
    '서천군': '4477',
    '청양군': '4479',
    '홍성군': '4480',
    '예산군': '4481',
    '태안군': '4482',
  },
  '대전': {
    '대덕구': '3023',
    '동구': '3011',
    '서구': '3017',
    '유성구': '3020',
    '중구': '3014',
  },
  '전북': {
    '전주시': '5211',
    '군산시': '5213',
    '익산시': '5214',
    '정읍시': '5218',
    '남원시': '5219',
    '김제시': '5221',
    '완주군': '5271',
    '진안군': '5272',
    '무주군': '5273',
    '장수군': '5274',
    '임실군': '5275',
    '순창군': '5277',
    '고창군': '5279',
    '부안군': '5280',
  },
  '전남': {
    '목포시': '4611',
    '여수시': '4613',
    '순천시': '4615',
    '나주시': '4617',
    '광양시': '4623',
    '담양군': '4671',
    '곡성군': '4672',
    '구례군': '4673',
    '고흥군': '4677',
    '보성군': '4678',
    '화순군': '4679',
    '장흥군': '4680',
    '강진군': '4681',
    '해남군': '4682',
    '영암군': '4683',
    '무안군': '4684',
    '함평군': '4686',
    '영광군': '4687',
    '장성군': '4688',
    '완도군': '4689',
    '진도군': '4690',
    '신안군': '4691',
  },
  '광주': {
    '동구': '2911',
    '서구': '2914',
    '남구': '2915',
    '북구': '2917',
    '광산구': '2920',
  },
  '경북': {
    '포항시': '4711',
    '경주시': '4713',
    '김천시': '4715',
    '안동시': '4717',
    '구미시': '4719',
    '영주시': '4721',
    '영천시': '4723',
    '상주시': '4725',
    '문경시': '4728',
    '경산시': '4729',
    '의성군': '4773',
    '청송군': '4775',
    '영양군': '4776',
    '영덕군': '4777',
    '청도군': '4782',
    '고령군': '4783',
    '성주군': '4784',
    '칠곡군': '4785',
    '예천군': '4790',
    '봉화군': '4792',
    '울진군': '4793',
    '울릉군': '4794',
  },
  '경남': {
    '창원시': '4812',
    '진주시': '4817',
    '통영시': '4822',
    '사천시': '4824',
    '김해시': '4825',
    '밀양시': '4827',
    '거제시': '4831',
    '양산시': '4833',
    '의령군': '4872',
    '함안군': '4873',
    '창녕군': '4874',
    '고성군': '4882',
    '남해군': '4884',
    '하동군': '4885',
    '산청군': '4886',
    '함양군': '4887',
    '거창군': '4888',
    '합천군': '4889',
  },
  '대구': {
    '중구': '2711',
    '동구': '2714',
    '서구': '2717',
    '남구': '2720',
    '북구': '2723',
    '수성구': '2726',
    '달서구': '2729',
    '달성군': '2771',
    '군위군': '2772',
  },
  '부산': {
    '중구': '2611',
    '서구': '2614',
    '동구': '2617',
    '영도구': '2620',
    '부산진구': '2623',
    '동래구': '2626',
    '남구': '2629',
    '북구': '2632',
    '해운대구': '2635',
    '사하구': '2638',
    '금정구': '2641',
    '강서구': '2644',
    '연제구': '2647',
    '수영구': '2650',
    '사상구': '2653',
    '기장군': '2671',
  },
  '울산': {
    '중구': '3111',
    '남구': '3314',
    '동구': '3117',
    '북구': '3120',
    '울주군': '3171',
  },
  '제주': {
    '제주시': '5011',
    '서귀포시': '5013',
  },
};