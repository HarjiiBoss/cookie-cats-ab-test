# Executive Summary

**Cookie Cats A/B Test: Placement of the First Gate**  
Taofeek Salami · October 2026

---

## Recommendation

**Keep the first gate at level 30.**  
Players assigned to the version with the gate at level 40 had lower 7-day retention than players assigned to the version with the gate at level 30. The difference met the decision rule set before the data was examined.

---

## Background

Cookie Cats is a mobile puzzle game in which, according to the dataset description, players encounter gates at certain levels and must wait or make an in-app purchase to continue. In a test, 44,700 players were assigned to a version with the first gate at level 30 and 45,489 to a version with it at level 40. The question was whether moving the gate changes player retention, measured mainly by whether players came back to play 7 days after installing the game.

---

## Key Findings

| Measure | Gate at level 30 | Gate at level 40 | Difference (level 40 − level 30) |
|---------|------------------|------------------|----------------------------------|
| 7-day retention (primary) | 19.0% | 18.2% | −0.8 percentage points |
| 1-day retention (secondary) | 44.8% | 44.2% | −0.6 percentage points |
| Game rounds played, median (exploratory) | 17 | 16 | −1 round |

- **7-day retention:** the difference is statistically significant. The 95% confidence interval for the difference runs from 0.3 to 1.3 percentage points lower at level 40.
- **1-day retention:** lower at level 40, but the difference is not statistically significant.
- **Game rounds:** the distributions of rounds played are very similar in the two versions.
- **Checks:** the 7-day conclusion was the same with a second interval method (bootstrap) and when the one player with an extreme number of rounds, the players with no rounds, or both were left out.

---

## What This Means

If the difference is caused by the gate position, keeping the gate at level 30 rather than moving it to level 40 would mean roughly 300 to 1,300 more players coming back on day 7 for every 100,000 new players. The data contains no revenue or purchase information, so the value of those players cannot be estimated here.

---

## Risks and Limitations

- **Assignment.** The dataset description does not explain how players were assigned to the two versions. A sample ratio test raised no alert under the threshold set for it (p = 0.009, against an alert level of 0.001), although a split of 50.4% at level 40 would be considered unusual at the conventional 5% level. The test cannot show that assignment was random, and reading the difference as caused by the gate depends on it.
- **Size of the effect.** The observed difference (0.8 percentage points) is close to the smallest difference this test was designed to detect with 90% probability (0.85 points). Estimates near that limit tend to overstate the true effect, so the full range of 0.3 to 1.3 points is a safer summary than the single figure.
- **Practical significance.** The difference is statistically significant, but whether it is large enough to matter commercially has not been established. The decision rule used zero as its threshold.
- **Missing information.** The data does not show which players reached the gate, what players spent, or retention beyond day 7.
- **Data source.** This is a public teaching dataset, so the findings illustrate the method and are not evidence about the current game.

---

## Next Steps

- Keep the gate at level 30.
- Before testing another gate-placement change, record player progression, including whether and when players reach the gate, alongside in-game purchases. This would support a fuller assessment of player behaviour and revenue, and a better-designed follow-up test.
- Agree in advance the smallest change in retention worth acting on, so the next result can be judged on its business size as well as its direction.

---

## Supporting Material

- [Phase 4 results](phase_04_advanced_analysis.md): full statistical results, checks and validity notes
- [Project charter](../PROJECT_INFO.md): question, metrics and decision rules
- [Statistical testing notebook](../notebooks/04_statistical_testing.ipynb)