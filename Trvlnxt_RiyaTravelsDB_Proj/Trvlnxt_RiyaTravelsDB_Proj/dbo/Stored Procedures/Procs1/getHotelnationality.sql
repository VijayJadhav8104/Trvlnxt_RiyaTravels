/****** Script for SelectTopNRows command from SSMS  ******/

CREATE procedure [dbo].[getHotelnationality]
--@ISOCode varchar(3)='IN'

as
SELECT  hn.[ID]
      ,[Code]
      ,[Nationality]
      ,[ISOCode]
	  ,cm.CountryName
  FROM [dbo].[Hotel_Nationality_Master] hn
  join Hotel_CountryMaster cm
  on hn.Code=cm.CountryCode
  --where ISOCode=@ISOCode






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getHotelnationality] TO [rt_read]
    AS [dbo];

