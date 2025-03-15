const markdown = require("./markdown");
const steamWorkshop = require("./steamWorkshop");
const bbcodenm = require("./bbcodenm");
const path = require("path");

const documentationPath = path.join(__dirname, "../../documentation");
const aboutPath = path.join(documentationPath, "about.md");
const contentPath = path.join(documentationPath, "content.md");
const steamNotes = path.join(documentationPath, "steam_notes.md");
const changeLogs = path.join(path.join(__dirname, "../.."), "changelog.md");

markdown([aboutPath, contentPath]);
steamWorkshop([aboutPath, steamNotes, contentPath, changeLogs]);
bbcodenm();