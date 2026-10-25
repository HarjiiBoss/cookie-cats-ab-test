# Presentation Notes

A three-minute spoken walk-through of the Cookie Cats dashboard, with prepared answers to the questions most likely to follow. Numbers match the [executive summary](executive_summary.md) and the [Phase 4 results](phase_04_advanced_analysis.md).

---

# Presentation Overview

| Field | Value |
|--------|-------|
| Project | Cookie Cats A/B Test |
| Audience | Product team (decision-makers); also used for portfolio reviews and interviews |
| Presenter | Taofeek Salami |
| Duration | About 3 minutes, then questions |
| Material | The Tableau Public dashboard, shown full screen |

---

# Objective and Core Message

By the end, the audience should know the decision, the evidence for it, and what the evidence cannot show.

**Core message:** Keep the first gate at level 30. Players assigned to the level-40 gate had lower 7-day retention, and the difference met the decision rule set before the data was examined.

---

# Script

| Time | On screen | What to say |
|------|-----------|-------------|
| 0:00–0:20 | Title band | "The question was whether to move the first gate in Cookie Cats from level 30 to level 40. About 90,000 new players were split between the two versions, and we measured whether they came back to play." |
| 0:20–0:45 | KPI cards | "Seven days after installing, 19.0% of players with the gate at level 30 came back to play, against 18.2% with the gate at level 40. That is 0.8 percentage points lower at level 40, and the decision rule we set before looking at the data says: keep the gate at level 30." |
| 0:45–1:20 | Retention difference chart | "Each line is the range the true difference plausibly falls in, at 95% confidence. For 7-day retention, the whole range sits below zero, from 0.3 to 1.3 points lower, so the drop is not explained by chance. For 1-day retention the range just crosses zero, so we cannot tell the versions apart at day 1." |
| 1:20–1:45 | Bars and game rounds | "The bars show the same rates side by side. On the right, how much people played was almost identical in the two versions, so the gate position did not visibly change the amount of play." |
| 1:45–2:10 | Robustness chart | "We checked the result four other ways: a second way of calculating the range, and leaving out one player with an extreme number of rounds, players who never played a round, or both. Every range stays below zero, so the result does not depend on those players." |
| 2:10–2:45 | Insight panel, Caveat | "Two limits matter. First, reading this as caused by the gate assumes players were assigned at random; the data does not document how assignment was done. Second, there is no revenue in the data, so we cannot put a value on the lost retention. For every 100,000 new players, the range corresponds to roughly 300 to 1,300 fewer players coming back on day 7." |
| 2:45–3:00 | Recommendation | "So: keep the gate at level 30. Before testing another placement, record the level each player reaches and what they spend, and agree in advance how large a change would be worth acting on." |

---

# Anticipated Questions

| Question | Answer |
|----------|--------|
| Is 0.8 points worth acting on? | The data cannot say, because it has no revenue. The decision rule used zero as its threshold, so it establishes direction, not commercial size. The next test should agree a minimum worthwhile change in advance. |
| How do you know the gate caused the drop? | We do not know for certain. A causal reading needs random assignment, which is not documented. The group sizes passed the pre-set check (p = 0.009 against an alert level of 0.001), but that check cannot prove assignment was random. |
| Why is day 7 significant but day 1 not? | The day-1 difference is in the same direction (−0.6 points) but its range, −1.2 to +0.1, includes zero. That means the data cannot separate a small drop from no difference at day 1. It does not mean there was no effect. |
| Why not compare only players who reached the gate? | Reaching the gate happens after assignment, so comparing only those players would compare groups that are no longer alike. The data also has no level column. All players were analysed in the group they were assigned to. |
| Could the effect be smaller than 0.8 points? | Yes. The plausible range runs down to 0.3 points, and estimates near the smallest effect a test can reliably detect (0.85 points here) tend to overstate the true effect. The range is the safer summary. |
| Did knowing the published results affect the analysis? | The decision rules were set before the data was examined, and the published analyses of this dataset were not reviewed beforehand. The rule for the group-size check was added later, before that check was run. |
| What would you do next? | Keep the gate at level 30. Log player progression and purchases so a follow-up test can measure effects on revenue and design around players who actually meet the gate. |
| What exactly counts as retained? | The data does not define it. 111 players with no recorded rounds are marked as retained, so the flag may record a return to the game rather than a round played. Both versions use the same flag, so the comparison between them holds. |

---

# Delivery Notes

- Say "players assigned to the level-40 gate", not "players who met the gate": the analysis includes players who never reached it.
- Say "came back to play on day 7", not "were still playing": the data records a return on that day only.
- Raise the two limits before being asked; they are part of the result, not a weakness to hide.
- Do not round the range to "about 1 point"; quote 0.3 to 1.3.

---

# Checklist Before Presenting

- [x] Dashboard opened full screen and tooltips tested
- [ ] Script rehearsed aloud and timed at about 3 minutes
- [ ] Numbers in the script checked against the executive summary
- [ ] Answers to the anticipated questions rehearsed