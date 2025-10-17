CREATE proc [dbo].[Get_TJQ_IATA_exempt_ICUST]
as                      
begin                              
 select CustID from TJQ_IATA_exempt_ICUST where IsActive=1
end