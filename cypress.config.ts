import { defineConfig } from "cypress";
import Browser = Cypress.Browser;
import BrowserLaunchOptions = Cypress.BrowserLaunchOptions;

module.exports = defineConfig({
  video: false,
  e2e: {
    setupNodeEvents(on, config) {
      on(
        "before:browser:launch",
        (browser: Browser, browserLaunchOptions: BrowserLaunchOptions) => {
          if (browser.name === "chromium") {
            browserLaunchOptions.args.push(
              "--no-zygote",
              "--single-process",
              "--disable-gpu",
              "--single-process",
              "--disable-setuid-sandbox",
              "--disable-extensions",
            );
          }
          return browserLaunchOptions;
        }
      );
    },
    specPattern: "./tests/**/*.cy.{js,ts}",
    supportFile: false
  },
});
