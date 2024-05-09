import 'package:flutter/material.dart';

final List<String> categories = ['교통', '건물', '내부', '인프라', '치안'];

class ReviewRating extends StatelessWidget {
  final Function(String, int) onRatingUpdated;

  ReviewRating({required this.onRatingUpdated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((category) => ListTile(
        title: Container(
          child: Center(
            child: Text(category, textAlign: TextAlign.center),
          ),
        ),
        trailing: RatingWidget(
          onRatingChanged: (rating) => onRatingUpdated(category, rating),
        ),
      )).toList(),
    );
  }
}

class RatingWidget extends StatefulWidget {
  final Function(int) onRatingChanged;

  RatingWidget({required this.onRatingChanged});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) => IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star_rounded : Icons.star_border_rounded,
            color: index < _currentRating ? Colors.amber : Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingChanged(_currentRating);
          },
          iconSize: 30,
        )),
        SizedBox(width: 3),
        Text('$_currentRating / 5', style: TextStyle(fontSize: 16))
      ],
    );
  }
}
