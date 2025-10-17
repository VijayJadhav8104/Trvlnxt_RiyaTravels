CREATE TABLE [dbo].[tbl_InqueryEmail] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [TO]           VARCHAR (100) NULL,
    [CC]           VARCHAR (100) NULL,
    [BCC]          VARCHAR (100) NULL,
    [Type]         VARCHAR (50)  NULL,
    [IsActive]     BIT           NULL,
    [InsertedDate] DATETIME      NULL,
    [UpdateDate]   DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

