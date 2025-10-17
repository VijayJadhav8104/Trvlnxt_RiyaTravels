CREATE TABLE [dbo].[UserCountryMapping] (
    [pkid]         INT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Country]      VARCHAR (2) NOT NULL,
    [UserID]       INT         NOT NULL,
    [Status]       BIT         CONSTRAINT [DF_UserCountryMapping_Status] DEFAULT ((1)) NULL,
    [InsertedBy]   INT         NULL,
    [InsertedDate] DATETIME    CONSTRAINT [DF_UserCountryMapping_InsertedDate] DEFAULT (getdate()) NULL,
    [IsActive]     BIT         CONSTRAINT [DF_UserCountryMapping_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_UserCountryMapping] PRIMARY KEY CLUSTERED ([pkid] ASC)
);

