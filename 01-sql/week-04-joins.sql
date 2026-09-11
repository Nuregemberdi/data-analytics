-- ============================================
-- 4-жума: JOIN, подзапрос, fan-out
-- Тема: INNER JOIN, LEFT JOIN, self join, subquery
-- Максат: 30 маселе
-- Булак: https://pgexercises.com/questions/joins/  (браузерде, чыныгы PostgreSQL)
-- ============================================
--
-- ЭРЕЖЕ: ар бир query'ди жазардан МУРУН эмне күтөрүңдү жаз.
-- Канча катар, канча тилке, эмне үчүн. Дал келбесе — токто, ойлон.
--
-- ЭКИНЧИ ЭРЕЖЕ (4-жуманын өзгөчөлүгү):
-- JOIN жазган сайын катарлардын саны КӨБӨЙБӨДҮБҮ деп текшер.
-- Бул fan-out тузагы — 4-жуманын эң маанилүү сабагы.
--
-- ============================================


-- --------------------------------------------
-- 0. Базанын түзүлүшү (schema)
-- --------------------------------------------
--
-- cd.members     — клубдун мүчөлөрү
--   memid (ачкыч), surname, firstname, address, zipcode, telephone,
--   recommendedby, joindate
--
-- cd.facilities  — эмеректер (теннис корту, бассейн, ж.б.)
--   facid (ачкыч), name, membercost, guestcost, initialoutlay, monthlymaintenance
--
-- cd.bookings    — брондоолор
--   bookid (ачкыч), facid, memid, starttime, slots
--
-- БАЙЛАНЫШТАРЫ:
--   bookings.memid → members.memid        (ким брондоду)
--   bookings.facid → facilities.facid     (эмнени брондоду)
--   members.recommendedby → members.memid (ким сунуштаган — ӨЗ таблицасына!)
--
-- bookings — ортодогу таблица, экөөнү байланыштырат.
-- Мындай түзүлүш чыныгы базаларда дайыма кездешет.


-- --------------------------------------------
-- 1. Түшүнүктөр (2026-09-07де үйрөнүлдү, курал орнотулганга чейин)
-- --------------------------------------------
--
-- KEY (ачкыч) — эки таблицаны байланыштыруучу тилке.
--   Компьютер "Toy Story" деген катар менен "$191 млн" деген катардын бир
--   нерсеге тиешелүү экенин ӨЗҮ билбейт. Сен ага көрсөтөсүң.
--
-- CARTESIAN PRODUCT (декарттык көбөйтүндү, cross join) —
--   ачкыч көрсөтүлбөсө SQL ар бир катарды ар бир катар менен жупташтырат.
--   Ката БЕРБЕЙТ, токтоп да калбайт — жөн эле жалган натыйжа берет.
--   Математикада: A × B. 14 катар × 14 катар = 196 катар.
--   Алардын 14ү гана туура жуп, калган 182си жалган.
--   Бул silent failure'дин бир түрү.
--
-- ON — JOIN'дун чыпкасы. 196дан 14үн тандап алат.
--   ON movies.id = boxoffice.movie_id
--
-- INNER JOIN — эки таблицада ТЕҢ дал келгендер гана калат.
--   Дал келбеген катар натыйжада КӨРҮНБӨЙТ.
--
-- LEFT JOIN — сол таблицанын БАРДЫК катарлары калат.
--   Дал келбегендеринин оң жактагы тилкелери NULL болот.
--
-- КАЧАН LEFT JOIN КЕРЕК:
--   «Канча фильмдин кассасы жазылбай калган?» деген суроого
--   INNER JOIN жооп БЕРЕ АЛБАЙТ — ал дал ошол катарларды алып салат.
--   Көрүнбөй турган нерсени санай албайсың.
--   LEFT JOIN аларды калтырат, revenue тилкесинде NULL турат.
--   Анан санайсың:
--     COUNT(*) - COUNT(revenue)     ← 3-жумадагы өз эрежем
--     же WHERE revenue IS NULL      ← чыпкалап, анан COUNT(*)
--
-- БАЙКОО: 3-жумада үйрөнгөн эреже 4-жуманын куралына айланды.
-- JOIN жаңы тема, бирок анын ичиндеги логика мага тааныш.


-- --------------------------------------------
-- 2. JOIN маселелери
-- --------------------------------------------

-- 1.1  Retrieve the start times of members' bookings   [pgexercises: joins/simplejoin]
-- Котормо: «David Farrell» деген мүчөнүн брондоолорунун башталуу убактыларын чыгар.
--
-- ОЙ ЖҮГҮРТҮҮ:
--   Аты bookings таблицасында ЖОК — ал жерде memid деген сан гана бар.
--   Кайсы сан «David Farrell» экенин members таблицасынан табам.
--   Демек эки таблица тең керек, ачкычы memid.
--
--   Мен муну адегенде КОЛ МЕНЕН жасадым: bookings'тен memid = 1 дегенди алдым,
--   members'тен ошол номерди таап, атын окудум. JOIN дал ушуну автоматтык кылат.
SELECT starttime
FROM cd.members
INNER JOIN cd.bookings ON cd.members.memid = cd.bookings.memid
WHERE firstname = 'David' AND surname = 'Farrell';
-- Чыкты: David Farrell'дин брондоолорунун убактылары. Сайт ✓ деп ырастады.
--
-- КАТАЛАРЫМ (тартиби менен):
-- 1) SELECT'ке таблицанын атын жаздым: SELECT cd.members, cd.bookings
--    SELECT'ке ТИЛКЕ жазылат, таблица эмес.
-- 2) WHERE'ди JOIN'ден МУРУН койдум.
--    JOIN — FROM'дун бир бөлүгү, ошондуктан тартиби:
--       FROM ... -> INNER JOIN ... ON ... -> WHERE ...
-- 3) Тырмакчаларды бош калтырдым — атты тапшырманын өз текстинен алыш керек эле.
--
-- ЭМНЕ ҮЧҮН cd.members.memid деп толук жазылат:
--   Эки таблицада тең memid деген тилке бар. Жөн эле memid десем,
--   SQL кайсынысы экенин билбейт. starttime болсо бир гана таблицада бар,
--   ошондуктан ал таблицанын атынсыз да иштейт.
--
-- САЙТТЫН ЖООБУ (менден айырмасы — ALIAS колдонгон):
--   from cd.bookings bks
--   inner join cd.members mems on mems.memid = bks.memid
--   cd.bookings bks — таблицага кыска ат. Мындан ары bks деп жазса болот.
--   Узун query'де ыңгайлуу. Логикасы меникине бирдей.
--
-- Бир мүчөнүн бир нече брондоосу болсо, ал натыйжада бир нече жолу чыгат.
-- Darren members'те бир катар эле, эки брондоосу бар -> JOIN'де эки катар.
-- Бул fan-out'тун башталышы. Кийинки маселелерде текшерем.


-- ============================================
-- 2026-09-07 · МАШЫГУУ: өз таблицаларым (students / grades)
-- ============================================
--
-- pgexercises базасы али орнотула элек эле. JOIN'ду түшүнүү үчүн өз тармагымдан
-- кичине таблица түзүлдү — окуучулар жана баалар журналы.
--
-- Бул аналогия мага дароо кирди: класс журналынын БИРИНЧИ бетинде №7 бир жолу
-- (primary key), баалар бетинде №7 он жолу (foreign key). Экинчи дептерде ат
-- жазылбайт, номер гана. JOIN дал ошол номерди атка айландырат.

CREATE TABLE students (id INT, name TEXT);
CREATE TABLE grades (gid INT, student_id INT, grade INT);

INSERT INTO students VALUES (1,'Айбек'),(2,'Нурзат'),(3,'Мээрим'),(4,'Эркин'),(5,'Гүлназ');
INSERT INTO grades   VALUES (1,1,5),(2,1,4),(3,3,3),(4,5,5),(5,5,4),(6,5,3);

-- Байланыш: grades.student_id -> students.id
-- Нурзат менен Эркиндин бир да баасы жок — LEFT JOIN үчүн атайын ушундай.


-- --------------------------------------------
-- КОЛ МЕНЕН JOIN (кагаз үстүндө, query жазганга чейин)
-- --------------------------------------------
--   Айбек (id=1) -> grades'те 2 дал келүү -> 2 катар
--   Нурзат (id=2) -> 0 дал келүү         -> LEFT JOIN'до 1 катар, grade = NULL
--   Мээрим (id=3) -> 1 дал келүү         -> 1 катар
-- 2 + 1 + 1 = 4 катар.
--
-- Мен адегенде 3 деп божомолдодум — INNER JOIN'дун жообун айткам.
-- Айбектин ЭКИ жолу чыгышы — fan-out'тун өзү.
-- Дагы бир баа кошсок 5 катар болмок.


-- --------------------------------------------
-- ⚠️ ЭСЕПКЕ КИРБЕЙТ: калып көрсөтүлүп жазылгандар
-- --------------------------------------------
-- Мугалим адегенде БАШКА таблицада (teachers / classes) ошол эле түзүлүштү
-- көрсөттү, мен аны которуп жаздым. Ченем боюнча бул эсепке кирбейт.
-- Бирок каталары жазылып калсын:

SELECT students.name, grades.grade
FROM students
LEFT JOIN grades ON grades.student_id = students.id;
-- КАТАЛАРЫМ (тартиби менен, ар бири өзүнчө аракет):
--  1) LEFT JOIN students  -> FROM'догу таблицанын ӨЗҮН кошуп жаттым
--  2) ON students.name = grades.student_id -> ТЕКСТТИ САН менен салыштыруу.
--     'Айбек' менен 1 эч качан барабар болбойт -> бир да катар дал келмек эмес
--  3) WHERE grade != 'null' деп жаздым, анын үстүнө FROM'дон МУРУН.
--     NULL'ду =/!= менен салыштырууга БОЛБОЙТ, жана 'null' — жөн эле текст
--
-- ЭКИ ЭРЕЖЕ ушул жерден чыкты:
--   «Сол» — экрандагы орду эмес, ЖАЗУУ ТАРТИБИ.
--     FROM'дон кийинкиси сол, JOIN'дон кийинкиси оң.
--   FROM'го ТОЛУК САКТАЛЫШЫ керек болгон таблица жазылат.

SELECT students.name, grades.grade
FROM students
INNER JOIN grades ON students.id = grades.student_id;
-- 3 катар. Нурзат өзү жоголду — WHERE'дин кереги жок экен.

SELECT students.name
FROM students
LEFT JOIN grades ON students.id = grades.student_id
WHERE grades.student_id IS NULL;
-- Нурзат. IS NULL — NULL'ду кармаган жалгыз курал.

SELECT students.name, COUNT(grades.gid)
FROM students
LEFT JOIN grades ON grades.student_id = students.id
GROUP BY students.name
ORDER BY COUNT(grades.gid) DESC;
-- ORDER BY'ды суралбай өзүм коштум.
--
-- COUNT(*) vs COUNT(тилке) — ӨЗҮМ ТЕСТКЕ САЛЫП ТАПТЫМ:
--   COUNT(grades.gid) -> Нурзат 0   (туурасы)
--   COUNT(*)          -> Нурзат 1   (жалганы)
-- Себеби: LEFT JOIN'дон кийин Нурзаттын БИР катары бар, ичинде grade = NULL.
-- COUNT(*) ошол катарды санайт, COUNT(тилке) NULL'ду санабайт.


-- --------------------------------------------
-- ✅ ЭСЕПКЕ КИРГЕНДЕР (калыпсыз, өз алдынча)
-- --------------------------------------------

-- 10/30  Айбектин гана баалары
SELECT students.name, grades.grade
FROM students
INNER JOIN grades ON students.id = grades.student_id
WHERE students.name = 'Айбек';
--
-- КАНТИП БУЗУУГА БОЛОТ (өзүм таптым): эки Айбек болсо, экөөнүн баалары
-- аралашмак. Ат уникалдуу эмес.

-- 11/30  Ошол эле, бирок id боюнча — оңдоону өзүм таптым
SELECT students.name, grades.grade
FROM students
INNER JOIN grades ON students.id = grades.student_id
WHERE students.id = 1;
-- students.id — primary key, кайталанбайт. Издөө ат боюнча эмес, ачкыч боюнча.

-- 12/30  Эки же андан көп баасы бар окуучулар
SELECT students.name, COUNT(grades.gid)
FROM students
LEFT JOIN grades ON grades.student_id = students.id
GROUP BY students.name
HAVING COUNT(grades.gid) >= 2
ORDER BY COUNT(grades.gid) DESC;
-- HAVING'ти өзүм эстедим.
-- Адегенде "= 2 OR > 2" деп жазгам -> бир белги менен: >=
--
-- ЭМНЕ ҮЧҮН WHERE ЭМЕС:
--   Тартиби: FROM/JOIN -> WHERE -> GROUP BY -> HAVING
--   WHERE иштегенде катарлар дагы эле ӨЗ-ӨЗҮНЧӨ турат, топ түзүлө элек.
--   COUNT — ТОПТУН мүнөздөмөсү. Топ жок болсо, саналчу нерсе да жок.
--   Математикада: топтом түзүлмөйүнчө анын кубаттуулугун |A| айта албайсың.

-- 13/30  Орточо баасы 3төн төмөн ЖЕ баасы такыр жок окуучулар
SELECT students.name, AVG(grades.grade)
FROM students
LEFT JOIN grades ON grades.student_id = students.id
GROUP BY students.name
HAVING AVG(grades.grade) < 3 OR AVG(grades.grade) IS NULL;
-- Нурзат, Эркин.
--
-- ЭҢ МААНИЛҮҮ САБАК (бул жерден чыкты):
--   Директор «орточо баасы 3төн төмөн окуучуларды тап» десе,
--   HAVING AVG(...) < 3 гана жазылса — баасы ТАКЫР ЖОК окуучулар,
--   б.а. эң тобокелдүүлөрү, тизмеге ТАПТАКЫР кирбейт.
--   Себеби: аларда AVG = NULL, NULL < 3 -> UNKNOWN, HAVING аны таштайт.
--   Ката чыкпайт. Отчёт жасалат. Чечим кабыл алынат. -> silent failure
--
--   COUNT менен AVG'дин айырмасы да ушул жерден:
--     COUNT -> 0    («нөл даана» — БИЛИНГЕН жооп)
--     AVG   -> NULL (сумма ÷ 0 — аныкталбайт)


-- --------------------------------------------
-- ⚠️ Alt+X тузагы (ушул машыгууда чыкты)
-- --------------------------------------------
-- Скриптти бир нече жолу Alt+X менен аткардым -> INSERT'тер кайра иштеп,
-- маалымат көчүрүлүп калды. 3 катардын ордуна 24 катар чыкты.
--   students'те 4 Айбек, grades'те 2 «5» -> 4 × 2 = 8 катар.
-- Query туура эле, МААЛЫМАТ бузулган.
--
-- Тазалоо:
--   DELETE FROM students; DELETE FROM grades; анан INSERT'терди БИР жолу.
--
-- ЭРЕЖЕ: Ctrl+Enter = курсор турган бир query. Alt+X = бүт скрипт.
-- Query туура болуп, натыйжа туура эмес болсо — адегенде МААЛЫМАТТАН шектен.

-- ============================================
-- 2026-09-08 · КУРАЛ ОРНОТУЛДУ
-- ============================================
--
-- pgexercises клуб базасы эми ӨЗ компьютеримде турат — сайттын кутучасы эмес.
--
-- Кантип орнотулду (кайталоо керек болсо):
--   1. https://pgexercises.com/dbfiles/clubdata.sql жүктөлдү
--   2. DBeaver'де: CREATE DATABASE exercises;
--   3. Файлдан эки сап өчүрүлдү: "CREATE DATABASE exercises;" жана "\c exercises"
--      ⚠️ "CREATE SCHEMA cd;" КАЛЫШЫ КЕРЕК. Ал кокустан өчүп кетип,
--      таблицалар pg_catalog'ко түшүүгө аракет кылып, ката берген
--   4. DBeaver: Файл -> Открыть файл -> clubdata.sql
--   5. Панелде туташуу postgres, база public@exercises
--   6. Alt+X
--   7. Текшерүү: SELECT COUNT(*) FROM cd.members;  -> 31
--
-- ⚠️ postgres колдонуучунун паролу унутулган. psql иштебейт.
--    DBeaver'де пароль сакталып турат, ошондуктан баары ошол аркылуу жасалды.
--    Керек болсо pg_hba.conf аркылуу алмаштырса болот (~10 мүнөт).


-- ============================================
-- 2026-09-08 · ЖЕТЕЛӨӨСҮЗ ЧЕЧИЛГЕН МАСЕЛЕЛЕР
-- ============================================
--
-- ЭСЕПКЕ КИРҮҮ ЧЕНЕМИ (ушул күнү макулдашылды):
--   Кирет  — тапшырманы өзүм жазсам жана туура болсо.
--            Тилкенин атын сурап алуу — кирет, ал жөн эле карап алуу.
--   Кирбейт — мугалим жообун берсе, же кадам сайын жетелесе.


-- --------------------------------------------
-- 1/30  David Farrell (1.1 кайра, жетелөөсүз)
-- --------------------------------------------
-- Күттүм: бир нече ондогон катар, бир тилке.
SELECT cd.bookings.starttime
FROM cd.members
INNER JOIN cd.bookings ON cd.members.memid = cd.bookings.memid
WHERE cd.members.firstname = 'David'
  AND cd.members.surname = 'Farrell';
-- Чыкты: 34 катар. ✓
--
-- КАНТИП БУЗУУГА БОЛОТ: клубда эки David Farrell болсо, экөөнүн брондоолору
-- бир тизмеге аралашмак — 34түн ордуна 60 чыгып, кимдики экени билинбей калмак.
-- Ката ЧЫКПАЙТ. Оңдоо: memid боюнча издөө.
-- (Кийинчерээк базада эки Darren Smith бар экени табылды — бул ойдон чыгарылган
--  коркунуч эмес экен.)


-- --------------------------------------------
-- 2/30  Tennis courts, 2012-09-21
-- --------------------------------------------
-- Күттүм: эки корт, күн бою — он чакты катар.
SELECT cd.bookings.starttime, cd.facilities.name
FROM cd.bookings
INNER JOIN cd.facilities ON cd.bookings.facid = cd.facilities.facid
WHERE cd.facilities.name LIKE 'Tennis Court%'
  AND cd.bookings.starttime >= '2012-09-21'
  AND cd.bookings.starttime <  '2012-09-22'
ORDER BY cd.bookings.starttime;
-- Чыкты: 12 катар. ✓
--
-- КАТАМ: биринчи аракетте күн боюнча чыпка ТАКТАКЫР жок эле — июль айынын
-- күндөрү чыкты. Жана SELECT'те корттун аты жок эле.
--
-- КҮН — ЧЕКИТ ЭМЕС, АРАЛЫК:
--   starttime'да саат да бар, ошондуктан "= '2012-09-21'" иштебейт.
--   >= '2012-09-21' AND < '2012-09-22'
--   Экинчи чекте <= ЭМЕС, < — болбосо кийинки күндүн 00:00у кирип кетет.
--
-- LIKE тузагы (өзүм текшердим):
--   'Tennis Court%' -> 12 катар
--   '%Tennis%'      -> 21 катар болмок (Table Tennis кошулат)
--   '%Tennis Court%'-> 12 катар (Table Tennis'те "Tennis Court" айкалышы жок)
--   Мен адегенде "жообум өзгөргөн жок" деп ойлодум. Мугалим "текшер" деди.
--   Table Tennis ал күнү 9 жолу брондолгонун өзүнчө query менен таптым ->
--   демек биринчи божомол жалган эле, query'де дагы деле 'Tennis Court%' турган.
--   САБАК: божомолду ырастоочу өзүнчө query жазуу — бул рефлекс болушу керек.


-- --------------------------------------------
-- 3/30  Massage Room 1 брондоолору
-- --------------------------------------------
SELECT cd.facilities.name, cd.bookings.starttime
FROM cd.facilities
INNER JOIN cd.bookings ON cd.facilities.facid = cd.bookings.facid
WHERE cd.facilities.name = 'Massage Room 1'
ORDER BY cd.bookings.starttime;
-- Чыкты: 629 катар.
--
-- DBEAVER ТУЗАГЫ: where менен order by ортосунда БОШ САП калтырсам,
-- DBeaver аны эки өзүнчө query деп кабылдап, курсор турганын гана аткарат.
-- Натыйжада order by менен limit иштебей калды. Бош сап калтырбайм.
--
-- Тизменин АЯГЫН көрүү: ORDER BY ... DESC LIMIT 10 — тартипти тескери кыл.


-- --------------------------------------------
-- 4/30  Ар бир эмерек канча жолу брондолгон
-- --------------------------------------------
-- Күттүм: 9 катар (эмерек 9).
SELECT cd.facilities.name, COUNT(*)
FROM cd.facilities
INNER JOIN cd.bookings ON cd.facilities.facid = cd.bookings.facid
GROUP BY cd.facilities.name
ORDER BY COUNT(*) DESC;
-- Чыкты: 9 катар. Pool Table 837, Massage Room 2 111. ✓
--
-- КАТАМ (мурунку кадамда): SELECT'ке COUNT(*) менен катар name жана starttime
-- жаздым -> ката. Агрегат бар болсо, же GROUP BY керек, же жеке тилкелер
-- SELECT'те болбошу керек. Жалпы санды гана сурасам — SELECT COUNT(*) жалгыз калат.


-- --------------------------------------------
-- 5/30  Ар бир эмерек канча САAT колдонулган
-- --------------------------------------------
SELECT cd.facilities.name, SUM(cd.bookings.slots) / 2
FROM cd.facilities
INNER JOIN cd.bookings ON cd.facilities.facid = cd.bookings.facid
GROUP BY cd.facilities.name
ORDER BY SUM(cd.bookings.slots) / 2 DESC;
-- ✓
--
-- КАТАМ: адегенде starttime'ды суммалап, андан узактыкты чыгарайын деп ойлодум.
-- Бул мүмкүн эмес — starttime башталуу гана, аяктоо убактысы базада ЖОК.
-- Узактык мурунтан эле slots тилкесинде турат.
-- 2 slots = 1 саат -> сан КИЧИРЕЙИШИ керек -> 2ге БӨЛӨМ.
--
-- САБАК: маалыматта даяр турган нерсени эсептеп чыгарууга аракет кылбайм.
-- Адегенде тилкелердин тизмесин карайм.


-- --------------------------------------------
-- 6/30  30дан ашык брондогон мүчөлөр
-- --------------------------------------------
-- Күттүм: 20дан ашуун катар.
SELECT cd.members.surname, cd.members.firstname, COUNT(*)
FROM cd.bookings
INNER JOIN cd.members ON cd.members.memid = cd.bookings.memid
WHERE cd.bookings.memid != 0
GROUP BY cd.members.surname, cd.members.firstname
HAVING COUNT(*) > 30
ORDER BY COUNT(*) DESC;
-- Чыкты: 23 катар. Rownam Tim 408 — эң активдүү мүчө. ✓
--
-- ТАЛДОО (өзүм жасадым): cd.facilities бул тапшырмада КЕРЕК ЭМЕС —
-- эмерек жөнүндө эч нерсе суралган жок. Ашыкча JOIN fan-out тобокелдигин жаратат.
--
-- WHERE memid != 0 — эмне үчүн:
--   cd.members'те memid = 0 деген катар бар, аты "GUEST GUEST".
--   Ал чыныгы адам эмес — бөтөн адамдардын брондоолору ошол номерге жазылат.
--   Ажырата турган ТАК белги — memid = 0, аты эмес.
--
-- ТЕКШЕРҮҮ (өзүм жаздым): шартты алып салып аткардым ->
--   GUEST GUEST 883 болуп тизменин ЭҢ БАШЫНА чыкты, 24 катар болду.
--   Демек шарт чын эле иштеп турат.
--   Аз өзгөрүү (23 -> 24), чоң кесепет: отчёттун биринчи сабы башка.
--
-- GROUP BY'га эки тилке эмне үчүн:
--   Клубда 3 Smith бар (Darren 261, Tracy 210, Jack 89).
--   Жалгыз surname боюнча топтосом, үчөө бир топко кошулуп 560 деген
--   жалган сан чыкмак. Толук чечим — memid боюнча топтоо.


-- --------------------------------------------
-- 7/30  Ар бир мүчөнүн орточо slots'у
-- --------------------------------------------
SELECT m.surname, m.firstname, ROUND(AVG(b.slots), 2)
FROM cd.members m
INNER JOIN cd.bookings b ON b.memid = m.memid
WHERE b.memid != 0
GROUP BY m.surname, m.firstname
ORDER BY ROUND(AVG(b.slots), 2) DESC;
-- Чыкты: 29 катар. Hunt John 2.67 ... Worthington-Smyth Henry 1.46 ✓
--
-- ROUND(маани, белги) — 4.5000000000000000 отчётко жараксыз.
--
-- БАЙКОО: 29 катар чыкты, а клубда GUEST'тен башка 30 мүчө бар.
-- Бирөө жоголду -> ал бир да брондоо жасабаган -> INNER JOIN аны алып салган.
-- "Көрүнбөгөн нерсени санай албайсың" — 3-жумадан келе жаткан эреже.
--
-- Alias'ты (m, b) ушул жерден баштап өзүм колдоно баштадым.


-- --------------------------------------------
-- 8/30  Бир да брондоосу жок мүчө
-- --------------------------------------------
SELECT m.surname, m.firstname
FROM cd.members m
LEFT JOIN cd.bookings b ON b.memid = m.memid
WHERE b.memid IS NULL;
-- Чыкты: Smith Darren. 1 катар. ✓
--
-- ТӨРТ ЖОЛУ ТЫГЫЛДЫМ (синтаксис, логика эмес):
--   1) FROM cd.bookings деп жаздым — тескериси. LEFT JOIN СОЛ таблицаны сактайт,
--      мага брондоосу жок МҮЧӨ керек -> FROM cd.members.
--      Текшерүү: ал мүчө bookings'те барбы? Жок. Демек members'те гана.
--   2) WHERE b.memid != 0 деп жаздым — бул GUEST'ти алат, мага ал керек эмес.
--      Дал келүү табылбаган катарлар керек -> IS NULL.
--   3) LEFT JOIN cd.bookings b m — эки alias катар жазылып калды.
--   4) SELECT'те керексиз ROUND(AVG(slots),2) калып калды. Тапшырма ат гана сурады.
--
-- ЭҢ КЫЗЫГЫ: бул Darren Smith — 261 брондоо жасаган Darren Smith ЭМЕС.
-- Базада ЭКИ Darren Smith бар: башка memid, бирдей ат.
-- Ат боюнча издөө коркунучтуу экенине чыныгы далил.
-- Ат боюнча топтосо: 261 + 0 = 261 -> сан кокустан туура көрүнөт,
-- бирок "бир Darren Smith бар" деген жыйынтык жалган. Мүчөлөр 30 эмес, 29 болуп калат.


-- --------------------------------------------
-- 9/30  Ар бир мүчөнүн БИРИНЧИ брондоосу
-- --------------------------------------------
-- INNER JOIN тандадым: брондоосу жок мүчө бул тизмеде керек эмес.
SELECT m.surname, m.firstname, MIN(b.starttime)
FROM cd.bookings b
INNER JOIN cd.members m ON m.memid = b.memid
WHERE m.memid != 0
GROUP BY m.surname, m.firstname
ORDER BY MIN(b.starttime);
-- Чыкты: 29 катар. Эң эртеси Smith Darren 2012-07-03 08:00. ✓
--
-- OBSERVATION WINDOW (жаңы термин):
--   Бул сан "мүчө биринчи жолу келген күн" ЭМЕС.
--   База клубдун бүт тарыхын камтыбайт — 2012-07-03тен 09-30га чейинки үч ай гана.
--   Андан мурунку брондоолор жүктөлгөн эмес.
--   Демек MIN(starttime) берген нерсе — "МААЛЫМАТТАГЫ эң эрте брондоо".
--
--   MAX менен симметриялуу: "акыркы жолу 30-сентябрда келген, андан бери жок"
--   деген жыйынтык да жалган — балким 5-октябрда келген, база ошол жерде бүткөн.
--
--   ЭРЕЖЕ: MIN/MAX маалыматтын чегине жабышып турса, ал чыныгы маани эмес,
--   ЧЕКТИН ӨЗҮ болушу мүмкүн. Адегенде маалымат кайсы аралыкты камтыйт —
--   ошону текшерем.


-- ============================================
-- КИЙИНКИ: self join (10/30дан баштап)
-- ============================================
--
-- ӨТҮЛӨ ЭЛЕК. Эки жолу башталганда токтоттум — өтө элек теманы сурап отуруу
-- мага туура келбейт.
--
-- Байланышы: cd.members.recommendedby -> cd.members.memid
--   (ким сунуштаган — ӨЗ таблицасына шилтеме)
--
-- Ошондой эле: подзапрос — 4-жуманын планында бар, али башталган жок.

-- ============================================
-- 2026-09-09 · SELF JOIN, ҮЧ ТАБЛИЦА, ПОДЗАПРОС
-- ============================================


-- --------------------------------------------
-- SELF JOIN — түшүнүгү
-- --------------------------------------------
--
-- Бир таблица ЭКИ РОЛЬ ойногондо керек.
--
-- Элестетүү (мага ушул кирди): тизмени эки жолу басып чыгардың.
--   Бир кагазда «окуучулар», экинчисинде «насаатчылар» деп жазылган —
--   мазмуну бирдей, бирок эки башка кагаз.
-- SQL үчүн да ошондой: таблица эки жолу жазылат, ЭКИ БАШКА ALIAS менен.
-- Ансыз SQL «id кайсы көчүрмөнүкү?» деп биле албайт.

DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS students;
CREATE TABLE students (id INT, name TEXT, mentor_id INT);
INSERT INTO students VALUES (1,'Айбек',3),(2,'Нурзат',1),(3,'Мээрим',NULL),(4,'Эркин',1);

-- Байланыш: students.mentor_id -> students.id   (ӨЗ таблицасына)
-- Мээримде насаатчы жок -> NULL.


-- 14/30  Ар бир окуучу жана анын насаатчысы (насаатчысы жоктор чыкпасын)
SELECT s.name AS okuuchu, m.name AS nasaatchy
FROM students s
INNER JOIN students m ON s.mentor_id = m.id;
-- 3 катар: Нурзат|Айбек · Эркин|Айбек · Айбек|Мээрим
--
-- БАЙКОО (мен өзүм таптым): Мээрим натыйжада БАР, бирок okuuchu тилкесинде эмес,
-- nasaatchy тилкесинде. Себеби анын mentor_id'си NULL — насаатчысы жок,
-- бирок ал өзү насаатчы. Эки роль — эки башка тилке, бир адам биринде болуп
-- экинчисинде болбошу мүмкүн.

-- 15/30  Бардык окуучу чыксын, насаатчысы жоктор да
SELECT s.name AS okuuchu, m.name AS nasaatchy
FROM students s
LEFT JOIN students m ON s.mentor_id = m.id;
-- 4 катар. Мээримдин nasaatchy тилкесинде NULL.
-- INNER -> LEFT: бир гана сөз, бирок «сол таблица» деген s экенин билиш керек.


-- --------------------------------------------
-- 16/30  pgexercises 4 · List all members, with their recommender
-- --------------------------------------------
-- cd.members.recommendedby -> cd.members.memid
--   m = сунушталган мүчө · r = сунуштаган мүчө
SELECT
    m.surname, m.firstname,
    r.surname, r.firstname
FROM cd.members m
LEFT JOIN cd.members r ON m.recommendedby = r.memid
ORDER BY m.surname, m.firstname;
-- 31 катар. Сунуштоочусу жоктордо NULL.
--
-- ҮЧ КАТАМ:
-- 1) SELECT'ке эки башка alias'тан бирден тилке алдым: «Joplette | Darren».
--    Бул бир адам эмес, ЭКИ адам. Тапшырма бир адамды сурап жатса,
--    эки тилке тең БИР alias'тан болушу керек.
-- 2) Тилкелердин тартиби тескери болду: r мурун, m кийин.
-- 3) DISTINCT койдум -> 31дин ордуна 30 катар чыкты.
--    ⚠️ DISTINCT БУЛ ЖЕРДЕ ЗЫЯН: эки Darren Smith'тин ат-фамилиясы бирдей,
--    сунуштоочусу да жок. DISTINCT аларды БИР катарга кысып салды —
--    эки башка адам бир болуп калды. Бир мүчө отчёттон жоголду.
--    САБАК: DISTINCT кайталанууну «оңдойт» деп ойлобо. Ал ЧЫНЫГЫ айырманы да
--    жашырат. Адегенде «эмне үчүн кайталанып жатат?» деп сура.


-- --------------------------------------------
-- ҮЧ ТАБЛИЦАЛУУ JOIN — түшүнүгү
-- --------------------------------------------
--   FROM A
--   JOIN B ON ...
--   JOIN C ON ...
-- Ар бир JOIN'дун ӨЗ ON'у бар. Экинчи JOIN A'га да, B'га да кошулушу мүмкүн —
-- ачкыч кайсынысында болсо, ошонуку.

-- 17/30  pgexercises 5 · threejoin
SELECT
    m.firstname, m.surname,
    f.name,
    b.starttime
FROM cd.bookings b
INNER JOIN cd.members    m ON m.memid = b.memid
INNER JOIN cd.facilities f ON f.facid = b.facid
WHERE b.starttime >= '2012-09-21'
  AND b.starttime <  '2012-09-22'
  AND f.name LIKE 'Tennis Court%'
ORDER BY b.starttime;
-- 12 катар.
--
-- ЭҢ МААНИЛҮҮ БАЙКОО: эки JOIN тең cd.bookings'ке кошулат — эки ачкыч тең
-- ошол жерде (memid, facid). cd.members менен cd.facilities бири-бирине
-- ТАПТАКЫР кошулбайт: алардын жалпы тилкеси жок, ON жазууга эч нерсе жок.
--   cd.bookings — FACT таблица (окуялар журналы)
--   cd.members, cd.facilities — DIMENSION таблицалар (туруктуу тизмелер)
--   Fact таблица dimension'дарды байланыштырат.
--
-- КАТАМ: адегенде эки чыпканы тең жазбай, бүт базаны чыгардым (4044 катар).
-- Анан бир аралыкта ON шарты жаңылыш тилкеге түшүп, БАШКА аттар чыкты.
-- Эки жолу аткарганда эки башка натыйжа чыкканын байкап, кайра текшердим.
-- САБАК: эки натыйжа тең «ишенимдүү» көрүнөт. Айырманы байкоо — өзүнчө көндүм.


-- ============================================
-- ПОДЗАПРОС (SUBQUERY)
-- ============================================
--
-- ЭМНЕ ҮЧҮН КЕРЕК:
--   «Орточодон жогору алгандарды чыгар» деген суроого
--   WHERE salary > AVG(salary) деп жазса КАТА берет —
--   WHERE иштеген учурда агрегат али эсептеле элек (3-жумадагы эреже).
--
--   Демек эки кадам керек:
--     1) адегенде орточону тап — бул бир сан
--     2) анан ар бир катарды ошол сан менен салыштыр
--
--   Подзапрос — дал ушул: query'нин ичиндеги query.
--   Ичкиси БИРИНЧИ иштейт, натыйжасын тышкысына берет.

DROP TABLE IF EXISTS salaries;
CREATE TABLE salaries (id INT, name TEXT, salary INT);
INSERT INTO salaries VALUES (1,'Азамат',30000),(2,'Бегим',50000),(3,'Салтанат',40000),(4,'Тилек',20000);

-- 18/30  Орточодон ТӨМӨН маяна алгандар
SELECT name, salary
FROM salaries
WHERE salary < (SELECT AVG(salary) FROM salaries);
-- Азамат 30000 · Тилек 20000
--
-- КАНТИП ИШТЕЙТ:
--   Ичкиси: SELECT AVG(salary) FROM salaries  -> 35000
--   SQL аны ошол жерге коёт:  WHERE salary < 35000
--   Анан ар бир катарды текшерет.
--
-- ТЕКШЕРҮҮ ЫКМАСЫ (эң маанилүүсү):
--   Кашаанын ичиндеги query ӨЗ АЛДЫНЧА иштей алат.
--   Күмөн болсоң аны бөлүп алып өзүнчө аткар — 35000 чыгат.
--
-- БИР МААНИ vs КӨП МААНИ:
--   Ички query кайтарат  |  кайсы белги
--   -----------------------------------
--   БИР маани            |  = > < >= <=
--   КӨП маани            |  IN, NOT IN
--
--   SELECT AVG(salary) FROM salaries  -> 1 катар  (агрегат)
--   SELECT salary FROM salaries       -> 4 катар  (ар бир катар)
--   Экинчисин > менен колдонсо ката: «more than one row returned by a
--   subquery used as an expression».

-- 19/30  Massage Room 1'ди брондогон мүчөлөр (JOIN'сиз, подзапрос менен)
SELECT
    cd.members.surname AS surname,
    cd.members.firstname AS name
FROM cd.members
WHERE memid != 0
  AND memid IN (
        SELECT memid
        FROM cd.bookings
        WHERE facid = 4
  )
ORDER BY surname;
-- 24 катар. GUEST жок, кайталанбайт.
--
-- Ички query 629 катар кайтарат — Massage Room 1'дин БАРДЫК брондоолору,
-- ичинде бир эле memid ондогон жолу кайталанат.
-- IN буга кайдыгер: «бул тизменин ичиндеби?» деген суроого бир «ооба» жетиштүү.
-- Ошондуктан тышкы натыйжада кайталануу жок — DISTINCT да керек болгон жок.


-- ============================================
-- КИЙИНКИ
-- ============================================
-- Подзапростун калган түрлөрү (NOT IN, коррелденген подзапрос)
-- 11 маселе калды (19/30)
-- UNION — жол картасында жок, кошумча


-- ============================================
-- 2026-09-09 (экинчи сессия) · NOT IN
-- ============================================

-- Механикасы: колдон жазылган тизме менен (мисал, эсепке кирбейт)
SELECT facid, name
FROM cd.facilities
WHERE facid NOT IN (SELECT facid FROM cd.facilities WHERE name LIKE '%Tennis%');
-- 6 катар: Badminton Court, Massage Room 1, Massage Room 2,
--          Squash Court, Snooker Table, Pool Table.
-- Ички query 0, 1, 3 кайтарат (Tennis Court 1, Tennis Court 2, Table Tennis).
-- Эскертүү: LIKE '%Tennis%' Table Tennis'ти КАМТЫЙТ,
-- ал эми LIKE 'Tennis%' камтыбайт — тузак ошол жерде.


-- 20-тапшырма (ЭСЕПКЕ КИРБЕЙТ — калып көрсөтүлдү)
-- Бир да брондоо жасабаган мүчөлөр, NOT IN менен.
-- 8/30 тапшырмасынын (LEFT JOIN + IS NULL) жообу менен дал келди.
SELECT
    cd.members.firstname AS firstname,
    cd.members.surname AS surname
FROM cd.members
WHERE memid NOT IN (SELECT memid FROM cd.bookings);
--
-- ЭКИ ШАРТ (эсте кармоо керек):
-- 1) Подзапрос БИР ГАНА тилке кайтарат. SELECT * ката берет.
-- 2) Эки жагы бир эле нерсени билдириши керек: memid — адам, facid — эмерек.
--
-- Жол-жолунда кетирилген каталар:
--   (SELECT * FROM cd.bookings)      -> беш тилке, NOT IN бирди күтөт
--   (SELECT * FROM cd.facilities)    -> таблица алмашып кетти, тапшырма брондоо жөнүндө
--   (SELECT memid FROM cd.bookings)  -> туура




-- ============================================
-- 2026-09-11 · NOT IN + NULL тузагы
-- ============================================

-- 20/30  Эч кимди сунуштабаган мүчөлөр
SELECT *
FROM cd.members
WHERE memid NOT IN (
    SELECT DISTINCT recommendedby
    FROM cd.members
    WHERE recommendedby IS NOT NULL
);
-- 18 катар (ичинде memid = 0, GUEST).
-- IS NOT NULL сабын өзүм коштум — тузак алдын ала айтылган эмес.


-- ⚠️ ТУЗАК: ушул эле query, IS NOT NULL сабы жок.
-- Жыйынтыгы 0 катар. Ката билдирүү ЧЫКПАЙТ — silent failure.
-- SELECT * FROM cd.members
-- WHERE memid NOT IN (SELECT recommendedby FROM cd.members);
--
-- ЭМНЕ ҮЧҮН — чынжыры:
--   memid = 5, тизме (3, 7, NULL) болсун.
--   NOT IN муну AND чынжырына ажыратат:
--
--     5 != 3     -> TRUE
--     5 != 7     -> TRUE
--     5 != NULL  -> UNKNOWN   (белгисиз сан 5 болуп калышы мүмкүн)
--     ------------------------------------------
--     TRUE AND TRUE AND UNKNOWN -> UNKNOWN
--
--   WHERE TRUE болгондорду ГАНА өткөрөт. UNKNOWN өтпөйт.
--   Бул ар бир катарда кайталанат -> 0 катар.
--
-- UNKNOWN ЖУГУШТУУ: бир гана UNKNOWN бүт AND чынжырын UNKNOWN кылат.
--
-- ЭРЕЖЕ: NOT IN ичиндеги тилкеде NULL болушу мүмкүн болсо,
--        ар дайым WHERE ... IS NOT NULL кош.
--        IN'де бул тузак ЖОК — ал жерде NULL жөн гана дал келбейт.




-- ============================================
-- 2026-09-11 · 21-26 · COUNT(DISTINCT), нормалдаштыруу
-- ============================================

-- 21/30  Эң көп адам сунуштаган мүчө
SELECT
    m.firstname,
    m.surname,
    COUNT(r.memid) AS count
FROM cd.members r
JOIN cd.members m ON m.memid = r.recommendedby
GROUP BY m.memid, m.firstname, m.surname;
-- Darren Smith — 5.
-- GROUP BY m.memid: эки Darren Smith бар, ат боюнча топтосок кошулуп калмак.
-- ЭРЕЖЕ: топтоо primary key боюнча, көрсөтмө тилке боюнча эмес.
-- firstname/surname GROUP BY'да турганы жооп үчүн эмес —
-- SELECT'те турууга уруксат алуу үчүн (functional dependency).


-- 22/30  Massage Room 1'ди эң көп брондогон 5 мүчө
SELECT
    m.firstname,
    m.surname,
    COUNT(b.memid) AS count
FROM cd.members m
INNER JOIN cd.bookings b ON m.memid = b.memid
WHERE b.facid = 4 AND m.memid != 0
GROUP BY m.memid, m.firstname, m.surname
ORDER BY count DESC
LIMIT 5;
-- Жетелөөсүз жазылды.
--
-- ⚠️ ТУЗАК: 5 жана 6-орундун counту бирдей болсо, LIMIT 5 кимди тандайт?
-- Жооп: non-deterministic — база кайсынысын биринчи жолуктурса, ошону.
-- Чечими — tie-breaker:  ORDER BY count DESC, m.memid
-- Tie-breaker УНИКАЛДУУ болушу керек. surname жарабайт: эки Darren Smith.


-- 23/30  Ар бир эмерек боюнча канча БАШКА мүчө брондогон
SELECT
    f.name,
    COUNT(DISTINCT b.memid) AS member_count
FROM cd.bookings b
INNER JOIN cd.facilities f ON b.facid = f.facid
WHERE b.memid != 0
GROUP BY f.facid
ORDER BY member_count DESC;
-- Pool Table 27 · Table Tennis 25 · Massage Room 1 24 · Badminton 24 ·
-- Squash 24 · Tennis Court 1 23 · Snooker 22 · Tennis Court 2 21 ·
-- Massage Room 2 12   <- башкалардан эки эсе аз
--
-- COUNT(b.memid)          -> катарларды санайт   (4-тапшырма)
-- COUNT(DISTINCT b.memid) -> башка маанилерди     (ушул)
-- SELECT DISTINCT'тен айырмасы: бир тилкенин ичинде иштейт, катар өчүрбөйт.


-- 24/30  Божомолду текшерүү: баа айырмасы барбы?
SELECT f.name, f.membercost, f.guestcost
FROM cd.facilities f
WHERE f.name = 'Massage Room 1' OR f.name = 'Massage Room 2';
-- Экөө тең: membercost 35, guestcost 80. БИРДЕЙ.
-- Баа божомолу ЖОККО ЧЫКТЫ (falsified hypothesis).
-- Бул жеңилүү эмес: бир түшүндүрмө четке кагылды, тизме кыскарды.
--
-- Үч божомол айтылган: VIP · жаңы · тейлөө сапаты.
-- Текшерилчүсү бирөө гана (testable hypothesis) — баа.
-- «Тейлөө сапаты» базада таптакыр жок, эч бир query аны айта албайт.
--
-- ⚠️ Бул query'де адегенде агрегатсыз GROUP BY турган. Ал ашыкча:
--    агрегат бар -> GROUP BY керек; агрегат жок -> GROUP BY да жок.


-- 25/30  Эки бөлмө: брондоо саны ЖАНА мүчө саны бир query'де
SELECT
    f.name,
    COUNT(b.bookid) AS bookid_count,
    COUNT(DISTINCT b.memid) AS memid_count
FROM cd.bookings b
INNER JOIN cd.facilities f ON b.facid = f.facid
WHERE (f.name = 'Massage Room 1' OR f.name = 'Massage Room 2')
  AND b.memid != 0
GROUP BY f.name;
-- Massage Room 1 -> 421 брондоо, 24 мүчө
-- Massage Room 2 ->  27 брондоо, 12 мүчө
-- Мүчөлөр эки эсе, брондоолор ОН БЕШ эсе айырмаланат.
--
-- ⚠️ Бул жерде AND/OR катасы кетти:
--    name = 'Massage Room 1' AND name = 'Massage Room 2'  -> 0 катар.
--    Бир катардын name'и бирөө гана. Эки башка маани керек болсо — OR.
--    Кашаа МИЛДЕТТҮҮ: AND, OR'го караганда күчтүүрөөк байланат.


-- 26/30  Нормалдаштыруу: бир мүчөгө канча брондоо туура келет
SELECT
    f.name,
    COUNT(b.bookid) AS bookid_count,
    COUNT(DISTINCT b.memid) AS memid_count,
    ROUND(COUNT(b.bookid)::numeric / COUNT(DISTINCT b.memid), 2) AS rate
FROM cd.bookings b
INNER JOIN cd.facilities f ON b.facid = f.facid
WHERE b.memid != 0
GROUP BY f.name
ORDER BY rate DESC;
--
-- Pool Table      784  27  29.04
-- Snooker Table   421  22  19.14
-- Massage Room 1  421  24  17.54
-- Table Tennis    385  25  15.40
-- Badminton Court 344  24  14.33
-- Tennis Court 1  308  23  13.39
-- Tennis Court 2  276  21  13.14
-- Squash Court    195  24   8.13
-- Massage Room 2   27  12   2.25
--
-- ⚠️⚠️ INTEGER DIVISION — бүгүнкү эң чоң сабак.
-- ::numeric жоксуз варианты 17.0 берген, а туурасы 17.54.
-- count() БҮТҮН сан кайтарат. SQLде бүтүн / бүтүн = БҮТҮН.
-- Ондугу тегеректелбейт, КЫРКЫЛАТ. ROUND'го 17.54 эмес, даяр 17 барат.
-- Ката ROUND'то эмес — андан МУРУНКУ кадамда.
-- Чечими: ::numeric же CAST(x AS numeric). Плюс ROUND(x, 2).
-- Мен муну өзүм байкадым: «калдык жок, жана туура эмес тегеректеген».
--
-- НОРМАЛДАШТЫРУУ (normalization):
--   421 vs 27      -> «кайсы эмерек көп иштейт?»      (популярдуулук)
--   17.54 vs 2.25  -> «келгендер кайра келеби?»        (кармап калуу)
--   Эки башка суроо. Түз салыштыруу жаңылыштырат, себеби топтордун
--   ӨЛЧӨМҮ башка. Жалпы негизге бөлүү = бөлчөктөрдү жалпы бөлүмгө келтирүү.
--
-- SAMPLE SIZE — бир адам дагы 20 жолу брондосо:
--   Massage Room 2:  2.25 -> 3.92   (+74%)
--   Pool Table:     29.04 -> 29.78  (+2.5%)
--   Кичине сандын үстүндөгү ченем ТУРУКСУЗ.
--   ЭРЕЖЕ: ченемдин жанында ар дайым n турушу керек.




-- ============================================
-- 2026-09-11 (кечки уландысы) · CORRELATED SUBQUERY
-- ============================================
--
-- Uncorrelated (мурункулар): ички query БИР ЖОЛУ иштейт, бир жооп берет.
-- Correlated:                ички queryде ТЫШКЫ alias турат ->
--                            тышкы querydin АР БИР катары үчүн кайра иштейт.
--                            Аналогия: турактуу сан эмес, функция f(x).
--
-- Эки alias МИЛДЕТТҮҮ: b (тышкы) жана b2 (ички).
-- Баасы: 4044 катар -> ички query 4044 жолу аткарылат.


-- Машыгуу мисалы (кагазда, эсепке кирбейт):
-- «Ар бир сатуу ӨЗ РЕГИОНУНУН орточосунан жогорубу?»
--
--   SELECT s.id, s.region, s.summa
--   FROM satuu s
--   WHERE s.summa > (SELECT AVG(s2.summa) FROM satuu s2
--                    WHERE s2.region = s.region);
--
--   WHERE s2.region = s.region САБЫ жок болсо -> бүт таблицанын орточосу,
--   бир сан, бардыгына бирдей. Ал сап бар болсо -> ар бир катар үчүн
--   өз региону боюнча кайра эсептелет.


-- 27/30  Ар бир ЭМЕРЕКТИН эң узак брондоосу (slots эң чоңу)
SELECT
    f.name,
    m.firstname,
    m.surname,
    b.slots
FROM cd.bookings b
INNER JOIN cd.members m ON m.memid = b.memid
INNER JOIN cd.facilities f ON b.facid = f.facid
WHERE b.memid != 0
  AND b.slots = (
        SELECT MAX(b2.slots)
        FROM cd.bookings b2
        WHERE b2.facid = b.facid
          AND b2.memid != 0      -- <<< БУЛ САП АДЕГЕНДЕ ЖОК ЭЛЕ
  );
-- Тогуз эмерек тең чыгат. Түзүлүш жетелөөсүз жазылды.
--
-- ЭКИ НЕГИЗГИ ТҮШҮНҮК:
--
-- 1) БАЙЛАНЫШ САБЫ GROUP BY'ДЫН ОРДУН ЭЭЛЕЙТ.
--    b2.memid = b.memid -> ар бир МҮЧӨНҮН эң узагы
--    b2.facid = b.facid -> ар бир ЭМЕРЕКТИН эң узагы
--    Query'нин калганы бирдей, суроо башка. КАТА ЧЫКПАЙТ.
--    (Адегенде memid деп жазып, аткарып көрүп өзүм өзгөрттүм.)
--
-- 2) ТЫШКЫ QUERY ТАНДАБАЙТ — ЧЫПКАЛАЙТ.
--    Ага агрегат да, GROUP BY да керек эмес. Ал ар бир катардан:
--    «менин slots'ум ошол максимумга барабарбы?» деп сурайт.
--    Ошондуктан GROUP BY бир топтон БИР САН берсе,
--    correlated subquery ТОЛУК КАТАРДЫ кайтара алат.


-- ⚠️⚠️ SILENT FAILURE: чыпка бир гана queryде
-- AND b2.memid != 0 сабы жок болсо -> тогуздун ордуна БЕШ эмерек чыгат.
--
-- Чынжыры: ички query GUEST'ти кошуп эсептейт ->
--          төрт эмеректе эң узагы GUEST'тики ->
--          тышкы query GUEST'ти алып салган ->
--          ошол санга барабар мүчө ЖОК -> эмерек ТОЛУК ЖОГОЛОТ.
--
--   Squash Court    14  GUEST
--   Tennis Court 1  12  GUEST
--   Massage Room 1   8  GUEST
--   Massage Room 2   4  GUEST
--
-- ЭРЕЖЕ: ЧЫПКА ЭКИ QUERYDE ТЕҢ БОЛУШУ КЕРЕК.
--        Бирөөндө бар, экинчисинде жок -> экөө эки башка жыйынды карайт.
--
-- Кантип табылды: тышкы чыпканы убактылуу алып салып, GUEST катарларын көрүү.


-- ТЕҢДИК: оңдолгон натыйжада Massage Room 1 боюнча ТОГУЗ катар бар, баары 4 slots.
-- Бул ката эмес. Отчётко эскертүү жазылат:
--   «эң узагы 4 slots, аны тогуз мүчө бөлүшөт».
-- Бирөөнү тандоо — сурап жаткандын чечими. Автоматтык тандоо = ROW_NUMBER (5-жума).




-- ============================================
-- 2026-09-11 (кечки уландысы 2) · DERIVED TABLE
-- ============================================
--
-- FROM'догу подзапрос УБАКТЫЛУУ ТАБЛИЦА жаратат = derived table.
--   1) AS менен ат берүү МИЛДЕТТҮҮ
--   2) тилкелеринин аттары подзапростун SELECT'индеги AS аттары
-- Эмнеге керек: АГРЕГАТТЫН ҮСТҮНӨН АГРЕГАТ. AVG(COUNT(...)) жазылбайт.


-- Машыгуу мисалы (кагазда, эсепке кирбейт):
--   «Бир регион орточосунда канча сатат?»
--   SELECT AVG(t.region_summa) AS orto
--   FROM (SELECT region, SUM(summa) AS region_summa
--         FROM satuu GROUP BY region) AS t;
--   Ош 400, Бишкек 900 -> (400+900)/2 = 650
--   Салыштыр: AVG(summa) = 260. Эки БАШКА суроо:
--     «бир сатуу канча?» жана «бир регион канча?»


-- 28/30  Бир мүчөгө орточо канча брондоо туура келет
-- Жообу: 109.00
-- Кол менен текшерүү: 3161 брондоо / 29 мүчө = 109.
--   3161 = 26-тапшырманын таблицасынын суммасы
--   29   = 31 мүчө - GUEST - эч качан брондобогон бирөө


-- 29/30  Эмеректер боюнча мүчө санынын эң чоңу жана эң кичинеси
SELECT
    MAX(t.unique_members) AS max,
    MIN(t.unique_members) AS min
FROM (
    SELECT
        facid,
        COUNT(DISTINCT memid) AS unique_members
    FROM cd.bookings
    WHERE memid != 0
    GROUP BY facid
) AS t;
-- 27 жана 12. 23-тапшырманын таблицасы менен дал келди.
-- Түзүлүш айтылбай, жардамсыз жазылды (атайын текшерүү тапшырмасы).
--
-- ⚠️ Биринчи вариантта WHERE memid != 0 сабы ЖОК эле —
--    кечээки «чыпка эки queryде тең» сабагы кайра кайталанды.


-- 30/30  Орточо ченемден төмөн эмеректер — ЖАЗА АЛБАДЫМ, жообу берилди
SELECT t.name, t.rate
FROM (
    SELECT
        f.name,
        ROUND(COUNT(b.bookid)::numeric / COUNT(DISTINCT b.memid), 2) AS rate
    FROM cd.bookings b
    INNER JOIN cd.facilities f ON b.facid = f.facid
    WHERE b.memid != 0
    GROUP BY f.name
) AS t
WHERE t.rate < (
    SELECT AVG(t2.rate)
    FROM (
        SELECT ROUND(COUNT(b.bookid)::numeric / COUNT(DISTINCT b.memid), 2) AS rate
        FROM cd.bookings b
        WHERE b.memid != 0
        GROUP BY b.facid
    ) AS t2
)
ORDER BY t.rate;
-- Орточо ченем ~14.71. Андан төмөн БЕШӨӨ:
--   Badminton Court · Tennis Court 1 · Tennis Court 2 · Squash Court · Massage Room 2
--
-- ҮЧ КАТМАР (ичинен тышка):
--   1) t   — ар бир эмеректин ченеми, тогуз катар
--   2) t2  — ошол эле эсептөө, үстүнөн AVG -> БИР САН (14.71)
--   3) тышкы query — t'нын катарларын ошол сан менен салыштырат
--
-- ЭМНЕ ҮЧҮН ЭСЕПТӨӨ ЭКИ ЖОЛУ ЖАЗЫЛДЫ:
--   «AS t» деген ат ТЫШКЫ QUERYDE ГАНА жашайт.
--   WHERE'дин ичиндеги подзапрос көз каранды эмес query — ал t'ны КӨРБӨЙТ.
--   Ошондуктан эсептөө t2 деген ат менен кайра жазылды.
--
--   Бул коркунучтуу: бир жагын оңдоп экинчисин унутсаң, ката ЧЫКПАЙТ,
--   жалган жооп чыгат.
--   ОШОЛ ЫҢГАЙСЫЗДЫК CTE'ДИ ЖАРАТТЫ (WITH) — 5-жуманын биринчи темасы.
--
-- WHERE'де AVG жазууга болбойт (WHERE rate < AVG(rate) -> ката).
-- Агрегатты WHERE'ге киргизүүнүн жалгыз жолу — подзапрос. 18-тапшырманын чоңойтулганы.


-- ============================================
-- 4-ЖУМАНЫН АКЫРКЫСЫ (29/30)
-- ============================================
-- 30-тапшырма: орточодон КӨП брондогон мүчөлөр.
--   Аты, фамилиясы, брондоо саны. Эң көптөн баштап ирет. GUEST кирбесин.
--   Орточо санды query өзү эсептеши керек — 109ду колго жазба.
--
-- 5-ЖУМА: CTE (WITH) жана терезе функциялары
--   ROW_NUMBER, RANK, LAG, SUM() OVER. Максат 25 маселе.
--
-- ФАЗА 1ДИ ЖАБУУ ҮЧҮН ҮЧ ШАРТ:
--   1) 100 маселе — 4-жума бүткөндө аткарылат (30+40+30)
--   2) терезе функциясын жардамсыз жазуу — 5-жумада
--   3) БАШКАНЫН туура эмес query'син таап оңдоо — сынак али коюла элек
--
-- Ачык калган аналитикалык суроо:
--   Massage Room 2 эмне үчүн дээрлик колдонулбайт? (rate 2.25)
--   Баа божомолу жокко чыкты — баалар бирдей (35 / 80).
