CREATE TABLE [dbo].[adminMaster] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserName]     VARCHAR (50)  NOT NULL,
    [Password]     VARCHAR (128) NOT NULL,
    [FullName]     VARCHAR (300) NULL,
    [Status]       BIT           CONSTRAINT [DF_adminMaster_Status] DEFAULT ((1)) NULL,
    [InsertedBy]   INT           NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_adminMaster_InsertedDate] DEFAULT (getdate()) NULL,
    [UpdatedBy]    INT           NULL,
    [UpdateDate]   DATETIME      NULL,
    [DeletedDate]  DATETIME      NULL,
    [DeletedBy]    INT           NULL,
    [SessionID]    VARCHAR (50)  NULL,
    [Allagents]    BIT           NULL,
    CONSTRAINT [PK_adminMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

