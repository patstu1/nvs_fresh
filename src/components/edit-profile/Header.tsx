
import React from 'react';
import { ChevronLeft } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { useUserSession } from '@/hooks/useUserSession';
import { toast } from '@/hooks/use-toast';

interface HeaderProps {
  onSave: () => void;
  title?: string;
  isProcessing?: boolean;
}

const Header: React.FC<HeaderProps> = ({ onSave, title = "Edit Profile", isProcessing = false }) => {
  const navigate = useNavigate();
  const { completeProfileSetup } = useUserSession();

  const handleSave = () => {
    // Mark profile as complete when saving
    completeProfileSetup();
    localStorage.setItem('onboardingCompleted', 'true');
    
    // Display success toast
    toast({
      title: "Profile Updated",
      description: "Your profile changes have been saved successfully."
    });
    
    // Call the parent onSave function
    onSave();
  };

  return (
    <motion.div 
      className="fixed top-0 left-0 right-0 z-50 bg-black/90 border-b border-[#333] flex items-center px-4 h-16 backdrop-blur-md"
      style={{ paddingTop: 'env(safe-area-inset-top)' }}
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <motion.button 
        whileTap={{ scale: 0.95 }}
        onClick={() => navigate(-1)}
        className="p-2 -ml-2 rounded-full active:bg-white/10 transition-colors"
        disabled={isProcessing}
      >
        <ChevronLeft className="w-5 h-5 text-[#E6FFF4]" />
      </motion.button>
      
      <motion.h1 
        className="text-lg font-medium ml-2 flex-1 text-center text-[#E6FFF4]"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.1 }}
      >
        {title}
      </motion.h1>
      
      <Button 
        onClick={handleSave}
        variant="ghost" 
        size="sm"
        disabled={isProcessing}
        className={`
          text-[#AAFF50] hover:text-[#AAFF50]/90 hover:bg-[#AAFF50]/10 
          transition-all relative overflow-hidden
        `}
      >
        {isProcessing ? (
          <>
            <span className="mr-2 block w-4 h-4 rounded-full border-2 border-[#AAFF50] border-r-transparent animate-spin"></span>
            Saving...
          </>
        ) : (
          <>
            Save
            <motion.span 
              className="absolute bottom-0 left-0 right-0 h-0.5 bg-[#AAFF50]"
              initial={{ scaleX: 0 }}
              whileHover={{ scaleX: 1 }}
              transition={{ duration: 0.3 }}
            />
          </>
        )}
      </Button>
    </motion.div>
  );
};

export default Header;
