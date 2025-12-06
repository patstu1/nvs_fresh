
/// <reference types="vite/client" />

interface Window {
  Capacitor?: {
    isNative?: boolean;
    getPlatform?: () => string;
    [key: string]: any;
  };
}
