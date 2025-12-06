
import React, { useState, useEffect, useRef } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import BottomNavBar from '@/components/BottomNavBar';
import { toast } from '@/hooks/use-toast';
import { TabType } from '@/types/TabTypes';
import TabContent from '@/components/index/TabContent';
import ToolbarConfig from '@/components/index/ToolbarConfig';
import SubscriptionPrompt from '@/components/index/SubscriptionPrompt';
import { useAuth } from '@/hooks/useAuth';
import { FilterType } from '@/types/FilterTypes';
import SymbolToolbar from '@/components/symbol-toolbar/SymbolToolbar';

interface IndexProps {
  initialTab?: TabType;
}

const Index: React.FC<IndexProps> = ({ initialTab = 'grid' }) => {
  const [activeTab, setActiveTab] = useState<TabType>(initialTab);
  const [activeFilter, setActiveFilter] = useState<FilterType>('popular');
  const [showFilters, setShowFilters] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();
  const { user } = useAuth();
  const symbolToolbarRef = useRef<HTMLDivElement>(null);
  
  // Direct DOM manipulation to ensure symbol toolbar visibility
  useEffect(() => {
    console.log('Index component mounted, ensuring symbol toolbar visibility');
    
    // Direct DOM manipulation for MAXIMUM visibility assurance
    const forceToolbarVisibility = () => {
      console.log('Force applying critical visibility styles to toolbar');
      
      // Apply to wrapper
      document.querySelectorAll('.symbol-toolbar-wrapper').forEach(el => {
        if (el instanceof HTMLElement) {
          console.log('Found symbol-toolbar-wrapper in DOM, applying critical styles');
          Object.assign(el.style, {
            position: 'fixed',
            bottom: '80px',
            left: '0',
            right: '0',
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            zIndex: '9999',
            visibility: 'visible',
            opacity: '1',
            pointerEvents: 'none',
            width: '100%',
            height: '60px',
            minHeight: '60px',
            backgroundColor: 'transparent'
          });
        } else {
          console.error('Symbol toolbar wrapper element not found or not HTMLElement');
        }
      });
      
      // Apply to container
      document.querySelectorAll('.toolbar-container').forEach(el => {
        if (el instanceof HTMLElement) {
          console.log('Found toolbar-container in DOM, applying critical styles');
          Object.assign(el.style, {
            display: 'flex',
            visibility: 'visible',
            opacity: '1',
            zIndex: '9999',
            pointerEvents: 'auto',
            position: 'relative'
          });
        } else {
          console.error('Toolbar container element not found or not HTMLElement');
        }
      });
    };
    
    // Apply visibility fixes multiple times to ensure they catch
    forceToolbarVisibility();
    const timers = [
      setTimeout(forceToolbarVisibility, 100),
      setTimeout(forceToolbarVisibility, 500),
      setTimeout(forceToolbarVisibility, 1000),
      setTimeout(forceToolbarVisibility, 2000),
      setTimeout(forceToolbarVisibility, 3000)
    ];
    
    return () => {
      timers.forEach(timer => clearTimeout(timer));
    };
  }, []);
  
  // Update active tab based on location
  useEffect(() => {
    if (location.pathname === '/search') {
      setActiveTab('search');
    } else if (location.pathname === '/grid') {
      setActiveTab('grid');
    } else if (location.pathname === '/map') {
      setActiveTab('map');
    } else if (location.pathname === '/messages') {
      setActiveTab('messages');
    } else if (location.pathname === '/favorites') {
      setActiveTab('favorites');
    } else if (location.pathname === '/yo') {
      setActiveTab('yo');
    } else if (location.pathname === '/connect') {
      setActiveTab('connect');
    } else if (location.pathname === '/rooms') {
      setActiveTab('rooms');
    }
  }, [location.pathname]);
  
  const handleFilterChange = (filter: FilterType) => {
    setActiveFilter(filter);
    toast({
      title: "Filter Changed",
      description: `You selected ${filter} view`,
    });
  };
  
  const handleFilterToggle = () => {
    setShowFilters(!showFilters);
  };

  const handleProfileClick = () => {
    if (user) {
      navigate('/edit-profile');
    } else {
      navigate('/auth');
    }
  };
  
  return (
    <div className="min-h-screen bg-black text-[#E6FFF4] flex flex-col">
      {/* Top UI Elements */}
      <div className="fixed top-0 left-0 right-0 z-50 flex flex-col bg-black/90 backdrop-blur-md">
        <ToolbarConfig activeTab={activeTab} />
      </div>
      
      {/* Main Content Area - Increased bottom padding for toolbar visibility */}
      <div className="flex-grow pt-28 pb-60 bg-black">
        <TabContent 
          activeTab={activeTab}
          activeFilter={activeFilter}
        />
      </div>
      
      {/* Symbol Toolbar with direct styles and inline styles for MAXIMUM visibility */}
      <div 
        className="symbol-toolbar-wrapper"
        id="fixed-toolbar-container"
        style={{
          position: 'fixed',
          bottom: '80px',
          left: '0',
          right: '0',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          pointerEvents: 'none',
          zIndex: 9999,
          visibility: 'visible',
          opacity: 1,
          width: '100%',
          height: '60px',
          minHeight: '60px',
          backgroundColor: 'transparent'
        }}
      >
        <SymbolToolbar />
      </div>
      
      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-0 right-0 z-40">
        <BottomNavBar 
          activeTab={activeTab}
          onTabChange={setActiveTab}
        />
      </div>
      
      {/* Subscription Prompt */}
      <SubscriptionPrompt />
    </div>
  );
};

export default Index;
