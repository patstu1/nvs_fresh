
import { useRef } from "react";

export const useMapboxContainer = () => {
  return useRef<HTMLDivElement>(null);
};
