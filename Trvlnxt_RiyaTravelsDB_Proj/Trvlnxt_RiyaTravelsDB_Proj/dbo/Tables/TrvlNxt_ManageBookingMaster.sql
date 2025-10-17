CREATE TABLE [dbo].[TrvlNxt_ManageBookingMaster] (
    [Id]                  INT           NOT NULL,
    [BookingPkId]         INT           NOT NULL,
    [AgentId]             INT           NOT NULL,
    [RiyaUserId]          INT           NOT NULL,
    [BookingId]           VARCHAR (150) NOT NULL,
    [BookingStatus]       VARCHAR (100) NULL,
    [BookingInsertedDate] DATETIME      NULL,
    [LeadPaxName]         VARCHAR (500) NULL,
    [AgencyName]          VARCHAR (200) NULL,
    [StartDate]           DATETIME      NULL,
    [EndDate]             DATETIME      NULL,
    [TotalBookingAmount]  DECIMAL (18)  NULL,
    [BookdBy]             VARCHAR (200) NULL,
    [ProductName]         VARCHAR (100) NULL,
    [ModifyByDate]        DATETIME      NULL,
    [ModifyBy]            VARCHAR (200) NULL,
    CONSTRAINT [PK_TrvlNxt_ManageBookingMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

