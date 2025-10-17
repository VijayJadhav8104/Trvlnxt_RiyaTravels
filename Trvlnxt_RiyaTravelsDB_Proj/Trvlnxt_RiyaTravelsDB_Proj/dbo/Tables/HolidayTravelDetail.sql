CREATE TABLE [dbo].[HolidayTravelDetail] (
    [HolidayTravelDetailIDP] BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [HolidayInquieryIDF]     BIGINT         NULL,
    [FromCity]               VARCHAR (50)   NULL,
    [Destination]            NVARCHAR (MAX) NULL,
    [FromTravleDate]         DATETIME       NULL,
    [ToTravelDate]           DATETIME       NULL,
    [NoOfNights]             INT            NULL,
    [CreatedDateTime]        DATETIME       CONSTRAINT [DF_HolidayTravelDetail_CreatedDateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_HolidayTravelDetail] PRIMARY KEY CLUSTERED ([HolidayTravelDetailIDP] ASC)
);

