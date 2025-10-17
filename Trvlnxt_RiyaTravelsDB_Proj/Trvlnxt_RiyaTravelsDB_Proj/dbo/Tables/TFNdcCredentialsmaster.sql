CREATE TABLE [dbo].[TFNdcCredentialsmaster] (
    [Pkid]            BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Airline]         VARCHAR (50)  NOT NULL,
    [Country]         VARCHAR (50)  NOT NULL,
    [AgentLogin]      VARCHAR (150) NULL,
    [Password]        VARCHAR (150) NULL,
    [Active]          BIT           CONSTRAINT [DF_TFNdcCredentialsmaster_Active] DEFAULT ((1)) NOT NULL,
    [Inserteddate]    DATETIME      CONSTRAINT [DF_TFNdcCredentialsmaster_Inserteddate] DEFAULT (getdate()) NOT NULL,
    [AgentIdentifier] VARCHAR (150) NULL,
    CONSTRAINT [PK_TFNdcCredentialsmaster] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

