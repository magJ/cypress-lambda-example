
describe("example.com", () => {
  it("should find some text", () => {
    cy.visit("https://www.example.com")
    cy.contains("This domain is for use in illustrative examples in documents")
  });
});
