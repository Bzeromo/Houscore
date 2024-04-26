import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

class ReviewCard extends StatelessWidget {
  final String address;
  final double userRating;
  final double aiRating;
  final String like;
  final String dislike;

  const ReviewCard({
    Key? key,
    required this.address,
    required this.userRating,
    required this.aiRating,
    required this.like,
    required this.dislike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 리뷰 상세 페이지 이동 로직
        print('${this.address} tapped!');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(12.0), // 내부
        width: MediaQuery.of(context).size.width * 0.9, // 너비 : 화면 너비 0.7
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    address,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.0,
                    ),
                    Text(
                      userRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue, // PRIMARY_COLOR 대신 사용
                                borderRadius: BorderRadius.circular(7), // 모서리 둥글기
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 5), // 좌우 여백// PRIMARY_COLOR 대신 사용
                              child: Text(
                                "AI",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3),
                    Text(
                      aiRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '추천해요! ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Flexible(
                  child: Text(
                    like,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '별로에요! ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Flexible(
                  child: Text(
                    dislike,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
