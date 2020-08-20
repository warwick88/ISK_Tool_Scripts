select distinct b.ScreenName
from ListPageColumnConfigurations as a
join Screens as b on a.ScreenId = b.ScreenId