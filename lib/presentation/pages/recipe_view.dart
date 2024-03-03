import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/helpers/extensions/string_extension.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';

class RecipeView extends StatelessWidget {
  const RecipeView({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(recipe.base64Image);
    var photo = Image.memory(
      bytes,
      fit: BoxFit.cover,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            primary: false,
            elevation: 0,
            stretch: true,
            expandedHeight: MediaQuery.of(context).size.height / 2.2,
            flexibleSpace: _AppBar(
              image: photo,
            ),
            backgroundColor: Colors.transparent,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
          )
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  Text(
                    recipe.name.capitalize,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${recipe.calculateCalories().round()} calories',
                    style: Theme.of(context).textTheme.displaySmall,
                  )
                ],
              ),
            ),
            const SizedBox(height: 13),
            Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 9),
              decoration: BoxDecoration(
                color: Theme.of(context).extension<CustomColors>()!.background,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '${(recipe.calculateCalories() * 4.184).round()} K',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)),
                      ),
                      Text(
                        'Energy',
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${recipe.pro} g',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)),
                      ),
                      Text(
                        'Protein',
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${recipe.carb} g',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)),
                      ),
                      Text(
                        'Carbs',
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${recipe.fat} g',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)),
                      ),
                      Text(
                        'Fat',
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text('Ingredients', style: Theme.of(context).textTheme.displaySmall),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(recipe.ingredients,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6))),
            )
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final Image image;

  const _AppBar({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 20, left: 10),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        image: DecorationImage(
          image: image.image,
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoButton(
            child: ImageHelper.svgImage(SvgNames.arrowLeft, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
