class BlogPost {
  final String slug;
  final String title;
  final String date;
  final String excerpt;
  final String content;

  const BlogPost({
    required this.slug,
    required this.title,
    required this.date,
    required this.excerpt,
    required this.content,
  });
}

final List<BlogPost> blogPosts = [
  BlogPost(
    slug: 'design-to-development-workflow',
    title: 'My Design-to-Development Workflow',
    date: '2026-02-18',
    excerpt:
        'How I move from product idea to polished Flutter interface with clear handoff.',
    content: '''
# My Design-to-Development Workflow

**2026-02-18**

---

When building products, my goal is simple: 
design interfaces that feel clear, fast, and useful from the first interaction.

## 1) Start with structure, not colors

I begin with content hierarchy and user flow. Before visual polish, I map:

- Core user actions
- Information priority
- Edge cases for mobile and desktop

This keeps the product useful even in low-fidelity form.

## 2) Build a reusable system in Figma

I avoid one-off components. I create a shared system for spacing, typography, 
states, and reusable components so scaling the product stays predictable.

## 3) Translate directly into Flutter components

I turn design blocks into composable Flutter widgets and keep naming aligned 
with the design system. This makes handoff easy and future updates faster.

## 4) Iterate with feedback

I validate with real use cases, improve readability, tighten spacing, and 
optimize interactions. The final version should look good, but also feel effortless.

---

If you want to collaborate on product UI or Flutter interfaces, 
feel free to reach out via email.
''',
  ),
];

class BlogRepository {
  List<BlogPost> getAllPosts() => blogPosts;

  BlogPost? getPost(String slug) {
    try {
      return blogPosts.firstWhere((p) => p.slug == slug);
    } catch (_) {
      return null;
    }
  }
}
