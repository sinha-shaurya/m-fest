import 'package:aash_india/presentations/widgets/capitalize.dart';
import 'package:flutter/material.dart';

class CityAutocomplete extends StatelessWidget {
  final List<String> cities;
  final TextEditingController cityController;

  const CityAutocomplete({
    super.key,
    required this.cities,
    required this.cityController,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return cities.where((city) =>
            city.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selection) {
        cityController.text = capitalize(selection);
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "City",
            prefixIcon: const Icon(Icons.location_on),
            fillColor: Colors.white60,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF386641)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
            textEditingController.value = TextEditingValue(
              text: capitalize(value),
              selection: textEditingController.selection,
            );
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
