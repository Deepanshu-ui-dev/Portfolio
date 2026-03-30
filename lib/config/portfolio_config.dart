class PortfolioConfig {
  static const String name = 'Deepanshu Kaushik';
  static const String firstName = 'Deepanshu';
  static const int age = 20;
  static const String location = 'Ghaziabad, India';
  static const String role = 'UI/UX Designer • Flutter Developer';
  static const String email = 'imdeepanshu4work@gmail.com';
  static const String phone = '+91 9582405021';

  static const String githubUrl = 'https://github.com/Deepanshu-ui-dev';
  static const String resumeUrl = 'https://github.com/Deepanshu-ui-dev/portfolio/raw/main/resume.pdf';
  static const String githubUsername = 'Deepanshu-ui-dev';
  static const String linkedinUrl = 'https://linkedin.com/in/deepanshu-kaushik';
  static const String twitterUrl = 'https://twitter.com/deepanshu_ui';
  static const String websiteUrl = 'https://deepanshui.framer.website/';

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
      installUrl: 'https://github.com/Deepanshu-ui-dev/Codexa-App/releases/download/Codexa/Codexa1.0.3.apk',
    ),
    ProjectItem(
      name: 'Document-Search-Engine',
      description: 'Built a document search engine using an inverted index and TF-IDF ranking, supporting fast keyword and phrase queries via positional indexing.',
      tags: ['CLI', 'Algorithm'],
      badge: 'Public',
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Document-Search-Engine',
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