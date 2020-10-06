USE ProdSmartCare

--so let's find the document
select * from documents
where documentid=2704682


--find it's version so you can find it in TPProcedures
select * from documentversions
where documentid=2704682

---
select * from TPProcedures