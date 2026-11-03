/*
Hospital KPIs
These queries produce the figures quoted in the project README.
Each one reads directly from the source tables and changes nothing.
*/

USE hospital_data;


/* KPI 1: Bed occupancy. */

SELECT
    COUNT(*) AS total_beds,
    SUM(CASE WHEN status = 'Occupied' THEN 1 ELSE 0 END) AS occupied_beds,
    ROUND(SUM(CASE WHEN status = 'Occupied' THEN 1 ELSE 0 END) * 100 / COUNT(*), 1) AS occupancy_percent
FROM beds;


/* KPI 2: Average length of stay for discharged patients. */

SELECT
    COUNT(*) AS discharged_patients,
    ROUND(AVG(DATEDIFF(discharge_date, admission_date)), 1) AS average_stay_days
FROM patient
WHERE discharge_date IS NOT NULL;


/* KPI 3: Total billed, average bill and discounts given. */

SELECT
    COUNT(*)                 AS total_bills,
    SUM(total_amount)        AS total_billed,
    ROUND(AVG(total_amount)) AS average_bill,
    SUM(discount)            AS total_discount,
    SUM(paid_amount)         AS total_collected
FROM hospital_bills;


/* KPI 4: Where billed revenue comes from. */

SELECT
    ROUND(SUM(surgery_charges)  * 100 / SUM(total_amount), 1) AS surgery_share_percent,
    ROUND(SUM(room_charges)     * 100 / SUM(total_amount), 1) AS room_share_percent,
    ROUND(SUM(test_charges)     * 100 / SUM(total_amount), 1) AS test_share_percent,
    ROUND(SUM(other_charges)    * 100 / SUM(total_amount), 1) AS other_share_percent,
    ROUND(SUM(doctor_fees)      * 100 / SUM(total_amount), 1) AS doctor_fee_share_percent,
    ROUND(SUM(medicine_charges) * 100 / SUM(total_amount), 1) AS medicine_share_percent
FROM hospital_bills;


/* KPI 5: Value of medicine dispensed at list price compared with medicine charges on bills. */

WITH dispensed AS (
    SELECT SUM(usage_log.qty * stock.unit_price) AS dispensed_value
    FROM medicine_patient AS usage_log
    JOIN medical_stock AS stock
        ON stock.medicine_id = usage_log.medicine_id
),
billed AS (
    SELECT SUM(medicine_charges) AS billed_value
    FROM hospital_bills
)
SELECT
    dispensed.dispensed_value,
    billed.billed_value,
    dispensed.dispensed_value - billed.billed_value AS unbilled_gap,
    ROUND(billed.billed_value * 100 / dispensed.dispensed_value, 1) AS billed_share_percent
FROM dispensed
CROSS JOIN billed;


/* KPI 5 continued: Medicine records dated inside and outside the patient's stay.
   This shows how much of the gap above comes from records that cannot be matched to a stay. */

SELECT
    CASE
        WHEN usage_log.date < patient.admission_date THEN 'Before admission'
        WHEN usage_log.date > patient.discharge_date THEN 'After discharge'
        ELSE 'During stay'
    END AS record_timing,
    COUNT(*) AS medicine_records,
    SUM(usage_log.qty * stock.unit_price) AS value_at_list_price
FROM medicine_patient AS usage_log
JOIN patient
    ON patient.patient_id = usage_log.patient_id
JOIN medical_stock AS stock
    ON stock.medicine_id = usage_log.medicine_id
GROUP BY record_timing;


/* KPI 6: Patient satisfaction and how many patients gave feedback. */

SELECT
    COUNT(*)              AS ratings_received,
    ROUND(AVG(rating), 2) AS average_rating,
    (SELECT COUNT(*) FROM patient) AS total_patients,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM patient), 1) AS response_rate_percent
FROM satisfaction_score;


/* KPI 7: Lowest rated feedback, to read what patients actually said. */

SELECT doctor_id, rating, feedback
FROM satisfaction_score
WHERE rating <= 3
ORDER BY doctor_id;


/* KPI 8: Doctor availability. */

SELECT
    availability,
    COUNT(*) AS total_doctors
FROM doctor
GROUP BY availability;


/* KPI 9: Medicine stock cover at the recent rate of use, lowest cover first. */

WITH usage_period AS (
    SELECT DATEDIFF(MAX(date), MIN(date)) / 30.0 AS months_observed
    FROM medicine_patient
),
medicine_use AS (
    SELECT medicine_id, SUM(qty) AS total_dispensed
    FROM medicine_patient
    GROUP BY medicine_id
)
SELECT
    stock.name AS medicine_name,
    stock.stock_qty,
    stock.reorder_level,
    stock.expiry_date,
    medicine_use.total_dispensed,
    ROUND(stock.stock_qty / (medicine_use.total_dispensed / usage_period.months_observed), 1) AS months_of_cover
FROM medical_stock AS stock
JOIN medicine_use
    ON medicine_use.medicine_id = stock.medicine_id
CROSS JOIN usage_period
ORDER BY months_of_cover;


/* KPI 10: Share of completed tests with an abnormal result. */

SELECT
    COUNT(*) AS completed_tests,
    SUM(CASE WHEN result = 'Abnormal' THEN 1 ELSE 0 END) AS abnormal_tests,
    ROUND(SUM(CASE WHEN result = 'Abnormal' THEN 1 ELSE 0 END) * 100 / COUNT(*), 1) AS abnormal_percent
FROM patient_tests
WHERE status = 'Completed';
