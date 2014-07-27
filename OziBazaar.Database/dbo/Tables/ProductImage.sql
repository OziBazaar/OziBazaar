CREATE TABLE [dbo].[ProductImage](
	[ProductImageID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ImagePath] [nvarchar](500) NULL,
	[ImageType] [nvarchar](50) NULL,
	[MimeType] [nvarchar](100) NULL,
	[Description] [nvarchar](500) NULL,
	[ImageOrder] [smallint] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductImage] PRIMARY KEY CLUSTERED (	[ProductImageID] ASC),
CONSTRAINT [FK_ProductImage_Product] FOREIGN KEY([ProductID])REFERENCES [dbo].[Product] ([ProductID])
) ON [PRIMARY]




