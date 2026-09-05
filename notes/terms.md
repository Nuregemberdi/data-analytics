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

---

## Кесиптик сүйлөм үлгүлөрү (README жана иш маеги үчүн)

- *The goal of this analysis is to find out whether ...*
- *The data comes from ... and covers the period from ... to ...*
- *I cleaned the data by removing duplicates and converting ... to numeric.*
- *The results suggest that ..., but this is a correlation, not a causal effect.*
- **Limitations:** *The sample only includes students who reported their score, so the average is likely overestimated.*

Акыркысы эң маанилүү конструкция — ар бир долбоордо колдоном.
