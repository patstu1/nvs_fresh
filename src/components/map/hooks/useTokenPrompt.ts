
import { useEffect, useState } from 'react';

export function useTokenPrompt(token: string | null) {
  const [hasInitialized, setHasInitialized] = useState(false);
  const [showTokenPrompt, setShowTokenPrompt] = useState(false);

  useEffect(() => {
    if (!token && !hasInitialized) {
      setShowTokenPrompt(true);
    }
  }, [token, hasInitialized]);

  useEffect(() => {
    if (token && !hasInitialized) {
      setHasInitialized(true);
      setShowTokenPrompt(false);
    }
  }, [token, hasInitialized]);

  return { hasInitialized, setHasInitialized, showTokenPrompt, setShowTokenPrompt };
}
