part of 'image_editor.dart';

class _FaceSelector extends StatefulWidget {
  const _FaceSelector();

  @override
  State<StatefulWidget> createState() => _FaceSelectorState();
}

class _FaceSelectorState extends State<_FaceSelector> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_key.currentContext != null) {
            context.addEvent(
              _SetFaceSelectorImageSize(_key.currentContext!.size!),
            );
          }
        });
        return false;
      },
      child: _BlocBuilder(
        buildWhen:
            (previous, current) =>
                previous.faceLandmarks != current.faceLandmarks ||
                previous.selectedFaces != current.selectedFaces ||
                previous.faceSelectorImageSize != current.faceSelectorImageSize,
        builder:
            (context, state) => Center(
              child: IntrinsicHeight(
                child: Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: SizeChangedLayoutNotifier(
                        key: _key,
                        child: IntrinsicHeight(
                          child: _BlocBuilder(
                            buildWhen:
                                (previous, current) =>
                                    previous.src != current.src ||
                                    previous.dst != current.dst,
                            builder:
                                (context, state) => Image(
                                  image: (state.dst ?? state.src!).let(
                                    (obj) => PixelImage(
                                      obj.pixel,
                                      obj.width,
                                      obj.height,
                                    ),
                                  ),
                                  fit: BoxFit.contain,
                                  gaplessPlayback: true,
                                  frameBuilder: (
                                    context,
                                    child,
                                    frame,
                                    wasSynchronouslyLoaded,
                                  ) {
                                    const SizeChangedLayoutNotification()
                                        .dispatch(context);
                                    return child;
                                  },
                                ),
                          ),
                        ),
                      ),
                    ),
                    if (state.faceSelectorImageSize == null ||
                        state.faceLandmarks == null)
                      const Positioned.fill(child: _FaceSelectorDetectingView())
                    else
                      ...state.faceLandmarks!.map((f) {
                        final src = state.postTransformSrc ?? state.src!;
                        return Positioned(
                          left:
                              f.boundingBox.left /
                                  src.width *
                                  state.faceSelectorImageSize!.width +
                              // Make it work with portrait image
                              (MediaQuery.sizeOf(context).width -
                                      state.faceSelectorImageSize!.width) /
                                  2,
                          top:
                              f.boundingBox.top /
                              src.height *
                              state.faceSelectorImageSize!.height,
                          width:
                              f.boundingBox.width /
                              src.width *
                              state.faceSelectorImageSize!.width,
                          height:
                              f.boundingBox.height /
                              src.height *
                              state.faceSelectorImageSize!.height,
                          child: AnimatedEnterOpacity(
                            curve: Curves.easeOut,
                            duration: k.animationDurationNormal,
                            child: AnimatedEnterScale(
                              curve: Curves.easeOut,
                              duration: k.animationDurationNormal,
                              from: 1.5,
                              child: GestureDetector(
                                onTap: () {
                                  context.addEvent(_ToggleFaceSelection(f));
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          state.selectedFaces.contains(f)
                                              ? Colors.green
                                              : Colors.white,
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  final _key = GlobalKey();
}

class _FaceSelectorDetectingView extends StatelessWidget {
  const _FaceSelectorDetectingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            Text(L10n.global().imageEditFaceDetectionRunningMessage),
          ],
        ),
      ),
    );
  }
}
