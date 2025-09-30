## GRC Solutions Platform

A centralized evaluation and discovery platform for Governance, Risk, and Compliance (GRC) software vendors. Designed to support informed decision-making, the platform enables users to explore, compare, and rate GRC tools using a transparent, data-driven scoring algorithm.

---

## Key Features

* **Vendor Directory:** Access a curated database of 50+ leading GRC solution providers, complete with profiles, offerings, and differentiators.
* **Transparent Scoring Algorithm:** Each platform is evaluated on 10 critical dimensions using the **Weighted Sum Model (WSM)**, chosen for its interpretability, robustness, and suitability for small datasets.
* **Evaluation Criteria:** Platforms are scored (1–5) across 10 dimensions. Each dimension is weighted based on expert judgment and industry relevance.

### Evaluation Dimensions

Each GRC product is scored on the following 10 criteria:

| Category                    | Priority Tier  | Description                                                                  |
| --------------------------- | -------------- | ---------------------------------------------------------------------------- |
| Security & Compliance       | High (≥ 12%)   | Measures risk control features, compliance frameworks, certifications        |
| Integration Capabilities    | Medium (8–10%) | Evaluates APIs, third-party integrations, and data interoperability          |
| User Experience             | Medium         | Assesses UI design, workflow intuitiveness, and accessibility                |
| Scalability                 | Medium         | Reflects how well the platform adapts to growth or complex org structures    |
| Cost Effectiveness          | Medium         | Evaluates value for price, licensing models, and operational cost efficiency |
| Customer Support            | Low (< 7%)     | Rates responsiveness, expertise, and availability of support                 |
| Implementation & Training   | Low            | Measures ease of deployment and availability of onboarding/training          |
| Customization & Flexibility | Low            | Assesses how well the solution adapts to unique processes                    |
| Reporting & Analytics       | Medium         | Evaluates dashboards, KPIs, export capabilities, and visualizations          |
| Vendor Stability            | Low            | Considers company longevity, funding, and market presence                    |

We evaluated multiple MCDM algorithms—**WSM, WPM, TOPSIS,** and **VIKOR**—and selected the **Weighted Sum Model (WSM)** for its:

* Interpretability: Easy to explain to without diving into implementation details
* Simplicity: Straightforward to implement in spreadsheets or scripts
* Robustness: Minimal sensitivity to small weight changes
* Consistency: Performs well with small datasets and uniformly scaled scores
* 
> For full algorithm and evaluation methodology, refer to our [Scoring Algorithm Document](client/scoring-algorithm.pdf).
> For implementation details, see the full dataset available in our public [Google Sheet](https://docs.google.com/spreadsheets/d/1hCxfIgb6IBzKeXfrMkdMKXhmC4U0daMWWJkmPWVepSg/edit?usp=sharing)

---

## Tech Stack

| Area                 | Stack                                  |
| -------------------- | -------------------------------------- |
| **Frontend**         | React 18, TypeScript                   |
| **Build Tool**       | Vite                                   |
| **Styling**          | Tailwind CSS, shadcn/ui                |
| **Routing**          | React Router                           |
| **State Management** | TanStack Query (React Query)           |
| **HTTP Client**      | Axios                                  |
| **Data Handling**    | Google Sheets (backend dataset source) |
| **Deployment**       | Vercel (or your preferred platform)    |

---

This project is maintained by Anvi Singh at Cyber Sierra


