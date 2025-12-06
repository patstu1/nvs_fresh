
import React from 'react';
import { Button } from '@/components/ui/button';
import { ChevronLeft, ChevronRight, Check, Loader2 } from 'lucide-react';
import { motion } from 'framer-motion';
import { useUserSession } from '@/hooks/useUserSession';

interface NavigationControlsProps {
  currentSection: number;
  totalSections: number;
  onPrevious: () => void;
  onNext: () => void;
  isValid?: boolean;
  isLastSection?: boolean;
  onSubmit?: () => void;
  isSubmitting?: boolean;
}

const NavigationControls: React.FC<NavigationControlsProps> = ({
  currentSection,
  totalSections,
  onPrevious,
  onNext,
  isValid = true,
  isLastSection = false,
  onSubmit,
  isSubmitting = false
}) => {
  const { completeProfileSetup } = useUserSession();
  
  // Don't show any controls if we're beyond the total sections (done state)
  if (currentSection >= totalSections) {
    return null;
  }
  
  const handleSubmit = () => {
    if (onSubmit) {
      // Mark profile setup as complete in the user session
      if (isLastSection) {
        completeProfileSetup();
      }
      onSubmit();
    }
  };

  return (
    <motion.div 
      className="flex justify-between items-center pt-6"
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.2 }}
    >
      <div>
        {currentSection > 0 && (
          <Button 
            type="button" 
            variant="outline" 
            onClick={onPrevious}
            disabled={isSubmitting}
            className="bg-black text-[#E6FFF4] border-2 border-[#E6FFF4] hover:bg-[#E6FFF4]/10 gap-2"
          >
            <ChevronLeft size={16} />
            Back
          </Button>
        )}
      </div>
      
      <div className="flex items-center">
        {Array.from({ length: totalSections }).map((_, index) => (
          <motion.div
            key={index}
            className={`w-2 h-2 rounded-full mx-1 ${
              index <= currentSection ? "bg-[#E6FFF4]" : "bg-[#E6FFF4]/30"
            }`}
            initial={{ scale: 0.8, opacity: 0.5 }}
            animate={{ 
              scale: index === currentSection ? 1.2 : 1,
              opacity: index <= currentSection ? 1 : 0.5
            }}
            transition={{ duration: 0.3 }}
          />
        ))}
      </div>
      
      <div>
        {isLastSection ? (
          <Button 
            type="submit"
            onClick={handleSubmit}
            className="bg-[#E6FFF4] hover:bg-[#E6FFF4]/90 text-black border-2 border-black gap-2 min-w-[120px] justify-center"
            disabled={!isValid || isSubmitting}
          >
            {isSubmitting ? (
              <>
                <Loader2 size={16} className="animate-spin mr-2" />
                Processing
              </>
            ) : (
              <>
                Complete <Check size={16} />
              </>
            )}
          </Button>
        ) : (
          <Button 
            type="button" 
            className="bg-[#E6FFF4] hover:bg-[#E6FFF4]/90 text-black border-2 border-black gap-2"
            onClick={onNext}
            disabled={!isValid || isSubmitting}
          >
            Continue
            <ChevronRight size={16} />
          </Button>
        )}
      </div>
    </motion.div>
  );
};

export default NavigationControls;
