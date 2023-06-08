import 'package:flutter/material.dart';

class SlideVerifyWidget extends StatefulWidget {
  /// 背景色
  final Color backgroundColor;

  /// 滑动过的颜色
  final Color slideColor;

  /// 边框颜色
  final Color borderColor;

  final double sheight;
  final double swidth;

  final VoidCallback? verifySuccessListener;

  const SlideVerifyWidget({
    this.backgroundColor = Colors.blueGrey,
    this.slideColor = Colors.green,
    this.borderColor = Colors.grey,
    this.sheight = 44,
    this.swidth = 240,
    this.verifySuccessListener,
    super.key,
  });

  @override
  SlideVerifyState createState() {
    return SlideVerifyState();
  }
}

class SlideVerifyState extends State<SlideVerifyWidget>
    with TickerProviderStateMixin {
  double sliderDistance = 0;

  double initial = 0.0;

  /// 滑动块宽度
  double sliderWidth = 64;

  /// 验证是否通过，滑动到最右方为通过
  bool verifySuccess = false;

  /// 是否允许拖动
  bool enableSlide = true;

  late AnimationController _animationController;
  late Animation _curve;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        if (!enableSlide) {
          return;
        }
        initial = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!enableSlide) {
          return;
        }
        sliderDistance = details.globalPosition.dx - initial;
        if (sliderDistance < 0) {
          sliderDistance = 0;
        }

        /// 当滑动到最右边时，通知验证成功，并禁止滑动
        if (sliderDistance > widget.swidth - sliderWidth) {
          sliderDistance = widget.swidth - sliderWidth;
          enableSlide = false;
          verifySuccess = true;
          if (widget.verifySuccessListener != null) {
            widget.verifySuccessListener!();
          }
        }
        setState(() {});
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        /// 滑动松开时，如果未达到最右边，启动回弹动画
        if (enableSlide) {
          enableSlide = false;
          _animationController.forward();
        }
      },
      child: Container(
        height: widget.sheight,
        width: widget.swidth,
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: widget.borderColor),

            /// 圆角实现
            borderRadius:
                BorderRadius.all(new Radius.circular(widget.sheight))),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: widget.sheight - 2,

                /// 当slider滑动到距左边只有两三像素距离时，已滑动背景会有一点点渲染出边框范围，
                /// 因此当滑动距离小于1时，直接将宽度设置为0，解决滑动块返回左边时导致的绿色闪动，但如果是缓慢滑动到左边该问题仍没解决
                width:
                    sliderDistance < 1 ? 0 : sliderDistance + sliderWidth / 2,
                decoration: BoxDecoration(
                    color: widget.slideColor,

                    /// 圆角实现
                    borderRadius: BorderRadius.all(
                        new Radius.circular(widget.sheight / 2))),
              ),
            ),
            Center(
              child: Text(
                verifySuccess ? "验证成功" : "请按住滑块，拖动到最右边",
                style: TextStyle(
                    color: verifySuccess ? Colors.white : Colors.black54,
                    fontSize: 14),
              ),
            ),
            Positioned(
              top: 0,

              /// 此处将sliderDistance距离往左偏2是解决当滑动块滑动到最右边时遮挡外部边框
              left: sliderDistance > sliderWidth
                  ? sliderDistance - 2
                  : sliderDistance,
              child: Container(
                width: sliderWidth,
                height: widget.sheight - 2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: widget.borderColor),

                    /// 圆角实现
                    borderRadius:
                        BorderRadius.all(new Radius.circular(widget.sheight))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    Image.asset(
                      "assets/images/ic_safety.png",
                      height: 24,
                      width: 24,
                    ),
                    Image.asset(
                      "assets/images/ic_next_primary.png",
                      height: 16,
                      width: 16,
                    ),

                    /// 因为向右箭头有透明边距导致两个箭头间隔过大，因此将第二个箭头向左偏移，如果切图无边距则不用偏移
                    Transform(
                      transform: Matrix4.translationValues(-8, 0, 0),
                      child: Image.asset(
                        "assets/images/ic_next_primary.png",
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 回弹动画
  void _initAnimation() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _curve.addListener(() {
      setState(() {
        sliderDistance = sliderDistance - sliderDistance * _curve.value;
        if (sliderDistance <= 0) {
          sliderDistance = 0;
        }
      });
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        enableSlide = true;
        _animationController.reset();
      }
    });
  }
}
