import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/dimensions.dart';

class ContainerWithPaddingMealSubscription extends StatelessWidget {
  final String content;
  
  const ContainerWithPaddingMealSubscription({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                        vertical: Dimensions.paddingSizeLarge),
                    child: Row(
                      children: [
                        
                        const Gap(5),
                        Expanded(
                            child: Text(
                          content,
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                       const Icon(Icons.chevron_right)
                      ],
                    ),
                  );
  }
}