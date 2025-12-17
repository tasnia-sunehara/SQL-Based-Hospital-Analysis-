# Healthcare Analytics Dashboard 📊

# Objective:

Analyzed 5 years of hospital data to identify trends in patient admissions, payer coverage, and procedure costs. Cleaned raw data to correct naming errors and standardized entry formats using **MySQL**.

## 📂 Data Source
The dataset used for this analysis was generated using **Synthea™**, an open-source patient population simulator that outputs realistic (but synthetic) electronic health records (EHR). This ensures strict adherence to **HIPAA privacy standards** while allowing for complex data analysis.

**Dataset Citation:**
> Walonoski, J., Kramer, M., Nichols, J., Quina, A., Moesel, C., Hall, D., ... & McLachlan, S. (2018). **Synthea: An approach, method, and software mechanism for generating synthetic patients and the synthetic electronic health care record**. *Journal of the American Medical Informatics Association*, 25(3), 230–238. [https://doi.org/10.1093/jamia/ocx079](https://doi.org/10.1093/jamia/ocx079)

**Database Schema:**


![Dashboard Overview](https://github.com/tasnia-sunehara/SQL-Based-Hospital-Analysis-/blob/main/Db%20Schema.png)

The analysis focuses on 5 core tables simulating a hospital database:

*   `Patients` (Demographics)
*   `Encounters` (Visits & Admissions)
*   `Procedures` (Clinical Actions)
*   `Payers` (Insurance & Coverage)
*   `Organizations` (Provider details)


# Key Skills Used:

Data Cleaning (REGEX, UPDATE)
Advanced SQL (Window Functions, CTEs, Joins)
Date Logic (Time Deltas, Quarter aggregation)

# Key Insights:


```

📉 Zero Coverage Rate: 48.7%    🏥 <24hr Encounters: 95.9%
💰 Avg Medicaid Cost: $6,205    🔄 30-Day Readmits: 84 patients
⚕️ ICU Avg Base Cost: $206,260  📈 Max Total Encounter : 3885 (2014)


```

---


### 💰 Financial Risk & Payer Analysis


| Metric | Value | Impact |
|--------|-------|--------|
| **Zero Coverage Rate** | 48.7% | Critical revenue exposure |
| **Medicaid Avg Cost** | $6,205 | Highest payer category |
| **Uninsured Avg Cost** | $5,593 | Second-highest cost driver |
| **ICU Base Cost** | $206,260 | 4x coronary Artery bypass grafting |


---

### 🏥 Operational Volume & Efficiency


| Metric | Value |
|--------|-------|
| **Ambulatory Care** | 40-60% annually |
| **Outpatient (2021)** | 40% (↗️ 2x from ~20%) |
| **<24hr Resolution** | 95.9% |
| **2014 Max Encounters** | +57% |
| **2021 Encounters Spike** | +41% |



---

### 👥 Patient Behavior & Care Patterns


| Category | Details |
|----------|--------|
| **Top Procedures** | Assessment of health and social care needs |
| **Super-User (Top Patient)** | 62 readmissions - Mr. Raleigh Frami |
| **Top 10 Patients** | 400+ readmissions |
| **30-Day Readmissions** | 84 unique patients |



---

<div align="center">

**Made with 🩷 for better healthcare outcomes**

</div>
