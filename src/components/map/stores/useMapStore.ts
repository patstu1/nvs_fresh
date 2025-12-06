
import { create } from 'zustand';

type MapStatus = 'loading' | 'loaded' | 'error';

interface MapStoreState {
  status: MapStatus;
  error: string | null;
  retryCount: number;
  tokenValid: boolean;
  setStatus: (status: MapStatus) => void;
  setError: (error: string | null) => void;
  incrementRetry: () => void;
  resetRetry: () => void;
  setTokenValid: (valid: boolean) => void;
}

export const useMapStore = create<MapStoreState>((set) => ({
  status: 'loading',
  error: null,
  retryCount: 0,
  tokenValid: false,
  setStatus: (status) => set({ status }),
  setError: (error) => set({ error, status: error ? 'error' : 'loading' }),
  incrementRetry: () => set((state) => ({ retryCount: state.retryCount + 1 })),
  resetRetry: () => set({ retryCount: 0 }),
  setTokenValid: (valid) => set({ tokenValid: valid }),
}));
