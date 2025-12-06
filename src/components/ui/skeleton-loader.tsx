
import React from 'react';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/lib/utils';

export const ProfileCardSkeleton: React.FC<{ className?: string }> = ({ className }) => {
  return (
    <div className={cn("p-4 border border-[#333] rounded-lg bg-black/50 animate-pulse", className)}>
      <div className="flex items-center space-x-4">
        <Skeleton className="h-12 w-12 rounded-full bg-[#333]" />
        <div className="space-y-2">
          <Skeleton className="h-4 w-[100px] bg-[#333]" />
          <Skeleton className="h-3 w-[70px] bg-[#333]" />
        </div>
      </div>
      <div className="mt-4 space-y-2">
        <Skeleton className="h-3 w-full bg-[#333]" />
        <Skeleton className="h-3 w-5/6 bg-[#333]" />
        <Skeleton className="h-3 w-4/6 bg-[#333]" />
      </div>
    </div>
  );
};

export const GridTileSkeleton: React.FC<{ className?: string }> = ({ className }) => {
  return (
    <div className={cn("aspect-square animate-pulse", className)}>
      <Skeleton className="w-full h-full bg-[#333]/50" />
      <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/70 to-transparent p-2">
        <Skeleton className="h-3 w-14 mb-1 bg-[#333]" />
        <Skeleton className="h-2 w-10 bg-[#333]" />
      </div>
    </div>
  );
};

export const GridSkeletonLoader: React.FC = () => {
  return (
    <div className="grid grid-cols-3 gap-[3px] px-[3px]">
      {Array(12).fill(0).map((_, i) => (
        <GridTileSkeleton key={i} />
      ))}
    </div>
  );
};

export const MapPinSkeleton: React.FC<{ className?: string }> = ({ className }) => {
  return (
    <div className={cn("h-6 w-6 rounded-full bg-[#333]/70 animate-pulse", className)} />
  );
};

export const ChatMessageSkeleton: React.FC<{ isSent?: boolean; className?: string }> = ({ isSent = false, className }) => {
  return (
    <div className={cn(
      "flex w-full mb-4", 
      isSent ? "justify-end" : "justify-start",
      className
    )}>
      <div className={cn(
        "max-w-[80%] rounded-lg py-2 px-3",
        isSent ? "bg-[#AAFF50]/20" : "bg-[#333]",
      )}>
        <Skeleton className="h-3 w-full bg-current opacity-20 mb-1" />
        <Skeleton className="h-3 w-5/6 bg-current opacity-20" />
      </div>
    </div>
  );
};

export const ConnectCardSkeleton: React.FC<{ className?: string }> = ({ className }) => {
  return (
    <div className={cn("w-full max-w-sm mx-auto bg-[#1A1A1A] rounded-xl overflow-hidden shadow-lg animate-pulse", className)}>
      <Skeleton className="h-64 w-full bg-[#333]" />
      <div className="p-5 space-y-3">
        <Skeleton className="h-6 w-3/4 bg-[#333]" />
        <div className="flex space-x-2">
          <Skeleton className="h-4 w-12 rounded-full bg-[#333]" />
          <Skeleton className="h-4 w-12 rounded-full bg-[#333]" />
        </div>
        <Skeleton className="h-4 w-full bg-[#333]" />
        <Skeleton className="h-4 w-5/6 bg-[#333]" />
        <div className="flex justify-between mt-4">
          <Skeleton className="h-10 w-24 rounded-full bg-[#333]" />
          <Skeleton className="h-10 w-24 rounded-full bg-[#333]" />
        </div>
      </div>
    </div>
  );
};

export const RoomCardSkeleton: React.FC<{ className?: string }> = ({ className }) => {
  return (
    <div className={cn("border border-[#333] rounded-lg overflow-hidden animate-pulse", className)}>
      <div className="p-4">
        <Skeleton className="h-5 w-1/2 mb-2 bg-[#333]" />
        <Skeleton className="h-4 w-1/4 bg-[#333]" />
      </div>
      <div className="grid grid-cols-3 gap-0.5 bg-[#333]/20">
        {Array(6).fill(0).map((_, i) => (
          <Skeleton key={i} className="aspect-square bg-[#333]/50" />
        ))}
      </div>
    </div>
  );
};
