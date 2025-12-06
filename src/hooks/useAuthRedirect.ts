
import { useEffect, useCallback, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { User } from '@supabase/supabase-js';
import { useUserSession } from './useUserSession';

interface UseAuthRedirectProps {
  user: User | null;
}

export const useAuthRedirect = ({ user }: UseAuthRedirectProps) => {
  const { hasCompletedSetup } = useUserSession();
  const navigate = useNavigate();
  const location = useLocation();
  const from = location.state?.from || '/';
  const hasRedirected = useRef(false);

  const performRedirect = useCallback(() => {
    if (user && !hasRedirected.current) {
      hasRedirected.current = true;
      if (!hasCompletedSetup) {
        navigate('/profile-setup');
      } else {
        navigate(from);
      }
    }
  }, [user, navigate, from, hasCompletedSetup]);

  useEffect(() => {
    if (user) {
      // Small timeout to prevent multiple rapid redirects
      const timer = setTimeout(performRedirect, 50);
      return () => clearTimeout(timer);
    }
    return undefined;
  }, [user, performRedirect]);
};
