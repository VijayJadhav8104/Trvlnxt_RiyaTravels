CREATE TABLE [SS].[SS_BookedActivities] (
    [ActivityId]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BookingId]           INT           NOT NULL,
    [Activitycode]        VARCHAR (50)  NULL,
    [ActivityName]        VARCHAR (500) NULL,
    [ActivityDesc]        TEXT          NULL,
    [ActivityStatus]      VARCHAR (50)  NULL,
    [PricingPackageType]  VARCHAR (50)  NULL,
    [SessionId]           VARCHAR (MAX) NULL,
    [ActivityOptionName]  VARCHAR (500) NULL,
    [ActivityOptionCode]  VARCHAR (50)  NULL,
    [GuidingLanguage]     VARCHAR (50)  NULL,
    [GuidingLanguageCode] VARCHAR (50)  NULL,
    [ActivityOptionTime]  VARCHAR (50)  NULL,
    [ActivityDetailJson]  TEXT          NULL,
    [ProviderInfo]        VARCHAR (MAX) NULL,
    [InsertedDate]        DATETIME      CONSTRAINT [DF__SS_Booked__Inser__05D38327] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_SS_BookedActivities] PRIMARY KEY CLUSTERED ([ActivityId] ASC)
);

