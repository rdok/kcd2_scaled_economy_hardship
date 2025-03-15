const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

function bbcodenm() {
  const rootDir = path.join(__dirname, "../..");
  const readmeFile = path.join(rootDir, "readme.md");
  const readmeFileBbcodenm = path.join(
    rootDir,
    "documentation",
    "readme.bbcodenm",
  );
  execSync(`markdown_to_bbcodenm -i ${readmeFile} > ${readmeFileBbcodenm}`);

  const faqFile = path.join(rootDir, "documentation", "faq.md");
  const faqFileBbcodenm = path.join(rootDir, "documentation", "faq.bbcodenm");
  execSync(`markdown_to_bbcodenm -i ${faqFile} > ${faqFileBbcodenm}`);

  const ideasFile = path.join(rootDir, "documentation", "ideas.md");
  const ideasFileBbcodenm = path.join(
    rootDir,
    "documentation",
    "ideas.bbcodenm",
  );
  execSync(`markdown_to_bbcodenm -i ${ideasFile} > ${ideasFileBbcodenm}`);
}

module.exports = bbcodenm;
