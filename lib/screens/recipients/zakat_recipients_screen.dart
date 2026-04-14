import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/shared/zakati_app_bar.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class _Asnaf {
  final String arabic;
  final String transliteration;
  final String description;
  final String? badge; // e.g. 'Abrogated', 'Key difference', 'Extended today'

  const _Asnaf({
    required this.arabic,
    required this.transliteration,
    required this.description,
    this.badge,
  });
}

class _MadhabContent {
  final String name;
  final String distributionRule;
  final String fuqaraVsMasakin;
  final List<_Asnaf> asnaf;

  const _MadhabContent({
    required this.name,
    required this.distributionRule,
    required this.fuqaraVsMasakin,
    required this.asnaf,
  });
}

// ── Content per madhab ────────────────────────────────────────────────────────

const _maliki = _MadhabContent(
  name: 'Maliki',
  distributionRule:
      'You may give all of your Zakat to a single category or even one individual. '
      'Distribution across all eight categories is not required.',
  fuqaraVsMasakin:
      'Al-Fuqara are considered more destitute than Al-Masakin. '
      'The poor (Fuqara) have little to nothing; the needy (Masakin) have some income but it falls short.',
  asnaf: [
    _Asnaf(
      arabic: 'الفقراء',
      transliteration: 'Al-Fuqara — The Poor',
      description:
          'Those with little or no income who are unable to meet their basic needs. '
          'In the Maliki view, Fuqara are the most destitute category — worse off than Masakin.',
    ),
    _Asnaf(
      arabic: 'المساكين',
      transliteration: 'Al-Masakin — The Needy',
      description:
          'Those who have some income or resources but still insufficient to cover their needs. '
          'Better off than Fuqara, but still eligible to receive Zakat.',
    ),
    _Asnaf(
      arabic: 'العاملين عليها',
      transliteration: 'Al-Amileen — Zakat Administrators',
      description:
          'Those officially appointed by an Islamic authority to collect, manage, and distribute Zakat. '
          'They receive a portion regardless of their personal wealth as compensation for their work.',
    ),
    _Asnaf(
      arabic: 'المؤلفة قلوبهم',
      transliteration: "Al-Mu'allafatu Qulubuhum — Hearts to be Reconciled",
      description:
          'Valid in the Maliki madhab. Includes new Muslims who may need support, '
          'and those whose goodwill toward the Muslim community is beneficial. '
          'Zakat may be given to non-Muslims in this category.',
      badge: 'Valid category',
    ),
    _Asnaf(
      arabic: 'الرقاب',
      transliteration: 'Al-Riqab — Freeing of Captives',
      description:
          'Historically used to purchase and free enslaved people. '
          'This category is largely inapplicable today, though some scholars extend it to ransom for captives.',
      badge: 'Largely inapplicable today',
    ),
    _Asnaf(
      arabic: 'الغارمين',
      transliteration: 'Al-Gharimeen — Those in Debt',
      description:
          'Those burdened by debt incurred out of genuine personal necessity, '
          'or those who took on debt for communal benefit such as reconciling disputes. '
          'Debt incurred for sinful purposes does not qualify.',
    ),
    _Asnaf(
      arabic: 'في سبيل الله',
      transliteration: 'Fi Sabilillah — In the Cause of Allah',
      description:
          'Traditionally: fighters defending the Muslim community with no salary from the state. '
          'Many contemporary Maliki scholars extend this to Islamic education and dawah, '
          'though the classical ruling is more restrictive.',
      badge: 'Traditionally fighters; some extend today',
    ),
    _Asnaf(
      arabic: 'ابن السبيل',
      transliteration: "Ibn al-Sabil — The Stranded Traveler",
      description:
          'A traveler who is far from home and has run out of or lacks sufficient funds '
          'to complete their journey or return, even if they are wealthy at home.',
    ),
  ],
);

const _hanafi = _MadhabContent(
  name: 'Hanafi',
  distributionRule:
      'You may give all of your Zakat to a single category or even one individual. '
      'There is no requirement to distribute across all eight categories.',
  fuqaraVsMasakin:
      'Al-Masakin are considered worse off than Al-Fuqara — the opposite of the other three madhabs. '
      'Fuqara have some means but below nisab; Masakin have absolutely nothing.',
  asnaf: [
    _Asnaf(
      arabic: 'الفقراء',
      transliteration: 'Al-Fuqara — The Poor',
      description:
          'Those who possess some wealth or income but it is below the nisab threshold. '
          'In the Hanafi view, Fuqara are less destitute than Masakin — they have something, but not enough.',
      badge: 'Less destitute than Masakin (Hanafi-specific)',
    ),
    _Asnaf(
      arabic: 'المساكين',
      transliteration: 'Al-Masakin — The Needy',
      description:
          'Those with absolutely nothing — no income, no assets, no means of support. '
          'In the Hanafi madhab, Masakin are considered worse off than Fuqara.',
      badge: 'Most destitute (Hanafi-specific)',
    ),
    _Asnaf(
      arabic: 'العاملين عليها',
      transliteration: 'Al-Amileen — Zakat Administrators',
      description:
          'Those officially appointed to collect and distribute Zakat. '
          'They receive a share from Zakat funds as compensation for their work, '
          'even if they are personally wealthy.',
    ),
    _Asnaf(
      arabic: 'المؤلفة قلوبهم',
      transliteration: "Al-Mu'allafatu Qulubuhum — Hearts to be Reconciled",
      description:
          'This category is considered abrogated (suspended) in the Hanafi madhab. '
          'After the Prophet\'s time, when Islam became strong, the need to win over hearts '
          'through Zakat was deemed to have ended. Zakat cannot be given to non-Muslims under this category.',
      badge: 'Abrogated in Hanafi',
    ),
    _Asnaf(
      arabic: 'الرقاب',
      transliteration: 'Al-Riqab — Freeing of Captives',
      description:
          'Historically used to purchase and free enslaved people. '
          'This category is largely inapplicable today in most jurisdictions.',
      badge: 'Largely inapplicable today',
    ),
    _Asnaf(
      arabic: 'الغارمين',
      transliteration: 'Al-Gharimeen — Those in Debt',
      description:
          'Those who have incurred debt for permissible personal needs and cannot repay it. '
          'Also includes those who took on debt for communal benefit. '
          'Debt incurred through sinful means is excluded.',
    ),
    _Asnaf(
      arabic: 'في سبيل الله',
      transliteration: 'Fi Sabilillah — In the Cause of Allah',
      description:
          'In the classical Hanafi position, this is restricted to volunteer fighters '
          'who are not receiving a state salary. '
          'It does not extend to general Islamic causes or charitable projects in the classical ruling.',
      badge: 'Restricted to fighters (classical)',
    ),
    _Asnaf(
      arabic: 'ابن السبيل',
      transliteration: "Ibn al-Sabil — The Stranded Traveler",
      description:
          'A traveler who is far from home and lacks the funds to complete their journey '
          'or return, even if they have wealth at home that they cannot access.',
    ),
  ],
);

const _shafii = _MadhabContent(
  name: "Shafi'i",
  distributionRule:
      'Zakat must be distributed to all eight categories that are present in your locality. '
      'You cannot give all of your Zakat to just one category — this is a distinctive Shafi\'i requirement.',
  fuqaraVsMasakin:
      'Al-Fuqara are considered more destitute than Al-Masakin. '
      'The poor (Fuqara) have nothing or almost nothing; the needy (Masakin) have some income but it is insufficient.',
  asnaf: [
    _Asnaf(
      arabic: 'الفقراء',
      transliteration: 'Al-Fuqara — The Poor',
      description:
          'Those with no income or assets, or those whose income covers less than half of their needs. '
          'Considered more destitute than Masakin in the Shafi\'i madhab.',
    ),
    _Asnaf(
      arabic: 'المساكين',
      transliteration: 'Al-Masakin — The Needy',
      description:
          'Those whose income covers more than half, but still not all, of their basic needs. '
          'They have some means but remain in genuine need.',
    ),
    _Asnaf(
      arabic: 'العاملين عليها',
      transliteration: 'Al-Amileen — Zakat Administrators',
      description:
          'Those appointed by an Islamic authority to collect and distribute Zakat. '
          'They receive a fair wage from Zakat funds proportional to their work, '
          'even if they are personally wealthy.',
    ),
    _Asnaf(
      arabic: 'المؤلفة قلوبهم',
      transliteration: "Al-Mu'allafatu Qulubuhum — Hearts to be Reconciled",
      description:
          'Valid in the Shafi\'i madhab. Includes new Muslims who may benefit from financial support, '
          'and influential individuals whose goodwill benefits the Muslim community. '
          'Can include non-Muslims.',
      badge: 'Valid category',
    ),
    _Asnaf(
      arabic: 'الرقاب',
      transliteration: 'Al-Riqab — Freeing of Captives',
      description:
          'Historically used to purchase and free enslaved people. '
          'This category is largely inapplicable today, though some scholars explore modern applications.',
      badge: 'Largely inapplicable today',
    ),
    _Asnaf(
      arabic: 'الغارمين',
      transliteration: 'Al-Gharimeen — Those in Debt',
      description:
          'Those burdened by debt for permissible personal needs, and those who took on debt '
          'to reconcile disputes between people in the community. '
          'The debt must not have been incurred for sinful purposes.',
    ),
    _Asnaf(
      arabic: 'في سبيل الله',
      transliteration: 'Fi Sabilillah — In the Cause of Allah',
      description:
          'In the classical Shafi\'i position, this refers to volunteer fighters in the path of Allah '
          'who are not on a state salary. '
          'The classical ruling does not broadly extend this to general Islamic projects.',
      badge: 'Restricted to fighters (classical)',
    ),
    _Asnaf(
      arabic: 'ابن السبيل',
      transliteration: "Ibn al-Sabil — The Stranded Traveler",
      description:
          'A traveler who is far from home and lacks the funds to return or complete their journey, '
          'even if they have wealth available at home.',
    ),
  ],
);

const _hanbali = _MadhabContent(
  name: 'Hanbali',
  distributionRule:
      'You may give all of your Zakat to a single category or even one individual. '
      'Distribution across all eight categories is not required.',
  fuqaraVsMasakin:
      'Al-Fuqara are those who cannot meet even half of their basic needs. '
      'Al-Masakin have more than half but still fall short — Fuqara are considered more destitute.',
  asnaf: [
    _Asnaf(
      arabic: 'الفقراء',
      transliteration: 'Al-Fuqara — The Poor',
      description:
          'Those whose income or assets cannot meet even half of their basic needs. '
          'The most destitute of the two poverty categories in the Hanbali madhab.',
    ),
    _Asnaf(
      arabic: 'المساكين',
      transliteration: 'Al-Masakin — The Needy',
      description:
          'Those whose income covers more than half of their basic needs but not all. '
          'They are in genuine need but less destitute than Fuqara.',
    ),
    _Asnaf(
      arabic: 'العاملين عليها',
      transliteration: 'Al-Amileen — Zakat Administrators',
      description:
          'Those appointed by an Islamic authority to collect, manage, and distribute Zakat. '
          'They receive a portion of Zakat funds as fair compensation for their role.',
    ),
    _Asnaf(
      arabic: 'المؤلفة قلوبهم',
      transliteration: "Al-Mu'allafatu Qulubuhum — Hearts to be Reconciled",
      description:
          'Valid in the Hanbali madhab. Includes new Muslims and influential community leaders '
          'whose support strengthens the Muslim community. '
          'Can include non-Muslims whose goodwill benefits Muslims.',
      badge: 'Valid category',
    ),
    _Asnaf(
      arabic: 'الرقاب',
      transliteration: 'Al-Riqab — Freeing of Captives',
      description:
          'Historically used to free enslaved people. '
          'Some Hanbali scholars extend this today to include paying ransoms for Muslim captives or prisoners.',
      badge: 'Some extend to captive ransom today',
    ),
    _Asnaf(
      arabic: 'الغارمين',
      transliteration: 'Al-Gharimeen — Those in Debt',
      description:
          'Those in debt due to personal necessity who cannot repay, '
          'and those who took on debt to reconcile disputes between members of the community. '
          'Debt for sinful purposes is excluded.',
    ),
    _Asnaf(
      arabic: 'في سبيل الله',
      transliteration: 'Fi Sabilillah — In the Cause of Allah',
      description:
          'Traditionally refers to fighters defending the Muslim community. '
          'Some Hanbali scholars are more open than other madhabs to extending this '
          'to broader Islamic causes, though the classical ruling centres on fighters.',
      badge: 'Some openness to extension',
    ),
    _Asnaf(
      arabic: 'ابن السبيل',
      transliteration: "Ibn al-Sabil — The Stranded Traveler",
      description:
          'A traveler who is stranded or lacks sufficient funds to return home, '
          'even if they have wealth at home that they cannot access during the journey.',
    ),
  ],
);

const _madhabs = [_maliki, _hanafi, _shafii, _hanbali];

// ── Screen ────────────────────────────────────────────────────────────────────

class ZakatRecipientsScreen extends StatelessWidget {
  const ZakatRecipientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _madhabs.length,
      child: Scaffold(
        appBar: const ZakatiAppBar(
          title: 'Who Can Receive Zakat?',
          bottom: _MadhabTabBar(),
        ),
        body: TabBarView(
          children: _madhabs
              .map((m) => _MadhabView(content: m))
              .toList(),
        ),
      ),
    );
  }
}

class _MadhabTabBar extends StatelessWidget implements PreferredSizeWidget {
  const _MadhabTabBar();

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: false,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white60,
      indicatorColor: Colors.white,
      indicatorWeight: 2.5,
      labelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      tabs: _madhabs.map((m) => Tab(text: m.name)).toList(),
    );
  }
}

// ── Madhab view ───────────────────────────────────────────────────────────────

class _MadhabView extends StatelessWidget {
  final _MadhabContent content;
  const _MadhabView({required this.content});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quran reference
          _QuranReferenceCard(),
          const SizedBox(height: 16),

          // Distribution rule
          _InfoBlock(
            icon: Icons.volunteer_activism_outlined,
            label: 'Distribution Rule',
            body: content.distributionRule,
          ),
          const SizedBox(height: 12),

          // Fuqara vs Masakin note
          _InfoBlock(
            icon: Icons.compare_arrows_rounded,
            label: 'Al-Fuqara vs Al-Masakin',
            body: content.fuqaraVsMasakin,
          ),
          const SizedBox(height: 24),

          Text('The Eight Recipients (Asnaf)', style: AppTextStyles.headingSmall),
          const SizedBox(height: 14),

          ...List.generate(content.asnaf.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AsnafCard(number: i + 1, asnaf: content.asnaf[i]),
              )),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _QuranReferenceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: AppColors.accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إِنَّمَا الصَّدَقَاتُ لِلْفُقَرَاءِ وَالْمَسَاكِينِ...',
            style: AppTextStyles.body.copyWith(
              color: AppColors.accent,
              fontFamily: 'Amiri',
              fontSize: 16,
              height: 1.8,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 6),
          Text(
            '"Zakah expenditures are only for the poor and for the needy and for those '
            'employed to collect [zakah] and for bringing hearts together [for Islam] '
            'and for freeing captives [or slaves] and for those in debt and for the '
            'cause of Allah and for the [stranded] traveler." — Quran 9:60',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final IconData icon;
  final String label;
  final String body;

  const _InfoBlock({
    required this.icon,
    required this.label,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.primary)),
                const SizedBox(height: 4),
                Text(body,
                    style: AppTextStyles.caption.copyWith(height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Asnaf card ────────────────────────────────────────────────────────────────

class _AsnafCard extends StatelessWidget {
  final int number;
  final _Asnaf asnaf;

  const _AsnafCard({required this.number, required this.asnaf});

  @override
  Widget build(BuildContext context) {
    final hasBadge = asnaf.badge != null;
    final isAbrogated = asnaf.badge?.toLowerCase().contains('abrogat') ?? false;
    final isInapplicable =
        asnaf.badge?.toLowerCase().contains('inapplicable') ?? false;

    Color badgeColor;
    Color badgeTextColor;
    if (isAbrogated) {
      badgeColor = const Color(0xFFFDE8E8);
      badgeTextColor = const Color(0xFFB91C1C);
    } else if (isInapplicable) {
      badgeColor = const Color(0xFFF3F4F6);
      badgeTextColor = AppColors.textSecondary;
    } else {
      badgeColor = AppColors.primaryLight;
      badgeTextColor = AppColors.primaryDark;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number badge
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic name
                    Text(
                      asnaf.arabic,
                      style: AppTextStyles.body.copyWith(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: AppColors.accent,
                        height: 1.4,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 2),
                    // Transliteration
                    Text(
                      asnaf.transliteration,
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            asnaf.description,
            style: AppTextStyles.caption.copyWith(height: 1.6),
          ),
          // Badge
          if (hasBadge) ...[
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                asnaf.badge!,
                style: AppTextStyles.caption.copyWith(
                  color: badgeTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
