CREATE TABLE [dbo].[InflightSer] (
    [PKID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id]   INT          NOT NULL,
    [text] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_InflightSer] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

