
import React from 'react';
import { Progress } from '@/components/ui/progress';
import { motion } from 'framer-motion';
import { cn } from '@/lib/utils';

interface QuestionnaireProgressProps {
  currentQuestionIndex: number;
  totalQuestions: number;
}

const QuestionnaireProgress: React.FC<QuestionnaireProgressProps> = ({
  currentQuestionIndex,
  totalQuestions,
}) => {
  const progress = (currentQuestionIndex / totalQuestions) * 100;

  return (
    <motion.div 
      className="mb-6"
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <div className="h-2 bg-gray-800 rounded-full overflow-hidden">
        <motion.div 
          className="h-full bg-[#00FFC4] rounded-full relative"
          initial={{ width: `${Math.max((currentQuestionIndex - 1) / totalQuestions * 100, 0)}%` }}
          animate={{ width: `${progress}%` }}
          transition={{ duration: 0.5, ease: "easeOut" }}
        >
          <div className="absolute top-0 right-0 h-full w-4 bg-gradient-to-r from-[#00FFC4] to-[#00FFC4]/30"></div>
        </motion.div>
      </div>
      
      <div className="mt-2 text-xs text-gray-400 flex justify-between items-center">
        <span className="font-medium">Question {currentQuestionIndex + 1} of {totalQuestions}</span>
        <motion.span 
          key={progress}
          initial={{ scale: 1.2, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className={cn(
            "px-2 py-0.5 rounded-full text-xs",
            progress < 30 ? "bg-red-500/20 text-red-300" :
            progress < 70 ? "bg-yellow-500/20 text-yellow-300" :
            "bg-green-500/20 text-green-300"
          )}
        >
          {Math.round(progress)}% Complete
        </motion.span>
      </div>
    </motion.div>
  );
};

export default QuestionnaireProgress;
