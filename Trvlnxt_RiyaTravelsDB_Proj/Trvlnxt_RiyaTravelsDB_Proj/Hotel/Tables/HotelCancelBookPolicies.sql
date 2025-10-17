CREATE TABLE [Hotel].[HotelCancelBookPolicies] (
    [id]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKBookingId]      INT           NULL,
    [PolicyText]       VARCHAR (MAX) NULL,
    [PolicyType]       VARCHAR (200) NULL,
    [CPvalue]          FLOAT (53)    NULL,
    [CPValueType]      VARCHAR (200) NULL,
    [CPEstimatedValue] FLOAT (53)    NULL,
    [CPStardDate]      DATETIME      NULL,
    [CPEndDate]        DATETIME      NULL,
    [GroupName]        VARCHAR (50)  NULL,
    [FKRoomId]         INT           NULL,
    [RoomType]         VARCHAR (400) NULL,
    [Roomid]           INT           NULL,
    [Text]             VARCHAR (MAX) NULL,
    [RefundText]       VARCHAR (100) NULL,
    CONSTRAINT [PK_HotelCancelBookPolicies] PRIMARY KEY CLUSTERED ([id] ASC)
);

