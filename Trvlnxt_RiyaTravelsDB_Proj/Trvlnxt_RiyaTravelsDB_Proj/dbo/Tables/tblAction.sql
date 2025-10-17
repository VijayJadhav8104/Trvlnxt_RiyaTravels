CREATE TABLE [dbo].[tblAction] (
    [PKID]         BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ActionName]   VARCHAR (50) NULL,
    [MenuID]       INT          NULL,
    [IsActive]     BIT          CONSTRAINT [DF_Table_1_Status] DEFAULT ((1)) NULL,
    [InsertedDate] DATETIME     CONSTRAINT [DF_tblAction_InsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblAction] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

