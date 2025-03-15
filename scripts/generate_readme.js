const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const filePaths = [path.join(__dirname, "..", "documentation", "about.md")];

let generatedWarningMessage =
  "[//]: # (DO NOT EDIT: This file has been autogenerated, any changes will be overwritten)\r\n";
let combinedContent = generatedWarningMessage;
const combineSeparator = "\r\n\r\n***\r\n\r\n";

filePaths.forEach((filePath) => {
  const fileContent = fs.readFileSync(filePath, "utf8");
  combinedContent += fileContent + combineSeparator + generatedWarningMessage;
});

const readmeFile = path.join(__dirname, "..", "readme.md");
fs.writeFileSync(readmeFile, combinedContent, "utf8");

const readmeFileBbcodenm = path.join(
  __dirname,
  "..",
  "documentation",
  "readme.bbcodenm",
);
execSync(`markdown_to_bbcodenm -i ${readmeFile} > ${readmeFileBbcodenm}`);

const faqFile = path.join(__dirname, "..", "documentation", "faq.md");
const faqFileBbcodenm = path.join(__dirname, "..", "documentation", "faq.bbcodenm");
execSync(`markdown_to_bbcodenm -i ${faqFile} > ${faqFileBbcodenm}`);

const ideasFile = path.join(__dirname, "..", "documentation", "ideas.md");
const ideasFileBbcodenm = path.join(__dirname, "..", "documentation", "ideas.bbcodenm");
execSync(`markdown_to_bbcodenm -i ${ideasFile} > ${ideasFileBbcodenm}`);
