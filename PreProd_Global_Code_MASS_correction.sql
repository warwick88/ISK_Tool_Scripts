

update preprod
set sortorder=prod.sortorder
from [kcmh-db1].Prodsmartcare.dbo.globalcodes prod
join smartcarepreprod.dbo.globalcodes preprod
    on prod.globalcodeid=preprod.GlobalCodeId and prod.category=preprod.category and prod.codename=preprod.codename
where isnull(prod.sortorder,0)<>isnull(preprod.sortorder,0)