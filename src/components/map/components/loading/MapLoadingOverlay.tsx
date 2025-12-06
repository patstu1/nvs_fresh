
import React from 'react';
import { Skeleton } from '@/components/ui/skeleton';

export const MapLoadingOverlay = () => (
  <div className="w-full h-screen bg-black flex items-center justify-center">
    <div className="space-y-4 w-full max-w-md">
      <Skeleton className="h-[300px] w-full bg-gray-800" />
      <div className="flex gap-2">
        <Skeleton className="h-10 w-10 rounded-full bg-gray-800" />
        <Skeleton className="h-10 flex-1 bg-gray-800" />
      </div>
      <div className="flex gap-2">
        <Skeleton className="h-10 w-10 rounded-full bg-gray-800" />
        <Skeleton className="h-10 flex-1 bg-gray-800" />
      </div>
    </div>
  </div>
);
