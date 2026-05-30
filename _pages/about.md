---
permalink: /
title: ""
excerpt: ""
author_profile: true
redirect_from: 
  - /about/
  - /about.html
---

{% if site.google_scholar_stats_use_cdn %}
{% assign gsDataBaseUrl = "https://cdn.jsdelivr.net/gh/" | append: site.repository | append: "@" %}
{% else %}
{% assign gsDataBaseUrl = "https://raw.githubusercontent.com/" | append: site.repository | append: "/" %}
{% endif %}
{% assign url = gsDataBaseUrl | append: "google-scholar-stats/gs_data_shieldsio.json" %}

<span class='anchor' id='about-me'></span>

Hi, I'm **Yuxiao Yang (杨宇骁)**.


I am a first-year Ph.D. student in Computer Science at the University of North Carolina at Chapel Hill, where I am fortunate to be advised by [Prof. Weitong Zhang](https://zeroweight.github.io/).

I am broadly interested in reinforcement learning and large language models.

Before joining UNC, I earned my bachelor's degree in Computer Science from the John Hopcroft Class at Shanghai Jiao Tong University.

<span class='anchor' id='-publications'></span>

# 📝 Publications
- **Return-to-Go Is More Than a Number: Q-Guided Alignment for Return-Conditioned Supervised Learning** (**ICML 2026**)  
  **Yuxiao Yang**, Weitong Zhang  
  [Paper](https://arxiv.org/abs/2605.29028) · [Code](https://github.com/yangyuxiao-sjtu/Q-Align-DT)
- **Provable and Practical In-Context Policy Optimization for Self-Improvement** (**ICLR 2026**)  
  Tianrun Yu*, **Yuxiao Yang\***, Zhaoyang Wang, Kaixiang Zhao, Porter Jenkins, Xuchao Zhang, Chetan Bansal, Huaxiu Yao, Weitong Zhang  
  [Paper](https://arxiv.org/pdf/2603.01335) · [Code](https://github.com/UNCSciML/ICPO)

\* indicates equal contribution.
