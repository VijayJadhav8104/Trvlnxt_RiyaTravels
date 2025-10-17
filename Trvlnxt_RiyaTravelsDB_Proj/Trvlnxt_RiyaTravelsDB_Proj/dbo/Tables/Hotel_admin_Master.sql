CREATE TABLE [dbo].[Hotel_admin_Master] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserName]     VARCHAR (50)  NOT NULL,
    [Password]     VARCHAR (128) NOT NULL,
    [FullName]     VARCHAR (300) NULL,
    [Status]       BIT           NULL,
    [InsertedBy]   INT           NULL,
    [InsertedDate] DATETIME      NULL,
    [UpdatedBy]    INT           NULL,
    [UpdateDate]   DATETIME      NULL,
    [DeletedDate]  DATETIME      NULL,
    [DeletedBy]    INT           NULL,
    [SessionID]    VARCHAR (50)  NULL,
    CONSTRAINT [PK_Hotel_admin_Master] PRIMARY KEY CLUSTERED ([Id] ASC)
);

