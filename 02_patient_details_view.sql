/*
Patient details view
Creates one row per patient with their doctor, bed, room, department, surgery, bill and feedback.
This view is the main source for the dashboard, so Power BI does not need to rebuild these joins.
A left join keeps every patient, even when some of the related records are missing.
*/

USE hospital_data;

CREATE OR REPLACE VIEW patient_details_view AS
SELECT
    /* Patient details */
    patient.patient_id,
    patient.name AS patient_name,
    patient.gender AS patient_gender,
    patient.weight AS patient_weight,
    patient.age AS patient_age,
    patient.blood_group AS patient_blood_group,
    patient.email AS patient_email,
    patient.address AS patient_address,
    patient.admission_date,
    patient.discharge_date,
    patient.status AS patient_status,
    CASE
        WHEN bed.bed_id IS NULL THEN 'Discharged'
        ELSE 'Admitted'
    END AS bed_based_status,

    /* Doctor details */
    doctor.doctor_id,
    doctor.name AS doctor_name,
    doctor.salary AS doctor_salary,
    doctor.specialization AS doctor_specialization,
    doctor.department AS doctor_department,
    doctor.availability AS doctor_availability,
    doctor.joining_date AS doctor_joining_date,
    doctor.qualification AS doctor_qualification,
    doctor.experience_years AS doctor_experience_years,
    doctor.email AS doctor_email,
    doctor.phone AS doctor_phone,

    /* Bed and room details */
    bed.bed_id,
    bed.occupied_from AS bed_occupied_from,
    bed.occupied_till AS bed_occupied_till,
    bed.status AS bed_status,
    room.room_id,
    room.floor AS room_floor,
    room.room_type,
    room.capacity AS room_capacity,
    room.daily_charge AS room_daily_charge,
    room.avgmontlymaintenancecost AS room_monthly_maintenance_cost,
    room.status AS room_status,

    /* Department details */
    department.department_id,
    department.name AS department_name,
    department.total_staff AS department_total_staff,

    /* Patient feedback */
    feedback.satisfaction_id,
    feedback.rating AS satisfaction_rating,
    feedback.feedback AS satisfaction_comment,

    /* Surgery details */
    surgery.appointment_id AS surgery_appointment_id,
    surgery.appointment_date AS surgery_date,
    surgery.appointment_time AS surgery_time,
    surgery.status AS surgery_status,
    surgery.reason AS surgery_reason,
    surgery.notes AS surgery_notes,

    /* Billing details */
    bill.room_charges,
    bill.surgery_charges,
    bill.medicine_charges,
    bill.test_charges,
    bill.doctor_fees,
    bill.other_charges,
    bill.total_amount,
    bill.discount,
    bill.paid_amount,
    bill.payment_method,
    bill.payment_status

FROM patient
LEFT JOIN satisfaction_score AS feedback
    ON feedback.patient_id = patient.patient_id
LEFT JOIN surgery
    ON surgery.patient_id = patient.patient_id
LEFT JOIN hospital_bills AS bill
    ON bill.patient_id = patient.patient_id
LEFT JOIN beds AS bed
    ON bed.patient_id = patient.patient_id
LEFT JOIN rooms AS room
    ON room.room_id = bed.room_id
LEFT JOIN department
    ON department.department_id = room.department_id
LEFT JOIN (
    SELECT DISTINCT patient_id, doctor_id
    FROM appointment
) AS patient_doctor
    ON patient_doctor.patient_id = patient.patient_id
LEFT JOIN doctor
    ON doctor.doctor_id = patient_doctor.doctor_id;
