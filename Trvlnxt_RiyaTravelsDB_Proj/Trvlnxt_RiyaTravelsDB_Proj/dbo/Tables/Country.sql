CREATE TABLE [dbo].[Country] (
    [ID]      BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [country] NVARCHAR (255) NULL,
    [A1]      NVARCHAR (255) NULL,
    [A2]      NVARCHAR (255) NULL,
    [Num]     FLOAT (53)     NULL,
    [code]    VARCHAR (25)   NULL,
    CONSTRAINT [PK_Country_1] PRIMARY KEY CLUSTERED ([ID] ASC)
);

