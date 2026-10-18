require "fileutils"
require "jekyll"
require "minitest/autorun"
require "nokogiri"
require "tmpdir"

class HomepagePreprintsTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def setup
    @destination = Dir.mktmpdir("homepage-preprints-")
    config = Jekyll.configuration(
      "source" => ROOT,
      "destination" => @destination,
      "quiet" => true,
      "safe" => true
    )
    Jekyll::Site.new(config).process
    @document = Nokogiri::HTML(File.read(File.join(@destination, "index.html")))
  end

  def teardown
    FileUtils.remove_entry(@destination)
  end

  def test_renders_preprints_as_a_separate_section_below_publications
    headings = @document.css("h1").map { |heading| heading.text.strip }
    publication_index = headings.index("📝 Publications")
    preprint_index = headings.index("📄 Preprints")

    refute_nil publication_index
    refute_nil preprint_index
    assert_operator publication_index, :<, preprint_index

    expected_papers = [
      ["https://arxiv.org/abs/2605.12400", "OGLS-SD: On-Policy Self-Distillation with Outcome-Guided Logit Steering for LLM Reasoning"],
      ["https://arxiv.org/abs/2609.20511", "When EOS Tokens Disagree: Understanding Length Inflation in On-Policy Distillation"],
      ["https://arxiv.org/abs/2609.37500", "REVO: Rollout-Efficient Off-Policy Distillation via Variance-Guided Reuse"],
      ["https://arxiv.org/abs/2609.32444", "Rethinking Training-Inference Mismatch in LLM Reinforcement Learning: Where It Arises and How to Correct It"],
      ["https://arxiv.org/abs/2609.35505", "An RL View of OPD: Least Square Policy Distillation for Sample-Efficient LLM Reasoning"],
      ["https://arxiv.org/abs/2610.20572", "Recovering Reliable Supervision via Critique-Guided On-Policy Distillation"]
    ]

    expected_papers.each do |url, title|
      link = @document.at_css("a[href='#{url}']")
      refute_nil link, "Expected a Paper link for #{title}"
      assert_includes @document.text, title
    end

    preprint_items = @document.xpath("//h1[@id='-preprints']/following-sibling::ul[1]/li")
    assert_equal expected_papers.map(&:first), preprint_items.map { |item| item.at_css("a[href*='arxiv.org/abs/']")["href"] }

    expected_authors = [
      "Yuxiao Yang, Xiaoyun Wang, Weitong Zhang",
      "Yuxiao Yang, Tianrun Yu, Shangzhe Li, Kaixiang Zhao, Xuchao Zhang, Chetan Bansal, Huaxiu Yao, Taylor W. Killian, Weitong Zhang",
      "Yuxiao Yang, Shangzhe Li, Tianrun Yu, Kaixiang Zhao, Taylor W. Killian, Weitong Zhang",
      "Tianrun Yu, Kaixiang Zhao, Shangzhe Li, Yuxiao Yang, Porter Jenkins, Weitong Zhang, Taylor W. Killian",
      "Shangzhe Li, Yuxiao Yang, Tianrun Yu, Kaixiang Zhao, Xiaoyun Wang, Taylor W. Killian, Weitong Zhang",
      "Kaixiang Zhao, Tianrun Yu, Shangzhe Li, Yuxiao Yang, Amanda Hughes, Weitong Zhang, Taylor W. Killian"
    ]

    preprint_items.zip(expected_authors).each do |item, authors|
      assert_includes item.text.gsub(/\s+/, " "), authors
      assert_includes item.css("strong").map(&:text), "Yuxiao Yang"
    end

    assert @document.at_css("a[href='/#-preprints']"), "Expected a Preprints navigation link"
  end

  def test_versions_the_hugging_face_stats_script_to_avoid_stale_counts
    script = @document.css("script[src]").find do |element|
      element["src"].include?("assets/js/huggingface-paper-stats.js")
    end

    refute_nil script
    assert_match %r{\A/?assets/js/huggingface-paper-stats\.js\?v=\d+\z}, script["src"]
  end

  def test_uses_the_ranking_badge_as_the_only_hugging_face_paper_link
    eos_item = @document.xpath("//h1[@id='-preprints']/following-sibling::ul[1]/li").find do |item|
      item.text.include?("When EOS Tokens Disagree")
    end

    refute_nil eos_item
    links = eos_item.css("a[href='https://huggingface.co/papers/2609.20511']")
    assert_equal 1, links.size

    badge = links.first
    assert_includes badge["class"].to_s.split, "paper-of-day-badge"
    assert_nil badge.at_css("img")
    assert_equal "2609.20511", badge.at_css("[data-hf-paper-id]")["data-hf-paper-id"]
    assert_nil eos_item.at_css("a[href='https://huggingface.co/papers/date/2026-09-18']")
  end

  def test_shows_the_eos_hugging_face_ranking_as_a_title_badge
    eos_item = @document.xpath("//h1[@id='-preprints']/following-sibling::ul[1]/li").find do |item|
      item.text.include?("When EOS Tokens Disagree")
    end

    refute_nil eos_item
    ranking_link = eos_item.at_css("a[href='https://huggingface.co/papers/2609.20511']")
    refute_nil ranking_link
    assert_includes ranking_link["class"].to_s.split, "paper-of-day-badge"
    assert_equal "🤗 #2 Paper of the Day", ranking_link.text.strip
    assert_equal "Hugging Face Paper of the Day, #2 on Sep 18, 2026", ranking_link["title"]
    assert_equal "strong", ranking_link.previous_element.name
    assert_equal "br", ranking_link.next_element.name
  end

  def test_cv_section_opens_published_pdf
    headings = @document.css("h1")
    cv_heading = headings.find { |heading| heading.text.strip == "📋 CV" }
    publication_heading = headings.find { |heading| heading.text.strip == "📝 Publications" }

    refute_nil cv_heading
    assert_operator headings.index(cv_heading), :<, headings.index(publication_heading)
    assert cv_heading.xpath("following-sibling::p[1]/a[@href='/files/CV.pdf']").any?

    pdf = File.join(@destination, "files", "CV.pdf")
    assert File.file?(pdf), "Expected the CV PDF to be published"
    assert_equal "%PDF-", File.binread(pdf, 5)
  end

  def test_renders_environmental_portrait_beside_the_homepage_introduction
    intro = @document.at_css(".about-intro")

    refute_nil intro
    assert intro.at_css(".about-intro__text")

    portrait = intro.at_css(".about-intro__portrait img")
    refute_nil portrait
    assert_equal "/images/self-pic.jpg", portrait["src"]
    assert_equal "Yuxiao Yang in New York City", portrait["alt"]
    assert_equal "1000", portrait["width"]
    assert_equal "750", portrait["height"]
    assert File.file?(File.join(@destination, "images", "self-pic.jpg"))
  end

  def test_keeps_the_illustrated_avatar_in_the_author_profile
    avatar = @document.at_css(".profile_box .author__avatar img")

    refute_nil avatar
    assert_equal "images/pic.jpg", avatar["src"]
    assert_equal "Yuxiao Yang", avatar["alt"]
  end

  def test_cv_navigation_opens_pdf_directly
    link = @document.at_css("#site-nav a[href='/files/CV.pdf']")

    refute_nil link
    assert_equal "CV", link.text.strip
  end

  def test_renders_academic_service_and_teaching_below_preprints
    headings = @document.css("h1").map { |heading| heading.text.strip }
    preprint_index = headings.index("📄 Preprints")
    service_index = headings.index("🤝 Academic Service")
    teaching_index = headings.index("🎓 Teaching")
    page_text = @document.text.gsub(/\s+/, " ")

    refute_nil service_index
    refute_nil teaching_index
    assert_operator preprint_index, :<, service_index
    assert_operator service_index, :<, teaching_index
    assert_includes page_text, "Conference Reviewer: AAAI 2027"
    assert_includes page_text, "Journal Reviewer: Transactions on Machine Learning Research (TMLR)"
    assert_includes page_text, "Teaching Assistant: DATA 521: Foundations of AI, UNC-Chapel Hill (Fall 2026)"
  end

  def test_does_not_publish_test_sources
    refute Dir.exist?(File.join(@destination, "test"))
  end
end
