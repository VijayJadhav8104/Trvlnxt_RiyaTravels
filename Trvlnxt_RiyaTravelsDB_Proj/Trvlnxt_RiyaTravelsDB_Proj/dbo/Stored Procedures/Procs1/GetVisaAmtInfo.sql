CREATE proc [dbo].[GetVisaAmtInfo]
As
Begin

select ActualCost as 'ActualAmt',DiscountedCost as 'DiscountedAmt' from tblVisaAssuranceAmount where IsActive=1

End

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetVisaAmtInfo] TO [rt_read]
    AS [dbo];

