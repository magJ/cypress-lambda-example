import * as cypress from "cypress";
import * as fse from "fs-extra";

const init = () => {
  console.log("Copying project to writeable location");
  // Cypress requires that project directory is writeable
  fse.copySync("/var/task/", "/tmp/cypress/", {
    filter: (src, dest) => !src.includes("node_modules")
  });
  fse.symlinkSync("/var/task/node_modules", "/tmp/cypress/node_modules", 'dir')
};

init();

export const handler = async () => {
  console.log("Running cypress tests");
  await cypress.run({
    headless: true,
    browser: "chromium",
    project: `/tmp/cypress`,
  });
};
