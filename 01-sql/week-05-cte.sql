-- =====================================================================
-- 5-жума · CTE (Common Table Expression) жана терезе функциялары
-- Фаза 1 · Максат: 25 маселе
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1/25 · 2026-09-14 · Орточодон төмөн айлык алгандар
-- База: public.salaries
-- Максат: CTE'нин түзүлүшүн биринчи жолу колдонуу
-- ---------------------------------------------------------------------

WITH avg_salary AS (
    SELECT AVG(salary) AS avg_val FROM salaries
)
SELECT name, salary
FROM salaries
WHERE salary < (SELECT avg_val FROM avg_salary);

-- Натыйжа: 2 катар — Азамат 30000, Тилек 20000. Орточосу 35000.
-- Эскертүү: түзүлүшү экранда үлгү катары турган, мен '>' белгисин '<' кылдым.


-- ---------------------------------------------------------------------
-- 2/25 · 2026-09-14 · Ар бир мүчө канча АР БАШКА эмерек колдонгон
-- База: cd.bookings (pgexercises)
-- Түзүлүшү берилген жок — өзүм курдум
-- ---------------------------------------------------------------------

WITH per_member AS (
    SELECT memid, COUNT(DISTINCT facid) AS cnt
    FROM cd.bookings
    WHERE memid != 0          -- GUEST чыпкаланат
    GROUP BY memid
)
SELECT memid, cnt
FROM per_member
WHERE cnt > 5;

-- Өзүм кабыл алган эки чечим:
--   1. COUNT(*) эмес, COUNT(DISTINCT facid) — «брондоо» эмес, «эмерек» суралган
--   2. Чыпка WITH'тин ичине эмес, негизги query'ге
--
-- Эмне үчүн бул жерде WHERE иштейт, HAVING эмес:
--   WITH'тин ичинде GROUP BY иштеп бүттү →
--   агрегат ТИЛКЕГЕ айланды, ар бир топ КАТАРГА айланды →
--   негизги query үчүн чыпкала турган топ калган жок, катарлар гана бар.
--
-- Балама вариант (бирдей натыйжа, WITH'тин ичинде чыпкалоо):
--   ... GROUP BY memid
--       HAVING COUNT(DISTINCT facid) > 5



-- ---------------------------------------------------------------------
-- 3/25 · 2026-09-15 · Ар бир эмерек боюнча мүчөлөрдүн брондоолору
-- Экранда үлгү болгон жок — түзүлүштү өзүм курдум
-- ---------------------------------------------------------------------

WITH bookings_per_facility AS (
    SELECT
        f.name AS facility_name,
        COUNT(b.bookid) AS member_bookings
    FROM cd.bookings b
    INNER JOIN cd.facilities f ON f.facid = b.facid
    WHERE b.memid != 0
    GROUP BY f.facid            -- алгач f.name жазгам: ат уникалдуу эмес, PK керек
)
SELECT facility_name, member_bookings
FROM bookings_per_facility
ORDER BY member_bookings DESC;

-- 9 катар, биринчиси Pool Table 784.
-- Жоопту бузуунун эки жолу:
--   1. Такыр брондолбогон эмерек cd.bookings'те жок → GROUP BY аны көрбөйт.
--      Демек «9» = «9 эмерек брондолгон», «9 эмерек бар» эмес.
--   2. GROUP BY f.name болсо, аттары бирдей эки эмерек бир катарга кошулуп калат.
-- Postgres f.name'ди SELECT'те кабыл алат, себеби ал facid'тен келип чыгат:
-- functional dependency.


-- ---------------------------------------------------------------------
-- 4/25, 5/25, 6/25 · 2026-09-15 · GUEST үлүшү
-- Эки CTE · LEFT JOIN · normalization · type casting · COALESCE
-- ---------------------------------------------------------------------

WITH member_bookings AS (
    SELECT
        f.name AS facility_name,
        COUNT(b.bookid) AS member_count
    FROM cd.bookings b
    INNER JOIN cd.facilities f ON f.facid = b.facid
    WHERE b.memid != 0
    GROUP BY f.facid
),
guest_bookings AS (
    SELECT
        f.name AS facility_name,
        COUNT(b.bookid) AS guest_count
    FROM cd.bookings b
    INNER JOIN cd.facilities f ON f.facid = b.facid
    WHERE b.memid = 0
    GROUP BY f.facid
)
SELECT
    mb.facility_name,
    mb.member_count,
    COALESCE(gb.guest_count, 0) AS guest_count,
    ROUND(
        COALESCE(gb.guest_count, 0)::numeric
        / (mb.member_count + COALESCE(gb.guest_count, 0)),
    2) AS guest_share
FROM member_bookings mb
LEFT JOIN guest_bookings gb
    ON mb.facility_name = gb.facility_name   -- ТОЛУК ЭМЕС: текст боюнча кошуу.
                                             -- facid боюнча болушу керек — эртең.
ORDER BY guest_share DESC;

-- Натыйжа:
--   Massage Room 2   27   84   0.76
--   Squash Court    195  245   0.56
--   Massage Room 1  421  208   0.33
--   Tennis Court 2  276  113   0.29
--   Tennis Court 1  308  100   0.25
--   Badminton Court 344   39   0.10
--   Pool Table      784   53   0.06
--   Snooker Table   421   23   0.05
--   Table Tennis    385   18   0.04
-- GUEST тилкесинин суммасы = 883 ✓ (өзүн-өзү текшерүү)
--
-- ТАБЫЛГА: 4-жумада Massage Room 2 «эч ким колдонбойт» деп көрүнгөн (27 брондоо,
-- ченеми 2.25). Чындыгында ал бош эмес — брондоолорунун 76%ы GUEST'тики.
-- Squash Court'то да конокчулар мүчөлөрдөн көп брондогон: 245 vs 195.
--
-- Үч курал, үч себеп:
--   LEFT JOIN  — INNER JOIN чыпка сыяктуу иштейт: GUEST'сиз эмерек жоголуп калмак
--   ::numeric  — integer/integer = integer, ондук бөлүк кыркылат (ROUND кечигет!)
--   COALESCE   — LEFT JOIN бош клеткага NULL коёт, NULL арифметикада жугуштуу.
--                Тилке колдонулган ҮЧ жерге тең коюлушу керек.


-- =====================================================================
-- КИЙИНКИ ЖОЛУ
-- =====================================================================
-- - CTE'ни экранда үлгү жок кезде жазуу
-- - Терезе функциялары: ROW_NUMBER, RANK, LAG, SUM() OVER
-- - Ар бир тапшырмадан кийин query'ди үч сүйлөм менен түшүндүрүү
