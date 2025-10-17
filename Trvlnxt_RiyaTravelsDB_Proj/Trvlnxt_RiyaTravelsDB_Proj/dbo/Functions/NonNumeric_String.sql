
CREATE FUNCTION [dbo].[NonNumeric_String]
(    
       @NonNumeric varchar(max)
)
RETURNS  varchar(1000)
 
AS
BEGIN
     
	 DECLARE @Index int  
SET @Index = 0  
while 1=1  
begin  
    set @Index = patindex('%[^a-z^`!@#$%^&*_()=+\|{};",]%',@NonNumeric)  
    if @Index <> 0  
    begin  
        SET @NonNumeric = replace(@NonNumeric,substring(@NonNumeric,@Index, 1), '')  
    end  
    else    
        break;   
end     
RETURN @NonNumeric -- `!@#$%^&*_()=+\|{};",<>/?a-z]
      
END
