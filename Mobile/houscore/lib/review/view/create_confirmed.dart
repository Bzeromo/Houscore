import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confirmation_success/confirmation_success.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/review/view/my_review_list.dart';

class CreateConfirmed extends StatefulWidget {
  final String reviewAddress;

  CreateConfirmed({required this.reviewAddress});

  @override
  State<CreateConfirmed> createState() => _CreateConfirmedState();
}

class _CreateConfirmedState extends State<CreateConfirmed> {
  StreamSubscription<void>? _sub;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConfirmationSuccess(
                    reactColor: Colors.blue,
                    bubbleColors: [Colors.blue],
                    numofBubbles: 35,
                    maxBubbleRadius: 8,
                    child: const Icon(
                      Icons.check,
                      size: 180,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Text(
                            "리뷰 등록이 성공적으로 완료되었습니다!\n",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (widget.reviewAddress != '') {
                        // GoRouter를 사용하여 ResidenceDetail로 라우팅
                        context.go('/residence/${widget.reviewAddress}');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text('건물정보'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      side: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text('확인'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
