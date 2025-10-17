CREATE proc [dbo].[Sp_UpdatePNRRetrivalFromAudit_TJQ_DATA]
@Id int
,@ICust varchar(50) =''
,@EmpID varchar(20) =''
as                    
begin                            
 Update PNRRetrivalFromAudit set ICust = @ICust,EmpID =@EmpID where Id = @Id
end