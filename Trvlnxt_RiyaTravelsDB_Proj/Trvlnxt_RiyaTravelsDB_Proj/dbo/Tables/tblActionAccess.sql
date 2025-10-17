CREATE TABLE [dbo].[tblActionAccess] (
    [PKID]         BIGINT   IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ActionID]     BIGINT   NULL,
    [MenuID]       INT      NULL,
    [UserID]       INT      NULL,
    [IsActive]     BIT      CONSTRAINT [DF_tblActionAccess_Status] DEFAULT ((1)) NULL,
    [InsertedBy]   INT      NULL,
    [InsertedDate] DATETIME CONSTRAINT [DF_tblActionAccess_InsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblActionAccess] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

