# Medical Analytics Dashboard

## Project Description

Hospital managers often need to check several separate systems to answer simple questions about patients, beds, medicine stock and billing. This project brings that information together in a single Power BI dashboard.

The source data is 15 Excel tables covering patients, doctors, staff, appointments, beds, rooms, departments, surgeries, tests, bills, medicine stock, suppliers and patient feedback. Two SQL views combine 11 of those tables, so that Power BI reads clean, ready to use data. The dashboard has six pages: Home, Overview, Patient, Doctor, Hospital and Finance.

The data is a small sample of 30 patients, 15 doctors, 20 staff and 25 beds. The figures below show the kind of decisions the dashboard supports, and they should not be read as the performance of a full hospital.

## Tech Used

- Excel for the source data tables
- MySQL for joining the tables into views and calculating KPIs
- Power Query for preparing the data in Power BI
- DAX for dashboard measures
- Power BI for the interactive dashboard
- Figma for the page backgrounds

## Impact

The project gives managers one place to review operations and finance together. Looking at the data side by side also exposed problems that would be hard to spot inside any one table.

- **Bed occupancy is 36 percent, with 9 of 25 beds in use.** Most of the hospital's bed capacity is sitting idle. This matters because rooms still carry about 67,000 a month in maintenance cost whether or not they are full.

- **Average length of stay is 7.9 days across 22 discharged patients.** This is the main driver of how many patients each bed can serve. Even a small reduction would free up capacity, so it is a useful number to track by department and diagnosis.

- **Total billed charges are 713,805, and surgery makes up 60.2 percent.** Revenue depends heavily on surgery, and only 9 of the 30 patients have surgery charges. The average bill of 23,794 is far above the typical bill of 8,868 for the same reason, so a drop in surgical cases would hit income quickly.

- **Discounts total 13,300, or 1.9 percent of billed charges, and every bill is marked as paid.** Collections look healthy and discounting is under control, so this area does not need urgent attention. That lets managers put their time on the issues below.

- **Medicine charges on bills total 5,505, while medicine records add up to 41,089 at list price.** Bills show only 13.4 percent of the recorded value, and the two cannot be reconciled today. The main reason is that 429 of 517 medicine records are dated outside the patient's stay, so either the dates are wrong or some medicine is not reaching the bill.

- **Patient satisfaction averages 4.16 out of 5, based on 19 of 30 patients.** Patients are broadly happy, with no rating below 3. A response rate of 63.3 percent means over a third of patients are not represented, so the true picture could be different.

- **All four of the lowest ratings accept the treatment itself but mention a service gap.** Three point to poor communication or explanation and one to a long wait. This suggests the hospital's weak spot is how it communicates with patients and not the quality of its care, and that is usually cheaper to fix.

- **Insulin has about 2.1 months of stock at the recent rate of use, and diazepam has about 2.7 months.** All 15 medicines are above their reorder level, so nothing looks urgent on the current report. However, the insulin reorder level of 20 units covers only about 13 days of use, so the alert could arrive too late.

- **Three of the 15 doctors are on leave, which is 20 percent of the medical team.** Each of the 15 departments has a single doctor, so Orthopedics, Gastroenterology and Endocrinology currently have no doctor available. Patients in those departments have no one else to see, which puts both care and income at risk.

- **26 of 30 completed tests are abnormal, or 86.7 percent.** This is unusually high, even with a small sample. It could reflect how sick these patients are or how results are recorded, so it is worth checking before anyone relies on test data.

## Recommendations

1. **Reconcile medicine records with billing.** Compare each patient's medicine records with their bill, and correct how medicine dates are captured. Until this is done, the hospital cannot tell whether the gap is a recording issue or lost income.

2. **Set reorder levels from actual usage.** Base each level on how quickly the medicine is used and how long suppliers take to deliver. Critical medicines such as insulin should get the largest safety margin, because running out would directly affect patient care.

3. **Review bed capacity by ward.** Look at occupancy by room type and over a longer period, then decide whether to repurpose or close the beds that stay empty. With 64 percent of beds unused, this is the clearest route to lowering running costs.

4. **Improve patient communication.** Give doctors and nurses a simple routine for explaining treatment and recovery before discharge, and share expected waiting times. Most low scores mention this directly, and it can be improved without major spending.

5. **Reduce reliance on surgery income.** Track surgical volume every month and look for steady growth in other services such as diagnostics. Today, a few patients produce most of the revenue, which makes income hard to predict.

6. **Clean up records at the source.** One discharged patient still holds a bed in the system, the bed and room tables disagree on what is occupied, and the surgery table contains routine appointments with misaligned columns. Clear rules at data entry would make every dashboard page more reliable.

7. **Collect feedback from every patient at discharge.** Make it a standard step in the discharge process. A higher response rate would give managers a fairer view of each department and doctor, since many doctors currently have only one or two ratings.

8. **Plan leave cover by department.** Check doctor leave against upcoming appointments and surgeries, and arrange cover in advance. Every department relies on one doctor, so a single absence can stop a whole service, and planned cover protects both patient access and surgical income.

9. **Audit how test results are recorded.** Review a sample of abnormal results against the original reports. If the 86.7 percent rate is accurate, clinical leaders should know about it, and if it is not, the data needs to be corrected.
