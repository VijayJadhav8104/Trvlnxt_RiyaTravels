CREATE TABLE [dbo].[Tbl_StarCategory] (
    [id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [StarCategory] NVARCHAR (150) NULL,
    CONSTRAINT [PK_Tbl_StarCategory] PRIMARY KEY CLUSTERED ([id] ASC)
);

