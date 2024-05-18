import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/const/data.dart';
import 'package:houscore/common/model/data_state_model.dart';
import 'package:houscore/residence/model/ai_recommended_residence_model.dart';
import 'package:lottie/lottie.dart';
import 'package:visibility_detector/visibility_detector.dart'; // VisibilityDetector 임포트

import '../provider/ai_recommended_residence_provider.dart';
import 'ai_recommendation_card.dart';

class AiRecommendation extends ConsumerStatefulWidget {
  AiRecommendation({Key? key}) : super(key: key);

  final GlobalKey<_AiRecommendationState> aiRecommendationKey = GlobalKey<_AiRecommendationState>();

  @override
  _AiRecommendationState createState() => _AiRecommendationState();

  void removeOverlay() {
    aiRecommendationKey.currentState?._removeOverlay();
  }
}

class _AiRecommendationState extends ConsumerState<AiRecommendation>
    with WidgetsBindingObserver {
  final PageController _pageController =
  PageController(viewportFraction: 0.9); // 한 스크롤에 카드가 하나씩 보이게 하기 위한 설정용
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _selectionKey = GlobalKey();

  String getSiGunGuCode(String region, String subRegion) {
    return sigunguCode[region]?[subRegion] ?? '0000';
  }

  String? selectedRegion; // 고른 지역
  String? selectedSubRegion; // 고른 세부 지역

  OverlayEntry? _overlayEntry; // 선택창

  bool _isRegionExpanded = false; // 지역 선택창 열린지 여부
  bool _isSubRegionExpanded = false; // 세부 지역 선택창 열렸는지 여부

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 상태 변화 감지용 옵저버 추가
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 상태 변화 감지용 옵저버 제거
    _removeOverlay();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _removeOverlay();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _toggleOverlay(BuildContext context, List<String> items, bool isSubRegion) {
    setState(() {
      if (isSubRegion) {
        _isSubRegionExpanded = !_isSubRegionExpanded; // 세부 지역 토글
        _isRegionExpanded = false; // 지역의 상태를 안눌린 것으로!
      } else {
        _isRegionExpanded = !_isRegionExpanded; // 지역 토글
        _isSubRegionExpanded = false; // 세부 지역의 상태를 안눌린 것으로!
      }
    });

    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _overlayEntry = _createOverlayEntry(context, items, isSubRegion);
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context, List<String> items, bool isSubRegion) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    final RenderBox headerBox = _headerKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox selectionBox = _selectionKey.currentContext?.findRenderObject() as RenderBox;
    final double offsetTop = headerBox.size.height + selectionBox.size.height;

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx,
        top: offset.dy + offsetTop,
        width: size.width,
        child: Material(
          color: Color(0xfffafafa),
          elevation: 10, // 떠있는 정도 // 0 이상으로 둘 것!
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5, // 한 줄에 갯수
            childAspectRatio: 2, // 가로 세로 비율
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            children: items.map((String region) {
              Color selectedOrNot = (isSubRegion
                  ? selectedSubRegion == region
                  : selectedRegion == region)
                  ? PRIMARY_COLOR
                  : Colors.grey;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSubRegion) {
                      selectedSubRegion = region;
                    } else {
                      selectedRegion = region;
                      selectedSubRegion = null; // 지역 선택 시 세부 지역 리셋
                    }
                  });
                  _removeOverlay();
                },
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: selectedOrNot, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      region,
                      style: TextStyle(color: selectedOrNot, fontSize: 10),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isRegionExpanded = false;
      _isSubRegionExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCode = selectedRegion != null && selectedSubRegion != null
        ? getSiGunGuCode(selectedRegion!, selectedSubRegion!)
        : null;

    final residenceData = selectedCode != null
        ? ref.watch(aiRecommendedResidenceProvider(selectedCode))
        : null;

    return VisibilityDetector(
      key: Key('ai-recommendation-visibility-detector'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 0) {
          _removeOverlay();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              key: _headerKey,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '🤖 AI 추천 거주지',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              key: _selectionKey,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: _isRegionExpanded || _isSubRegionExpanded
                      ? Radius.zero
                      : Radius.circular(10),
                  bottomRight: _isRegionExpanded || _isSubRegionExpanded
                      ? Radius.zero
                      : Radius.circular(10),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: _buildButton(
                        child: Text(
                          selectedRegion ?? '지역',
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedRegion != null
                                  ? Colors.black
                                  : Colors.grey[500]),
                        ),
                        onTap: () => _toggleOverlay(context, regions, false),
                        isExpanded: _isRegionExpanded, // 지역 선택 버튼의 확장 상태
                      ),
                    ),
                    VerticalDivider(
                      width: 2,
                      indent: 8,
                      endIndent: 8,
                    ),
                    Flexible(
                      child: _buildButton(
                        child: Text(
                          selectedSubRegion ?? '세부 지역',
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedSubRegion != null
                                  ? Colors.black
                                  : Colors.grey[500]),
                        ),
                        onTap: () => _toggleOverlay(
                            context, subRegions[selectedRegion]!, true),
                        isExpanded: _isSubRegionExpanded, // 세부지역 선택 버튼의 확장 상태
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (residenceData != null) ...[
              if (residenceData is DataStateLoading)
                Lottie.asset('asset/img/logo/loading_lottie_animation.json'),
              if (residenceData is DataState)
                if (residenceData.data.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('해당 지역에 AI 추천 거주지가 존재하지 않습니다.'),
                  )
                else
                  Container(
                    height: 220, // 고정 높이
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: residenceData.data.length,
                      itemBuilder: (context, index) {
                        return AiRecommendationCard(
                            model: residenceData.data[index]);
                      },
                    ),
                  ),
              if (residenceData is DataStateError)
                Container(
                    height: 300,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '해당 지역의',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'AI 추천 거주지가 없습니다.',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Lottie.asset(
                              'asset/img/logo/error_lottie_animation_cat.json'),
                        ),
                      ],
                    )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required Widget child,
    required VoidCallback onTap,
    required bool isExpanded,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: child),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down, // 상태에 따른 아이콘 방향
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    _removeOverlay();
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    _removeOverlay();
    super.didChangeDependencies();
  }
}
