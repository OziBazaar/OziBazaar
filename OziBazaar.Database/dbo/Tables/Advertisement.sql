CREATE TABLE [dbo].[Advertisement] (
    [AdvertisementID] INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]       INT            NOT NULL,
    [Title]           NVARCHAR (200) NULL,
    [Price]           VARCHAR (50)   NOT NULL,
    [StartDate]       DATETIME       NOT NULL,
    [EndDate]         DATETIME       NOT NULL,
    [OwnerID]         INT            NOT NULL,
    [IsActive]        BIT            CONSTRAINT [DF_Advertisement_IsActive] DEFAULT ((1)) NULL,
    [Version]         ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Advertisement] PRIMARY KEY CLUSTERED ([AdvertisementID] ASC),
    CONSTRAINT [FK_Advertizement_Product] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID])
);



