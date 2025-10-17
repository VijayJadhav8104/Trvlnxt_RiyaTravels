CREATE TABLE [dbo].[RailINCERPDataLog] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkBookMasterId] BIGINT        NOT NULL,
    [Type]           VARCHAR (50)  NULL,
    [Response]       VARCHAR (MAX) NULL,
    [Request]        VARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME      NULL
);

