CREATE TABLE [dbo].[Hotel_RoleAccess] (
    [PKID]         BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]       NVARCHAR (500) NULL,
    [MenuID]       INT            NULL,
    [Status]       BIT            NULL,
    [InsertedBy]   INT            NULL,
    [InsertedDate] DATETIME       NULL,
    [IsActive]     BIT            NULL,
    CONSTRAINT [PK_Hotel_RoleAccess] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

