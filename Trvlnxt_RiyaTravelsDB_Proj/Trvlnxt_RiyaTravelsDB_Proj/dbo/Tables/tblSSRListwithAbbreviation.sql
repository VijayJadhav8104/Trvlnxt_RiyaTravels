CREATE TABLE [dbo].[tblSSRListwithAbbreviation] (
    [id]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SSRCode]      VARCHAR (50)  NULL,
    [Description]  VARCHAR (MAX) NULL,
    [Carrier]      VARCHAR (10)  NULL,
    [IsActive]     BIT           NULL,
    [Type]         VARCHAR (50)  NULL,
    [Quarters]     VARCHAR (20)  NULL,
    [FromTime]     TIME (7)      NULL,
    [ToTime]       TIME (7)      NULL,
    [ProductClass] VARCHAR (2)   NULL,
    [FromDate]     DATETIME      NULL,
    [ToDate]       DATETIME      NULL,
    [Isliquor]     BIT           NULL,
    CONSTRAINT [PK_tblSSRListwithAbbreviation] PRIMARY KEY CLUSTERED ([id] ASC)
);

