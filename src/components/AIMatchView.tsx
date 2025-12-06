
import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { Button } from './ui/button';
import { ArrowRight, RefreshCw } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface AIMatchViewProps {
  onComplete?: () => void;
}

const AIMatchView: React.FC<AIMatchViewProps> = ({ onComplete }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [progress, setProgress] = useState(0);
  const [matches, setMatches] = useState<any[]>([]);
  
  useEffect(() => {
    // Simulate AI processing
    const timer = setInterval(() => {
      setProgress(prev => {
        const newProgress = prev + Math.random() * 15;
        return newProgress >= 100 ? 100 : newProgress;
      });
    }, 500);
    
    // Simulate match generation completion
    setTimeout(() => {
      setIsLoading(false);
      clearInterval(timer);
      setProgress(100);
      
      setMatches([
        { id: 1, name: 'Alex', distance: '0.8 miles', compatibility: 92 },
        { id: 2, name: 'Jordan', distance: '1.2 miles', compatibility: 89 },
        { id: 3, name: 'Taylor', distance: '2.5 miles', compatibility: 87 },
        { id: 4, name: 'Sam', distance: '0.5 miles', compatibility: 85 },
        { id: 5, name: 'Jamie', distance: '3.1 miles', compatibility: 82 },
      ]);
    }, 4000);
    
    return () => clearInterval(timer);
  }, []);
  
  const handleStartBrowsing = () => {
    if (onComplete) {
      onComplete();
    }
    
    toast({
      title: "Welcome to CONNECT",
      description: "We've found your best matches. Start browsing now!",
    });
  };
  
  const handleRefreshMatches = () => {
    setIsLoading(true);
    setProgress(0);
    
    // Simulate refreshing
    setTimeout(() => {
      setIsLoading(false);
      setProgress(100);
      
      toast({
        title: "Matches Refreshed",
        description: "We've updated your matches with new results.",
      });
    }, 2000);
  };

  return (
    <div className="w-full max-w-md mx-auto p-4">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="space-y-6"
      >
        <h1 className="text-2xl font-bold text-center text-[#00FFCC]">
          AI Match Generation
        </h1>
        
        {isLoading ? (
          <div className="space-y-6">
            <div className="h-2 bg-gray-700 rounded-full overflow-hidden">
              <motion.div
                className="h-full bg-gradient-to-r from-[#00FFCC] to-[#FF00FF]"
                initial={{ width: 0 }}
                animate={{ width: `${progress}%` }}
                transition={{ duration: 0.5 }}
              />
            </div>
            
            <p className="text-center text-[#E6FFF4]/80">
              Our AI is analyzing your preferences and finding your best matches...
            </p>
          </div>
        ) : (
          <div className="space-y-8">
            <p className="text-center text-[#E6FFF4]">
              Based on your preferences, we've found these compatible matches:
            </p>
            
            <div className="space-y-3">
              {matches.map(match => (
                <motion.div
                  key={match.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ duration: 0.3, delay: match.id * 0.1 }}
                  className="flex items-center justify-between bg-black/50 p-3 rounded-lg border border-[#FF00FF]/30"
                >
                  <div>
                    <p className="text-[#E6FFF4] font-medium">{match.name}</p>
                    <p className="text-[#E6FFF4]/60 text-sm">{match.distance}</p>
                  </div>
                  <div className="flex items-center justify-center w-12 h-12 rounded-full bg-gradient-to-r from-[#00FFCC] to-[#FF00FF]/80">
                    <span className="text-white font-bold">{match.compatibility}%</span>
                  </div>
                </motion.div>
              ))}
            </div>
            
            <div className="flex justify-between pt-4">
              <Button
                variant="outline"
                onClick={handleRefreshMatches}
                className="border-[#FF00FF] text-[#FF00FF]"
              >
                <RefreshCw className="w-4 h-4 mr-2" />
                Refresh
              </Button>
              
              <Button
                onClick={handleStartBrowsing}
                className="bg-[#FF00FF] hover:bg-[#FF00FF]/80 text-white"
              >
                Start Browsing <ArrowRight className="w-4 h-4 ml-2" />
              </Button>
            </div>
          </div>
        )}
      </motion.div>
    </div>
  );
};

export default AIMatchView;
