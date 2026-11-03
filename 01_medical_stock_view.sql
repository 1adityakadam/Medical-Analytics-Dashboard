/*
Medical stock view
Joins each medicine to its supplier so that the dashboard can read stock from one place.
*/

USE hospital_data;

CREATE OR REPLACE VIEW medical_stock_view AS
SELECT
    stock.medicine_id,
    stock.name AS medicine_name,
    stock.category,
    stock.supplier_id,
    supplier.name AS supplier_name,
    stock.cost_price,
    stock.unit_price,
    stock.stock_qty,
    stock.reorder_level,
    stock.manufacture_date,
    stock.expiry_date,
    stock.batch_number
FROM medical_stock AS stock
LEFT JOIN supplier
    ON stock.supplier_id = supplier.supplier_id;
