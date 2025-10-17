
CREATE proc [dbo].[InsertCommsion]-- 'Create',0,'ab',2.0,3.0,'IN','1',null,null,'3','%','%',0
  @OperationType varchar(50),
  @PKID int=null,
  @Airline char(2)=null,
  @DomesticCommission float=null,
  @InternationalComm float=null,
  @Country varchar(100)=null,
  @UserId varchar(500)=null,
  @ModifiedBy varchar(500)=null,
  @DeletedBy varchar(500)=null,
  @FairBasis varchar(500)=null,
  @DomesticType varchar(500)=null,
  @InternationalType varchar(500)=null,
  @status int out
  AS
  BEGIN
		SET @status=0
		BEGIN

			IF @OperationType='Create'
			BEGIN
			INSERT INTO Comission(airline,domesticcomision,DomesticType,intcommision,InternationalType,Country,FairBasis,CreatedDate,UserId,IsACtive)
			VALUES(	@Airline,@DomesticCommission,@DomesticType,@InternationalComm,@InternationalType,@Country,@FairBasis,GETDATE(),@UserId,1)
			SET @status=1				
			END		
			IF @OperationType='Update'
			BEGIN
			IF EXISTS(SELECT PKID FROM Comission WHERE PKID=@PKID)
			BEGIN
			UPDATE Comission SET airline=@Airline,domesticcomision=@DomesticCommission,DomesticType=@DomesticType,InternationalType=@InternationalType,intcommision=@InternationalComm,Country=@Country,ModifiedBy=@ModifiedBy,ModifiedDate=GETDATE()
			WHERE
			PKID=@PKID					
			SET @status=1
			END
			END		
			IF @OperationType='Delete'
			BEGIN
			IF EXISTS(SELECT PKID FROM Comission WHERE PKID=@PKID)
			BEGIN
			DELETE FROM	Comission WHERE PKID=@PKID 

			UPDATE Comission set DeletedBy=@DeletedBy				
			SET @status=1
			END				
			END
			
		END
  END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertCommsion] TO [rt_read]
    AS [dbo];

