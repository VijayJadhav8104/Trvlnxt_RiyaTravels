CREATE TABLE [dbo].[AirlinesName_] (
    [_NAME]      NVARCHAR (255) NULL,
    [_CODE]      NVARCHAR (255) NOT NULL,
    [ICAO]       NVARCHAR (255) NULL,
    [AWB Prefix] FLOAT (53)     NULL,
    [ID]         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    CONSTRAINT [PK_AirlinesName_new] PRIMARY KEY CLUSTERED ([_CODE] ASC)
);

