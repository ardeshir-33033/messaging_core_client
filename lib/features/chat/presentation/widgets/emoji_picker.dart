import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';
import 'package:messaging_core/locator.dart';

class EmojiPickerWidget extends StatefulWidget {
  const EmojiPickerWidget(
      {super.key,
      required this.textController,
      required this.scrollController});

  final TextEditingController textController;
  final ScrollController scrollController;

  @override
  State<EmojiPickerWidget> createState() => _EmojiPickerWidgetState();
}

class _EmojiPickerWidgetState extends State<EmojiPickerWidget> {
  final EmojiController emojiController = Get.find<EmojiController>();

  final _utils = EmojiPickerUtils();
  late final EmojiTextEditingController _controller;
  late final TextStyle _textStyle;
  final bool isApple = [TargetPlatform.iOS, TargetPlatform.macOS]
      .contains(foundation.defaultTargetPlatform);

  Color accentColor = const Color(0xFF4BA586);
  Color accentColorDark = const Color(0xFF377E6A);
  Color backgroundColor = const Color(0xFFEEE7DF);
  Color secondaryColor = const Color(0xFF8B98A0);
  Color systemBackgroundColor = const Color(0xFFF7F8FA);

  @override
  void initState() {
    final fontSize = 24 * (isApple ? 1.2 : 1.0);

    _textStyle = DefaultEmojiTextStyle.copyWith(
      fontFamily: GoogleFonts.notoColorEmoji().fontFamily,
      fontSize: fontSize,
    );

    _controller = EmojiTextEditingController(emojiTextStyle: _textStyle);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmojiController>(
        id: "emoji",
        builder: (_) {
          return emojiController.emojiShowing
              ? EmojiPicker(
                  textEditingController: widget.textController,
                  scrollController: widget.scrollController,
                  onEmojiSelected: (Category? category, Emoji emoji) {
                    emojiController.handleShowSendButton();
                  },
                  onBackspacePressed: () {
                    if (widget.textController.text.isEmpty) {
                      emojiController.handleNotShowSendButton();
                    }
                  },
                  config: Config(
                    height: 256,
                    checkPlatformCompatibility: true,
                    emojiTextStyle: _textStyle,
                    emojiViewConfig: const EmojiViewConfig(
                      backgroundColor: Colors.white,
                    ),
                    swapCategoryAndBottomBar: true,
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: Colors.white,
                      dividerColor: Colors.white,
                      indicatorColor: accentColor,
                      iconColorSelected: Colors.black,
                      iconColor: secondaryColor,
                      customCategoryView: (
                        config,
                        state,
                        tabController,
                        pageController,
                      ) {
                        return WhatsAppCategoryView(
                          config,
                          state,
                          tabController,
                          pageController,
                        );
                      },
                      categoryIcons: const CategoryIcons(
                        recentIcon: Icons.access_time_outlined,
                        smileyIcon: Icons.emoji_emotions_outlined,
                        animalIcon: Icons.cruelty_free_outlined,
                        foodIcon: Icons.coffee_outlined,
                        activityIcon: Icons.sports_soccer_outlined,
                        travelIcon: Icons.directions_car_filled_outlined,
                        objectIcon: Icons.lightbulb_outline,
                        symbolIcon: Icons.emoji_symbols_outlined,
                        flagIcon: Icons.flag_outlined,
                      ),
                    ),
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor: Colors.white,
                      buttonColor: Colors.white,
                      buttonIconColor: secondaryColor,
                    ),
                    searchViewConfig: SearchViewConfig(
                      backgroundColor: Colors.white,
                      customSearchView: (
                        config,
                        state,
                        showEmojiView,
                      ) {
                        return WhatsAppSearchView(
                          config,
                          state,
                          showEmojiView,
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox();
        });
  }
}

/// Customized Whatsapp category view
class WhatsAppCategoryView extends CategoryView {
  const WhatsAppCategoryView(
    super.config,
    super.state,
    super.tabController,
    super.pageController, {
    super.key,
  });

  @override
  WhatsAppCategoryViewState createState() => WhatsAppCategoryViewState();
}

class WhatsAppCategoryViewState extends State<WhatsAppCategoryView>
    with SkinToneOverlayStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.config.categoryViewConfig.backgroundColor,
      child: Row(
        children: [
          Expanded(
            child: WhatsAppTabBar(
              widget.config,
              widget.tabController,
              widget.pageController,
              widget.state.categoryEmoji,
              closeSkinToneOverlay,
            ),
          ),
          _buildBackspaceButton(),
        ],
      ),
    );
  }

  Widget _buildBackspaceButton() {
    if (widget.config.categoryViewConfig.showBackspaceButton) {
      return BackspaceButton(
        widget.config,
        widget.state.onBackspacePressed,
        widget.state.onBackspaceLongPressed,
        widget.config.categoryViewConfig.backspaceColor,
      );
    }
    return const SizedBox.shrink();
  }
}

class WhatsAppTabBar extends StatelessWidget {
  const WhatsAppTabBar(
    this.config,
    this.tabController,
    this.pageController,
    this.categoryEmojis,
    this.closeSkinToneOverlay, {
    super.key,
  });

  final Config config;

  final TabController tabController;

  final PageController pageController;

  final List<CategoryEmoji> categoryEmojis;

  final VoidCallback closeSkinToneOverlay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: config.categoryViewConfig.tabBarHeight,
      child: TabBar(
        labelColor: config.categoryViewConfig.iconColorSelected,
        indicatorColor: config.categoryViewConfig.indicatorColor,
        unselectedLabelColor: config.categoryViewConfig.iconColor,
        dividerColor: config.categoryViewConfig.dividerColor,
        controller: tabController,
        labelPadding: const EdgeInsets.only(top: 1.0),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black12,
        ),
        onTap: (index) {
          closeSkinToneOverlay();
          pageController.jumpToPage(index);
        },
        tabs: categoryEmojis
            .asMap()
            .entries
            .map<Widget>(
                (item) => _buildCategory(item.key, item.value.category))
            .toList(),
      ),
    );
  }

  Widget _buildCategory(int index, Category category) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          getIconForCategory(
            config.categoryViewConfig.categoryIcons,
            category,
          ),
          size: 20,
        ),
      ),
    );
  }
}

/// Custom Whatsapp Search view implementation
class WhatsAppSearchView extends SearchView {
  const WhatsAppSearchView(super.config, super.state, super.showEmojiView,
      {super.key});

  @override
  WhatsAppSearchViewState createState() => WhatsAppSearchViewState();
}

class WhatsAppSearchViewState extends SearchViewState {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final emojiSize =
          widget.config.emojiViewConfig.getEmojiSize(constraints.maxWidth);
      final emojiBoxSize =
          widget.config.emojiViewConfig.getEmojiBoxSize(constraints.maxWidth);
      return Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: emojiBoxSize + 8.0,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                scrollDirection: Axis.horizontal,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return buildEmoji(
                    results[index],
                    emojiSize,
                    emojiBoxSize,
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: widget.showEmojiView,
                  color: widget.config.searchViewConfig.buttonColor,
                  icon: Icon(
                    Icons.arrow_back,
                    color: widget.config.searchViewConfig.buttonIconColor,
                    size: 20.0,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: onTextInputChanged,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
