# Data Engineer & Data Analyst Guide

DTF gives data roles agents that understand dbt, SQL, notebooks, and your data platform — with skills for pipeline building, analysis workflows, and performance optimization.

## What You Get

| | Data Engineer | Data Analyst |
|--|--------------|-------------|
| **Agents** | data-engineer, pipeline-builder, insights-reporter, architect | data-analyst, insights-reporter |
| **Skills** | data-conventions, data-analysis-workflows | data-analysis-workflows |

### Default Workflow Steps

**Data Engineer:**
```
before-push: ⚡ dbt build, ⚡ dbt test, 📋 SQL review
```

**Data Analyst:**
```
before-commit: 📋 Notebook outputs cleared
before-push:   📋 SQL queries documented
before-pr:     📋 Findings summarized
```

---

## Agents

**data-engineer** — EF Core migrations, dbt models, SQL optimization, data pipelines
**pipeline-builder** — dbt model DAGs (staging → intermediate → marts), incremental processing, data quality tests
**data-analyst** — SQL queries, Jupyter notebooks, visualization, business intelligence
**insights-reporter** — Transforms analysis into executive summaries, dashboard specs, data narratives

---

## Analysis Workflow

1. Define the question
2. Identify data sources (dbt models, raw tables)
3. Write and validate SQL
4. Visualize (bar charts for comparisons, line charts for trends)
5. Document findings with caveats

---

## Recommended Plugins

| Plugin | What it does |
|--------|-------------|
| **data-engineering-skills** (65 stars) | 7 dbt skills + 3 Snowflake: model creation, debugging, incremental models |
| **anthropic-xlsx** (official) | Excel formulas, analysis, charts via plain English |
