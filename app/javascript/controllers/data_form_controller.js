// app/javascript/controllers/data_form_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Get the range and number input fields
    const rangeField = this.element.querySelector("input[type='range']");
    const numberField = this.element.querySelector("input[type='number']");
    const exportBtn = this.element.querySelector("#export-csv-btn");
    const form = this.element.querySelector("form");

    // Add event listeners to update each other's values
    rangeField.addEventListener("input", () => {
      numberField.value = rangeField.value;
    });

    numberField.addEventListener("input", () => {
      if (numberField.value > 1000) {
        numberField.value = 1000;
      }
      if (numberField.value == "") {
        rangeField.value = 0;
      } else {
        rangeField.value = numberField.value;
      }
    });

    form.addEventListener("input", (event) => {
      this.refreshData(event);
    });

    form.addEventListener("submit", (event) => {
      this.randomData(event);
    });
    window.addEventListener("scroll", () => {
      const { scrollTop, clientHeight, scrollHeight } = document.documentElement;
      if (scrollTop + clientHeight >= scrollHeight - 10) {
          this.loadMoreData();
      }
  });
  
  }

  async loadMoreData() {
    const currentRowCount = document.querySelectorAll("tbody tr").length;
    // await this.refreshData(event);
    const newRowCount = document.querySelectorAll("tbody tr").length;
    if (newRowCount === currentRowCount) {
      // No new data loaded, indicating end of data
      const { region, seed, rangeMax, numberMax } = this.getFormData();

      const maxErrorCount = Math.max(rangeMax, numberMax);

      const response = await fetch("/load-more-data", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document
            .querySelector("meta[name='csrf-token']")
            .getAttribute("content"),
        },
        body: JSON.stringify({
          region: region,
          error_count: maxErrorCount,
          seed: seed,
          last_row_count: currentRowCount,
        }),
      });

      const data = await response.json();

      // Update the table with the new data
      data.forEach((item) => {
        this.createAndAppendRow(item);
      });
    }
  }

  async randomData(event) {
    event.preventDefault();
    const seed = this.element.querySelector("#seed");

    const response = await fetch("/generate-random-seed", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document
          .querySelector("meta[name='csrf-token']")
          .getAttribute("content"),
      },
    });

    const data = await response.json();
    seed.value = data; // Update the value of the seed input field
    this.refreshData(event);
  }

  async refreshData(event) {
    event.preventDefault();

    const { region, seed, rangeMax, numberMax } = this.getFormData();

    const maxErrorCount = Math.max(rangeMax, numberMax);

    const response = await fetch("/generate-data", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document
          .querySelector("meta[name='csrf-token']")
          .getAttribute("content"),
      },
      body: JSON.stringify({
        region: region,
        error_count: maxErrorCount,
        seed: seed,
      }),
    });

    const data = await response.json();

    // Clear the existing table data
    const tableBody = document.querySelector("tbody");
    tableBody.innerHTML = "";

    // Update the table with the new data
    data.forEach((item) => {
      this.createAndAppendRow(item);
    });
  }

  getFormData() {
    const region = document.querySelector("#region").value;
    const seed = document.querySelector("#seed").value;
    const rangeMax = document.querySelector("#error_count_input").value;
    const numberMax = document.querySelector(
      "#error_count_input_display"
    ).value;

    return { region, seed, rangeMax, numberMax };
  }

  createAndAppendRow(item) {
    const tableBody = document.querySelector("tbody"); // Assuming you have a <tbody> element

    const row = document.createElement("tr");
    row.id = `generated_data_${item.identifier}`;

    const indexCell = this.createTableCell("border px-4 py-2", item.index);
    const identifierCell = this.createTableCell(
      "border px-4 py-2",
      item.identifier
    );
    const nameCell = this.createTableCell(
      "border px-4 py-2",
      this.truncateText(item.name, 30)
    );
    const addressCell = this.createTableCell(
      "border px-4 py-2",
      this.truncateText(item.address, 30)
    );
    const phoneCell = this.createTableCell(
      "border px-4 py-2",
      this.truncateText(item.phone, 30)
    );

    // Append cells to the row
    row.appendChild(indexCell);
    row.appendChild(identifierCell);
    row.appendChild(nameCell);
    row.appendChild(addressCell);
    row.appendChild(phoneCell);

    // Append row to the table body
    tableBody.appendChild(row);
  }

  createTableCell(className, textContent) {
    const cell = document.createElement("td");
    cell.className = className;
    cell.textContent = textContent;
    return cell;
  }

  truncateText(text, maxLength) {
    return text.length > maxLength
      ? text.substring(0, maxLength) + "..."
      : text;
  }
}
