import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/helpers/content_embedding.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/business/services/navigation/route_names.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';

enum TabSegment { articles, tips }

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  TabSegment _selectedSegment = TabSegment.articles;

  final articles = ContentEmbedding().articles;
  final tips = ContentEmbedding().nutritionTips;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        color: Theme.of(context).colorScheme.onPrimary,
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: CupertinoSlidingSegmentedControl<TabSegment>(
                  backgroundColor: Theme.of(context).extension<CustomColors>()!.sliderBg!,
                  thumbColor: Theme.of(context).colorScheme.onPrimary,
                  groupValue: _selectedSegment,
                  padding: const EdgeInsets.all(2),
                  onValueChanged: (TabSegment? value) {
                    if (value != null) {
                      setState(() {
                        _selectedSegment = value;
                      });
                    }
                  },
                  children: <TabSegment, Widget>{
                    TabSegment.articles: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Articles',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: _selectedSegment == TabSegment.articles
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                    TabSegment.tips: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Tips',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: _selectedSegment == TabSegment.tips
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  },
                ),
              ),
              const SizedBox(height: 35),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ..._selectedSegment == TabSegment.articles
                        ? articles.map((e) => ArticleContainer(
                              article: e,
                              index: articles.indexOf(e),
                            ))
                        : tips.map((e) => TipContainer(
                              tip: e,
                              index: tips.indexOf(e),
                            )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({super.key, required this.article, required this.index});

  final Article article;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.of(context).pushNamed(RouteNames.article, arguments: article),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Theme.of(context).colorScheme.primary)),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                child: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TipContainer extends StatelessWidget {
  const TipContainer({super.key, required this.tip, required this.index});

  final String tip;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Theme.of(context).colorScheme.primary)),
            child: Center(
              child: Text(
                '${index + 1}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              child: Text(
                tip,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ArticleView extends StatelessWidget {
  const ArticleView({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
        color: Theme.of(context).colorScheme.onPrimary,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 13,
                    width: 9,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: ImageHelper.svgImage(SvgNames.arrowLeft, width: 7, height: 13),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Text(article.title,
                          maxLines: 2, style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      article.text,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
