
CREATE proc [dbo].[CMS_GetPageContent]
  @PageName varchar(200),
  @Country varchar(100)
  AS
  BEGIN
			BEGIN
				SELECT 						
						TOP 1 Content										
				FROM 
				CMS_pagecontent
				WHERE 
					Country=@Country
					and
					PageName=@PageName
				ORDER BY
					CreatedDate desc
			END
  END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetPageContent] TO [rt_read]
    AS [dbo];

