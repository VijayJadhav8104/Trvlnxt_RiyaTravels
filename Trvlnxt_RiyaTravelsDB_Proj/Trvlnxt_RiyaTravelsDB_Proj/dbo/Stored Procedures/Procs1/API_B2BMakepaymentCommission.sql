CREATE procedure API_B2BMakepaymentCommission
@OrderID varchar(250) = ''

As
Begin

	Select AmountBeforeCommission,AmountWithCommission,TotalCommission From B2BMakepaymentCommission where OrderId = @OrderID

End