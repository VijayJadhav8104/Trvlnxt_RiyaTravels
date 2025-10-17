CREATE TABLE [dbo].[tblLogError] (
    [id]      BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Msg]     VARCHAR (200) NULL,
    [Details] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblLogError] PRIMARY KEY CLUSTERED ([id] ASC)
);

