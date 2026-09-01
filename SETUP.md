# 1-жума: куралдарды коюу (Windows)

Бул жумада эч нерсе үйрөнбөйсүң — куралды коёсуң. Көбү ушул жерде эки жума жоготот.
Максат: бир отурганда бүтүрүү, ~4-6 саат.

---

## 1. Git жана GitHub

**Git for Windows:** https://git-scm.com/download/win — жүктөп, баарын демейки бойдон "Next" басып орнот.

Орнотулганын текшер (PowerShell ач):

```powershell
git --version
```

**GitHub аккаунт:** https://github.com/signup

Атыңды жана почтаңды Git'ке айт (бир жолу гана кылынат):

```powershell
git config --global user.name "Сенин атың"
git config --global user.email "почтаң@example.com"
```

## 2. Python

https://www.python.org/downloads/ — 3.12 же 3.13.

> **Эң маанилүү кадам:** орнотуу терезесинде эң ылдыйдагы
> **"Add python.exe to PATH"** кутучасын **сөзсүз** белгиле.
> Аны унутуп калуу — эң көп кездешкен ката.

Текшер:

```powershell
python --version
pip --version
```

Керектүү китепканалар:

```powershell
pip install pandas numpy matplotlib seaborn jupyter openpyxl
```

## 3. VS Code

https://code.visualstudio.com/

Орноткондон кийин кеңейтмелерди кош (сол жактагы төрт чарчы белги → издөө):

- **Python** (Microsoft)
- **Jupyter** (Microsoft)
- **SQLTools** (Matheus Teixeira)

## 4. Маалымат базасы

Башталгыч үчүн эң жеңили — **SQLite**: эч нерсе орнотуунун кереги жок, Python менен кошо келет.
PostgreSQL кийинчерээк, 4-жумада керек болот.

**DBeaver Community** (базага кароо үчүн): https://dbeaver.io/download/

## 5. Git'тин төрт командасы

Азырынча ушул төртөө гана керек. Калганын үйрөнбө.

```powershell
git add .                        # өзгөрүүлөрдү даярдоо
git commit -m "week 1: setup"    # сактоо, түшүндүрмө менен
git push                         # GitHub'ка жөнөтүү
git status                       # эмне өзгөрдү — карап туруу
```

Долбоорду биринчи жолу GitHub'ка байлоо:

```powershell
cd $HOME\Desktop\data-analytics
git init
git branch -M main
git remote add origin https://github.com/СЕНИН-АТЫҢ/data-analytics.git
git add .
git commit -m "week 1: project setup"
git push -u origin main
```

> `git push` биринчи жолу браузерде GitHub'га кирүүнү сурайт — бул нормалдуу.

## 6. Текшерүү тизмеси

- [ ] `git --version` иштейт
- [ ] `python --version` иштейт (3.12+)
- [ ] `pip list` ичинде pandas бар
- [ ] VS Code ачылат, Python кеңейтмеси орнотулган
- [ ] Jupyter ноутбугу ачылып, `import pandas as pd` катасыз иштейт
- [ ] DBeaver орнотулган
- [ ] GitHub'да ачык `data-analytics` репозиторийи бар
- [ ] Биринчи `git push` ийгиликтүү өттү

Баары белгиленсе — 1-жума бүттү. `PROGRESS.md` файлын толтуруп, 2-жумага өт.
