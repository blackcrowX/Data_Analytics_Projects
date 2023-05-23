DROP TABLE IF EXISTS nashville_housing;
CREATE TABLE nashville_housing(
	UniqueID int,
	ParcelID varchar(255),
	LandUse	varchar(255),
	PropertyAddress	varchar(255),
	SaleDate date,
	SalePrice varchar(255),
	LegalReference varchar(255),
	SoldAsVacant varchar(255),
	OwnerName varchar(255),
	OwnerAddress varchar(255),
	Acreage numeric,
	TaxDistrict varchar(255),
	LandValue int,
	BuildingValue numeric,
	TotalValue int,
	YearBuilt int,
	Bedrooms int,
	FullBath int,
	HalfBath int
)