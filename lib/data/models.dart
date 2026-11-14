import 'package:flutter/material.dart';

@immutable
class TitleItem {
  const TitleItem({
    required this.id,
    required this.name,
    required this.poster,
    required this.year,
    required this.maturity,
    required this.episodes,
    required this.duration,
    required this.match,
    required this.genres,
    required this.synopsis,
    required this.cast,
    this.isSeries = true,
    this.progress = 0,
    this.badge,
    this.seasons = 1,
  });

  final String id;
  final String name;
  final String poster;
  final int year;
  final String maturity;
  final int episodes;
  final String duration;
  final int match;
  final List<String> genres;
  final String synopsis;
  final String cast;
  final bool isSeries;
  final double progress;
  final String? badge;
  final int seasons;

  String get metaLine => '$year  •  $maturity  •  $episodes Episodes';
}

@immutable
class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.color,
    this.isKids = false,
    this.avatar,
  });

  final String id;
  final String name;
  final Color color;
  final bool isKids;
  final String? avatar;
}

@immutable
class RowData {
  const RowData({
    required this.title,
    required this.items,
    this.wide = false,
    this.showProgress = false,
  });

  final String title;
  final List<TitleItem> items;
  final bool wide;
  final bool showProgress;
}
