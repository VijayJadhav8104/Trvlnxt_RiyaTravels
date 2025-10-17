CREATE TABLE [dbo].[HolidayEmailIDs] (
    [HolidayEmailIDP]  INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EmailID]          VARCHAR (150) NULL,
    [Country]          VARCHAR (50)  NULL,
    [IsActive]         BIT           CONSTRAINT [DF_HolidayEmailIDs_IsActive] DEFAULT ((1)) NULL,
    [InsertedDateTime] DATETIME      CONSTRAINT [DF_HolidayEmailIDs_InsertedDateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_HolidayEmailIDs] PRIMARY KEY CLUSTERED ([HolidayEmailIDP] ASC)
);

