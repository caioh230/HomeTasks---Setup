import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hometasks/core/services/account.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/core/services/preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
 
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
 
class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificacoesPush = true;
  bool _sonsAlertas = true;
  //Verificar em caso de erro
  String _tema = UserPreferences.tema;
  String _idioma = UserPreferences.idioma;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FF),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ───
              Row(
                children: [
                  BackButton(
                    color: const Color(0xFF1067B4),
                    onPressed: () =>
                        DashboardPage.globalKey.currentState?.closeOverlay(),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Configurações',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
 
              // ─── NOTIFICAÇÕES ───
              _SectionHeader(label: 'NOTIFICAÇÕES'),
              const SizedBox(height: 10),
              _SettingsCard(
                children: [
                  _ToggleRow(
                    icon: Icons.notifications_outlined,
                    label: 'Notificações Push',
                    value: _notificacoesPush,
                    onChanged: (v) => setState(() => _notificacoesPush = v),
                  ),
                  _Divider(),
                  _ToggleRow(
                    icon: Icons.volume_up_outlined,
                    label: 'Sons e Alertas',
                    value: _sonsAlertas,
                    onChanged: (v) => setState(() => _sonsAlertas = v),
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
 
              // ─── PREFERÊNCIAS ───
              _SectionHeader(label: 'PREFERÊNCIAS'),
              const SizedBox(height: 10),
              _SettingsCard(
                children: [
                  _NavRow(
                    icon: Icons.palette_outlined,
                    label: 'Tema',
                    //Verificar em caso de erro
                    trailing: _tema,
                  ),
                  _Divider(),
                  _NavRow(
                    icon: Icons.translate_outlined,
                    label: 'Idioma',
                    //Verificar em caso de erro
                    trailing: _idioma,
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
 
              // ─── SOBRE ───
              _SectionHeader(label: 'SOBRE'),
              const SizedBox(height: 10),
              _SettingsCard(
                children: [
                  _NavRow(
                    icon: Icons.info_outline,
                    label: 'Versão do App',
                    trailing: 'v2.4.12',
                    showChevron: false,
                    trailingStyle: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                  _Divider(),
                  _NavRow(
                    icon: Icons.description_outlined,
                    label: 'Termos de Uso',
                    trailingWidget: const Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: Color(0xFF9CA3AF),
                    ),
                    showChevron: false,
                  ),
                  _Divider(),
                  _NavRow(
                    icon: Icons.shield,
                    label: 'Política de Privacidade',
                    trailingWidget: const Icon(
                      Icons.verified_user_outlined,
                      size: 18,
                      color: Color(0xFF9CA3AF),
                    ),
                    showChevron: false,
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
 
              // ─── Sair / Excluir ───
              _SettingsCard(
                children: [
                  _ActionRow(
                    icon: Icons.logout,
                    label: 'Sair da conta',
                    color: const Color(0xFFE53E3E),
                    onTap: () async {
                      await UserAccount.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  ),
                  _Divider(),
                  _ActionRow(
                    icon: Icons.delete_outline,
                    label: 'Excluir conta',
                    subtitle: 'Esta ação é irreversível',
                    color: const Color(0xFFE53E3E),
                    iconBg: const Color(0xFFE53E3E),
                    iconColor: Colors.white,
                    //Verificar em caso de erro
                    onTap: () async {
                      await UserAccount.exclude();
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
 
// ─────────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────────
 
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;
 
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: Color(0xFF1067B4),
      ),
    );
  }
}
 
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
 
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.8,
      indent: 56,
      color: Colors.grey.shade100,
    );
  }
}
 
class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});
  final IconData icon;
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: const Color(0xFF1067B4), size: 20),
    );
  }
}
 
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });
 
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _IconBox(icon: icon),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: const Color(0xFF1067B4),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
 
class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.trailingWidget,
    this.showChevron = true,
    this.trailingStyle,
  });
 
  final IconData icon;
  final String label;
  final String? trailing;
  final Widget? trailingWidget;
  final bool showChevron;
  final TextStyle? trailingStyle;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _IconBox(icon: icon),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          if (trailingWidget != null) trailingWidget!,
          if (trailing != null)
            Text(
              trailing!,
              style: trailingStyle ??
                  const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            ),
          if (showChevron) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ],
      ),
    );
  }
}
 
class _ActionRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color;
  final Color? iconBg;
  final Color? iconColor;
  final Function? onTap;

  _ActionRow({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.color,
    this.iconBg,
    this.iconColor,
    this.onTap,
  });

  @override
  State<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<_ActionRow> {
  bool _pressed = false;
  void _setPressed(bool value) {
    setState(() {
      _pressed = value;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        if(widget.onTap != null)
          widget.onTap!();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _pressed ? widget.color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.iconBg != null ? widget.iconBg! : widget.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                color: widget.iconBg != null ? widget.iconColor : widget.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: widget.color,
                  ),
                ),
                if (widget.subtitle != null)
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.color.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}