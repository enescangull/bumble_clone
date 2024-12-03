import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/components/dropdown_genders.dart';
import 'package:bumble_clone/common/constants.dart';
import 'package:bumble_clone/presentation/filter/bloc/filter_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bumble_clone/presentation/filter/bloc/filter_bloc.dart';
import 'package:bumble_clone/presentation/filter/bloc/filter_state.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  double? ageMin, ageMax;
  double? maxDistance = 100;
  Genders? preferredGender;
  RangeValues? rangeValues;
  RangeLabels? labels = const RangeLabels('18', '80');

  @override
  void initState() {
    super.initState();
    preferredGender = Genders.female;
    context.read<FilterBloc>().add(GetFilterParameters());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FilterBloc, FilterState>(
        listener: (context, state) {
          if (state is FiltersLoaded) {
            setState(() {
              ageMin = state.preferencesModel.ageMin.toDouble();
              ageMax = state.preferencesModel.ageMax.toDouble();
              rangeValues = RangeValues(ageMin ?? 18, ageMax ?? 80);
              labels = RangeLabels(
                  rangeValues!.start.toString(), rangeValues!.end.toString());
              maxDistance = state.preferencesModel.distance.toDouble();
              preferredGender = Genders.values.firstWhere(
                (gender) =>
                    gender.value == state.preferencesModel.preferredGender,
              );
            });
          }
        },
        child: BlocBuilder<FilterBloc, FilterState>(
          builder: (context, state) {
            if (state is FiltersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FiltersLoaded) {
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                        onPressed: () {
                          BlocProvider.of<FilterBloc>(context).add(
                              UpdatePreferences(
                                  ageMin: ageMin!.toInt(),
                                  ageMax: ageMax!.toInt(),
                                  distance: maxDistance!.round().toInt(),
                                  preferredGender: preferredGender!.value));
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close_rounded)),
                    title: const Text("Narrow your search"),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 15, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Select preferred gender section
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            "Who would you like to date?",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownGenders(
                          value: preferredGender!,
                          onSelected: (gender) {
                            setState(() {
                              preferredGender = gender;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Select age preference section

                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            "How old are they?",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, top: 10),
                                child: Text(
                                  "Between ${labels!.start} and ${labels!.end}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              RangeSlider(
                                activeColor: AppColors.black,
                                inactiveColor: AppColors.lightGrey,
                                values: rangeValues!,
                                min: 18,
                                max: 80,
                                divisions: 62,
                                onChanged: (value) {
                                  setState(() {
                                    rangeValues = value;
                                    ageMin = rangeValues!.start;
                                    ageMax = rangeValues!.end;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            "How close they are?",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Maximum distance",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      "${maxDistance!.round().toString()} km",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              RangeSlider(
                                inactiveColor: AppColors.lightGrey,
                                activeColor: AppColors.black,
                                values: RangeValues(0, maxDistance!),
                                min: 0,
                                max: 100,
                                labels: RangeLabels(
                                    "", maxDistance!.round().toString()),
                                onChanged: (value) {
                                  setState(() {
                                    maxDistance = value.end;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(
                child: Column(
              children: [
                const Text("AMINA KOYDUĞUMUN YERİNDE BİR PROBLEM VAR"),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close))
              ],
            ));
          },
        ),
      ),
    );
  }
}
