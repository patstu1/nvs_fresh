import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nvs/meatup_core.dart';
import '../../domain/models/connect_models.dart';

/// Multiple choice question widget
class MultipleChoiceQuestion extends StatefulWidget {
  const MultipleChoiceQuestion({
    required this.question,
    required this.onAnswered,
    super.key,
  });
  final CuratorQuestion question;
  final Function(String) onAnswered;

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    final List<String> choices = widget.question.choices ?? <String>[];
    _slideAnimations = List.generate(choices.length, (int index) {
      return Tween<Offset>(
        begin: Offset(0, 1 + (index * 0.1)),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: Interval(
            index * 0.1,
            1.0,
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _selectChoice(String choice) {
    HapticFeedback.lightImpact();
    widget.onAnswered(choice);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> choices = widget.question.choices ?? <String>[];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: choices.asMap().entries.map((MapEntry<int, String> entry) {
          final int index = entry.key;
          final String choice = entry.value;

          return SlideTransition(
            position: _slideAnimations[index],
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectChoice(choice),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: NVSColors.cardBackground.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: NVSColors.neonMint.withValues(alpha: 0.3),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.neonMint.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      choice,
                      style: const TextStyle(
                        fontFamily: 'MagdaClean',
                        fontSize: 16,
                        color: NVSColors.ultraLightMint,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Image selection question widget
class ImageSelectQuestion extends StatefulWidget {
  const ImageSelectQuestion({
    required this.question,
    required this.onAnswered,
    super.key,
  });
  final CuratorQuestion question;
  final Function(String) onAnswered;

  @override
  State<ImageSelectQuestion> createState() => _ImageSelectQuestionState();
}

class _ImageSelectQuestionState extends State<ImageSelectQuestion>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _selectImage(String imageUrl) {
    HapticFeedback.lightImpact();
    widget.onAnswered(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = widget.question.imageUrls ?? <String>[];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _scaleController,
                curve: Interval(
                  index * 0.2,
                  1.0,
                  curve: Curves.elasticOut,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () => _selectImage(imageUrls[index]),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: NVSColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: NVSColors.neonMint.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.neonMint.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    children: <Widget>[
                      // Placeholder for image
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: NVSColors.neonMint.withValues(alpha: 0.1),
                        child: Icon(
                          Icons.image,
                          color: NVSColors.neonMint.withValues(alpha: 0.5),
                          size: 40,
                        ),
                      ),
                      // Overlay
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.transparent,
                              NVSColors.pureBlack.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Slider question widget
class SliderQuestion extends StatefulWidget {
  const SliderQuestion({
    required this.question,
    required this.onAnswered,
    super.key,
  });
  final CuratorQuestion question;
  final Function(double) onAnswered;

  @override
  State<SliderQuestion> createState() => _SliderQuestionState();
}

class _SliderQuestionState extends State<SliderQuestion> {
  double _currentValue = 5.0;

  void _submitValue() {
    HapticFeedback.lightImpact();
    widget.onAnswered(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                '1',
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 16,
                  color: NVSColors.secondaryText,
                ),
              ),
              Text(
                _currentValue.round().toString(),
                style: const TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.neonMint,
                ),
              ),
              const Text(
                '10',
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 16,
                  color: NVSColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: NVSColors.neonMint,
              inactiveTrackColor: NVSColors.neonMint.withValues(alpha: 0.2),
              thumbColor: NVSColors.ultraLightMint,
              overlayColor: NVSColors.neonMint.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _currentValue,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (double value) {
                setState(() {
                  _currentValue = value;
                });
                HapticFeedback.selectionClick();
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitValue,
            style: ElevatedButton.styleFrom(
              backgroundColor: NVSColors.neonMint,
              foregroundColor: NVSColors.pureBlack,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontFamily: 'MagdaClean',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Yes/No question widget
class YesNoQuestion extends StatelessWidget {
  const YesNoQuestion({
    required this.question,
    required this.onAnswered,
    super.key,
  });
  final CuratorQuestion question;
  final Function(bool) onAnswered;

  void _selectAnswer(bool answer) {
    HapticFeedback.lightImpact();
    onAnswered(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => _selectAnswer(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: NVSColors.neonMint.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: NVSColors.neonMint.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Text(
                  'YES',
                  style: TextStyle(
                    fontFamily: 'MagdaClean',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NVSColors.neonMint,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectAnswer(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: NVSColors.cardBackground.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: NVSColors.secondaryText.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Text(
                  'NO',
                  style: TextStyle(
                    fontFamily: 'MagdaClean',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NVSColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Text input question widget
class TextInputQuestion extends StatefulWidget {
  const TextInputQuestion({
    required this.question,
    required this.onAnswered,
    super.key,
  });
  final CuratorQuestion question;
  final Function(String) onAnswered;

  @override
  State<TextInputQuestion> createState() => _TextInputQuestionState();
}

class _TextInputQuestionState extends State<TextInputQuestion> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitText() {
    if (_controller.text.trim().isNotEmpty) {
      HapticFeedback.lightImpact();
      widget.onAnswered(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 3,
            style: const TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 16,
              color: NVSColors.ultraLightMint,
            ),
            decoration: InputDecoration(
              hintText: 'Share your thoughts...',
              hintStyle: TextStyle(
                fontFamily: 'MagdaClean',
                color: NVSColors.secondaryText.withValues(alpha: 0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: NVSColors.neonMint.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: NVSColors.neonMint,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: NVSColors.pureBlack.withValues(alpha: 0.3),
            ),
            onSubmitted: (_) => _submitText(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitText,
            style: ElevatedButton.styleFrom(
              backgroundColor: NVSColors.neonMint,
              foregroundColor: NVSColors.pureBlack,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontFamily: 'MagdaClean',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
