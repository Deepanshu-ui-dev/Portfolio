class PortfolioConfig {
  static const String name = 'Deepanshu Kaushik';
  static const String firstName = 'Deepanshu';
  static const int age = 20;
  static const String location = 'Delhi, India';
  static const String role = 'UI/UX Designer • Flutter Developer';
  static const String email = 'imdeepanshu4work@gmail.com';
  static const String phone = '+91 9582405021';

  static const String githubUrl = 'https://github.com/Deepanshu-ui-dev';
  static const String resumeUrl = 'https://drive.google.com/file/d/13DlMr7MfBh8kz5IzYKE3XHK9S-YF9bix/view?usp=sharing';
  static const String githubUsername = 'Deepanshu-ui-dev';
  static const String linkedinUrl = 'https://www.linkedin.com/in/imdeepanshukaushik/';
  static const String twitterUrl = 'https://x.com/Deepanshu25u';
  static const String websiteUrl = 'https://deepanshui.framer.website/';
  static const String visitorApiUrl = 'https://api.counterapi.dev/v1/deepanshux.tech/visits';

  // Supabase credentials - can be overridden via --dart-define
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://jqddkjhxjsuskpebqgfr.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpxZGRramh4anN1c2twZWJxZ2ZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY1OTc1MjksImV4cCI6MjA5MjE3MzUyOX0.LVL9t6ix1z4hOJirqY83pw8M89m_3ZIl9okB0Z7aR5Y',
  );

  static const String bio =
      'I\'m a UI/UX designer and Flutter developer currently pursuing B.Tech in Data Science at ABES Engineering College (2023–2027). '
      'I craft pixel-perfect interfaces and scalable design systems — currently working as Founding Designer at Layerance while freelancing for web and mobile clients worldwide. '
      'I believe great products live at the intersection of clean code, bold design, and deep empathy for users.';

  static const String college = 'ABES Engineering College (ABESEC)';
  static const String degree = 'B.Tech — Data Science';
  static const String eduPeriod = '2023 — 2027';

  static const List<ProjectItem> projects = [
    ProjectItem(
      name: 'Codexa-App',
      description: 'A unified coding analytics platform that tracks problem-solving trends across LeetCode, CodeChef, and other competitive programming platforms.',
      tags: ['Flutter', 'Open Source'],
      badge: 'Public',
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Codexa-App',
      installUrl: 'https://github.com/Deepanshu-ui-dev/Codexa-App/releases/latest/',
    ),
    ProjectItem(
      name: 'Document-Search-Engine',
      description: 'Built a document search engine using an inverted index and TF-IDF ranking, supporting fast keyword and phrase queries via positional indexing.',
      tags: ['CLI', 'Algorithm'],
      badge: 'Public',
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Document-Search-Engine',
    ),
    ProjectItem(
      name: 'Deepanshu-Kaushik-Portfolio',
      description: 'A minimal, interactive, high-refresh-rate personal portfolio built with Flutter and Dart, showcasing a custom glassmorphic design system and GitHub contribution integration.',
      tags: ['Flutter', 'Dart', 'UI/UX'],
      badge: 'Public',
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Deepanshu-Kaushik-Portfolio',
      liveUrl: 'https://www.deepanshux.tech/',
    ),
    ProjectItem(
      name: 'Chat-app-flutter',
      description: 'A Flutter chat application built while learning Flutter, implementing real-time messaging, user authentication, and a clean UI using Supabase.',
      tags: ['Flutter', 'Supabase'],
      badge: 'Public',
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Chat-app-flutter',
    ),
    ProjectItem(
      name: 'BarterNow',
      description: 'An AI-powered sponsorship marketplace that connects sponsors and event organizers effortlessly with smart matching and secure payments.',
      tags: ['UI/UX', 'Figma', 'Marketplace'],
      figmaUrl: 'https://www.figma.com/design/JSusKlnQlKXZuxwTEDqWn0/BARTERNOW?node-id=0-1&t=niAU5psXEhRhiZFA-1',
    ),
    ProjectItem(
      name: 'KNOW YOUR COLLEGE',
      description: 'Streamlines the entire admission journey by offering verified insights, personalized mentorship, real-time data, and an intuitive user experience.',
      tags: ['UI/UX', 'Figma', 'EdTech'],
      figmaUrl: 'https://www.figma.com/design/fSjnCY31C5NrGjkap5iofA/Know-Your-College?node-id=0-1&t=A3fmcd9PgvB8WXbW-1',
    ),
    ProjectItem(
      name: 'Layerance Task',
      description: 'UI/UX assignment demonstrating clean layout principles, user-centric flows and component design.',
      tags: ['UI/UX', 'Figma'],
      figmaUrl: 'https://www.figma.com/design/8mVqjDRjNToHNpKj6BPJPP/Layerance-Task?node-id=0-1&t=maPr4idi82bxqYlc-1',
    ),
  ];
}

class ProjectItem {
  final String name;
  final String description;
  final List<String> tags;
  final String? badge;
  final String? githubUrl;
  final String? liveUrl;
  final String? installUrl;
  final String? figmaUrl;

  const ProjectItem({
    required this.name,
    required this.description,
    required this.tags,
    this.badge,
    this.githubUrl,
    this.liveUrl,
    this.installUrl,
    this.figmaUrl,
  });
}

class ExperienceItem {
  final String company;
  final String duration;
  final bool isCurrent;
  final List<String> bullets;
  final List<String> tags;

  const ExperienceItem({
    required this.company,
    required this.duration,
    required this.bullets,
    required this.tags,
    this.isCurrent = false,
  });
}