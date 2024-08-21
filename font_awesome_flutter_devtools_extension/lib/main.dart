import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'icons.dart';

void main() {
  runApp(const FontAwesomeGalleryApp());
}

class FontAwesomeGalleryApp extends StatelessWidget {
  const FontAwesomeGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(
      child: FontAwesomeGalleryHome(),
    );
  }
}

class FontAwesomeGalleryHome extends StatefulWidget {
  const FontAwesomeGalleryHome({super.key});

  @override
  State<StatefulWidget> createState() => FontAwesomeGalleryHomeState();
}

class FontAwesomeGalleryHomeState extends State<FontAwesomeGalleryHome> {
  var _searchTerm = "";
  var _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final filteredIcons = icons
        .where((icon) =>
            _searchTerm.isEmpty ||
            icon.title.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();
    final theme = Theme.of(context);
    return Column(
      children: [
        _isSearching ? _searchBar(context) : _titleBar(),
        Expanded(
          child: GridView.builder(
            itemCount: filteredIcons.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              mainAxisExtent: 90.0,
            ),
            itemBuilder: (context, index) {
              final icon = filteredIcons[index];
              return InkWell(
                onTap: () {
                  final iconName = 'FontAwesomeIcons.${icon.title}';
                  extensionManager.copyToClipboard(
                    'FontAwesomeIcons.${icon.title}',
                    successMessage: "Copied '$iconName' to clipboard.",
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(densePadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: icon,
                        child: FaIcon(
                          icon.iconData,
                          size: actionsIconSize,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: defaultSpacing),
                        child: Text(icon.title),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  AppBar _titleBar() {
    return AppBar(
      title: const Text("Font Awesome Flutter Gallery"),
      actions: [
        IconButton(
            icon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: defaultIconSize,
            ),
            onPressed: () {
              ModalRoute.of(context)?.addLocalHistoryEntry(
                LocalHistoryEntry(
                  onRemove: () {
                    setState(() {
                      _searchTerm = "";
                      _isSearching = false;
                    });
                  },
                ),
              );

              setState(() {
                _isSearching = true;
              });
            })
      ],
    );
  }

  AppBar _searchBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.arrowLeft,
          size: defaultIconSize,
        ),
        onPressed: () {
          setState(
            () {
              Navigator.pop(context);
              _isSearching = false;
              _searchTerm = "";
            },
          );
        },
      ),
      title: TextField(
        onChanged: (text) => setState(() => _searchTerm = text),
        autofocus: true,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}
