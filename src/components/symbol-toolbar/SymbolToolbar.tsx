
import React, { useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  LayoutGrid, 
  Heart, 
  Star, 
  Search,
  Video,
  Sparkles,
  Radar,
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';
import '../../styles/symbol-toolbar.css';

const SymbolToolbar = () => {
  const navigate = useNavigate();
  const toolbarRef = useRef<HTMLDivElement>(null);

  const navigationIcons = [
    {
      icon: LayoutGrid,
      label: "Jock-grid",
      color: "#4BEFE0",
      action: () => navigate('/grid')
    },
    {
      icon: Radar,
      label: "Radar-now",
      color: "#4BEFE0",
      action: () => navigate('/map')
    },
    {
      icon: Video,
      label: "Video cam-live",
      color: "#E6FFF4",
      action: () => navigate('/rooms')
    },
    {
      icon: Sparkles,
      label: "Twinkle-AI",
      color: "#4BEFE0",
      action: () => navigate('/connect')
    },
    {
      icon: Heart,
      label: "Heart-favorites",
      color: "#4BEFE0",
      action: () => navigate('/favorites')
    },
    {
      icon: Search,
      label: "Search",
      color: "#E6FFF4",
      action: () => navigate('/search')
    },
    {
      icon: Star,
      label: "YO",
      color: "#4BEFE0",
      action: () => {
        navigate('/yo');
        toast({ title: "YO!" });
      }
    }
  ];

  // Direct, aggressive approach to ensure visibility
  useEffect(() => {
    console.log('SymbolToolbar component mounted and rendering');
    
    const forceToolbarVisibility = () => {
      console.log('Forcing toolbar visibility');
      
      // Apply direct styles to toolbar wrapper
      document.querySelectorAll('.symbol-toolbar-wrapper').forEach(el => {
        if (el instanceof HTMLElement) {
          console.log('Found symbol-toolbar-wrapper, applying critical styles');
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
            backgroundColor: 'transparent'
          });
        }
      });
      
      // Apply direct styles to toolbar container
      document.querySelectorAll('.toolbar-container').forEach(el => {
        if (el instanceof HTMLElement) {
          console.log('Found toolbar-container, applying critical styles');
          Object.assign(el.style, {
            display: 'flex',
            visibility: 'visible',
            opacity: '1',
            position: 'relative',
            zIndex: '9999',
            pointerEvents: 'auto'
          });
        }
      });
      
      // Ensure ref styles are also applied
      if (toolbarRef.current) {
        console.log('Applying styles to toolbar ref');
        Object.assign(toolbarRef.current.style, {
          display: 'flex',
          visibility: 'visible',
          opacity: '1',
          position: 'fixed',
          bottom: '80px',
          left: '0',
          right: '0',
          zIndex: '9999',
          width: '100%'
        });
      }
    };

    // Call immediately and with delays to ensure it catches
    forceToolbarVisibility();
    
    // Create multiple timers at different intervals for redundancy
    const timers = [
      setTimeout(forceToolbarVisibility, 100),
      setTimeout(forceToolbarVisibility, 500),
      setTimeout(forceToolbarVisibility, 1000),
      setTimeout(forceToolbarVisibility, 2000)
    ];
    
    return () => {
      timers.forEach(timer => clearTimeout(timer));
    };
  }, []);

  return (
    <motion.div 
      ref={toolbarRef}
      initial={{ y: 20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="symbol-toolbar-wrapper"
      id="symbol-toolbar-wrapper"
      style={{ 
        position: 'fixed',
        bottom: '80px',
        left: '0',
        right: '0',
        width: '100%',
        height: '60px',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        zIndex: 9999,
        pointerEvents: 'none',
        visibility: 'visible',
        opacity: 1,
        transform: 'none',
        backgroundColor: 'transparent'
      }}
      data-testid="symbol-toolbar"
    >
      <motion.div 
        className="toolbar-container"
        id="toolbar-container"
        style={{
          display: 'flex',
          visibility: 'visible',
          opacity: 1,
          position: 'relative',
          zIndex: 9999,
          pointerEvents: 'auto'
        }}
      >
        <motion.div 
          className="luxury-toolbar rounded-full px-4 py-3 flex items-center gap-4 overflow-x-auto"
          whileHover={{ scale: 1.02 }}
          transition={{ duration: 0.3 }}
        >
          {navigationIcons.map((item, index) => (
            <SymbolButton 
              key={item.label} 
              symbol={item}
              index={index}
            />
          ))}
        </motion.div>
      </motion.div>
    </motion.div>
  );
};

interface SymbolButtonProps {
  symbol: {
    icon: React.FC<React.SVGProps<SVGSVGElement>>;
    label: string;
    color: string;
    action: () => void;
  };
  index: number;
}

const SymbolButton: React.FC<SymbolButtonProps> = ({ symbol, index }) => {
  const [isHovered, setIsHovered] = React.useState(false);
  
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ delay: index * 0.05 }}
      className="relative"
      onHoverStart={() => setIsHovered(true)}
      onHoverEnd={() => setIsHovered(false)}
    >
      <motion.button
        whileHover={{ scale: 1.2 }}
        whileTap={{ scale: 0.9 }}
        onClick={symbol.action}
        className="symbol-toolbar-icon p-2 rounded-full transition-colors relative group luxury-toolbar-btn"
      >
        <symbol.icon 
          className="w-6 h-6 transition-all duration-300"
          color={symbol.color}
          style={{
            filter: `drop-shadow(0 0 5px ${symbol.color}80)`
          }}
        />
      </motion.button>

      <AnimatePresence>
        {isHovered && (
          <motion.div
            initial={{ opacity: 0, y: 10, scale: 0.8 }}
            animate={{ opacity: 1, y: -32, scale: 1 }}
            exit={{ opacity: 0, y: 10, scale: 0.8 }}
            className="absolute left-1/2 -translate-x-1/2 whitespace-nowrap z-50"
          >
            <span 
              className="px-3 py-1 rounded-md text-sm font-medium luxury-tooltip symbol-tooltip"
              style={{ 
                color: symbol.color,
                textShadow: `0 0 6px ${symbol.color}80`,
                borderColor: `${symbol.color}40`,
                boxShadow: `0 0 10px ${symbol.color}40`
              }}
            >
              {symbol.label}
            </span>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
};

export default SymbolToolbar;
