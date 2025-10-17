
CREATE FUNCTION [dbo].[ValidaFormatDate](@datestring VARCHAR(25))    
RETURNS datetime AS     
 BEGIN         
      if LEN(@datestring)< 11
	  BEGIN
			 SET @datestring = @datestring +' 00:00 AM'
	  END
  DECLARE @RtnStr Datetime;
  
  Set @RtnStr = (Select CONVERT(datetime, CAST(CONVERT(date, LEFT(@datestring, CHARINDEX(' ', @datestring)), 105) AS varchar(10)) + ' ' + SUBSTRING(@datestring, CHARINDEX(' ', @datestring) + 1, LEN(@datestring) - CHARINDEX(' ', @datestring)), 121) )
       
  RETURN @RtnStr     
 END 

 --Select dbo.ValidaFormatDate('12-11-2021 00:00 AM')

