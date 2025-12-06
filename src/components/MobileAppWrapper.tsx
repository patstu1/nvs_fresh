
import React from 'react';
import type { PropsWithChildren } from 'react';
import BottomNavBar from './BottomNavBar';
import TopToolbar from './TopToolbar';
import { TabType } from '@/types/TabTypes';

interface MobileAppWrapperProps extends PropsWithChildren {
  activeTab?: TabType;
  onTabChange?: (tab: TabType) => void;
}

const MobileAppWrapper: React.FC<MobileAppWrapperProps> = ({
  children,
  activeTab,
  onTabChange,
}) => {
  return (
    <div className="min-h-screen bg-black text-[#C2FFE6] flex flex-col">
      <TopToolbar />
      <main className="flex-1 relative bg-black">
        {children}
      </main>
      {activeTab && onTabChange && (
        <BottomNavBar activeTab={activeTab} onTabChange={onTabChange} />
      )}
    </div>
  );
};

export default MobileAppWrapper;
