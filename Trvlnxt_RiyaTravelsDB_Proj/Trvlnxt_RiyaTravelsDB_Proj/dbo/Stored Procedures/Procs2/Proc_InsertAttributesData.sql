Create Procedure Proc_InsertAttributesData
@FkBookId int=0,
@AttributeId int=0,
@Attributes varchar(200)=null,
@AttributesValue varchar(200)=null
As
Begin
 Insert into Hotel_AttributesData(
 FKBookId,AttributeId,Attributes,AttributesValue)
 Values(@FkBookId,@AttributeId,@Attributes,@AttributesValue)
End