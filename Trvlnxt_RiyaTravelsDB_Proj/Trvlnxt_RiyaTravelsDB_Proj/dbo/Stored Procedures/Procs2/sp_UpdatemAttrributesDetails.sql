CREATE procedure [dbo].[sp_UpdatemAttrributesDetails]      
      
@OrderID varchar(50),      
@GDSPNR varchar(50)=NULL,
@DEVIATION_APPROVER_NAME_AND_EMPCODE varchar(50)=null 
    
As      
Begin      
if exists (select GDSPNR from mAttrributesDetails where OrderID = @OrderID AND GDSPNR = @GDSPNR)      
begin      
  Update mAttrributesDetails set DEVIATION_APPROVER_NAME_AND_EMPCODE = @DEVIATION_APPROVER_NAME_AND_EMPCODE where OrderID = @OrderID AND GDSPNR = @GDSPNR      
end    
       
select SCOPE_IDENTITY();      
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatemAttrributesDetails] TO [rt_read]
    AS [dbo];

