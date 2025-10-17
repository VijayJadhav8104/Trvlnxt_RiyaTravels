CREATE proc [dbo].[Get_Icust] -- [Get_Icust] '4000'
@companycode varchar(20)
as                  
begin                          
	select top 1 Icast from B2BRegistration where companycode = @companycode
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_Icust] TO [rt_read]
    AS [dbo];

