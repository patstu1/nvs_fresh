
import React from 'react';
import AgeVerificationDialog from '@/components/common/AgeVerificationDialog';
import MapboxTokenInput from './MapboxTokenInput';

interface MapViewDialogsProps {
  showAgeVerification: boolean;
  showTokenInput: boolean;
  onAgeVerified: () => void;
  onAgeVerificationCancelled: () => void;
  onTokenSubmit: (token: string) => void;
  onTokenSkip: () => void;
}

const MapViewDialogs: React.FC<MapViewDialogsProps> = ({
  showAgeVerification,
  showTokenInput,
  onAgeVerified,
  onAgeVerificationCancelled,
  onTokenSubmit,
  onTokenSkip
}) => {
  return (
    <>
      {showAgeVerification && (
        <AgeVerificationDialog 
          isOpen={showAgeVerification}
          onVerify={onAgeVerified}
          onCancel={onAgeVerificationCancelled}
        />
      )}
      
      {showTokenInput && (
        <MapboxTokenInput 
          onSubmit={(newToken) => onTokenSubmit(newToken)}
          onSkip={onTokenSkip}
          open={showTokenInput}
        />
      )}
    </>
  );
};

export default MapViewDialogs;
