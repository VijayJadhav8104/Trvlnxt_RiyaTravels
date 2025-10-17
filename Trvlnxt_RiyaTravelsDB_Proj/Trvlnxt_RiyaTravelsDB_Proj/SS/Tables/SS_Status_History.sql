CREATE TABLE [SS].[SS_Status_History] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BookingId]    INT           NULL,
    [FkStatusId]   NCHAR (10)    NULL,
    [CreateDate]   DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedDate] DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    [IsActive]     BIT           NULL,
    [MainAgentId]  VARCHAR (50)  NULL,
    [MethodName]   VARCHAR (500) NULL,
    CONSTRAINT [PK_Hotel_Status_History] PRIMARY KEY CLUSTERED ([Id] ASC)
);

