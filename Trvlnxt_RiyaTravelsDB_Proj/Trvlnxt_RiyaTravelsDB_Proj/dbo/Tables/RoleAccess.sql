CREATE TABLE [dbo].[RoleAccess] (
    [PKID]         BIGINT   IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]       INT      NULL,
    [MenuID]       INT      NULL,
    [Status]       BIT      CONSTRAINT [DF_RoleAccess_Status] DEFAULT ((1)) NULL,
    [InsertedBy]   INT      NULL,
    [InsertedDate] DATETIME CONSTRAINT [DF_RoleAccess_InsertedDate] DEFAULT (getdate()) NULL,
    [IsActive]     BIT      CONSTRAINT [DF_RoleAccess_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_RoleAccess] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

