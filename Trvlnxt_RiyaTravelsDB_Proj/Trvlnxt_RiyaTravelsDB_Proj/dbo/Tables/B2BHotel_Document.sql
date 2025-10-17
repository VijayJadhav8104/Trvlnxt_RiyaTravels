CREATE TABLE [dbo].[B2BHotel_Document] (
    [id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkid]        NCHAR (10)    NULL,
    [FileType]    VARCHAR (50)  NULL,
    [Path]        VARCHAR (150) NULL,
    [Description] VARCHAR (200) NULL,
    [CreatedDate] DATETIME      NULL,
    [CreatedBy]   NVARCHAR (50) NULL,
    CONSTRAINT [PK_B2BHotel_Document] PRIMARY KEY CLUSTERED ([id] ASC)
);

