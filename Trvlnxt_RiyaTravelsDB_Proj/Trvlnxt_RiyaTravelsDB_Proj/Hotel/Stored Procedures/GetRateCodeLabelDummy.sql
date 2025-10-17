Create Proc [Hotel].GetRateCodeLabelDummy
@Agent int =0      
AS      
BEGIN
     Select
    Rate as'rateCode',
	Label,AgentId as 'agentId',
	SM.RhSupplierId as 'providerId',
	SM.SupplierName as 'supplierName',
	Case 
	  when Category_N is not Null  then Rate+':'+Category_N
	  else null end as 'N',
	Case 
	  when Category_P is not Null  then Rate+':'+Category_P
	  else null end as 'P',
	--Case when Category_B =''  and Category_N is not Null  then null
	--     when Category_B =null  then ''
    --     else '' end as 'B'
     null as 'B'
	from Hotel.RateLabel RL
	left join B2BHotelSupplierMaster SM on SM.Id=RL.SupplierId    
	where AgentId=@Agent 
END