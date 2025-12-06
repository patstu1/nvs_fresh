
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';
import { TabType } from '@/types/TabTypes';
import { Percent } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useUserSession } from '@/hooks/useUserSession';
import GridView from '@/components/GridView';
import MapView from '@/components/MapView';
import AIMatchView from '@/components/AIMatchView';
import MessagesView from '@/components/MessagesView';
import FavoritesView from '@/components/FavoritesView';
import YoView from '@/components/YoView';
import SearchView from '@/components/SearchView';
import RoomsView from '@/components/RoomsView';
import ConnectView from '@/components/ConnectView';
import SubscriptionBanner from '@/components/subscription/SubscriptionBanner';
import { analytics } from '@/services/analytics';
import { FilterType } from '@/types/FilterTypes';

interface TabContentProps {
  activeTab: TabType;
  activeFilter: FilterType;
}

const TabContent: React.FC<TabContentProps> = ({ activeTab, activeFilter }) => {
  const navigate = useNavigate();
  const { subscription } = useUserSession();

  React.useEffect(() => {
    analytics.trackEvent('tab_view', { 
      tab: activeTab,
      filter: activeFilter
    });
    
    console.log('Current active tab:', activeTab); // Log for debugging purposes
  }, [activeTab, activeFilter]);

  const handleProfileClick = (id: string) => {
    analytics.trackProfileView(id);
    
    if (!subscription.isPro && Math.random() > 0.7) {
      analytics.trackEvent('subscription_prompt', { trigger: 'profile_limit' });
      toast({
        title: "Profile Limit Reached",
        description: "Upgrade to YO BRO PRO to view unlimited profiles",
      });
      navigate('/subscription');
      return;
    }
    window.location.href = `/profile/${id}`;
  };
  
  const handlePinClick = (id: string) => {
    analytics.trackEvent('map_pin_click', { pinId: id });
    toast({
      title: "Map Pin Clicked",
      description: `You clicked on map pin ${id}`,
    });
  };
  
  const handleYoSend = (id: string) => {
    if (!subscription.isPro && Math.random() > 0.5) {
      analytics.trackEvent('subscription_prompt', { trigger: 'yo_limit' });
      toast({
        title: "Daily Yo Limit Reached",
        description: "Upgrade to YO BRO PRO to send unlimited Yos",
      });
      navigate('/subscription');
      return;
    }
    
    analytics.trackYoSent(id);
    toast({
      title: "Yo Sent!",
      description: `You sent a Yo to user ${id}`,
    });
  };

  const navigateToStats = () => {
    analytics.trackFeatureUsage('view_stats', 'connect');
    navigate('/connect-stats');
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 'grid':
        return (
          <>
            <GridView onProfileClick={handleProfileClick} activeFilter={activeFilter} />
            {!subscription.isPro && <SubscriptionBanner feature="profiles" className="mx-4 mt-4" />}
          </>
        );
      case 'favorites':
        return <FavoritesView onProfileClick={handleProfileClick} />;
      case 'yo':
        return (
          <>
            <YoView onYoSend={handleYoSend} />
            {!subscription.isPro && <SubscriptionBanner feature="messaging" className="mx-4 mt-4" />}
          </>
        );
      case 'messages':
        return <MessagesView />;
      case 'map':
        return (
          <>
            <MapView />
            {!subscription.isPro && <SubscriptionBanner className="mx-4 mt-4" />}
          </>
        );
      case 'search':
        return <SearchView onProfileClick={handleProfileClick} />;
      case 'rooms':
        return (
          <div className="mt-16">
            <RoomsView />
          </div>
        );
      case 'connect':
        return (
          <div className="relative w-full h-full">
            <ConnectView />
          </div>
        );
      default:
        return <GridView onProfileClick={handleProfileClick} activeFilter={activeFilter} />;
    }
  };

  return (
    <div className="bg-black text-[#E6FFF4] w-full h-full pb-24">
      {renderTabContent()}
    </div>
  );
};

export default TabContent;
