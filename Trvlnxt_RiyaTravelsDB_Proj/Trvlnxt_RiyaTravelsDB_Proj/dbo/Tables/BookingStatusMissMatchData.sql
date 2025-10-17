CREATE TABLE [dbo].[BookingStatusMissMatchData] (
    [ID]                        INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PKID]                      VARCHAR (500)   NOT NULL,
    [BookingReference]          VARCHAR (100)   NULL,
    [CurrentStatus]             VARCHAR (300)   NULL,
    [QutechCurrentStatus]       VARCHAR (300)   NULL,
    [InsertDate]                DATETIME        NULL,
    [AgentId]                   VARCHAR (100)   NULL,
    [MainAgentId]               VARCHAR (100)   NULL,
    [CheckInDate]               DATETIME        CONSTRAINT [DF__BookingSt__Check__0916D6CA] DEFAULT (NULL) NULL,
    [CancellationDeadLine]      NVARCHAR (1000) CONSTRAINT [DF__BookingSt__Cance__0A0AFB03] DEFAULT (NULL) NULL,
    [HotelHistoryCurrentStatus] VARCHAR (400)   CONSTRAINT [DF__BookingSt__Hotel__0FC3D459] DEFAULT (NULL) NULL,
    [DataInsertDate]            DATETIME        CONSTRAINT [DF__BookingSt__DataI__10B7F892] DEFAULT (NULL) NULL,
    [PaymentMode]               INT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_BookingStatusMissMatchData_1] PRIMARY KEY CLUSTERED ([ID] ASC)
);

