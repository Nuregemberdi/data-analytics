# Терминдер · Terms

> Күнүнө 3–5 термин. Англисче жазам, өз сөзүм менен кыргызча түшүндүрөм.
> Максат: 6 айда англисче математикалык жана аналитикалык текст жаза алуу.

| English | Кыргызча түшүндүрмө (өз сөзүм менен) | Мисал сүйлөм (англисче) |
|---|---|---|
| query | маалымат базасына берилген суроо | *I wrote a query to count students by school.* |
| row / column | сап / мамыча | *This table has 300 rows and 5 columns.* |
| aggregate | көп сапты бир санга чогултуу (сумма, орточо, саны) | *`COUNT` is an aggregate function.* |
| null | маани жок дегени — нөл эмес, бош эмес, "белгисиз" | *A `NULL` value is not the same as zero.* |
| duplicate | кайталанган сап | *I removed 12 duplicate rows before the analysis.* |
| missing value | жетишпеген маани | *About 8% of the scores are missing values.* |

| primary key | таблицанын тилкеси, ар бир катарда кайталанбайт, ошондуктан аны менен бир катарды так табууга болот | *The `id` column is the primary key, so no two rows share the same value.* |
| median | тизмени өсүү же кемүү тартибинде иреттеп, ортодогусун алуу; жуп сан болсо ортодогу экөөнүн орточосу | *The median salary is 45,000 — half of the employees earn less, half earn more.* |
| sanity check | жоопту тез текшерүү: «бул акылга сыябы?» деп өзүңдөн суроо | *Before reporting the number, I ran a quick sanity check.* |

## 2026-09-04 / 09-05 · GROUP BY жумасы

| English | Кыргызча түшүндүрмө (өз сөзүм менен) | Мисал сүйлөм (англисче) |
|---|---|---|
| alias | натыйжадагы мамычага берилген кыска ат, `AS` менен жазылат | *I used an alias to make the column name readable.* |
| cardinality | тилкедеги ар түрдүү маанилердин саны. `COUNT(DISTINCT)` ушуну берет | *The `country` column has a cardinality of four.* |
| silent failure | билдирүүсүз ката: программа иштейт, натыйжа чыгат, бирок ал жалган | *This is a silent failure — the query runs but the result is wrong.* |
| normalization | ар кандай көлөмдөгү топторду салыштырууга жарактуу кылуу. `AVG = SUM / COUNT` | *Without normalization you cannot compare groups of different sizes.* |
| generalizability | жыйынтык канчалык кеңири жайылтылат. Тандама кайдан алынса, ошол чөйрөгө гана тиешелүү | *The sample is limited to one studio, so generalizability is low.* |
| derived column | таблицада жок, маалыматтан эсептеп чыгарылган мамыча | *The decade is a derived column, not stored in the table.* |
| minimum sample size | ишеним үчүн керектүү эң аз байкоо саны. $n=1$ болсо орточо маанисиз | *We set a minimum sample size of five before reporting any average.* |
| granularity | кесимдин майдалыгы. Тилке кошуу finer кылат, алып салуу coarser кылат | *Let's look at the data at a finer granularity.* |
| variance | чачыранды: маанилер орточодон канчалык алыс жайгашканы | *High variance makes the average unstable.* |
| range | башы менен аягынын аралыгы: `MAX − MIN` | *The range of film lengths is 39 minutes.* |

## 2026-09-05 · COUNT жана NULL

| English | Кыргызча түшүндүрмө (өз сөзүм менен) | Мисал сүйлөм (англисче) |
|---|---|---|
| clause | SQL сүйлөмүнүн бир бөлүгү. `WHERE`, `GROUP BY`, `HAVING` — ар бири clause | *Find the number of artists without a `HAVING` clause.* |
| non-null | NULL эмес маани. `COUNT(тилке)` ушуларды гана санайт | *`COUNT(building)` returns the number of non-null values.* |
| arbitrary | ыктыярдуу, эрежесиз тандалган. Топтолбогон тилке ушундай тандалат | *SQLite picks an arbitrary value, so the result is not reliable.* |
| to derive | бар сандардан жаңы санды чыгаруу (жаңы маалымат албай) | *I derived the total from the average and the count.* |
| total | жалпы сумма. Англисчеде "total" → `SUM`, "number of" → `COUNT` | *Find the total number of years employed by all engineers.* |

**Айырма:** *the **total** number of years* → `SUM(years)`, ал эми *the **number** of employees* → `COUNT(*)`.
Экөө тең "number" сөзүн колдонот, бирок башка агрегат керек.

## 2026-09-06 · чачыранды, чек, атоо

| English | Кыргызча түшүндүрмө (өз сөзүм менен) | Мисал сүйлөм (англисче) |
|---|---|---|
| spread | маанилердин бири-биринен канчалык алыс жайгашканы | *Two groups can share a mean but differ in spread.* |
| threshold | чек, ченем. `HAVING`ке сөзсүз керек, маалыматтан тандалат | *I set a threshold of two years.* |
| base rate | топтун негизги үлүшү. Салыштыруудан мурун каралат | *The base rate explains it: he directed five of the fourteen films.* |
| robust | бекем — маалымат бир аз өзгөрсө да жыйынтык өзгөрбөйт | *The result is not robust: it depends on a third of a minute.* |
| career span | карьеранын узундугу: `MAX(year) - MIN(year)` | *His career span is sixteen years.* |
| to name a column | тилкеге ат берүү — ат эмнени ӨЛЧӨГӨНҮН айтышы керек | *Name it `length_range`, not `height_range`.* |

**Эки эреже:**

1. `range` эки санды гана колдонот (`MAX`, `MIN`), `variance` бардыгын колдонот.
   Ошондуктан эки топтун `range`и бирдей болуп, `variance`и башка болушу мүмкүн.
2. `snake_case` — SQL'де эки сөздүн ортосуна астын сызык: `total_minutes`,
   `career_span`, `length_range`. Боштук койсо SQL аны бир ат деп окубайт.


## 2026-09-07 / 09-08 · JOIN жумасы

| English | Кыргызча түшүндүрмө (өз сөзүм менен) | Мисал сүйлөм (англисче) |
|---|---|---|
| foreign key | башка таблицага шилтеме кылган тилке. `primary key`тен айырмасы: кайталанат | *`student_id` is a foreign key referencing the students table.* |
| fan-out | оң таблицада бир катарга бир нече дал келүү болгондо, сол таблицанын катары көбөйүп кетиши | *Watch out for fan-out: the join multiplied the rows.* |
| Cartesian product | ачкычсыз JOIN: ар бир катар ар бир катар менен жупташат, $N \times M$ | *Without an `ON` clause you get a Cartesian product.* |
| three-valued logic | SQL логикасы үч мааниге ээ: `TRUE`, `FALSE`, `UNKNOWN` | *SQL uses three-valued logic, so `NULL > 4` is unknown.* |
| unknown | үчүнчү маани. `NULL` менен салыштыруунун жообу. `WHERE` аны калтырбайт | *The comparison returns unknown, so the row is filtered out.* |
| observation window | маалымат камтыган убакыт аралыгы. `MIN`/`MAX` анын чегине жабышат | *The observation window covers only three months of 2012.* |
| to preserve | сактап калуу. `LEFT JOIN` сол таблицанын катарларын preserve кылат | *A `LEFT JOIN` preserves every row from the left table.* |
| to match | дал келүү. `ON` шарты дал келүүнү аныктайт | *Rows that do not match are dropped by an inner join.* |
| placeholder record | чыныгы объектти билдирбеген жасалма катар (`memid = 0` — GUEST) | *`memid` zero is a placeholder record for guests, not a real member.* |

**Үч эреже:**

1. `ON`догу шарт JOIN учурунда иштейт жана `LEFT JOIN`ду сактайт.
   `WHERE`деги шарт JOIN бүткөндөн кийин иштейт жана `LEFT JOIN`ду `INNER JOIN`го
   айландырып коёт. Себеби: `NULL` менен салыштыруу `UNKNOWN` берет, ал эми
   `WHERE` `TRUE` болгондорду гана калтырат.
2. Агрегат бар → `GROUP BY` керек. Агрегат жок → `GROUP BY` зыян.
3. `MIN`/`MAX` `observation window`дун чегине жакын болсо, ал чыныгы маани эмес,
   чектин өзү болушу мүмкүн.

**Жаңы сүйлөм үлгүлөрү (README үчүн):**

- *The two tables are joined on `facid`.*
- *Guest bookings (`memid = 0`) are excluded from the analysis.*
- **Limitations:** *The data covers only July to September 2012, so the earliest
  booking per member is bounded by the observation window rather than by the
  member's actual first visit.*


## 2026-09-09 · self join, подзапрос

| English | Кыргызча түшүндүрмө (өз сөзүм менен) | Мисал сүйлөм (англисче) |
|---|---|---|
| self join | таблицанын өзүнө кошулушу. Бир таблица эки роль ойногондо | *Use a self join to list each member with their recommender.* |
| subquery | query'нин ичиндеги query. Ичкиси биринчи иштейт | *The subquery returns the average salary.* |
| inner query / outer query | ички query / тышкы query | *The inner query runs first and passes its result to the outer query.* |
| scalar | бир гана маани кайтарган. `=`, `>` менен колдонулат | *`AVG()` returns a scalar value.* |
| membership test | тизменин ичинде барбы деп текшерүү — `IN` ушуну кылат | *`IN` performs a membership test against the list.* |
| fact table / dimension table | окуялар журналы / туруктуу тизме. Fact dimension'дарды байланыштырат | *`bookings` is the fact table; `members` and `facilities` are dimensions.* |
| to chain joins | JOIN'дорду кетирүү — үч же андан көп таблица | *You can chain joins as long as each one has its own `ON` clause.* |
| to collapse rows | катарларды бир катарга кысуу. `DISTINCT` жана `GROUP BY` ушуну кылат | *`DISTINCT` collapsed two different people into one row.* |

**Үч эреже:**

1. Ички query **бир** маани кайтарса — `=` `>` `<`. **Көп** маани кайтарса — `IN`.
2. `self join`то тапшырма бир адамды сурап жатса, `SELECT`теги бардык тилке
   **бир эле alias**тан болушу керек.
3. `DISTINCT` кайталанууну жашырат, оңдобойт. Адегенде «эмне үчүн кайталанып
   жатат?» деп сура.

**Жаңы сүйлөм үлгүлөрү:**

- *The query joins three tables through the bookings fact table.*
- *I verified the subquery by running it on its own.*
- **Limitations:** *Two members share the same name, so grouping by name rather
  than by `memid` would merge them into a single row.*

---

## 2026-09-11 · NULL логикасы, нормалдаштыруу, түр

| Термин | Мааниси |
|---|---|
| `three-valued logic` | TRUE · FALSE · UNKNOWN — SQLдеги логиканын үч абалы |
| `UNKNOWN` | `NULL` катышкан ар кандай салыштыруунун жообу |
| `non-deterministic` | ар жолу башка натыйжа чыгышы мүмкүн, кепилдик жок |
| `deterministic` | натыйжа ар дайым бирдей |
| `tie-breaker` | теңдикти бузуучу экинчи ченем (`ORDER BY`дын экинчи тилкеси) |
| `functional dependency` | `primary key` боюнча топтогондо башка тилкелер автоматтык аныкталат |
| `COUNT(DISTINCT ...)` | канча **башка** маани бар — катарлардын санын эмес |
| `integer division` | бүтүн ÷ бүтүн = бүтүн, ондугу кыркылат |
| `type casting` | түрдү өзгөртүү: `::numeric`, `CAST(x AS numeric)` |
| `normalization` | эки топту салыштыруу үчүн жалпы негизге бөлүү |
| `rate` | ошондон чыккан сан: «бир мүчөгө канча брондоо» |
| `sample size` (`n`) | тандоонун көлөмү — ченемдин жанында ар дайым турушу керек |
| `testable hypothesis` | маалымат менен текшерүүгө боло турган божомол |
| `falsified hypothesis` | текшерилип, жараксыз болуп чыккан божомол |

**Эстен чыкпасын:**

1. `NOT IN` ичинде `NULL` болсо — 0 катар, ката билдирүүсүз.
2. Бөлүү жазган сайын: «эки жагы тең бүтүн санбы?»
3. Ченем жалгыз турбайт — жанында `n`.
4. Бир тилкенин ар кандай маанилери керек болсо — `OR`, `AND` эмес.

**Жаңы сүйлөм үлгүлөрү:**

- *The rate is normalized by the number of distinct members.*
- *This hypothesis was falsified: both rooms have identical pricing.*
- *Integer division truncated the result, so the ratio was understated.*
- **Limitations:** *Massage Room 2 has only 27 bookings, so the rate is based on a
  very small sample and is not stable.*

---

## 2026-09-11 (кечки уландысы) · коррелденген подзапрос

| Термин | Мааниси |
|---|---|
| `correlated subquery` | ички query тышкысынын тилкесин колдонот, ар бир катар үчүн кайра иштейт |
| `uncorrelated subquery` | бир жолу иштейт, бир жооп берет, тышкысы жөнүндө билбейт |
| байланыш сабы | `WHERE b2.facid = b.facid` — коррелденген подзапросто `GROUP BY`дын ордун ээлейт |

**Эстен чыкпасын:**

1. Коррелденген подзапросто **эки alias милдеттүү** (`b` жана `b2`).
2. Тышкы query **тандабайт — чыпкалайт**. Ага агрегат да, `GROUP BY` да керек эмес.
3. **Чыпка эки queryде тең** болушу керек, антпесе экөө эки башка жыйынды карайт.
4. Байланыш тилкесин алмаштырсаң (`memid` → `facid`) query башка суроого жооп берет,
   ката чыкпайт.
5. `DISTINCT` — катарлар **көп** болгондо каралат. Катарлар **аз** болсо жардам бербейт.

**Жаңы сүйлөм үлгүлөрү:**

- *The subquery is correlated: it runs once per row of the outer query.*
- *The correlation predicate defines the group, the way `GROUP BY` would.*
- **Limitations:** *The filter was applied only in the outer query, so four
  facilities dropped out of the result silently.*
- *Nine members tie for the longest booking, so the result is not a single row.*

---

## 2026-09-11 (кечки уландысы 2) · derived table

| Термин | Мааниси |
|---|---|
| `derived table` | `FROM`догу подзапрос жараткан убактылуу таблица |
| `AS t` | ага берилген ат — PostgreSQL'де **милдеттүү** |
| агрегаттын үстүнөн агрегат | `AVG(COUNT(...))` жазылбайт; `COUNT`ту `derived table`ка чыгарып, анан `AVG` |
| `CTE` / `WITH` | 5-жуманын темасы: эсептөөнү бир жолу жазып, ат берип, кайра-кайра колдонуу |

**Эстен чыкпасын:**

1. `AS t` деген ат **тышкы queryде гана** жашайт. `WHERE`дин ичиндеги подзапрос аны
   көрбөйт — ошондуктан эсептөө кайра жазылат. Бул `CTE`нин себеби.
2. Бир эсептөө эки жерде жазылса — бирин оңдоп экинчисин унутуу коркунучу бар,
   жана ката чыкпайт.

**Жаңы сүйлөм үлгүлөрү:**

- *The subquery in the FROM clause produces a derived table, aliased as `t`.*
- *You cannot nest aggregates directly, so the counts are computed first.*
- *A CTE would let me write this calculation once instead of twice.*

---

## Кесиптик сүйлөм үлгүлөрү (README жана иш маеги үчүн)

- *The goal of this analysis is to find out whether ...*
- *The data comes from ... and covers the period from ... to ...*
- *I cleaned the data by removing duplicates and converting ... to numeric.*
- *The results suggest that ..., but this is a correlation, not a causal effect.*
- **Limitations:** *The sample only includes students who reported their score, so the average is likely overestimated.*

Акыркысы эң маанилүү конструкция — ар бир долбоордо колдоном.
