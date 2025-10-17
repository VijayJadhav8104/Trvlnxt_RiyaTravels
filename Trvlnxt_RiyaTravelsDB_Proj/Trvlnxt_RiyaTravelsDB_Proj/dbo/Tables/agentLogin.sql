CREATE TABLE [dbo].[agentLogin] (
    [UserID]             BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserCode]           VARCHAR (10)    NULL,
    [UserName]           VARCHAR (500)   NOT NULL,
    [Password]           VARCHAR (300)   NULL,
    [FirstName]          VARCHAR (150)   NULL,
    [LastName]           VARCHAR (150)   NULL,
    [InsertedDate]       DATETIME        CONSTRAINT [DF_agentLogin_InsertedDate] DEFAULT (getdate()) NOT NULL,
    [IsActive]           TINYINT         NULL,
    [MobileNumber]       VARCHAR (200)   NULL,
    [NewsLetter]         TINYINT         NULL,
    [Address]            VARCHAR (500)   NULL,
    [City]               VARCHAR (100)   NULL,
    [Country]            VARCHAR (100)   NULL,
    [Pincode]            VARCHAR (20)    NULL,
    [DrivingLicenceNo]   VARCHAR (20)    NULL,
    [HomeNo]             VARCHAR (20)    NULL,
    [IsB2BAgent]         BIT             NULL,
    [Province]           VARCHAR (50)    NULL,
    [BookingCountry]     VARCHAR (2)     NULL,
    [AgentApproved]      BIT             NULL,
    [SessionID]          VARCHAR (50)    NULL,
    [AgentBalance]       MONEY           CONSTRAINT [DF_agentLogin_AgentBalance] DEFAULT ((0)) NULL,
    [ParentAgentID]      BIGINT          NULL,
    [ResetPwdFlag]       BIT             CONSTRAINT [DF_agentLogin_ResetPwdFlag] DEFAULT ((1)) NULL,
    [AccessFlag]         INT             NULL,
    [userTypeID]         INT             CONSTRAINT [DF_agentLogin_userTypeID] DEFAULT ((2)) NULL,
    [BalanceUpdateDate]  DATETIME        NULL,
    [FareType]           VARCHAR (MAX)   NULL,
    [NewCurrency]        VARCHAR (MAX)   NULL,
    [TicketFormate]      VARCHAR (10)    NULL,
    [AutoTicketing]      BIT             CONSTRAINT [DF_agentLogin_AutoTicketing] DEFAULT ((0)) NULL,
    [ROE]                DECIMAL (18, 6) NULL,
    [ModifiedOn]         DATETIME2 (7)   NULL,
    [ModifiedBy]         INT             NULL,
    [GhostTrack]         BIT             CONSTRAINT [DF_agentLogin_GhostTrack] DEFAULT ((0)) NOT NULL,
    [NewSelfBalance]     BIT             CONSTRAINT [DF_agentLogin_NewSelfBalance] DEFAULT ((0)) NOT NULL,
    [GroupId]            INT             CONSTRAINT [DF_agentLogin_GroupId] DEFAULT ((1)) NULL,
    [EncryptedPassword]  NVARCHAR (300)  NULL,
    [UserDeviceID]       VARCHAR (100)   NULL,
    [UserDeviceIDTime]   DATETIME        NULL,
    [OTPGenerated]       VARCHAR (50)    NULL,
    [OTPTime]            DATETIME        NULL,
    [LoginAttempt]       INT             NULL,
    [AttemptNo]          INT             NULL,
    [AttemptedDate]      DATETIME        NULL,
    [Logo]               VARCHAR (MAX)   NULL,
    [NoERP]              BIT             NULL,
    [AgentLogoNew]       VARCHAR (MAX)   NULL,
    [FromScheduler]      INT             NULL,
    [LastLoginDate]      DATETIME        NULL,
    [OTPRequired]        BIT             NULL,
    [CreatedBy]          INT             NULL,
    [LoginFromCountry]   VARCHAR (MAX)   NULL,
    [SubUserEmail]       VARCHAR (500)   NULL,
    [PasswordExpiryDate] DATETIME        NULL,
    [PasswordEncrypt]    VARCHAR (550)   NULL,
    [BalanceFetch]       VARCHAR (100)   NULL,
    CONSTRAINT [PK_UserID] PRIMARY KEY CLUSTERED ([UserID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIDX_UserName]
    ON [dbo].[agentLogin]([UserName] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_UserID_UsrName_Plus3]
    ON [dbo].[agentLogin]([UserName] ASC, [Country] ASC, [BookingCountry] ASC, [GroupId] ASC)
    INCLUDE([userTypeID], [InsertedDate], [AgentApproved]);


GO
CREATE NONCLUSTERED INDEX [agentLogin_UserTypeID]
    ON [dbo].[agentLogin]([userTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [agentLogin_BookingCountry]
    ON [dbo].[agentLogin]([BookingCountry] ASC);


GO
CREATE NONCLUSTERED INDEX [agentLogin_ParentAgentID]
    ON [dbo].[agentLogin]([ParentAgentID] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Comman_Index]
    ON [dbo].[agentLogin]([UserID] ASC, [AgentApproved] ASC, [userTypeID] ASC, [BookingCountry] ASC)
    INCLUDE([UserName], [InsertedDate], [Country], [GroupId]);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_INDEX]
    ON [dbo].[agentLogin]([IsActive] ASC)
    INCLUDE([UserID], [userTypeID]);


GO
CREATE TRIGGER [dbo].[enforce_optrequired]
ON [dbo].[agentLogin]
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE agentlogin
    SET OTPRequired = 1
    WHERE OTPRequired <> 1 and UserID!= 53976 and  UserID!= 55923
    AND (EXISTS (SELECT * FROM inserted WHERE inserted.userid = agentlogin.userid)
         OR EXISTS (SELECT * FROM deleted WHERE deleted.userid = agentlogin.UserID));
END;