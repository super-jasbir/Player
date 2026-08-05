import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'sound_service.dart';

/// Sentinel stored inside a [MetaData] widget to mark a subtree whose taps must
/// NOT trigger the global UI click sound. Wrap such widgets with [NoTapSound].
class _NoTapSoundMarker {
  const _NoTapSoundMarker();
}

const _NoTapSoundMarker _kNoTapSound = _NoTapSoundMarker();

/// Wrap a tappable widget with this to mark it as a "back" control: instead of
/// the normal click, [GlobalTapSound] plays the dedicated back sound when it is
/// tapped. Used for every back button in the app.
class NoTapSound extends StatelessWidget {
  final Widget child;

  const NoTapSound({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Translucent so the wrapped button keeps its normal hit behaviour; the
    // marker just has to appear in the hit-test path for [GlobalTapSound].
    return MetaData(
      metaData: _kNoTapSound,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

/// Plays [SoundService.playClick] whenever the user taps a real, tappable
/// widget anywhere in the app — so individual screens never have to opt in.
///
/// Wrap the app's content once (in `MaterialApp.builder`). It watches for
/// pointer-ups at the root, hit-tests the tapped point, and only makes a sound
/// when the hit path contains a widget that actually handles taps. Scrolls,
/// drags and taps on inert areas stay silent; subtrees wrapped in [NoTapSound]
/// (back buttons) play the back sound instead of the click.
class GlobalTapSound extends StatefulWidget {
  final Widget child;

  const GlobalTapSound({super.key, required this.child});

  @override
  State<GlobalTapSound> createState() => _GlobalTapSoundState();
}

class _GlobalTapSoundState extends State<GlobalTapSound> {
  final GlobalKey _childKey = GlobalKey();

  /// The first finger currently down; extra simultaneous touches are ignored.
  int? _pointer;
  Offset _downPosition = Offset.zero;

  void _onPointerDown(PointerDownEvent event) {
    _pointer ??= event.pointer;
    if (event.pointer == _pointer) _downPosition = event.position;
  }

  void _onPointerUp(PointerUpEvent event) {
    final bool tracked = event.pointer == _pointer;
    if (tracked) _pointer = null;
    if (!tracked) return;

    // A drag/scroll moves further than the touch slop — that is not a tap.
    if ((event.position - _downPosition).distance > kTouchSlop) return;

    _maybePlay(event.position);
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (event.pointer == _pointer) _pointer = null;
  }

  void _maybePlay(Offset globalPosition) {
    final RenderObject? root = _childKey.currentContext?.findRenderObject();
    if (root is! RenderBox) return;

    final BoxHitTestResult result = BoxHitTestResult();
    root.hitTest(result, position: root.globalToLocal(globalPosition));

    bool tappable = false;
    bool isBack = false;
    for (final HitTestEntry entry in result.path) {
      final Object target = entry.target;
      // Inside a NoTapSound subtree (e.g. a back button): play the back sound
      // instead of the normal click.
      if (target is RenderMetaData && target.metaData is _NoTapSoundMarker) {
        isBack = true;
      }
      // A bare GestureDetector with an onTap exposes it here.
      if (target is RenderSemanticsGestureHandler && target.onTap != null) {
        tappable = true;
      }
      // InkWell / InkResponse and every Material button (ElevatedButton,
      // TextButton, IconButton, …) mark their inner GestureDetector as
      // excludeFromSemantics and instead carry the tap on an outer
      // Semantics(onTap:) — which lands here as a RenderSemanticsAnnotations.
      if (target is RenderSemanticsAnnotations &&
          target.properties.onTap != null) {
        tappable = true;
      }
    }

    if (!tappable) return;
    if (isBack) {
      SoundService.instance.playBack();
    } else {
      SoundService.instance.playClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: KeyedSubtree(key: _childKey, child: widget.child),
    );
  }
}
