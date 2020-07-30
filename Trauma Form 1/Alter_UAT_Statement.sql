use ProdSmartCare

select * from documentcodes
order by createddate desc

select * from CustomDocumenttraumaformone
select * from CustomDocumentabdnotice

select * from CustomDocumentTraumaFormOne

BEGIN TRAN
ALTER TABLE CustomDocumentTraumaFormOne
    ADD DreamsIY char(1) NULL,
        DreamsIN char(1) NULL,
        DreamsIIY char(1) NULL,
        DreamsIIN char(1) NULL,
        DreamsIIIY char(1) NULL,
        DreamsIIIN char(1) NULL,
        DreamsIVY char(1) NULL,
        DreamsIVN char(1) NULL,
        DreamsVY char(1) NULL,
        DreamsVN char(1) NULL,
        IPVIY char(1) NULL,
        IPVIN char(1) NULL,
        IPVIComment varchar(40) NULL,
        IPVIIY char(1) NULL,
        IPVIIN char(1) NULL,
        IPVIIComment varchar(80) NULL,
        IPVIIIY char(1) NULL,
        IPVIIIN char(1) NULL,
        IPVIIIComment varchar(80) NULL,
        DepQIY char(1) NULL,
        DepQIN char(1) NULL,
        DepQIIY char(1) NULL,
        DepQIIN char(1) NULL,
        DepQIIIY char(1) NULL,
        DepQIIIN char(1) NULL;

COMMIT TRAN