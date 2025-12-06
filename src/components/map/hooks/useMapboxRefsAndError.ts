
import { useRef, useState, useCallback } from "react";

/**
 * Provides refs and states needed for mapbox initialization: previousToken, initialization timeout, error.
 */
export const useMapboxRefsAndError = () => {
  const previousTokenRef = useRef<string | null>(null);
  const initializationTimeoutRef = useRef<number | null>(null);

  // Error state for initialization problems
  const [initializationError, setInitializationError] = useState<string | null>(null);

  // Memoize the setter to avoid recreating it on every render
  const setError = useCallback((error: string | null) => {
    setInitializationError(error);
  }, []);

  return {
    previousTokenRef,
    initializationTimeoutRef,
    initializationError,
    setInitializationError: setError,
  };
};
