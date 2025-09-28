import 'package:flutter/material.dart';
import 'package:ios_color_picker/custom_picker/shared.dart';
import 'package:super_tooltip/super_tooltip.dart';

import 'color_observer.dart';
import 'extensions.dart';
import 'helpers/cache_helper.dart';

class HistoryColors extends StatefulWidget {
  final ValueChanged<Color> onColorChanged;
  const HistoryColors({super.key, required this.onColorChanged});

  @override
  State<HistoryColors> createState() => _HistoryColorsState();
}

class _HistoryColorsState extends State<HistoryColors> {
  int page = 0;
  int colorPage = 0;
  int toolTip = 0;
  PageController pageController = PageController();
  final _tipController = SuperTooltipController();

  List<Color> historyColors = [];

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    var savedColors = await CacheHelper().getData(key: "history_colors");
    if (savedColors == null || (savedColors as List).isEmpty) {
      historyColors = defaultHistoryColors;
      setHistory();
    } else {
      for (var value in savedColors) {
        historyColors.add(HexColor.fromHex(value.toString()));
      }
      setHistory(empty: false);
    }
  }

  void setHistory({bool empty = true, bool delete = false}) {
    page = 0;
    for (int i = 0; i < historyColors.length + 1; i++) {
      if (i % 10 == 0) {
        page++;
      }
    }
    if (empty) {
      historyColors.toStringList().forEach((v) {});
      CacheHelper()
          .setData(key: "history_colors", value: historyColors.toStringList());
      if (page > 1 && colorPage != page && !delete) {
        pageController.jumpToPage(page);
        colorPage = page;
      }
    } else {
      if (!delete) {
        Future.delayed(const Duration(milliseconds: 200)).then((v) {
          pageController.jumpToPage(page);
        });
      }
    }
    if (delete) {
      _tipController.hideTooltip();
    }
    setState(() {});
  }

  Future<void> showTooltip() async {
    _tipController.hideTooltip();
    await Future.delayed(const Duration(milliseconds: 200));
    _tipController.showTooltip();
  }

  @override
  void dispose() {
    pageController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: maxWidth(context) - 100,
      child: ListView.builder(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 20, left: 10),
        itemCount: historyColors.length + 1,
        itemBuilder: (context, index) {
          if (index == historyColors.length) {
            return IconButton(
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.black12
                      : Colors.white12,
                ),
                splashFactory: InkSparkle.splashFactory,
              ),
              onPressed: () {
                historyColors.add(colorController.value);
                setHistory();
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.grey.shade400,
                size: 24,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SuperTooltip(
              backgroundColor: Colors.grey.shade200,
              borderColor: Colors.transparent,
              onHide: () {
                toolTip = -1;
              },
              onLongPress: () {
                setState(() {
                  toolTip = index;
                });
                showTooltip();
              },
              showBarrier: false,
              hasShadow: false,
              sigmaY: 16,
              sigmaX: 16,
              arrowLength: 8,
              arrowTipDistance: 17,
              bubbleDimensions: EdgeInsets.zero,
              popupDirection: TooltipDirection.up,
              controller: toolTip == index ? _tipController : null,
              content: InkWell(
                splashColor: Colors.black12,
                splashFactory: InkSparkle.splashFactory,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                onTap: () {
                  historyColors.removeAt(index);
                  setHistory(delete: true);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      fontFamily: 'Anaheim',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: historyColors[index],
                    ),
                  ),
                  if (colorController.value.toHex() ==
                      historyColors[index].toHex())
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white24,
                        splashFactory: InkSparkle.splashFactory,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(100.0),
                        onTap: () {
                          colorController.updateColor(historyColors[index]);
                          widget.onColorChanged(colorController.value);
                          _tipController.hideTooltip();
                          toolTip = -1;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
