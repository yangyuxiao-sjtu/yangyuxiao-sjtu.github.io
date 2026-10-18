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

<div class="about-intro">
<div class="about-intro__text" markdown="1">

Hi, I'm **Yuxiao Yang (杨宇骁)**.

I am a first-year Ph.D. student in Computer Science at the University of North Carolina at Chapel Hill, where I am fortunate to be advised by [Prof. Weitong Zhang](https://zeroweight.github.io/).

My research focuses on reinforcement learning and post-training for large language models, particularly policy optimization, self-improvement, and knowledge distillation for reasoning.

Before joining UNC, I earned my bachelor's degree in Computer Science from the John Hopcroft Class at Shanghai Jiao Tong University.

</div>
<figure class="about-intro__portrait">
  <img src="{{ '/images/self-pic.jpg' | relative_url }}" alt="Yuxiao Yang in New York City" width="1000" height="750" decoding="async">
</figure>
</div>

# 📋 CV
[View CV (PDF)]({{ '/files/CV.pdf' | relative_url }})

<span class='anchor' id='-publications'></span>

# 📝 Publications
- **Return-to-Go Is More Than a Number: Q-Guided Alignment for Return-Conditioned Supervised Learning** (**ICML 2026**)  
  **Yuxiao Yang**, Weitong Zhang  
  [Paper](https://arxiv.org/abs/2605.29028) · [Code](https://github.com/yangyuxiao-sjtu/Q-Align-DT)
- **Provable and Practical In-Context Policy Optimization for Self-Improvement** (**ICLR 2026**)  
  Tianrun Yu*, **Yuxiao Yang\***, Zhaoyang Wang, Kaixiang Zhao, Porter Jenkins, Xuchao Zhang, Chetan Bansal, Huaxiu Yao, Weitong Zhang  
  [Paper](https://arxiv.org/pdf/2603.01335) · [Code](https://github.com/UNCSciML/ICPO)

\* indicates equal contribution.

<span class='anchor' id='-preprints'></span>

# 📄 Preprints
- **OGLS-SD: On-Policy Self-Distillation with Outcome-Guided Logit Steering for LLM Reasoning**<br>
  **Yuxiao Yang**, Xiaoyun Wang, Weitong Zhang<br>
  [Paper](https://arxiv.org/abs/2605.12400)
- **When EOS Tokens Disagree: Understanding Length Inflation in On-Policy Distillation** <a class="paper-of-day-badge" href="https://huggingface.co/papers/2609.20511" title="Hugging Face Paper of the Day, #2 on Sep 18, 2026"><span aria-hidden="true">🤗</span> <span>#2 Paper of the Day</span><span data-hf-paper-id="2609.20511"></span></a><br>
  **Yuxiao Yang**, Tianrun Yu, Shangzhe Li, Kaixiang Zhao, Xuchao Zhang, Chetan Bansal, Huaxiu Yao, Taylor W. Killian, Weitong Zhang<br>
  [Paper](https://arxiv.org/abs/2609.20511)
- **REVO: Rollout-Efficient Off-Policy Distillation via Variance-Guided Reuse**<br>
  **Yuxiao Yang**, Shangzhe Li, Tianrun Yu, Kaixiang Zhao, Taylor W. Killian, Weitong Zhang<br>
  [Paper](https://arxiv.org/abs/2609.37500)
- **Rethinking Training-Inference Mismatch in LLM Reinforcement Learning: Where It Arises and How to Correct It**<br>
  Tianrun Yu, Kaixiang Zhao, Shangzhe Li, **Yuxiao Yang**, Porter Jenkins, Weitong Zhang, Taylor W. Killian<br>
  [Paper](https://arxiv.org/abs/2609.32444)
- **An RL View of OPD: Least Square Policy Distillation for Sample-Efficient LLM Reasoning**<br>
  Shangzhe Li, **Yuxiao Yang**, Tianrun Yu, Kaixiang Zhao, Xiaoyun Wang, Taylor W. Killian, Weitong Zhang<br>
  [Paper](https://arxiv.org/abs/2609.35505)
- **Recovering Reliable Supervision via Critique-Guided On-Policy Distillation**<br>
  Kaixiang Zhao, Tianrun Yu, Shangzhe Li, **Yuxiao Yang**, Amanda Hughes, Weitong Zhang, Taylor W. Killian<br>
  [Paper](https://arxiv.org/abs/2610.20572)

# 🤝 Academic Service
- **Conference Reviewer:** AAAI 2027, ICLR 2027
- **Journal Reviewer:** Transactions on Machine Learning Research (TMLR)

# 🎓 Teaching
- **Teaching Assistant:** DATA 521: Foundations of AI, UNC-Chapel Hill (Fall 2026)
