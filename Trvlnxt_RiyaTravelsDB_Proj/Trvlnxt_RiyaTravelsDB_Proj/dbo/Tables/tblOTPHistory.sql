CREATE TABLE [dbo].[tblOTPHistory] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [OTPStatus] INT           NULL,
    [OTPDate]   DATETIME      NULL,
    [AgentID]   INT           NULL,
    [IPAddress] VARCHAR (500) NULL,
    [Source]    VARCHAR (20)  NULL,
    [OTP]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblOTPHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

