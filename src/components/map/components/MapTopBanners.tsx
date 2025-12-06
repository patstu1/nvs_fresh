
import React from 'react';
import LocationErrorBanner from './LocationErrorBanner';

export interface MapTopBannersProps {
  locationError: string | null;
}

const MapTopBanners: React.FC<MapTopBannersProps> = ({ locationError }) => {
  return (
    <>
      {locationError && <LocationErrorBanner locationError={locationError} />}
    </>
  );
};

export default MapTopBanners;
