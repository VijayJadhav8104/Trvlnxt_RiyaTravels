CREATE proc [Cruise].[Insert_OriginMappCrusDiscount]
(
	
	@FK_CrusId int NULL,
	@FK_OriginId int NULL
	)
	as
	begin
	insert into OriginMappCrusDiscount(FK_CrusID,FK_OriginId) values(@FK_CrusID,@FK_OriginId)
	end
