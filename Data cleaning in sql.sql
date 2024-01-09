--cleaning Data in sql queries

select*
from
SQLproject..nashvillehousing

--standard date formate

select saledateconverted,CONVERT(date,saledate)
from SQLproject..nashvillehousing

update nashvillehousing
set SaleDate=CONVERT(date,saledate)

alter table nashvillehousing
add saledateconverted Date;

update nashvillehousing
set saledateconverted =CONVERT(date,saledate)

alter table nashvillehousing
 DROP COLUMN saledateconvert

--populate property address data


select*
from SQLproject..nashvillehousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress)
from SQLproject..nashvillehousing a
join SQLproject..nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set propertyaddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from SQLproject..nashvillehousing a
join SQLproject..nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address into individual columns(Address,city,state)


select PropertyAddress
from SQLproject..nashvillehousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress,1,charindex(',',propertyaddress)-1) as address
,SUBSTRING(PropertyAddress,charindex(',',propertyaddress)+1,len (propertyaddress)) as address
from SQLproject..nashvillehousing


alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update nashvillehousing
set  propertysplitaddress =SUBSTRING(PropertyAddress,1,charindex(',',propertyaddress)-1) 

alter table  nashvillehousing
add   propertysplitcity nvarchar(255);



update nashvillehousing
set propertysplitcity =SUBSTRING(PropertyAddress,charindex(',',propertyaddress)+1,len (propertyaddress)) 

select*
from SQLproject..nashvillehousing

select OwnerAddress
from SQLproject..nashvillehousing

select
PARSENAME(replace(owneraddress,',','.') ,3)
,PARSENAME(replace(owneraddress,',','.') ,2)
,PARSENAME(replace(owneraddress,',','.') ,1)
from SQLproject..nashvillehousing



alter table nashvillehousing
add ownersplitaddress nvarchar(255);

update nashvillehousing
set  ownersplitaddress =PARSENAME(replace(owneraddress,',','.') ,3)

alter table  nashvillehousing
add   ownersplitcity nvarchar(255);



update nashvillehousing
set ownersplitcity =PARSENAME(replace(owneraddress,',','.') ,2)

alter table  nashvillehousing
add   ownersplitstate nvarchar(255);



update nashvillehousing
set ownersplitstate =PARSENAME(replace(owneraddress,',','.') ,1)

--change y and n to yes and no in "sold  as vacant" field

select distinct (soldasvacant), count(soldasvacant)
from SQLproject..nashvillehousing
group by soldasvacant
order by 2

select SoldAsVacant,
case when SoldAsVacant ='y' then 'yes'
when SoldAsVacant ='n' then 'no'
else SoldAsVacant
end
from SQLproject..nashvillehousing

update nashvillehousing
set SoldAsVacant=
case when SoldAsVacant ='y' then 'yes'
when SoldAsVacant ='n' then 'no'
else SoldAsVacant

end

--Remove duplicate


with rownumcte as(
select*,
row_number() over(
         partition by parcelid,
		 propertyaddress,
		 saleprice,
		 saledate,
		 legalreference
		 order by
		   uniqueid
		   )row_num
from SQLproject..nashvillehousing
)
select*
from rownumcte
where row_num>1
--order by PropertyAddress


--delete unused columns 

select*
from SQLproject..nashvillehousing


alter table SQLproject..nashvillehousing
drop column owneraddress,taxdistrict,propertyaddress


alter table SQLproject..nashvillehousing
drop column saledate


