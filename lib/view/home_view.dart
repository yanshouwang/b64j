import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ValueNotifier<Future<ui.Image?>> _future;

  @override
  void initState() {
    super.initState();
    _future = ValueNotifier(Future.value(null));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            Expanded(
              child: CupertinoTextField(
                onChanged: (text) => _future.value = _decode(text),
                maxLines: null,
                expands: true,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _future,
                builder: (context, future, child) {
                  return FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      final state = snapshot.connectionState;
                      final image = snapshot.data;
                      return Column(
                        spacing: 16.0,
                        children: [
                          Spacer(),
                          state == ConnectionState.done
                              ? image == null
                                    ? Icon(CupertinoIcons.nosign)
                                    : RawImage(image: image)
                              : CupertinoActivityIndicator(),
                          if (image != null)
                            Text('${image.width} × ${image.height}'),
                          Spacer(),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _future.dispose();
    super.dispose();
  }

  Future<ui.Image?> _decode(String text) async {
    try {
      final value = base64.decode(text);
      final buffer = await ui.ImmutableBuffer.fromUint8List(value);
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final codec = await descriptor.instantiateCodec();
      final info = await codec.getNextFrame();
      return info.image;
    } catch (e) {
      return null;
    }
  }
}
