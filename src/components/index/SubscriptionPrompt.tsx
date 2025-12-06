
import React from 'react';
import SubscriptionDialog from '@/components/subscription/SubscriptionDialog';
import { useUserSession } from '@/hooks/useUserSession';

const SubscriptionPrompt: React.FC = () => {
  const [showSubscription, setShowSubscription] = React.useState(false);
  const { subscription } = useUserSession();

  // Removed the automatic timer that showed the prompt
  // Now it will only show when explicitly triggered by setting showSubscription to true

  return (
    <SubscriptionDialog 
      isOpen={showSubscription}
      onClose={() => setShowSubscription(false)}
    />
  );
};

export default SubscriptionPrompt;
