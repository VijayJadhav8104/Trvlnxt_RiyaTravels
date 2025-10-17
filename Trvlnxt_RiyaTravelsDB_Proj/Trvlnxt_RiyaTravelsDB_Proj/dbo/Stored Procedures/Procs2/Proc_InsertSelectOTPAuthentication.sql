CREATE procedure Proc_InsertSelectOTPAuthentication --'23331',143552,'S'
@UserName varchar(50),
@OTP Varchar(10)='',
@Falg varchar(8)
As

	Declare @GeneratedOTP Varchar(10)
	Declare @OTPGeneratedDateTime datetime
	Declare @DateDifference varchar(10)
	Declare @Id varchar(100)=0
Begin
	if(@Falg ='S')
	Begin
	
		Select @Id=ID From mUser WITH (NOLOCK) 
		
		WHERE UserName=@UserName 
		
		and isActive=1
		
		and OTPGenerated=@OTP  
		
		and DATEDIFF(MINUTE, otptime,GETDATE()) <=15
		select isnull(@Id,0) As ID
			
	End
	if(@Falg ='U')
	Begin
			update mUser Set OTPGenerated=@OTP ,OTPTime=GETDATE() WHERE @UserName=UserName
			
	End
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Proc_InsertSelectOTPAuthentication] TO [rt_read]
    AS [dbo];

