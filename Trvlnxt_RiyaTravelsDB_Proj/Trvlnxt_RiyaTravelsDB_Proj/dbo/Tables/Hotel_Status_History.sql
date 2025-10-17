CREATE TABLE [dbo].[Hotel_Status_History] (
    [Id]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKHotelBookingId] INT           NULL,
    [FkStatusId]       NCHAR (10)    NULL,
    [MainAgentId]      VARCHAR (50)  NULL,
    [CreateDate]       DATETIME      CONSTRAINT [DF_Hotel_Status_History_CreateDate] DEFAULT (getdate()) NULL,
    [CreatedBy]        INT           NULL,
    [ModifiedDate]     DATETIME      NULL,
    [ModifiedBy]       INT           NULL,
    [IsActive]         BIT           CONSTRAINT [DF_Hotel_Status_History_IsActive] DEFAULT ((1)) NULL,
    [MethodName]       VARCHAR (500) DEFAULT (NULL) NULL,
    CONSTRAINT [PK_Hotel_Status_History] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-created date]
    ON [dbo].[Hotel_Status_History]([CreateDate] ASC);


GO
CREATE NONCLUSTERED INDEX [fkbookid_index]
    ON [dbo].[Hotel_Status_History]([FKHotelBookingId] ASC);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED Common Index]
    ON [dbo].[Hotel_Status_History]([FKHotelBookingId] ASC, [IsActive] ASC, [FkStatusId] ASC)
    INCLUDE([CreateDate], [ModifiedDate]);


GO
CREATE NONCLUSTERED INDEX [Noncluster_CompositeIndex]
    ON [dbo].[Hotel_Status_History]([IsActive] ASC)
    INCLUDE([FKHotelBookingId], [FkStatusId], [CreateDate], [ModifiedDate], [MethodName]);

