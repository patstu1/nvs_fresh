
import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';

export const useConnectOnboarding = () => {
  const navigate = useNavigate();
  const [isNewUser, setIsNewUser] = useState(true);

  useEffect(() => {
    // Check if user has completed onboarding
    const hasCompletedOnboarding = localStorage.getItem('connect-onboarding-completed');
    if (hasCompletedOnboarding === 'true') {
      setIsNewUser(false);
      navigate('/connect-dashboard');
    }
  }, [navigate]);

  return { isNewUser };
};
