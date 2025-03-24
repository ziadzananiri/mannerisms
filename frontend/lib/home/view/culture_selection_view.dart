import 'package:flutter/material.dart';
import 'package:mannerisms/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:mannerisms/home/viewmodel/culture_viewmodel.dart';
import 'package:mannerisms/utils/culture_images.dart';

class CultureSelectionView extends StatelessWidget {
  const CultureSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Culture'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<CultureViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Choose a Culture',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: viewModel.cultures.length,
                    itemBuilder: (context, index) {
                      final culture = viewModel.cultures[index];
                      final isSelected =
                          viewModel.selectedCulture == culture.tag;
                      return ElevatedButton(
                        onPressed: () => viewModel.selectCulture(culture.tag),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: isSelected
                              ? BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3)
                              : BorderSide.none,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                // Instead of using culture.tag, can also use "other" to only show flags for selected culture
                                cultureImages[isSelected
                                        ? viewModel.selectedCulture
                                        : culture.tag] ??
                                    cultureImages['other']!,
                              ),
                              fit: BoxFit.cover,
                            ),
                            color: isSelected
                                ? Colors.white.withValues(
                                    red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              minHeight: 50,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(
                                      red: 1.0,
                                      green: 1.0,
                                      blue: 1.0,
                                      alpha: 0.2)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  culture.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  culture.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Simple'),
                    const SizedBox(width: 8),
                    Switch(
                      value: viewModel.isAdvanced,
                      onChanged: (_) => viewModel.toggleDifficulty(),
                    ),
                    const SizedBox(width: 8),
                    const Text('Advanced'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: viewModel.canProceed()
                      ? !viewModel.isAdvanced
                          ? () => Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppConstants.mainRoute,
                                (Route<dynamic> route) => false,
                              )
                          : () => Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppConstants.advancedRoute,
                                (Route<dynamic> route) => false,
                              )
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Confirm Selection'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
