import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = AppSpacing.horizontalPadding(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent  = isDark ? AppColors.accentDark : AppColors.accentLight;

    return FadeTransition(
      opacity: _fade,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: padding, vertical: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // ── [ 04 ] EDITORIAL HEADER ──────────────────────
                Row(children: [
                  Text('[ 04 ]',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: accent, letterSpacing: 1.5)),
                  const SizedBox(width: 10),
                  Text('CONTACT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: textSec, letterSpacing: 2)),
                ]),
                const SizedBox(height: 14),
                Text(
                  "Let's work together.",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                      height: 1.0,
                    ),
              ),
              const SizedBox(height: 16),

              // Sub tagline
              Row(children: [
                Expanded(
                  child: Text(
                    'Open to freelance, full-time & collabs',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: textSec, height: 1.65),
                  ),
                ),
              ]),

              const SizedBox(height: AppSpacing.xxl),
              const DashedDivider(),
              const SizedBox(height: AppSpacing.xxl),

              // ── [ 01 ] SOCIAL / LINK GRID ─────────────────────
              Row(children: [
                Text('[ 01 ]',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: accent, letterSpacing: 1.5)),
                const SizedBox(width: 10),
                Text('REACH OUT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, letterSpacing: 2)),
              ]),
              const SizedBox(height: 16),

              LayoutBuilder(builder: (context, c) {
                final links = [
                  _LinkRow(
                    index: '01',
                    platform: 'EMAIL',
                    handle: PortfolioConfig.email,
                    icon: Icons.mail_outline_rounded,
                    url: 'mailto:${PortfolioConfig.email}',
                  ),
                  _LinkRow(
                    index: '02',
                    platform: 'GITHUB',
                    handle: PortfolioConfig.githubUrl
                        .split('github.com/')
                        .last,
                    icon: Icons.code_rounded,
                    url: PortfolioConfig.githubUrl,
                  ),
                  _LinkRow(
                    index: '03',
                    platform: 'PORTFOLIO',
                    handle: PortfolioConfig.websiteUrl
                        .replaceAll('https://', ''),
                    icon: Icons.language_rounded,
                    url: PortfolioConfig.websiteUrl,
                  ),
                  _LinkRow(
                    index: '04',
                    platform: 'PHONE',
                    handle: PortfolioConfig.phone,
                    icon: Icons.phone_outlined,
                    url:
                        'tel:${PortfolioConfig.phone.replaceAll(' ', '')}',
                  ),
                ];
                return Column(
                    children: links
                        .map((l) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 2),
                              child: l,
                            ))
                        .toList());
              }),

              const SizedBox(height: AppSpacing.xxl),
              const DashedDivider(),
              const SizedBox(height: AppSpacing.xxl),

              // ── [ 02 ] TERMINAL PING BLOCK ────────────────────
              Row(children: [
                Text('[ 02 ]',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: accent, letterSpacing: 1.5)),
                const SizedBox(width: 10),
                Text('QUICK PING',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, letterSpacing: 2)),
              ]),
              const SizedBox(height: 16),
              const _TerminalPing(),

              const SizedBox(height: AppSpacing.xxl),
              const DashedDivider(),
              const SizedBox(height: AppSpacing.xxl),

              // ── [ 03 ] STATUS + LOCATION ROW ─────────────────
              Row(children: [
                Text('[ 03 ]',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: accent, letterSpacing: 1.5)),
                const SizedBox(width: 10),
                Text('STATUS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, letterSpacing: 2)),
              ]),
              const SizedBox(height: 16),

              LayoutBuilder(builder: (context, c) {
                final isWide = c.maxWidth > 500;
                final cards = [
                  _StatusCard(),
                  _LocationCard(),
                ];
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 12),
                      Expanded(child: cards[1]),
                    ],
                  );
                }
                return Column(children: [
                  cards[0],
                  const SizedBox(height: 12),
                  cards[1],
                ]);
              }),

              const SizedBox(height: AppSpacing.xxl),
              const DashedDivider(),
              const SizedBox(height: AppSpacing.xxl),

              // ── [ 04 ] FREQUENTLY ASKED ───────────────────────
              Row(children: [
                Text('[ 04 ]',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: accent, letterSpacing: 1.5)),
                const SizedBox(width: 10),
                Text('FAQ',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, letterSpacing: 2)),
              ]),
              const SizedBox(height: 16),
              const _FaqList(),

              const SizedBox(height: AppSpacing.xxl),

              // ── BOTTOM CTA ────────────────────────────────────
              DashedBorderContainer(
                padding: const EdgeInsets.all(22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Got a project in mind?',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge),
                          const SizedBox(height: 6),
                          Text(
                            'Typical response within 24 hrs.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: textSec),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _SendBtn(
                      onTap: () => launchUrl(Uri.parse(
                          'mailto:${PortfolioConfig.email}'), mode: LaunchMode.externalApplication),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LINK ROW  — full-width row with index, platform, handle, arrow
// ─────────────────────────────────────────────

class _LinkRow extends StatefulWidget {
  final String index, platform, handle, url;
  final IconData icon;

  const _LinkRow({
    required this.index,
    required this.platform,
    required this.handle,
    required this.icon,
    required this.url,
  });

  @override
  State<_LinkRow> createState() => _LinkRowState();
}

class _LinkRowState extends State<_LinkRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final border   = isDark ? AppColors.borderDark   : AppColors.borderLight;
    final border2  = isDark ? AppColors.border2Dark  : AppColors.border2Light;
    final surfaceEl = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final textSec  = isDark ? AppColors.textSecDark  : AppColors.textSecLight;
    final textPri  = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent   = isDark ? AppColors.accentDark   : AppColors.accentLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? surfaceEl : Colors.transparent,
            border: Border.all(
                color: _hovered ? border2 : border, width: 1),
          ),
          child: Row(children: [
            // Index
            SizedBox(
              width: 28,
              child: Text(widget.index,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _hovered ? accent : textSec,
                        fontSize: 9,
                      )),
            ),
            // Icon
            Icon(widget.icon, size: 14, color: textSec),
            const SizedBox(width: 10),
            // Platform label
            SizedBox(
              width: 90,
              child: Text(widget.platform,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textSec,
                        letterSpacing: 1.5,
                      )),
            ),
            // Divider dash
            Text('——',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: textSec.withValues(alpha: 0.3))),
            const SizedBox(width: 10),
            // Handle
            Expanded(
              child: Text(
                widget.handle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textPri,
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Arrow
            AnimatedSlide(
              offset: _hovered ? const Offset(0.15, -0.15) : Offset.zero,
              duration: const Duration(milliseconds: 160),
              child: Icon(Icons.arrow_outward_rounded,
                  size: 14,
                  color: _hovered ? textPri : textSec.withValues(alpha: 0.4)),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TERMINAL PING  — interactive quick-message composer
// ─────────────────────────────────────────────

class _TerminalPing extends StatefulWidget {
  const _TerminalPing();

  @override
  State<_TerminalPing> createState() => _TerminalPingState();
}

class _TerminalPingState extends State<_TerminalPing> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  bool _sent = false;
  String _selectedTopic = 'freelance';

  static const _topics = ['freelance', 'full-time', 'collab', 'other'];

  void _send() async {
    if (_ctrl.text.trim().isEmpty) return;
    final subject = Uri.encodeComponent('[${_selectedTopic.toUpperCase()}] Quick Ping');
    final body    = Uri.encodeComponent(_ctrl.text.trim());
    final uri = Uri.parse('mailto:${PortfolioConfig.email}?subject=$subject&body=$body');
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        setState(() => _sent = true);
        Future.delayed(const Duration(seconds: 3),
            () => mounted ? setState(() { _sent = false; _ctrl.clear(); }) : null);
      } else {
        throw Exception('Cannot launch mail client');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No default mail app found! Reach me directly at: ${PortfolioConfig.email}',
              style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final border  = isDark ? AppColors.borderDark  : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final surfaceEl = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent  = isDark ? AppColors.accentDark  : AppColors.accentLight;
    final bg      = isDark ? AppColors.bgDark      : AppColors.bgLight;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Terminal title bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: surfaceEl,
              border: Border(bottom: BorderSide(color: border, width: 1)),
            ),
            child: Row(children: [
              _Dot(color: const Color(0xFFFF5F57)),
              const SizedBox(width: 6),
              _Dot(color: const Color(0xFFFFBD2E)),
              const SizedBox(width: 6),
              _Dot(color: const Color(0xFF28C840)),
              const SizedBox(width: 12),
              Text('ping — imdeepanshu4work@gmail.com',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textSec, fontSize: 9, letterSpacing: 0.8)),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Topic selector
                Text('// select topic',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec.withValues(alpha: 0.5),
                          fontSize: 9,
                        )),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _topics.map((t) {
                    final selected = _selectedTopic == t;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTopic = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: selected ? textPri : Colors.transparent,
                          border: Border.all(
                              color: selected ? textPri : border2,
                              width: 1),
                        ),
                        child: Text(
                          t,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: selected ? bg : textSec,
                                fontSize: 9,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 14),

                // Prompt line
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('> ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: accent)),
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        focusNode: _focus,
                        maxLines: 3,
                        minLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'type your message here...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      textSec.withValues(alpha: 0.4)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Send row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _sent
                          ? '✓ opening mail client...'
                          : 'opens your default mail app',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _sent
                                ? accent
                                : textSec.withValues(alpha: 0.45),
                            fontSize: 9,
                          ),
                    ),
                    _SendBtn(onTap: _send),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATUS CARD
// ─────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final border   = isDark ? AppColors.borderDark   : AppColors.borderLight;
    final surface  = isDark ? AppColors.surfaceDark  : AppColors.surfaceLight;
    final textSec  = isDark ? AppColors.textSecDark  : AppColors.textSecLight;
    final accent   = isDark ? AppColors.accentDark   : AppColors.accentLight;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AVAILABILITY',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textSec, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Row(children: [
            _PulsingDot(color: accent),
            const SizedBox(width: 10),
            Text('Open to Work',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 14)),
          ]),
          const SizedBox(height: 12),
          _StatusRow(label: 'Freelance',  value: 'Available', positive: true),
          _StatusRow(label: 'Full-time',  value: 'Available', positive: true),
          _StatusRow(label: 'Collab',     value: 'Always',    positive: true),
          const SizedBox(height: 12),
          Text('Response: < 24 hours',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textSec, fontSize: 9)),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label, value;
  final bool positive;
  const _StatusRow(
      {required this.label, required this.value, required this.positive});

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent  = isDark ? AppColors.accentDark  : AppColors.accentLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textSec, fontSize: 11)),
          Text(value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: positive ? accent : textSec,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOCATION CARD
// ─────────────────────────────────────────────

class _LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final border   = isDark ? AppColors.borderDark   : AppColors.borderLight;
    final surface  = isDark ? AppColors.surfaceDark  : AppColors.surfaceLight;
    final textSec  = isDark ? AppColors.textSecDark  : AppColors.textSecLight;
    final textPri  = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    // India Standard Time  UTC+5:30
    final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    final hour   = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm   = hour >= 12 ? 'PM' : 'AM';
    final h12    = hour % 12 == 0 ? 12 : hour % 12;
    final timeStr = '$h12:$minute $ampm IST';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('LOCATION',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textSec, letterSpacing: 1.5)),
          const SizedBox(height: 16),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.location_on_outlined, size: 16, color: textSec),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(PortfolioConfig.location,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Ghaziabad, UP — India',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: textSec, fontSize: 11)),
                ],
              ),
            ),
          ]),

          const SizedBox(height: 16),
          Container(height: 1, color: border),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('LOCAL TIME',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, fontSize: 8, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text(timeStr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textPri, fontWeight: FontWeight.w600)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('TIMEZONE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, fontSize: 8, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text('UTC +5:30',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textPri, fontWeight: FontWeight.w600)),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SEND BUTTON
// ─────────────────────────────────────────────

class _SendBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _SendBtn({required this.onTap});

  @override
  State<_SendBtn> createState() => _SendBtnState();
}

class _SendBtnState extends State<_SendBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final fg = isDark ? AppColors.bgDark : AppColors.bgLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: _hovered ? bg.withValues(alpha: 0.85) : bg,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('SEND',
                style: TextStyle(
                  fontFamily: 'IBMPlexMono',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: fg,
                )),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded, size: 13, color: fg),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PULSING DOT
// ─────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.7, end: 1.3)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: _scale,
        child: Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: widget.color),
        ),
      );
}

// ─────────────────────────────────────────────
// TERMINAL DOT (macOS-style traffic light)
// ─────────────────────────────────────────────

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

// ─────────────────────────────────────────────
// FAQ SECTION
// ─────────────────────────────────────────────

class _FaqList extends StatelessWidget {
  const _FaqList();

  static const _faqs = [
    (
      'What\'s your primary design tool?',
      'Figma is my main design tool for everything from wireframes to full design systems. I also use Framer for interactive prototypes and Adobe XD for client-specific work.'
    ),
    (
      'Do you do both design and development?',
      'Yes — I design in Figma and build in Flutter (Dart) for mobile, with HTML/CSS/JS for web. The best results come when the designer and developer are the same person.'
    ),
    (
      'Are you available for freelance work?',
      'Currently open to freelance projects and full-time opportunities. Reach out at imdeepanshu4work@gmail.com to discuss your project.'
    ),
    (
      'What is your education background?',
      'Pursuing B.Tech in Data Science at ABES Engineering College (2023–2027), Ghaziabad. Alongside formal education, I build real-world products and contribute to open-source communities.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _faqs
          .map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: _FaqItem(question: f.$1, answer: f.$2),
              ))
          .toList(),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _ctrl;
  late Animation<double> _heightAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220));
    _heightAnim =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border, width: 1),
      ),
      child: Column(children: [
        InkWell(
          onTap: _toggle,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    border: Border.all(color: border, width: 1)),
                child: Icon(Icons.help_outline, size: 13, color: textSec),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(widget.question,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.keyboard_arrow_down,
                    size: 15, color: textSec),
              ),
            ]),
          ),
        ),
        SizeTransition(
          sizeFactor: _heightAnim,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 56, right: 16, bottom: 14),
            child: Text(widget.answer,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.8)),
          ),
        ),
      ]),
    );
  }
}