const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const vm = require("node:vm");

const scriptPath = path.join(__dirname, "..", "assets", "js", "huggingface-paper-stats.js");

function loadStatsScript({ element, fetch }) {
  assert.ok(fs.existsSync(scriptPath), "Hugging Face stats script should exist");
  const listeners = {};
  const document = {
    addEventListener(event, callback) {
      listeners[event] = callback;
    },
    querySelectorAll(selector) {
      assert.equal(selector, "[data-hf-paper-id]");
      return [element];
    }
  };

  vm.runInNewContext(fs.readFileSync(scriptPath, "utf8"), {
    document,
    fetch,
    Number,
    encodeURIComponent
  });

  listeners.DOMContentLoaded();
}

test("shows the latest Hugging Face upvote count beside the icon", async () => {
  const element = {
    dataset: { hfPaperId: "2609.20511" },
    textContent: ""
  };

  loadStatsScript({
    element,
    fetch: async (url) => {
      assert.equal(url, "https://huggingface.co/api/papers/2609.20511");
      return {
        ok: true,
        json: async () => ({ upvotes: 109 })
      };
    }
  });

  await new Promise(setImmediate);
  assert.equal(element.textContent, "109 upvotes");
});

test("keeps the upvote text empty when the API fails", async () => {
  const element = {
    dataset: { hfPaperId: "2609.20511" },
    textContent: ""
  };

  loadStatsScript({
    element,
    fetch: async () => {
      throw new Error("network unavailable");
    }
  });

  await new Promise(setImmediate);
  assert.equal(element.textContent, "");
});
