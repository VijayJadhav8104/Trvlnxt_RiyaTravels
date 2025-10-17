CREATE TABLE [Hotel].[HotelReconRpt] (
    [Id]                 INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RowFlag]            VARCHAR (50)   NULL,
    [Sr_No]              INT            NULL,
    [Booking_Date]       DATETIME       NULL,
    [BookID]             VARCHAR (150)  NULL,
    [Supplier]           VARCHAR (50)   NULL,
    [Channel]            VARCHAR (50)   NULL,
    [Status]             VARCHAR (50)   NULL,
    [Agent_Currency]     VARCHAR (5)    NULL,
    [Supplier_Currency]  VARCHAR (5)    NULL,
    [ROE]                FLOAT (53)     NULL,
    [Total_Amount]       FLOAT (53)     NULL,
    [Commission]         FLOAT (53)     NULL,
    [Debit_to_Agent]     DECIMAL (18)   NULL,
    [Credit_to_Agent]    DECIMAL (18)   NULL,
    [Revenue]            DECIMAL (18)   NULL,
    [Payment_mode]       INT            NULL,
    [Convience_Fees]     DECIMAL (18)   NULL,
    [PG_Mode]            VARCHAR (150)  NULL,
    [No_of_Night]        INT            NULL,
    [No_of_Pax]          VARCHAR (15)   NULL,
    [No_of_Room]         INT            NULL,
    [Hotel_Name]         VARCHAR (MAX)  NULL,
    [Booked_City]        VARCHAR (150)  NULL,
    [Check_in_date]      DATETIME       NULL,
    [Check_out_date]     DATETIME       NULL,
    [Agency_Code]        VARCHAR (250)  NULL,
    [Agency_Name]        VARCHAR (250)  NULL,
    [Corelation_ID]      NVARCHAR (250) NULL,
    [IsActive]           BIT            DEFAULT ((1)) NULL,
    [ReconInsertDate]    DATETIME       DEFAULT (getdate()) NULL,
    [Checkintime]        VARCHAR (10)   NULL,
    [Checkouttime]       VARCHAR (10)   NULL,
    [FKBOOKID]           INT            NULL,
    [ErrorDesc]          VARCHAR (MAX)  NULL,
    [SBaseRateSCurrency] FLOAT (53)     NULL,
    [Room_Category]      VARCHAR (MAX)  NULL,
    [GuestName]          VARCHAR (MAX)  NULL,
    [DeadlineDate]       VARCHAR (MAX)  NULL,
    [HotelAddressline]   VARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20240103-123517]
    ON [Hotel].[HotelReconRpt]([RowFlag] ASC, [BookID] ASC);

