import * as cypress from "cypress";

export const handler = async () => {
  console.log("Running cypress tests with chromium");
  await cypress.run({
    headless: true,
    browser: "chromium",
  });
};
