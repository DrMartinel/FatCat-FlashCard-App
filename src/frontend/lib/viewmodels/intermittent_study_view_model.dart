import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:FatCat/models/card_model.dart';
import 'dart:async';

class IntermittentStudyViewModel extends ChangeNotifier {
  final List<CardModel> cards;
  late CardSwiperController cardSwiperController;
  late List<GlobalKey<FlipCardState>> cardKeys;

  int _studiedCards = 0;
  bool _showAnswer = false;
  Color? _currentBorderColor;
  Timer? _borderTimer;
  bool isCurrentCardAnswered = false;
  int _currentIndex = 0;

  int get studiedCards => _studiedCards;
  int get totalCards => cards.length;
  bool get showAnswer => _showAnswer;
  Color? get currentBorderColor => _currentBorderColor;

  IntermittentStudyViewModel({required this.cards}) {
    cardSwiperController = CardSwiperController();
    cardKeys = List.generate(cards.length, (_) => GlobalKey<FlipCardState>());
  }

  void toggleShowAnswer() {
    _showAnswer = !showAnswer;
    notifyListeners();
  }

  void flipCurrentCard(BuildContext context) {
    cardKeys[_currentIndex].currentState?.toggleCard();
  }

  void answerCard(int difficulty) {
    if (!isCurrentCardAnswered) {
      isCurrentCardAnswered = true;
      _studiedCards++;
      _showAnswer = false;
      print(difficulty);
      if (difficulty == 0 || difficulty == 1) {
        cardSwiperController.swipe(CardSwiperDirection.left);
      } else {
        cardSwiperController.swipe(CardSwiperDirection.right);
      }
      notifyListeners();
    }
  }

  bool onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    // Reset isCurrentCardAnswered when swiping to a new card
    isCurrentCardAnswered = false;
    // You can add logic here if needed when a card is swiped
    if (currentIndex != null) {
      _currentIndex = currentIndex;
      _showAnswer = false;
      notifyListeners();
    }
    return true;
  }

  void flipCard(int index) {
    cardKeys[index].currentState?.toggleCard();
  }

  void setBorderColor(Color color) {
    _currentBorderColor = color;
    notifyListeners();

    _borderTimer?.cancel();
    _borderTimer = Timer(const Duration(milliseconds: 400), () {
      _currentBorderColor = null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _borderTimer?.cancel();
    super.dispose();
  }
}