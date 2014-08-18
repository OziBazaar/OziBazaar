CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[ProductGroupID] [int] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)
)




GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductGroup] FOREIGN KEY([ProductGroupID])
REFERENCES [dbo].[ProductGroup] ([ProductGroupID])
GO

ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_ProductGroup]