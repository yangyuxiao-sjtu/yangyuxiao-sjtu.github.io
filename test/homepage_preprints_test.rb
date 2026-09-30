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
      ["https://arxiv.org/abs/2609.35505", "An RL View of OPD: Least Square Policy Distillation for Sample-Efficient LLM Reasoning"]
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
      "Shangzhe Li, Yuxiao Yang, Tianrun Yu, Kaixiang Zhao, Xiaoyun Wang, Taylor W. Killian, Weitong Zhang"
    ]

    preprint_items.zip(expected_authors).each do |item, authors|
      assert_includes item.text.gsub(/\s+/, " "), authors
      assert_includes item.css("strong").map(&:text), "Yuxiao Yang"
    end

    assert @document.at_css("a[href='/#-preprints']"), "Expected a Preprints navigation link"
  end

  def test_renders_hugging_face_link_as_an_accessible_icon
    link = @document.at_css("a[href='https://huggingface.co/papers/2609.20511']")

    refute_nil link
    assert_nil link["aria-label"]
    assert_equal "Hugging Face", link["title"]
    assert_equal "", link.text.strip
    icon = link.at_css("img")
    assert_equal "Hugging Face paper", icon["alt"]
    assert_equal "https://huggingface.co/front/assets/huggingface_logo-noborder.svg", icon["src"]
    assert_equal "2609.20511", link.at_css("[data-hf-paper-id]")["data-hf-paper-id"]
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
