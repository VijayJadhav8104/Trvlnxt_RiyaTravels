CREATE TABLE [dbo].[CMS_FAQ] (
    [Id]          INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Question]    NVARCHAR (MAX) NULL,
    [Answer]      NVARCHAR (MAX) NULL,
    [Country]     VARCHAR (100)  NULL,
    [CreatedDate] DATETIME       NULL,
    [IsActive]    BIT            NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

