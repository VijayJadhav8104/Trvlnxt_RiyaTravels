CREATE TABLE [dbo].[HotelAPIUser_Markup] (
    [Id]              INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId]          INT      NULL,
    [FromRange]       MONEY    NULL,
    [ToRange]         MONEY    NULL,
    [Amount]          MONEY    NULL,
    [Percentage]      INT      NULL,
    [createdOn]       DATETIME NULL,
    [modifiedOn]      DATETIME NULL,
    [createdBy]       INT      NULL,
    [modifiedBy]      INT      NULL,
    [HotelapiUser_id] INT      NULL,
    CONSTRAINT [PK_HotelAPIUser_Markup] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_HotelAPIUser_Markup_HotelAPIUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[HotelAPIUser] ([Id])
);

