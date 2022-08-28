import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

const String API_BASE_URL = 'https://no-finish-line.herokuapp.com/';
const String API_AUTH_KEY = 'aac48d6f-b63d-47a8-ada0-731db9955679';

const Color THEME_COLOR = Color.fromRGBO(168, 114, 247, 1);

void showLoadingConst(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => Center(
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: LoadingAnimationWidget.fourRotatingDots(
                color: THEME_COLOR, size: 60)),
      ),
    ),
  );
}